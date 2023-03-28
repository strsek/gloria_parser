## read in the elements of the MRIO, including labels

library(dplyr)

# set path where annual gloria folders and labels are stored
path_mrio <- "./output/EEMRIO/"

# set year
year = 2014
path_year <- paste0(path_mrio, year,"/")

# read labels
io_labs <- read.csv(paste0(path_mrio, "IO_labels.csv"))
fd_labs <- read.csv(paste0(path_mrio, "FD_labels.csv"))
va_labs <- read.csv(paste0(path_mrio, "VA_labels.csv"))
q_labs  <- read.csv(paste0(path_mrio, "Q_labels.csv")) # this also contains CO2 equivalence factors, taken from Exiobase
region_labs <- read.csv(paste0(path_mrio, "region_labels.csv")) # contains region groupings etc.
sector_labs <- read.csv(paste0(path_mrio, "sector_labels.csv")) # contains abbreviations

# read mrio
Z <- readRDS(paste0(path_year,year,"_Z.rds") )
A <- readRDS(paste0(path_year,year,"_A.rds") )
Y <- readRDS(paste0(path_year,year,"_Y.rds") )
V <- readRDS(paste0(path_year,year,"_V.rds") )
L <- readRDS(paste0(path_year,year,"_L.rds") )
x <- readRDS(paste0(path_year,year,"_x.rds") )
ZQ <- readRDS(paste0(path_year,year,"_ZQ.rds") )
YQ <- readRDS(paste0(path_year,year,"_YQ.rds") )


# assign labels at your choice, e.g. using abbreviations
io_labs <- left_join(io_labs, select(sector_labs, c(Lfd_Nr, Sector_short, Sector_group_short)), 
                     by = c("sector_nr" = "Lfd_Nr"))
io_labs <- mutate(io_labs, io_code_short = paste0(region_code,"_",Sector_group_short, ":", Sector_short))
fd_labs <- mutate(fd_labs, fd_code_short = paste0(fd_labs$region_code, "_Y:", fd_labs$fd_short))
va_labs <- mutate(va_labs, va_code_short = paste0(va_labs$region_code, "_V:", va_labs$va_short))


dimnames(Z) <- list(io_labs$io_code_short, io_labs$io_code_short)
dimnames(A) <- list(io_labs$io_code_short, io_labs$io_code_short)
dimnames(L) <- list(io_labs$io_code_short, io_labs$io_code_short)
dimnames(Y) <- list(io_labs$io_code_short, fd_labs$fd_code_short)
dimnames(V) <- list(va_labs$va_code_short, io_labs$io_code_short)
names(x) <- io_labs$io_code_short
dimnames(ZQ) <- list(q_labs$Lfd_Nr, io_labs$io_code_short)
dimnames(YQ) <- list(q_labs$Lfd_Nr, region_labs$Region_acronyms)
