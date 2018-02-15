
library(RSelenium)

# You need to download java development kit, and insert the selenium standalone server at the folder of the script. 
# For a nice walkthrough, see https://rpubs.com/grahamplace/rseleniumonmac.
# You also need to have installed the Mozilla Firefox web browser.

remDr <- remoteDriver(remoteServerAddr = "localhost"
                      , port = 5556
                      , browserName = "firefox")

driver<- rsDriver()
remDr <- driver[["client"]]

buttons = c('cphBody_btnHomicicio','cphBody_btnLatrocinio','cphBody_btnMortePolicial',
            'cphBody_btnMorteSuspeita','cphBody_btnFurtoVeiculo','cphBody_btnRouboVeiculo','cphBody_btnFurtoCelular')

for(k in buttons){
  for(i in c(3:17)){
    remDr$navigate("http://www.ssp.sp.gov.br/transparenciassp/Consulta.aspx")
    categoria <- remDr$findElement(using = 'id', value = k)
    categoria$sendKeysToElement(list("\uE007"))
    year <- remDr$findElement(using = 'id', value = paste0("cphBody_lkAno",i,sep=""))
    year$sendKeysToElement(list("\uE007"))#clicks on year
    for(j in c(1:12)){
        month <- remDr$findElement(using = 'id', value = paste0("cphBody_lkMes",j,sep=""))
        month$sendKeysToElement(list("\uE007"))#clicks on month
        planilha <- remDr$findElement(using = 'id', value = "cphBody_ExportarBOLink")
        planilha$clickElement()
  Sys.sleep(20)
    }
  }
}












