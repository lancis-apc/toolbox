library(readxl)
library(ggplot2)
library(rgl)
library(corrplot)
library(rpart)
library(rpart.plot)
library(factoextra)
library(randomForest)
library(partykit)
library(plyr)
library(dplyr)
library(parcoords)
library(ggrepel)
library(ggthemes)
library(tidyverse)
library(maditr)
library(MASS)
library(htmltools)
library(kableExtra)
library(d3r)
library(stringr)
library(rpart.utils)
library(manipulateWidget)

normalizar <- function(x){
  (x-min(x))/(max(x)-min(x))
}

region_name <- function(x){
  case_when(
    x == "r1" ~ "Region 1",
    x == "r2" ~ "Región II Noroeste",
    x == "r3" ~ "Region 3",
    x == "r4" ~ "Region 4",
    x == "r5" ~ "Region 5",
    x == "r6" ~ "Region 6",
    x == "r7" ~ "Region 7",
  )
}

region_folder <- function(x){
  case_when(
    x == "r1" ~ "region_1",
    x == "r2" ~ "region_2",
    x == "r3" ~ "region_3",
    x == "r4" ~ "region_4",
    x == "r5" ~ "region_5",
    x == "r6" ~ "region_6",
    x == "r7" ~ "region_7",
  )
}


escenario_name <- function(x){
  case_when(
    x == "tendencial" ~ "Tendencial",
    x == "contextual" ~ "Contextual",
    x == "estrategico" ~ "Estrategico"
  )
}


reliability_calc <- function(umb, data, forzante, estado, invertir){
  w25 <- data[paste0(estado, 25)]
  w0 <- data[paste0(estado, 0)]
  x25 <- data[paste0(forzante, 25)]
  x0 <- data[paste0(forzante, 0)]
  delta_w <- w25-w0
  delta_estresor <- x25-x0
  delta <- abs(delta_w)/abs(delta_estresor)
  #delta <- delta_w/delta_estresor
  if (invertir == 1) {
    den <- umb/w25
  } else {
    den <- w25/umb
  }
  rel_calc <- delta/den
  return(rel_calc)
}


crear_parallel <- function(data_cut){
  # remover 25
  colnames(data_cut) <- gsub('25', '  ', colnames(data_cut))
  # remover 0
  colnames(data_cut) <- gsub('0', '  ', colnames(data_cut))
  tmp <- rbind(rep(1, ncol(data_cut)), data_cut)
  data_parallel <- rbind(rep(0, ncol(data_cut)), tmp)
  parcoords(
    data_parallel,
    reorderable = T,
    brushMode = '1D-axes')
}


parallel_comparation <-  function(datos25, datos0){
  browsable(
    tagList(list(
      tags$div(
        style = 'width:50%;display:block;float:left;',
        tags$h5("a) Condiciones iniciales"),
        crear_parallel(datos0),
        #combineWidgets(
        #  crear_parallel(datos0),
        #  title = "Condición inicial"
        #)
      ),
      tags$div(
        tags$h5("b) Condiciones finales"),
        style = 'width:50%;display:block;float:left;',
        crear_parallel(datos25),
      )
    ))
  )
}



graficar_parallel <- function(datos_corte, datos_full, vars_parallel){
  vars_25 <- paste0(vars_parallel, '25')
  vars_0 <- paste0(vars_parallel, '0')
  data_parallel25_c <- subset(datos_corte, select = vars_25)
  #data_parallel25_c$riesgo <- datos_corte$riesgo
  # t0
  to_extract <- rownames(data_parallel25_c)
  # Cortar escenarios: REVISAR
  data_full_cut <- datos_full[-1] %>% slice(as.numeric(to_extract))
  data_full_cut <- as.data.frame(data_full_cut)
  rownames(data_full_cut) <- rownames(datos_corte)
  data_parallel0_c <- subset(data_full_cut, select = c(vars_0))
  parallel_comparation(data_parallel25_c, data_parallel0_c)
}



extraer <- function(datos_corte, datos_full, vars_data){
  vars_25 <- paste0(vars_data, '25')
  vars_0 <- paste0(vars_data, '0')
  data25_c <- subset(datos_corte, select = vars_25)
  # t0
  to_extract <- rownames(data25_c)
  data_full_cut <- datos_full[-1] %>% slice(as.numeric(to_extract))
  data_full_cut <- as.data.frame(data_full_cut)
  rownames(data_full_cut) <- rownames(datos_corte)
  data0_c <- subset(data_full_cut, select = c(vars_0))
  x <- cbind(data0_c, data25_c)
  return(x)
}




