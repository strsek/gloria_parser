# create all labels, codes and other information that the IO calculation needs

# Import region concordances
RegConco <- list("world" = read.xlsx( str_c("./input/", filename$RegConcordance), sheet = 3, colNames = TRUE),
                 "income" = read.xlsx( str_c("./input/", filename$RegConcordance), sheet = 4, colNames = TRUE),
                 "development" = read.xlsx( str_c("./input/", filename$RegConcordance), sheet = 5, colNames = TRUE) )

# Import sector concordance and abbreviations
SecConc <- read.xlsx( str_c("./input/", filename$labels), sheet = 7, colNames = TRUE, startRow = 2)
SecAbb <- read.xlsx( str_c("./input/", filename$abbrev), sheet = 1, colNames = TRUE)
IsicAbb <- read.xlsx( str_c("./input/", filename$abbrev), sheet = 2, colNames = TRUE)
FDAbb <- read.xlsx( str_c("./input/", filename$abbrev), sheet = 3, colNames = TRUE)
VAAbb <- read.xlsx( str_c("./input/", filename$abbrev), sheet = 4, colNames = TRUE)

# Clean look-up table for unique sector list:
tmp <- melt(SecConc, id.vars = "X1") %>% 
  filter(value == 1) %>% 
  select(X1, variable) %>% 
  `colnames<-`(c("Sector_names", "Sector_group")) %>%
  distinct(Sector_names, .keep_all = TRUE) ## there is a duplicate in Other Services as it is matched with two groups

tmp$Sector_group <- gsub(".", " ", tmp$Sector_group, fixed = TRUE)

# Clean the aggregation matrix
rownames(SecConc) <- SecConc$X1
SecConc$X1 <- NULL

## Read unique lists and create labels
unique <- list("region" = read.xlsx( str_c("./input/", filename$labels), sheet = 1, colNames = TRUE ),
               "sector" = read.xlsx( str_c("./input/", filename$labels), sheet = 2, colNames = TRUE ),
               "finaldemand" = read.xlsx( str_c("./input/", filename$labels), sheet = 3, colNames = TRUE, cols = c(1,3)  ),
               "valueadded" = read.xlsx( str_c("./input/", filename$labels), sheet = 3, colNames = TRUE, cols = c(1,2)  ),
               "extension" = read.xlsx( str_c("./input/", filename$labels), sheet = 5, colNames = TRUE  ) )

# TODO: extension lacks co2 equivalnet factor! 
# solution: was taken from W/GLORIA --> seems to be taken from Exiobase

# Add sector grouping to unique list
unique$sector <- left_join(unique$sector, tmp, by = "Sector_names")
unique$sector <- left_join(unique$sector, SecAbb, by = "Sector_names")
unique$sector <- left_join(unique$sector, IsicAbb, by = c("Sector_group" = "Sector_group_names"))


# Read region groupings and add to unique list
tmp <- melt(RegConco$world, id.vars = "region_index") %>% 
  filter(value == 1) %>% 
  select(region_index, variable ) %>% 
  arrange(region_index) 

unique$region["World_region"] <- gsub(".", " ", as.character( tmp$variable ), fixed = TRUE)


tmp <- melt(RegConco$income, id.vars = "region_index") %>% 
  filter(value == 1) %>% 
  select(region_index, variable ) %>% 
  arrange(region_index)

unique$region["Income_group"] <- gsub(".", " ", as.character( tmp$variable ), fixed = TRUE)


tmp <- melt(RegConco$development, id.vars = "region_index") %>% 
  filter(value == 1) %>% 
  select(region_index, variable ) %>% 
  arrange(region_index)

unique$region["Development_group"] <- gsub(".", " ", as.character( tmp$variable ), fixed = TRUE)

# Remove region indices in concordances
RegConco$world$region_index <- NULL
RegConco$income$region_index <- NULL
RegConco$development$region_index <- NULL

