##______________________________________________________________________________
##______________________________________________________________________________
#       UNIVERSIDAD NACIONAL DE COLOMBIA - FACULTAD DE CIENCIAS ECON�MICAS
#                         ECONOMETRIA II - 2020-II
#                 SESI�N #2 MONITORIA : ESTAD�STICA B�SICA
##______________________________________________________________________________
##______________________________________________________________________________

rm(list = ls()) #limpiar el environment 

## 1. Importaci�n y tipos de datos ____________________________________________________

##| Formatos  Permitidos |            Tipo             |   |   |   |
##|----------------------|-----------------------------|---|---|---|
##|          Csv         |     Delimitado por comas    |   |   |   |
##|          txt         | Delimitado por tabulaciones |   |   |   |
##|          dta         |            Stata            |   |   |   |
##|       xls, xlsx      |            Excel            |   |   |   |

#1.1 Configuraci�n del directorio de trabajo---------------------------------------------

directorio = getwd()       #Obtener el directorio de trabajo 
setwd(directorio)

#Establecer un nuevo directorio de trabajo  
#La ruta debe estar entre comillas y con el slash "/"

#1.2 Importar formato csv----------------------------------------------------------------
#read.csv
titanic<-read.csv(file.choose(),sep=",")
View(titanic)   #La funci�n View es con V may�scula
attach(titanic) # Trabajar con el nombre de los datos de las variables 
summary(titanic)  #res�men de los datos

#1.3 Archivos de Excel--------------------------------------------------------------------
install.packages("readxl")
library("readxl")

#Cargos Datos1
Excel<-read_excel(file.choose())
Excel
attach(Excel)
View(Excel) 

# 1.4 Datos en STATA ---------------------------------------------------------------------
# datos en http://qcpages.qc.cuny.edu/~rvesselinov/statadata/phillips.dta

install.packages("foreign") 
library(foreign)

#read.dta
Datos<-read.dta("http://qcpages.qc.cuny.edu/~rvesselinov/statadata/phillips.dta")


#Importci�n de datos usando las biblioteas de tidyverse----------------------------------

#Instalamos y cargamos los paquetes.
install.packages("tidyverse")
library(tidyverse)

# La biblioteca tidyverse es un conjunto de paquetes de R que permiten: 
# Importar, modificar y analizar bases de datos 
# Contiene el objeto: tibble que cumple el mismo papel que un dataframe pero con m�s funcionalidades
# Contiene adem�s funcionalidades de gr�ficaci�n
# Paquetes principales:
#### dplyr: Para modificar los datos dentro de la base de datos
#### tidyr: Para modificar la estructura de la base de datos
#### ggplot2: Biblioteca de graficaci�n
#### readr: Para importar y trabajar con archivos excel 

# Un ejemplo de esto es importar un archivo csv usando tidyverse
# read_csv importa la base de datos como un objeto tibble
titanic2 = read_csv(file.choose()) # La funci�n read_csv es diferente a read.csv
# glimpse es una herramienta que permite visualizar la base de datos en la consola
glimpse(titanic2) # funciona mejor si se emplea sobre un objeto de tipo tibble


# 2. Manipulaci�n de base de datos ______________________________________________________

# 2.1 Convertir variables cualitativas en cuantitativas -----------------------------------------------

titanic$Sex<-ifelse(titanic$Sex=="female",1,0) #ifelse(test l�gico, yes/verdadero, no/falso)
titanic$PClass<-ifelse(titanic$PClass=="1st",1,
                       ifelse(titanic$PClass=="2nd",2,3))

# 2.2 Medidas de tendencia central y variabilidad-----------------------------------------

mean(Age, na.rm= T)         #Media
median(Age,na.rm = T)       #Mediana
sd(Age,na.rm = T)           #Desviaci�n estandar
var(Age,na.rm = T)          #Varianza
help(mean) #na.rm es para que las casillas en las que no hay informaci�n no se tomen en cuenta

