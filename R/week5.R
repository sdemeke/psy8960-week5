#Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(lubridate)

#Data Import
Adata_tbl <- read_delim("../data/Aparticipants.dat", delim="-",col_names = c("casenum","parnum","stimver","datadate","qs"))
Anotes_tbl <- read_csv("../data/Anotes.csv")
Bdata_tbl <- read_tsv("../data/Bparticipants.dat", col_names = c("casenum","parnum","stimver","datadate","q1","q2","q3","q4","q5","q6","q7","q8","q9","q10"))
Bnotes_tbl <- read_tsv("../data/Bnotes.txt")

#Data Cleaning
Aclean_tbl <- Adata_tbl %>% 
  separate(qs, into = c("q1","q2","q3","q4","q5"), sep = " - ") %>% 
  mutate(datadate = mdy_hms(datadate)) %>% 
  mutate(across(q1:q5, as.integer)) %>% 
  inner_join(Anotes_tbl, by="parnum") %>% 
  filter(is.na(notes))
ABclean_tbl <- Bdata_tbl %>% 
  mutate(datadate = mdy_hms(datadate)) %>% 
  mutate(across(q1:q10, as.integer)) %>% 
  inner_join(Bnotes_tbl, by = "parnum") %>% 
  filter(is.na(notes)) %>% 
  bind_rows(Aclean_tbl, .id="lab") %>% 
  select(-notes)