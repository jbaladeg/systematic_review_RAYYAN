#ICC for three judges in a systematic block review (script)

#0. load required libraries

library(tidyr)
library(dplyr)
library(tidyverse)
library(jsonlite)
library(irr)
library(stringr)


#BLOQUE 1 / BLOCK 1----
#1.Open directory (Control + Mayus + H) ----
#2. find the file and read the base ----
dir()
bd <- as.data.frame(read.csv('articles_github.csv'))

View(bd)
#3. Prepare the base ----

bd <- bd[,c("key","notes")] #I just want to use these variables

#####this is a extra step... if you want to simplify the script, just change the names of your raters with "rater1", "rater2"...
#####In this case, "articles_github_cvs already has this change. Don't run this part for the example.
bd <- bd %>%
  mutate(notes = notes %>%
           str_replace_all("name_of_your_rater_1", "rater1") %>%
           str_replace_all("name_of_your_rater_2", "rater2") %>%
           str_replace_all("name_of_your_rater_3", "rater3"))

names(bd)

bd <- bd %>%
  mutate(rayyan_inclusion = str_extract(notes, "RAYYAN-INCLUSION: \\{[^}]+\\}")) #separate decision column
bd <- bd %>%
  mutate(bloques = str_extract(notes, "bloque 1")) #separate the labels from the blocks

#4. Prepare decision labels

extraer_decision <- function(texto, nombre) {
  # If the value is NA, return NA
  if (is.na(texto)) return(NA)
  # We use regular expression to extract the value associated with the name
  patron <- paste0('"', nombre, '"=>\\"(.*?)\\"')
  resultado <- regmatches(texto, regexpr(patron, texto, perl = TRUE))
  if (length(resultado) == 0) return(NA)
  sub(paste0('.*', nombre, '"=>\\"(.*?)\\".*'), "\\1", resultado)
}

bd$rater1    <- sapply(bd$rayyan_inclusion, extraer_decision, nombre = "rater1")
bd$rater2 <- sapply(bd$rayyan_inclusion, extraer_decision, nombre = "rater2")
bd$rater3    <- sapply(bd$rayyan_inclusion, extraer_decision, nombre = "rater3")

nv(bd)
bd[,5:7]#check

#5. I change the included by 1 and the excluded by 0 ----
bd$rater1_n    <- ifelse(is.na(bd$rater1), NA, ifelse(bd$rater1 == "Included", 1, 0))
bd$rater2_n <- ifelse(is.na(bd$rater2), NA, ifelse(bd$rater2 == "Included", 1, 0))
bd$rater3_n    <- ifelse(is.na(bd$rater3), NA, ifelse(bd$rater3 == "Included", 1, 0))


bd[,4:10]#check

#6. filter per block 1 ----

bd_filter <- subset(bd, blocks == "bloque 1")

#7. ICC - Block 1 ----

with(bd_filter, table(rater1_n, rater2_n, rater3_n))


#form 1 = ICC (in general)
decision <- bd_filter[, c("rater1_n", "rater2_n", "rater3_n")]
print(icc(decision, model = "twoway", type = "consistency", unit = "single"))
    #result = .23

#form 2 = Fleiss de kappa (for three raters)
decision <- bd_filter[, c("rater1_n", "rater2_n", "rater3_n")]
irr::kappam.fleiss(decision)
    #result = .21

#Interpretation
# ICC rate 	  Agreement
#
#   <0.40	    Poor
#0.40 - 0.59	Moderate
#0.60 - 0.74	Good
#0.75 - 1.00	Excelnt

    #In this case, the agreement was poor

#8. Charts ----

#chart form 1 
bd_filter$agreement <- apply(bd_filter[, c("rater1_n", "rater2_n", "rater3_n")], 1, function(x) {
  x <- na.omit(x)
  if(length(x) < 2) {
    return("No evaluated")  # one, two or nobody
  } else if(length(unique(x)) == 1) {
    return("AGRE") #agreement
  } else {
    return("DISA") #disagreement
  }
})

agreement_table <- table(bd_filter$agreement); agreement_table
pie(agreement_table,
    col = c("lightgreen", "tomato", "lightblue"),
    main = "Grado de acuerdo entre evaluadores")

nv(bd)

#chart form 2 (more aesthetic :) )
df_pie <- as.data.frame(agreement_table)
colnames(df_pie) <- c("agreement", "frequency")

ggplot(df_pie, aes(x = "", y = frequency, fill = agreement)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y") +
  theme_void() +
  labs(title = "Agreement between raters") +
  scale_fill_manual(values = c("lightgreen", "tomato", "lightblue"))