#2.3 Gr�ficos----------------------------------------------------------------------------

# 2.3.1 Gr�ficos usando las funciones de R

#Tablas
table(Sex)
table(PClass)

#Barras barplot
x11()
barplot(table(Sex), main ="Frecuencia de g�nero", xlab="G�nero", ylab ="N�mero", col="brown")

#histograma hist
x11()
hist(Age, main = "Edad de los tripulantes", xlab="Edad", ylab = "Frecuencia", col = "green")

#Diagrama de caja boxplot
x11()
boxplot(Age, col=c(3), horizontal = TRUE, main="Edad tripulantes Titanic")
abline(v=mean(Age,na.rm = T),col=c(2))
summary(Age)

#Gr�fico tipo pie
x11()
pie(table(Survived),radius=0.8, main = "Gr�fico tipo pastel", col = c("brown1","blue2"))
legend("topleft", legend= c("Desaparecido","Sobreviviente"), pch = 10,col =
         c("brown1","dodgerblue"),)


# 2.2 Gr�ficos usando la biblioteca ggplot2

# La funci�n base para hacer todos los gr�ficos es ggplot
hist1 = ggplot(data = titanic, aes(Age)) +
        geom_histogram(fill = "green") + 
        labs(title = "Edad de los tripulantes") +
        xlab("Edad") + 
        ylab("Frecuencia") 
hist1

#3. REGRESI�N LINEAL ____________________________________________________________________

install.packages("wooldridge")
library(wooldridge)

#Importar base de datos llamada bwght2

data("bwght2") # para importar bases de datos que se encuentran en el paquete wooldridge
attach(bwght2)
help(bwght2) # descripci�n de la base de datos 

#DESCRIPCI�N:  N=1832 & 23 variables, cross-sectional individual data on birth weights

##VARIABLES:
#mage: mother's age, years
#meduc: mother's educ, years
#monpre: month prenatal care began
#npvis: total number of prenatal visits
#fage: father's age, years
#feduc: father's educ, years
#bwght: birth weight, grams
#omaps: one minute apgar score
#fmaps: five minute apgar score
#cigs: avg cigarettes per day
#drink: avg drinks per week
#lbw: =1 if bwght <= 2000
#vlbw: =1 if bwght <= 1500
#male: =1 if baby male
#mwhte: =1 if mother white
#mblck: =1 if mother black
#moth: =1 if mother is other
#fwhte: =1 if father white
#fblck: =1 if father black
#foth: =1 if father is other
#lbwght: log(bwght)
#magesq: mage^2
#npvissq: npvis^2

#CARACTER�STICAS DE LAS VARIABLES
summary(bwght2) # informaci�n m�s extensa de la base de datos 
glimpse(bwght2) # manera compacta de visualizar la base de datos

#Histograma de la variable dependiente. 
x11()
hist(bwght2$bwght)

###ESTIMACI�N

#El peso promedio de un ni�o al nacer es una funci�n de: el promedio de cigarrillos fumados por la madre, promedio
#del consumo de alcohol, el sexo del beb�, la edad de la madre y de la raza de la madre.
MODELO1 = lm(bwght ~ cigs + drink + npvis + male + mage + mwhte + mblck, data = bwght2)
summary(MODELO1)

#En esta regresi�n, a parte de las anteriores variables, controlamos por la educaci�n del padre y de la madre, pues
#es posible que al no incluirlas en la regresi�n se presente un sesgo de variable omitida: �Puede haber correlaci�n 
#entre el consumo de alcohol y cigarrillos con el nivel educativo de la madre y el padre?
MODELO2 = lm(bwght ~ cigs + drink + npvis + male + mage + magesq +mwhte + mblck + meduc + feduc , data = bwght2)
summary(MODELO2)

