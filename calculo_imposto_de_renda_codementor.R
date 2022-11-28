#!/usr/bin/env Rscript
options(warn = -1)
library(jsonlite)

filename <- commandArgs(trailingOnly = T)

filename <- "../Arc_Codementor_Payout_Histories_2021-11_2021-11.csv"

file <- basename(filename)

# Obter data a ser procurada
first <- strsplit(file, split = ".", fixed = T)[[1]][1]
second <- strsplit(first, split = "_")
year_month <- second[[1]][lengths(second)]
split_year_month <- strsplit(year_month, split = "-")
month <- split_year_month[[1]][2]
year <- split_year_month[[1]][1]

# Obter mês anterior
if(month != "1"){
  previous_month <- as.numeric(month) - 1
} else {
  previous_month <- 12
}

# Checar qual dia deve ser procurado (último dia útil da primeira quinzena)
year_previous_month <- paste0(year, "-", previous_month)

day <- 15
date <- paste0(year_previous_month, "-", day)
date <- as.Date(date)
weekday <- weekdays(date)

if(weekday == "sábado"){
  date <- date - 1
} else if(weekday == "domingo"){
  date <- date - 2
} else {
  date <- date
}

# Obter data para input na API
date_input <- gsub("-", "", as.character(date))

dolar <- fromJSON(
  paste0("https://economia.awesomeapi.com.br/json/daily/USD-BRL/?start_date=", 
         date_input,"&end_date=", date_input))

usd <- as.numeric(dolar$bid)

data <- read.csv(filename)

# TODO further: create shiny app to calculate in a webpage

colname_values <- "Payout.Amount"

total <- sum(data[,colname_values])

total_brl <- round(total*usd, 2)

if(total_brl <= 1903.98){
  tax <- 0
  deduction <- 0
  total_pay <- 0
} else if(total_brl > 1903.98 & total_brl <= 2826.65){
  tax <- 0.075*total_brl
  deduction <- 142.8
  total_pay <- tax - deduction
} else if(total_brl > 2826.65 & total_brl <= 3751.05){
  tax <- 0.15*total_brl
  deduction <- 354.8
  total_pay <- tax - deduction
} else if(total_brl > 3751.05 & total_brl <= 4664.69){
  tax <- 0.225*total_brl
  deduction <- 636.13
  total_pay <- tax - deduction
} else {
  tax <- 0.275*total_brl
  deduction <- 869.36
  total_pay <- tax - deduction
}

total_pay <- round(total_pay)

real_gain <- total_brl - round(total_pay)

real_gain <- gsub(".", ",", real_gain, fixed = T)

paste0("Você deve pagar R$", total_pay, ",00 de imposto para o mês ", month, ".")

paste0("Seu ganho real é de R$", real_gain, ".")

# TODO verificarse épossível criar testes unitários para o script

# TODO coletar dados novos docodementor e testar para outros meses e comparar com o q eu fiz na mão