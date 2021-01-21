
rm(list = ls())

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

library(rvest)
library(openxlsx)
library(tidyverse)
library(readxl)

################################################################################

URL <- "https://www.sunedu.gob.pe/lista-de-universidades-licenciadas/"

sunedu_html <- read_html(URL)
#sunedu_html

col1 <- sunedu_html %>%
  html_nodes("table")%>%
  html_nodes("tbody")%>%
  html_nodes("tr")%>%
  html_nodes("td.column-1")%>%
  html_text

col2 <- sunedu_html %>%
  html_nodes("table")%>%
  html_nodes("tbody")%>%
  html_nodes("tr")%>%
  html_nodes("td.column-2")%>%
  html_text

col3.1 <- sunedu_html %>%
  html_nodes("table")%>%
  html_nodes("tbody")%>%
  html_nodes("tr")%>%
  html_nodes("td.column-3")%>%
  html_nodes("p")%>%
  html_nodes("a:nth-child(1)")%>%
  html_attr("href")

col3.2 <- sunedu_html %>%
  html_nodes("table")%>%
  html_nodes("tbody")%>%
  html_nodes("tr")%>%
  html_nodes("td.column-3")%>%
  html_nodes("p")%>%
  html_nodes("a:nth-child(2)")%>%
  html_attr("href")

col4 <- sunedu_html %>%
  html_nodes("table")%>%
  html_nodes("tbody")%>%
  html_nodes("tr")%>%
  html_nodes("td.column-4")%>%
  html_text

df <- cbind(col1, col2, col3.1, col3.2, col4)
df <- data.frame(df)

colnames(df) <- c("NombreEntidad","FechaLicenciamiento","ResoluciónLicenciamiento",
                  "InformeTécnicoLicenciamiento","Gestión")

#str(df$FechaLicenciamiento)
df$FechaLicenciamiento <- as.Date(df$FechaLicenciamiento, format="%d-%m-%Y")

################################################################################

write.xlsx(df, paste0("LicenciadosWebSunedu_get_",Sys.Date(),".xlsx"), asTable=F)
save(df, file=paste0("LicenciadosWebSunedu_get_",Sys.Date(),".rda"))

#load("LicenciadosWebSunedu.rda")
#glimpse(df)
