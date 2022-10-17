# Análisis de sensibilidad

Los análisis de sensibilidad permiten obtener una aproximación cuantitativa de la influencia que tiene un particular elemento (e.g. un criterio) o experto en el resultado general de un problema de decisión.

Por ejemplo, el análisis de grupos consiste en cotejar el juicio experto y la pertinencia del campo de conocimiento en cada una de las comparaciones pareadas de todos los elementos de un modelo multicriterio jerárquico (AHP).

Por su cuenta, el análisis de sensibilidad de intervalos de juicio no sólo incorpora rigurosamente la pluralidad de puntos de vista sobre la importancia relativa de los elementos del AHP, sino también sintetiza de manera pragmática la incertidumbre de los factores que determinan un problema de decisión.

Con estos análisis de sensibilidad es posible resolver aspectos fundamentales en el AHP en cuanto a la credibilidad y la incertidumbre del juicio de expertos.


## Análisis de sensibilidad de grupos

El análisis de sensibilidad de grupos, también llamdao del efecto individual, permite calcular la influencia de cada experto sobre los resultados agregados del AHP. 

Este análisis informa a los usuarios del AHP sobre los juicios individuales que más influyen en los pesos y alternativas grupales. Dicha información resulta útil en modelos multicriterio cuyo proceso de desarrollo involucra la agregación de resultados de múltiples expertos con preferencias, conocimientos y experiencias diferentes. El cambio parcial sobre los pesos grupales agregados se obtiene a partir del método de diferencias finitas. Esencialmente, este método consiste en modificar con un valor de perturbación de 1% mediante derivadas parciales cada comparación pareada. 

El efecto de la variación de la comparación pareada individual sobre el peso grupal se obtiene con la siguiente ecuación:


donde a_kl es la comparación pareada de renglón k y columna l, de cada matriz de comparaciones pareadas C^(P_j ), y A_s^(P_j )  es el peso de la alternativa, s,  del experto P_j.

Descarga [aquí] el análisis de sensibilidad de grupos en Excel o visita el [repositorio] para obtener el código en RStudio.

**Referencias**

Ivanco, M. (2015). Development of analytical sensitivity analysis for AHP applications. [Master of Science thesis, Old Dominion University].

Ivanco, M., Hou, G. & Michaeli, J. (2017). Sensitivity analysis method to address user disparities in the analytic hierarchy process. Expert Systems with Applications, 90, 111-126.

Merino-Benítez. T., Grave, I., & Bojórquez-Tapia, L. A. (2020). "AHP-based vulnerability index for small fisheries in Yucatan, Mexico". Proceedings of the International Symposium on the Analytic Hierarchy Process: the 16th ISAHP conference. DOI: http://www.isahp.org/uploads/048_001.pdf


## Análisis de intervalos de juicio

El análisis de sensibilidad por intervalos de juicio está basado en la metodología propuesta por Saaty y Vargas (1987). Este análisis permite (1) incorporar la incertidumbre inherente en las comparaciones pareadas, y (2) calcular la probabilidad de reversión de rango de las alternativas en los procesos de decisión. 
Las matrices de comparaciones pareadas se utilizan como insumos para la construcción de matrices con intervalos de juicio I_ij≡ a_ij^L,a_ij^U] , donde I_ij es el intervalo asociado a la incertidumbre de la comparación de la alternativa A_i con A_j de un conjunto finito de n alternativas A_1,A_2,… A_n. La matriz de intervalos de juicio queda compuesta de la siguiente manera:



## Análisis de sensibilidad de filas (ROW)



## Análisis de remoción de capas

