#ICC para tres jueces en una revision sistematica por bloques (script)

#0. carga librerias necesarias

library(tidyr)
library(dplyr)
library(tidyverse)
library(jsonlite)
library(irr)
library(stringr)


#BLOQUE 1----
#1.abre directorio (Control + Mayus + H)
setwd("~/JENNY/Docencia ULL/TFGs/2025/grupo kimberly, carla y laura") #este es para mi caso, pero el vuestro ser? otro

#2. busca el archivo y lee la base
dir()
bd <- as.data.frame(read.csv('articles_github.csv'))

View(bd)
#3. preparo la base

bd <- bd[,c("key","notes")] #me quedo solo con las columnas que me interesa

bd <- bd %>%
  mutate(notes2 = notes %>%
           str_replace_all("name_of_your_rater_1", "rater1") %>%
           str_replace_all("name_of_your_rater_2", "rater2") %>%
           str_replace_all("name_of_your_rater_3", "rater3"))

names(bd)

bd <- bd %>%
  mutate(rayyan_inclusion = str_extract(notes, "RAYYAN-INCLUSION: \\{[^}]+\\}")) #separo las inclusiones
bd <- bd %>%
  mutate(bloques = str_extract(notes, "bloque 1")) #separo las etiquetas de los bloques

#4 preparo las variables de decision

extraer_decision <- function(texto, nombre) {
  # Si el texto es NA, devolvemos NA directamente
  if (is.na(texto)) return(NA)
  # Usamos expresi?n regular para extraer el valor asociado al nombre
  patron <- paste0('"', nombre, '"=>\\"(.*?)\\"')
  resultado <- regmatches(texto, regexpr(patron, texto, perl = TRUE))
  if (length(resultado) == 0) return(NA)
  sub(paste0('.*', nombre, '"=>\\"(.*?)\\".*'), "\\1", resultado)
}

bd$rater1    <- sapply(bd$rayyan_inclusion, extraer_decision, nombre = "rater1")
bd$rater2 <- sapply(bd$rayyan_inclusion, extraer_decision, nombre = "rater2")
bd$rater3    <- sapply(bd$rayyan_inclusion, extraer_decision, nombre = "rater3")

nv(bd)
bd[,5:7]#compruebo

#5. cambio los included por 1 y los excluded por 0

bd$rater1_n    <- ifelse(is.na(bd$rater1), NA, ifelse(bd$rater1 == "Included", 1, 0))
bd$rater2_n <- ifelse(is.na(bd$rater2), NA, ifelse(bd$rater2 == "Included", 1, 0))
bd$rater3_n    <- ifelse(is.na(bd$rater3), NA, ifelse(bd$rater3 == "Included", 1, 0))


bd[,4:10]#compruebo


#6. filtro por bloque 1

bd_filtrada <- subset(bd, bloques == "bloque 1")

#7. ICC bloque 1

with(bd_filtrada, table(rater1_n, rater2_n, rater3_n))

#forma 1 = ICC
decisiones <- bd_filtrada[, c("rater1_n", "rater2_n", "rater3_n")]
print(icc(decisiones, model = "twoway", type = "consistency", unit = "single"))
#resultado = .23


#forma 2 = Fleiss de kappa
irr::kappam.fleiss(decisiones)
#resultado = .21


#Interpretación
# Rango ICC	  Nivel de acuerdo
#
#   <0.40	    Pobre
#0.40 - 0.59	Moderado
#0.60 - 0.74	Bueno
#0.75 - 1.00	Excelente