preparar_arbol2 <- function(data, umbral1, umbral2, forzante, estado, repercusion, invertir1, invertir2, corte_umbral){
  # Separar valores en el tiempo e interacciones
  #valores en el tiempo
  data_time <- as.data.frame(data[,1:265])
  
  # cálculo 
  
  data_time$reliability <- (0.5*unlist(reliability_calc(umbral1, data_time, forzante, estado, invertir1))) + (0.5*unlist(reliability_calc(umbral2, data_time, estado, repercusion, invertir2)))
  data_time  <- as.data.frame(data_time)
  
  if (corte_umbral!=1) {
    corte_umbral <- as.numeric(summary(data_time$reliability)[corte_umbral])
  }
  
  
  data_time$reliability <- factor(ifelse(data_time$reliability < corte_umbral, "abajo", "arriba"))
  
  #interacciones
  data_interacciones <- data[,267:ncol(data)]
  
  # seleccionar tiempo 25
  tmp <- data_time %>%
    dplyr::select(ends_with("25"))
  #incluir valores de prueba
  tmp$`valores_prueba` <- data$`Valores de prueba`
  # poner valores de prueba en la primera columna
  tmp <- tmp %>%
    dplyr::select(`valores_prueba`, everything())
  tmp$reliability <- data_time$reliability
  colnames(tmp)
  data2 <- tmp
  
  # Eliminar columnas
  data2_subset <- subset(data2, select = -c(valores_prueba, CC25, GEI25, TMAYA25))
  data2_subset <- as.data.frame(data2_subset)
  colnames(data2_subset)
  mod1 <- rpart(reliability ~ ., data=data2_subset, model=TRUE)
  return(mod1)
}



preparar_arbol <- function(data, umbral1, forzante, estado, invertir, corte_umbral){
  # Separar valores en el tiempo e interacciones
  
  #valores en el tiempo
  data_time <- as.data.frame(data[,1:265])
  # cálculo 
  data_time$reliability <- unlist(reliability_calc(umbral1, data_time, forzante, estado, invertir))
  if (corte_umbral!=1) {
    corte_umbral <- as.numeric(summary(data_time$reliability)[corte_umbral])
  }
  
  data_time$reliability <- factor(ifelse(data_time$reliability < corte_umbral, "abajo", "arriba"))
  
  #interacciones
  data_interacciones <- data[,267:ncol(data)]
  
  # seleccionar tiempo 25
  tmp <- data_time %>%
    dplyr::select(ends_with("25"))
  #incluir valores de prueba
  tmp$`valores_prueba` <- data$`Valores de prueba`
  # poner valores de prueba en la primera columna
  tmp <- tmp %>%
    dplyr::select(`valores_prueba`, everything())
  tmp$reliability <- data_time$reliability
  colnames(tmp)
  data2 <- tmp
  
  # Eliminar columnas
  #data2_subset <- subset(data2, select = -c('valores_prueba', vars_fuera_arbol))
  data2_subset <- subset(data2, select = -c(valores_prueba, CC25, GEI25, TMAYA25))
  data2_subset <- as.data.frame(data2_subset)
  colnames(data2_subset)
  mod1 <- rpart(reliability ~ ., data=data2_subset, model=TRUE)
  return(mod1)
}




#Gráficas de cajas
graficar_cajas_percentiles <- function(cortes, var, reglas, riesgo){
  # preparar datos
  a_comparar <- list()
  for (i in 1:total_cortes) {
    a_comparar[[i]] <- cortes[[i]] %>% dplyr::select((var))
    a_comparar[[i]]$condicion <- reglas[i]
    a_comparar[[i]]$riesgo <- cortes[[i]]$riesgo
  }
  df <- ldply (a_comparar, data.frame)
  data_tidy <- gather(df, variable, valor, -c(riesgo, condicion))
  # Gráfica cajas
  cajas <- ggplot(data= data_tidy, mapping= aes(x= condicion,
                                                fill= riesgo, color= riesgo, y=valor)) +
    geom_boxplot(alpha= 0.3,
                 outlier.colour= "black",
                 outlier.fill= "black",
                 outlier.size= 3) +
    #scale_y_continuous(limit = c(0,1)) +
    labs(plot.title=element_text(size=15),
         x= "", 
         y= "") +
    theme(axis.title.y = element_blank(), 
          #axis.text.y = element_blank(),
          axis.line.y=element_blank(),
          #axis.ticks.y = element_blank(),
          axis.line.x = element_line(colour = "black"),
          panel.background = element_blank(),
          panel.grid = element_line(color= "grey",linetype = 4)) +
    scale_x_discrete(labels = function(x) str_wrap(x, width = 5))
  return(cajas)
}



