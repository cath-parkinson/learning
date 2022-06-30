library(pdftools)
library(dplyr)

file_vector <- dir()
pdf_list <- file_vector[grepl(".pdf", file_vector)]

check <- pdf_text(pdf_list[[1]])
pdf_text(pdf_list[[1]]) %>% strsplit("\n") -> document_text

document_text <- document_text %>% unlist() %>% list()

document <- data.frame("company" = pdf_list[[1]],
           "text" = document_text,
           stringsAsFactors = FALSE)
