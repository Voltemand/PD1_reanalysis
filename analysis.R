library(tidyverse)
library(readxl)
library(flowCore)
library(reshape2)

setwd("/wehisan/home/allstaff/p/pullin.j/PD1_reanalysis/")
metadata_23_1 <- read_excel("./Data/attachments/metadata_23_01.xlsx")
metadata_29_1 <- read_excel("./Data/attachments/metadata_29_01.xlsx")

base_day1_files <- metadata_23_1$filename[1:15]
base_day2_files <- metadata_29_1$filename[1:15]

file_day1 <- "/wehisan/home/allstaff/p/pullin.j/PD1_reanalysis/Data/Data23_Panel1_base_HD1_Patient1.fcs"
markers1 <- colnames(read.FCS(file_day1)@exprs)

file_day2 <- "/wehisan/home/allstaff/p/pullin.j/PD1_reanalysis/Data/Data29_Panel1_base_HD6_Patient27.fcs"
markers2 <- colnames(read.FCS(file_day2)@exprs)

setwd("/wehisan/home/allstaff/p/pullin.j/PD1_reanalysis/Data/")
day1_expr <- make_expr_matrix(base_day1_files, markers1)
day2_expr <- make_expr_matrix(base_day2_files, markers2)

# We find that day 1 as an extra SampleID column which we remove
setdiff(colnames(day1_expr), colnames(day2_expr))
day1_expr <- subset(day1_expr, select = -SampleID)

day1_expr <- as.tibble(day1_expr)
day2_expr <- as.tibble(day2_expr)

day <- rep(rep(1,2), c(nrow(day1_expr), nrow(day2_expr)))

all_data <- rbind(day1_expr, day2_expr)
all_data <- cbind(day = factor(day), all_data)
all_data <- as.data.frame(all_data)
all_data <- all_data[sample(1:nrow(all_data), 1000), ]

all_data <- melt(all_data, id.vars = c(day), measures.vars = colnames())
str(all_data)
head(all_data)