#Gráficas de cajas
graficar_cajas <- function(cortes, datos_full, vars, reglas){
  # preparar datos
  a_comparar <- list()
  for (i in 1:total_cortes) {
    a_comparar[[i]] <- extraer(cortes[[i]], datos_full, vars)
    #a_comparar[[i]] <- cortes[[i]] %>% dplyr::select(starts_with(var))
    a_comparar[[i]]$condicion <- reglas[i]
  }
  df <- ldply (a_comparar, data.frame)
  data_tidy <- gather(df, Variable, valor, -condicion)
  # Gráfica cajas
  cajas <- ggplot(data= data_tidy, mapping= aes(x= condicion,
                                                fill= Variable, color= Variable, y=valor)) +
    geom_boxplot(alpha= 0.3,
                 outlier.colour= "black",
                 outlier.fill= "black",
                 outlier.size= 3) +
    #scale_y_continuous(limit = c(0,1)) +
    labs(plot.title=element_text(size=15),
         x= "", 
         y= "") +
    theme(axis.title.y = element_blank(), 
          #axis.text.y = element_blank(),
          axis.line.y=element_blank(),
          #axis.ticks.y = element_blank(),
          axis.line.x = element_line(colour = "black"),
          panel.background = element_blank(),
          panel.grid = element_line(color= "grey",linetype = 4)) +
    scale_x_discrete(labels = function(x) str_wrap(x, width = 15))
  
  return(cajas)
}

graficar_media <- function(data_s, xtime, titulo){
  out <- ggplot(data_s, aes(x = t, y = Estado, group = Variable, color= Variable)) +
    
    ##geom_line() +
    
    geom_smooth(se=FALSE) +
    ## Set the Y-axis scale, remove for autoscale
    coord_cartesian(xlim = c(0, xtime), ylim = c(0,1)) +
    
    ## Set theme&basic font
    theme_light(base_size = 16) #+
  
  ### Style the axis (font size)
  # theme(axis.text.x = element_text(size=16, angle=0, vjust = 0), axis.text.y = element_text(size=16)) +
  
  ### Set layout of the graph 
  #theme(panel.border = element_rect(size = 1, linetype = "solid", colour = "black", fill=NA)) +
  
  
  theme(legend.key=element_blank(), legend.background=element_blank()) +
    
    
    ### Set aspect ratio of the graph n/n = square
    #theme(aspect.ratio=4/4)
    return(out + labs(x= "Tiempo (años)", y = "Valor", title = titulo))
}

extraer_variable <- function(x, variable, par_val, first_column_name, time_values){
  tmp <- x %>%
    dplyr::select(starts_with(par_val) | starts_with(variable))
  tmp <- tmp[,1:7]
  names(tmp) <- c(first_column_name, time_values)
  return(tmp)
}

calcular_efecto <- function(corte_data, estado){
  efectos <- list() 
  df <- corte_data %>% dplyr::select(paste0(estado, 0), paste0(estado, 25))
  efectos$efecto <- round((mean(df[[2]])-mean(df[[1]]))*100)
  efectos$tendencia <- if (efectos$efecto > 0) {"Crecimiento"} else {"Decrecimiento"}
  efectos$efecto <- paste0(abs(efectos$efecto), '%')
  return(efectos)
}

regla_etiqueta <- function(n, n_ok, mod1){
  subrules <- rpart.subrules.table(mod1)
  rules <- rpart.rules.table(mod1)
  df_mod1 <- mod1$frame
  
  if (n_ok == 1) {
    nn <- df_mod1$n==n  
  } else {
    nn <- n  
  }
  
  
  # extrar la regla del banco de mod1
  #rownames(df_mod1[df_mod1$n==n,])
  rownames(df_mod1[nn,])
  
  # buscar las subrules asociadas
  subset(rules, Rule==rownames(df_mod1[nn,]))
  
  # sacar las subreglas
  tmpp <- subset(rules, Rule==rownames(df_mod1[nn,]))
  
  # unir los bancos
  tmpp <- merge(tmpp, subrules)
  
  tmpp$condicional <- "<"
  
  tmpp$condicional[tmpp$Greater>0] <- ">="
  
  is.na(tmpp$Less) <- 0
  tmpp[is.na(tmpp)] <- 0
  
  tmpp$valor <- as.numeric(tmpp$Less)+as.numeric(tmpp$Greater)
  tmpp$etiqueta <- paste0(tmpp$Variable, tmpp$condicional, round(tmpp$valor,2))
  
  etiq <- paste(tmpp$etiqueta, collapse = ", ")
  return(etiq)
} 

reglas_etiqueta <- function(n, n_ok, mod1){
  etiquetas <-list()
  for (i in 1:length(elem_seleccionados)) {
    etiquetas[[i]] <- regla_etiqueta(elem_seleccionados[[i]], n_ok, mod1)
  }
  return(etiquetas)
} 

banco_salida <- list()