unique$finaldemand$Final_demand_short <- FDAbb$Final_demand_short
unique$valueadded$Value_added_short <- VAAbb$Value_added_short


## Read dimensions
nreg <- nrow(unique$region)
nsec <- nrow(unique$sector)
nfd <- nrow(unique$finaldemand)
nva <- nrow(unique$valueadded)

## Create labels for raw and parsed tables
tmp_raw <- data.frame("index" = 1:(nreg * nsec * 2),
                      "region_nr" = rep(unique$region$Lfd_Nr, each = nsec * 2),
                      "region_code" = rep(unique$region$Region_acronyms, each = nsec * 2),
                      "region_name" = rep(unique$region$Region_names, each = nsec * 2),
                      "entity_code" = rep( 1:2, each = nsec ), 
                      "entity_name" = rep( c("Industry", "Product"), each = nsec ),
                      "sector_nr" = unique$sector$Lfd_Nr,
                      "sector_name" = unique$sector$Sector_names
                      )

tmp_parsed_Z <- data.frame("index" = 1:(nreg * nsec),
                           "region_nr" = rep(unique$region$Lfd_Nr, each = nsec),
                           "region_code" = rep(unique$region$Region_acronyms, each = nsec),
                           "region_name" = rep(unique$region$Region_names, each = nsec),
                           "sector_nr" = unique$sector$Lfd_Nr,
                           "sector_name" = unique$sector$Sector_names)

tmp_parsed_Y <- data.frame("index" = 1:(nreg * nfd),
                           "region_nr" = rep(unique$region$Lfd_Nr, each = nfd),
                           "region_code" = rep(unique$region$Region_acronyms, each = nfd),
                           "region_name" = rep(unique$region$Region_names, each = nfd),
                           "fd_nr" = unique$finaldemand$Lfd_Nr,
                           "fd_name" = unique$finaldemand$Final_demand_names,
                            "fd_short" = unique$finaldemand$Final_demand_short)

tmp_parsed_V <- data.frame("index" = 1:(nreg * nva),
                           "region_nr" = rep(unique$region$Lfd_Nr, each = nva),
                           "region_code" = rep(unique$region$Region_acronyms, each = nva),
                           "region_name" = rep(unique$region$Region_names, each = nva),
                           "va_nr" = unique$valueadded$Lfd_Nr,
                           "va_name" = unique$valueadded$Value_added_names,
                           "va_short" = unique$valueadded$Value_added_short)

labels <- list("T" = tmp_raw,
               "parsed" = list("Z" = tmp_parsed_Z,
                               "Y" = tmp_parsed_Y ,
                               "V" = tmp_parsed_V) )

indices <- list("ind" = labels$T %>% filter(entity_code == 1) %>% pull(index),
                "pro" = labels$T %>% filter(entity_code == 2) %>% pull(index) )

# Remove redundant objects 
remove(tmp_parsed_Y, tmp_parsed_Z, tmp_raw, tmp)

# Write labels to folder
fwrite( labels$parsed$Z, str_c(path$storeMRIOModel,"IO_labels.csv") )
fwrite( labels$parsed$Y, str_c(path$storeMRIOModel,"FD_labels.csv") )
fwrite( labels$parsed$V, str_c(path$storeMRIOModel,"VA_labels.csv") )
fwrite( unique$extension, str_c(path$storeMRIOModel,"Q_labels.csv") )
fwrite( unique$region, str_c(path$storeMRIOModel,"region_labels.csv") )
fwrite( unique$sector, str_c(path$storeMRIOModel,"sector_labels.csv") )
saveRDS( indices, str_c(path$storeMRIOModel,"indices.rds") )



# Compile aggregation function
Agg <- function(x,aggkey,dim)
{
  if(dim == 1) x <- t(x)
  
  colnames(x) <- aggkey
  
  x <- as.matrix(x) %*% sapply(unique(colnames(x)),"==",colnames(x))
  
  if(dim == 1) x <- t(x)
  
  return(x)
}

