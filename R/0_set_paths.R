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

## Set paths where tables in Tvy format are located and where the results should be stored
# In case functions or certain scripts don't work, the reason might be found here!
path <- list("rawMRIO" = "/mnt/nfs_fineprint/tmp/gloria/v055/T",
             "rawExtension" = "/mnt/nfs_fineprint/tmp/gloria/v055/E",
             "rawFD" = "/mnt/nfs_fineprint/tmp/gloria/v055/Y",
             "rawV" = "/mnt/nfs_fineprint/tmp/gloria/v055/V",
             "storeMRIOModel" = "./output/EEMRIO/")


filename <- list("pre" = "_120secMother_AllCountries_002_",
                 "mid" = "-Results_",
                 "post" = "_055_Markup001(full).csv",
                 "labels" = "GLORIA_ReadMe.xlsx",
                 "RegConcordance" = "GLORIA_164RegAgg.xlsx",
                 "abbrev" = "gloria_abbreviations.xlsx")

