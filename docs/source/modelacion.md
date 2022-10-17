# Modelación de sistemas dinámicos

La modelación de sistemas socioambientales se realiza a través de su conceptualización o abstracción a un modelo  matemático (Acevedo 2013). Dicho modelo es una representación simplificada de un aspecto de la realidad, basada en conceptos, hipótesis y teorías de cómo funciona el sistema real. Esto ayuda a reducir la complejidad de la realidad a una forma y tamaño manejables (Stokey y Zeckhauser 1978, Ford 2010). 

Existen dos tipos de modelación, la constitutiva y la exploratoria.  Con la modelación constitutiva se busca crear representaciones lo más apegadas a la realidad (Burns y Marcy 1979), mientras que con la modelación exploratoria se busca realizar experimentos computacionales que puedan revelar cómo el mundo se comportaría bajo ciertas suposiciones.

## Modelos de depósitos y flujos

Como su nombre lo indica, estos modelos incluyen flujos y depósitos. Los flujos (o variables forzantes) son entidades que hacen que los depósitos (o variables de estado) se incrementen o disminuyan. Si el flujo tiene un efecto positivo en el depósito (por ejemplo, infiltración de agua en un acuífero), es una entrada; mientras que, si tiene un efecto negativo (por ejemplo, extracción de agua del acuífero), es una salida. Los flujos representan actividad e indican movimiento de material o información. 

Otros elementos importantes a incluir son las variables auxiliares, como las constantes (que no cambian en el periodo de tiempo), y las ecuaciones que describen matemáticamente el comportamiento del sistema.

Encuentra [aquí](https://vensim.com/free-download/) la página donde puedes descargar VENSIM, un software especial para desarrollar estos modelos dinámicos.

### Modelo bioeconómico de Gordon-Schaefer

Un ejemplo de los modelos de depósitos y flujos es el modelo bioeconómico de Gordon-Schaefer (González-Olivares 1998; Gordon 1954; Schaefer 1954; Smith 1969), el cual es utilizado para estudiar el comportamiento pesquero. Este modelo describe el comportamiento de una población como un fenómeno que depende de la densidad de la población. 

Resulta en una curva sigmoidea, en la cual la biomasa (especies marinas) no explotada incrementa hasta el nivel máximo posible según la capacidad de carga del ambiente. En este punto, la población se mantiene en equilibrio ya que los factores de mortalidad que hacen decrecer la población (depredación, enfermedades, accidentes, etcétera) están balanceados por los factores que la hacen crecer (reproducción, reclutamiento, inmigración, etcétera).

Descarga [aquí] el modelo de Gordon-Schaefer desarrollado en Excel.

## KSIM

La KSIM, o simulación K, por Kane (1972), es una técnica de modelación exploratoria y cualitativa. El proceso de modelación consiste en que los modeladores lleguen a consensos sobre la estructura actual de un sistema, mediante la selección de sus componentes principales y las relaciones causa-efecto entre estos. A partir de dichas relaciones, el algoritmo KSIM genera gráficas de los comportamientos del sistema para un periodo de tiempo determinado.

Descarga [aquí] un ejemplo de KSIM desarrollado en Excel.

Descarga [aquí] la conjugación del modelo bioeconómico Gordon-Schaefer con la KSIM. 


## Modelación exploratoria

La modelación exploratoria es el proceso que responde a la pregunta “¿qué pasaría si…?”. Este tipo de modelación permite investigar, crear y probar condiciones del sistema en un tiempo futuro bajo una serie de conjeturas preestablecidas (Bankes 1993). Es decir, permite visualizar qué pasaría en el sistema en diferentes cursos de acción sobre sus componentes.

Los modelos exploratorios usan los datos disponibles y el poder de cómputo para realizar una serie de experimentos para visualizar y analizar múltiples posibilidades de evolución de un sistema bajo una gama de condiciones. Los productos de estos modelos pueden servir como base para las discusiones y la evaluación de consecuencias de posibles intervenciones y, por lo tanto, son un sustento para decisiones más racionales e informadas.

Descarga [aquí] un ejemplo de KSIM desarrollada con complemento de Excel llamado [Crystal Ball](https://www.oracle.com/applications/crystalball/). El uso de Crystal Ball permite variar los parámetros y variables del modelo con intervalos de incertidumbre. Visita [aquí] el repositorio para la visualización de los resultados del ejemplo.