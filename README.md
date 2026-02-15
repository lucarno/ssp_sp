# ssp_sp
Scraping tables from www.ssp.sp.gov.br/transparenciassp

Data on http://www.ssp.sp.gov.br/transparenciassp/Consulta.aspx can only be accessed by drop-down menus for different categories of crime, different years, and different months.

The R script will download all .xls files, convert them to .csv, and stack the data together.

## Status

**Note:** The scrape script (`ssp_sp_scrape.R`) was written in 2018 and is no longer expected to work. Known issues include:

- The target website may have been redesigned or moved, breaking the element IDs the script depends on.
- The Selenium setup references PhantomJS (deprecated) and a ChromeDriver resolution method that has since changed.
- The year range is hardcoded to 2003–2017.

The visualization script (`intervention_map.R`) and any previously downloaded data remain usable.
