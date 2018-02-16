rm(list = ls())
library(data.table)
library(ggmap)
library(ggplot2)
library(ggthemes)

setwd('path')

#you only need to run this once
#files<-list.files(pattern='Dados')
#newfiles <- gsub(".xls$", ".csv", files)
#file.rename(files, newfiles)

files<-list.files(pattern='Dados')

events <- lapply(files, read.csv, header = TRUE, sep = "\t",fileEncoding="UTF-16LE")

df = rbindlist(events, fill=TRUE)

df1 = unique(df[!is.na(LATITUDE),list(NUMERO_BOLETIM,LATITUDE,LONGITUDE,CIDADE,ANO_BO)])
df1[,lat:=gsub(',','.',LATITUDE)]
df1[,lat:=as.numeric(round(as.numeric(lat),6))]
df1[,lon:=gsub(',','.',LONGITUDE)]
df1[,lon:=as.numeric(round(as.numeric(lon),6))]

spo = get_map("SaoPaulo,Brazil", zoom=11,maptype = 'roadmap')
ggmap(spo) + 
  geom_point(data=df1, aes(x=lon, y=lat), color="red", size=1.5, alpha=.5) +
  theme_fivethirtyeight() +
  ggtitle('Deaths by Police Intervention',subtitle='From 2013 to 2017\nSource: SSP/SP') +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())

ggsave('map_spo.pdf', plot = map_spo, device = 'pdf',height = 20, width = 20, units = 'cm')