#A partir del mismo argumento utilizaremos el promedio de la educaci�n de ambos padres, con objeto de reducir las contradicciones
#de resultados que puedan darse entre el nivel educativo del padre y de la madre por separados.
mean.educ = (meduc + feduc)/2
MODELO3 = lm(bwght ~ cigs + drink + npvis + male + mage + magesq +mwhte + mblck + mean.educ, data = bwght2)
summary(MODELO3)


## PRESENTACI�N DE RESULTADOS

# Stargazer permite crear autom�ticamente tablas de regresiones y estad�stica descriptiva de alta calidad

install.packages("stargazer")
library(stargazer)

# Funci�n b�sica del paquete stargazer
stargazer(MODELO1, MODELO2, MODELO3, type="text", column.labels = c("REG1","REG2", "REG3"),keep.stat = c("n", "rsq","adj.rsq","aic"))
# En el ejemplo stargazer mostrar� las 3 regresiones lineales presentadas.


# Opciones de Stargazer: 
## Permite visualizar varios modelos al mismo tiempo
## title: introducir un t�tulo
## type: el formato de la tabla (e.g. text o latex)
## omit: si se quiere omitir alguna variable de la tabla
## style: espec�fica el estilo de la tabla (e.g. aer para American Economic Review)


#----------------------
##OTRO EJEMPLO

#DESCRIPCI�N:  173 observations on 10 variables.

#state: state postal code
#district: congressional district
#democA: =1 if A is democrat
#voteA: percent vote for A
#expendA: camp. expends. by A, $1000s
#expendB: camp. expends. by B, $1000s
#prtystrA: percent vote for president. That is to say, (the percentage of the most recent 
#presidential vote that went to A's party).
#lexpendA: log(expendA)
#lexpendB: log(expendB)
#shareA: 100*(expendA/(expendA+expendB))

#DESCRIPCI�N DE LAS VARIABLES.

#Cargamos la base de datos contenida en el archivo de excel Elecciones
library(readxl)
Elecciones = read_excel(file.choose())

#Le damos attach para poder trabajar con los mismos nombres de las columnas del excel
attach(Elecciones)

#Visualizamos los datos
View(Elecciones)
summary(Elecciones)

#3.1 Estimaci�n -------------------------------------------------------------------------

#Realizamos una regresi�n nivel-nivel
Regresi�nA1 = lm(voteA ~ democA +expendA + expendB + prtystrA) #lin-lin
summary(Regresi�nA1)

#Realizamos una regresi�n nivel-logaritmo.
Regresi�nA2 = lm(voteA ~ democA +log(expendA)+log(expendB) + log(prtystrA)) #lin-log
summary(Regresi�nA2)

#Presentaci�n de resultados
library(stargazer)
stargazer(Regresi�nA1, Regresi�nA2, type="text", column.labels = c("N-N","N-L"),keep.stat = c("n", "rsq" "adj.rsq", "aic"))

#3.2 Pruebas de significancia individual para las variables ------------------------------

install.packages("lmtest")
library("lmtest")
coeftest(Regresi�nA2)

#Intervalos de confianza para los coeficientes de la regresi�n
confint(Regresi�nA2) #Al 95%
confint(Regresi�nA2, level = 0.90) #Al 90%

#Valores ajustados/estimados (fitted.values)
fitted.values(Regresi�nA2)

#Residuales de la regresi�n
residuals(Regresi�nA2)
rstandard(Regresi�nA2) #Residuales estandarizados (divididos por su desviaci�n est�ndar)

# 4. Validaci�n de supuestos ------------------------------------------------------------

#Test de Ramsey para especificaci�n err�nea
resettest(Regresi�nA2) #Ho = el modelo est� bien especificado

#Heterocedasticidad en los residuales
install.packages("car")
library("car")

bptest(Regresi�nA2) #Test Breusch-Pagan con Ho=Homocedasticidad

ncvTest(Regresi�nA2)#Test de Varianza no constante con Ho= Homocedasticidad

