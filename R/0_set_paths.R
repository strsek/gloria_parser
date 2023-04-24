# set paths & filenames, and load required packages

# Load R packages
library(stringr)
library(data.table)
library(reshape2)
library(openxlsx)
library(dplyr)
library(reshape2)
library(parallel)
library(Matrix)

# set version
vers = "057"

## Set paths where tables in Tvy format are located and where the results should be stored
# In case functions or certain scripts don't work, the reason might be found here!
path <- list("rawMRIO" = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/T"),
             "rawExtension" = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/E"),
             "rawFD" = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/Y"),
             "rawV" = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/V"),
             "storeMRIOModel" = paste0("./output/v",vers,"/"))


filename <- list("pre" = "_120secMother_AllCountries_002_",
                 "mid" = "-Results_",
                 "post" = paste0("_",vers,"_Markup001(full).csv"),
                 "labels" = "GLORIA_ReadMe.xlsx",
                 "RegConcordance" = "GLORIA_164RegAgg.xlsx",
                 "abbrev" = "gloria_abbreviations.xlsx")

