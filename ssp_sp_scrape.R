rm(list = ls())
#library(dplyr)
library(RSelenium)

# one needs to download java development kit, insert the selenium standalone server at the folder of the script. for a nice walkthrough, see https://rpubs.com/grahamplace/rseleniumonmac

res = rsDriver(port = 4567L, browser = c('chrome'), version = "latest", chromever = "latest",
         geckover = "latest", iedrver = NULL, phantomver = "2.1.1",
         verbose = TRUE, check = TRUE)

#remDr <- remoteDriver(remoteServerAddr = "localhost"
#                      , port = 5556
#                      , browserName = "chrome")

#driver<- rsDriver()
remDr <- res[["client"]]


buttons = c('cphBody_btnMortePolicial','cphBody_btnFurtoVeiculo','cphBody_btnRouboVeiculo','cphBody_btnFurtoCelular','cphBody_btnRouboCelular','cphBody_btnIML')

#'cphBody_btnMorteSuspeita' not available (2/15/2)

for(k in buttons){
    remDr$navigate("http://www.ssp.sp.gov.br/transparenciassp/Consulta.aspx")
    categoria <- remDr$findElement(using = 'id', value = k)
    categoria$sendKeysToElement(list("\uE007"))
    for(i in c(3:17)){
        possibleError <- tryCatch(
          remDr$findElement(using = 'id', value = paste0("cphBody_lkAno",i,sep="")),
          error=function(e) e
        )
  
        if(!inherits(possibleError, "error")){
          print(paste0('Starting year ',2000 + i,sep=''))
          year = remDr$findElement(using = 'id', value = paste0("cphBody_lkAno",i,sep=""))
      year$sendKeysToElement(list("\uE007"))#clicks on year
      for(j in c(1:12)){
        print(paste0('Clicking on year ',2000 + i,', month ',j,sep=''))        
        month <- remDr$findElement(using = 'id', value = paste0("cphBody_lkMes",j,sep=""))
        month$sendKeysToElement(list("\uE007"))#clicks on month
        planilha <- remDr$findElement(using = 'id', value = "cphBody_ExportarBOLink")
        planilha$clickElement()
  Sys.sleep(20)
      }}
      else{
        print(paste0('Some or all files for the year ', 2000+i,' are unavailable.',sep=''))}
  }
}