#Correlaci�n serial en los residuales

dwtest(Regresi�nA2)#Durbin Watson test (Ho:No autocorrelaci�n de 1er orden)

bgtest(Regresi�nA2)#Prueba Breush-Godfrey (Ho:No autocorrelaci�n de orden p)

#Gr�fico de correlaci�n serial

residA2 =rstandard(Regresi�nA2)
acf(residA2, xlab="Residuos", ylab="Autocorrelaciones", main= "CORRELALOGRAMA")

#Err�res robustos a la heterocedasticidad y correlaci�n con HAC
install.packages("sandwich")
library("sandwich")

vcovHC(Regresi�nA2)
coeftest(Regresi�nA2, vcov=vcovHC(Regresi�nA2))
coeftest(Regresi�nA2)

#Normalidad en los residuales con Ho = Normalidad
install.packages("tseries")
library("tseries")

resreg=residuals(Regresi�nA2) # Calculamos los residuos 

shapiro.test(resreg) #Test Shapiro Wilk (Ho= normalidad)
jarque.bera.test(resreg)#Test Jarque Bera  (#Ho= normalidad)/M�s apropiado para series de tiempo
 

#Histograma de los residuos
hist(resreg, freq=FALSE, main="Distribuci�n de los Residuales", breaks = 20, prob=TRUE)
curve(dnorm(x, mean=mean(resreg), sd=sd(resreg)),col="darkblue", lwd=2, add=TRUE)

#Gr�fica qq-plot
install.packages("car")
library(car)
install.packages("patchwork") #Con este paquete podemos unificar gr�ficas del mismo formato
library(patchwork)
install.packages("gridGraphics")
library(gridGraphics)
install.packages("tibble")
library(tibble)
install.packages("ggplot2")
library(ggplot2)

#Definimos los cuartiles muestrales
q <- (rank(resreg) - .5) / length(resreg)
q


#Definimos los intervalos de confianza
band <- tibble(
        z = seq(-2.2, 2.2, length.out = 300),
        n = length(d$x_sample),
        
        sample_sd = sd(d$x_sample),
        se = sample_sd * se_z(z, n),
        line = mean(d$x_sample) + sample_sd * z,
        upper = line + 2 * se,
        lower = line - 2 * se,
        
        robust_sd = IQR(d$x_sample) / 1.349,
        robust_line = median(d$x_sample) + z * robust_sd,
        robust_se =  robust_sd * se_z(z, n),
        robust_upper = robust_line + 2 * robust_se,
        robust_lower = robust_line - 2 * robust_se,
)

#Ahora graficamos utilizando la funci�n qqplot

#Fijamos los m�rgenes
par(mar = c(4, 2, 1, 2))

p1 <- wrap_elements(~ car::qqPlot(resreg))

p2 <- wrap_elements(~ {
        car::qqPlot(resreg)
        lines(band$z, band$robust_line, col = "black", lwd = 2)
        lines(band$z, band$robust_upper, col = "black", lwd = 2)
        lines(band$z, band$robust_lower, col = "black", lwd = 2)
})

p1 + p2

#__________________________________________________________

#Nota:
#�Qu� elementos incluir en el stargazer?

#"all" all statistics
#"adj.rsq" adjusted R-squared
#"aic" Akaike Information Criterion
#"bic" Bayesian Information Criterion
#"chi2" chi-squared
#"f" F statistic
#"ll" log-likelihood
#"logrank" score (logrank) test
#"lr" likelihood ratio (LR) test
#"max.rsq" maximum R-squared
#"n" number of observations
#"null.dev" null deviance
#"Mills" Inverse Mills Ratio
#"res.dev" residual deviance
#"rho" rho
#"rsq" R-squared
#scale" scale
#"theta" theta
#"ser" standard error of the regression (i.e., residual standard error)
#"sigma2" sigma squared
#"ubre" Un-Biased Risk Estimator
#"wald" Wald test
