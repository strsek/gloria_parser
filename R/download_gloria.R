# download gloria

#T_zips <- rdrop2::drop_dir("https://www.dropbox.com/sh/o4fxq94n7grvdbk/AACRDJpNN53PgjhT-vfzKZTDa/latest_release/055/GLORIA_MRIO_Loop055_part_I_MRIOdatabase?dl=0&lst=")

# set version
vers = "057"

# option 1: download only one year: --------------------------------
year = 2020

# define URL from dropbox (has to be done manually by year..)
url_mrio = "https://www.dropbox.com/sh/o4fxq94n7grvdbk/AAAdrXgf7Ie4K8wE3WxgMhKVa/latest_release/057/GLORIA_MRIO_Loop057_part_I_MRIOdatabase/GLORIA_MRIOs_57_2020.zip?dl=0" # "https://www.dropbox.com/sh/o4fxq94n7grvdbk/AACk5muh_wg7ZlsnIEC3jPFna/latest_release/055/GLORIA_MRIO_Loop055_part_I_MRIOdatabase/GLORIA_MRIOs_55_2014.zip?dl=0"  # "https://www.dropbox.com/sh/o4fxq94n7grvdbk/AADnoK3nuFLl8G_iFEVsX2_8a/latest_release/055/GLORIA_MRIO_Loop055_part_I_MRIOdatabase/GLORIA_MRIOs_55_2020.zip?dl=0"
url_ext = "https://www.dropbox.com/sh/o4fxq94n7grvdbk/AAA60U3to9a0URqw2OErF9TQa/latest_release/057/GLORIA_MRIO_Loop057_part_III_satelliteaccounts/GLORIA_SatelliteAccounts_057_2020.zip?dl=0" # "https://www.dropbox.com/sh/o4fxq94n7grvdbk/AACSG9iwP2g8kttCrYRApBcca/latest_release/055/GLORIA_MRIO_Loop055_part_III_satelliteaccounts/GLORIA_SatelliteAccounts_055_2014.zip?dl=0"  # "https://www.dropbox.com/sh/o4fxq94n7grvdbk/AAAR7qlVRYk2-7cG93XKdYUZa/latest_release/055/GLORIA_MRIO_Loop055_part_III_satelliteaccounts/GLORIA_SatelliteAccounts_055_2020.zip?dl=0"

# download MRIO
download.file(
  url = paste0(url_mrio,"&raw=1"), 
  destfile = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/",year,".zip")
  )

# download extensions
download.file(
  url = paste0(url_ext,"&raw=1"), 
  destfile = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/",year,"_E.zip")
  )

# list content
IO_files <- unzip(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/",year,".zip"), list = TRUE)$Name
E_files <- unzip(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/",year,"_E.zip"), list = TRUE)$Name

# unzip monetary valuation T into T folder
unzip(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/",year,".zip"), 
      files = IO_files[grepl(paste0("T-Results_",year,"_",vers,"_Markup001(full)"),IO_files, fixed = TRUE)],
      exdir = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/T/"),
      unzip = "/usr/bin/unzip")

# unzip monetary valuation Y into Y folder
unzip(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/",year,".zip"), 
      files = IO_files[grepl(paste0("Y-Results_",year,"_",vers,"_Markup001(full)"),IO_files, fixed = TRUE)],
      exdir = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/Y/"),
      unzip = "/usr/bin/unzip")

# unzip monetary valuation V into V folder
unzip(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/",year,".zip"), 
      files = IO_files[grepl(paste0("V-Results_",year,"_",vers,"_Markup001(full)"),IO_files, fixed = TRUE)],
      exdir = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/V/"),
      unzip = "/usr/bin/unzip")

# unzip satellite accounts into E folder
unzip(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/",year,"_E.zip"), 
      exdir = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/E/"),
      unzip = "/usr/bin/unzip")


# delete zips
file.remove(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/",year,".zip"))
file.remove(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/",year,"_E.zip"))


# option 2: download all years ----------------------------------------------------------

years = 1990:2027

# define URL from dropbox, taking the url of the MRIO and extension folders
url_mrio = "https://www.dropbox.com/sh/o4fxq94n7grvdbk/AABiL3x3nzJh4iYzMdy88apFa/latest_release/057/GLORIA_MRIO_Loop057_part_I_MRIOdatabase?dl=0&lst="
url_ext = "https://www.dropbox.com/sh/o4fxq94n7grvdbk/AABvN65VjrYbyOa1aAkAJPzHa/latest_release/057/GLORIA_MRIO_Loop057_part_III_satelliteaccounts?dl=0&lst="

# download MRIOs
download.file(
  url = paste0(url_mrio,"&raw=1"), 
  destfile = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/MRIO.zip")
)

# download extensions
download.file(
  url = paste0(url_ext,"&raw=1"), 
  destfile = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/E.zip")
)


#IO_zipfiles <- unzip(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/MRIO.zip"), list = TRUE)$Name
#E_zipfiles <- unzip(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/E.zip"), list = TRUE)$Name


# unzip annual MRIO data (which are zipfiles themselves)
if(!dir.exists(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/MRIO_zips"))) dir.create(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/MRIO_zips"))
if(!dir.exists(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/E_zips"))) dir.create(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/E_zips"))

unzip(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/MRIO.zip"), 
      #files = IO_zipfiles,
      exdir = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/MRIO_zips/"),
      unzip = "/usr/bin/unzip")

unzip(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/E.zip"), 
      #files = E_zipfiles,
      exdir = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/E_zips/"),
      unzip = "/usr/bin/unzip")


# unzip annual MRIO components into folders for each component
IO_zipfiles <- list.files(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/MRIO_zips/"), full.names = TRUE)
E_zipfiles <- list.files(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/E_zips/"), full.names = TRUE)

for (year in years){
  
  MRIO_zip <- IO_zipfiles[grepl(paste0(year,".zip"), IO_zipfiles)]
  E_zip <- E_zipfiles[grepl(paste0(year,".zip"), E_zipfiles)]
  
  
  # list content of respective zip folders
  IO_files <- unzip(MRIO_zip, list = TRUE)$Name
  E_files <- unzip(E_zip, list = TRUE)$Name
  
  # unzip monetary valuation T into T folder
  unzip(MRIO_zip, 
        files = IO_files[grepl(paste0("T-Results_",year,"_",vers,"_Markup001(full)"),IO_files, fixed = TRUE)],
        exdir = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/T/"),
        unzip = "/usr/bin/unzip")
  
  # unzip monetary valuation Y into Y folder
  unzip(MRIO_zip, 
        files = IO_files[grepl(paste0("Y-Results_",year,"_",vers,"_Markup001(full)"),IO_files, fixed = TRUE)],
        exdir = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/Y/"),
        unzip = "/usr/bin/unzip")
  
  # unzip monetary valuation V into V folder
  unzip(MRIO_zip, 
        files = IO_files[grepl(paste0("V-Results_",year,"_",vers,"_Markup001(full)"),IO_files, fixed = TRUE)],
        exdir = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/V/"),
        unzip = "/usr/bin/unzip")
  
  # unzip satellite accounts into E folder
  unzip(E_zip, 
        exdir = paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/E/"),
        unzip = "/usr/bin/unzip")
  
}

# delete temporal data
unlink(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/MRIO_zips"), recursive = TRUE)
unlink(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/E_zips"), recursive = TRUE)
file.remove(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/MRIO.zip"))
file.remove(paste0("/mnt/nfs_fineprint/tmp/gloria/v",vers,"/E.zip"))


