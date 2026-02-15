# ssp_sp
Scraping crime statistics from the São Paulo State Public Security Secretariat (SSP/SP).

Data on https://www.ssp.sp.gov.br/estatistica/consultas can only be accessed through an interactive page with drop-down menus for different categories of crime, years, and months. The scrape script automates a real browser to walk through every combination and download the resulting `.xlsx` files.

## Requirements

- **R** with the [RSelenium](https://docs.ropensci.org/RSelenium/) package
- **Google Chrome** and a compatible ChromeDriver (RSelenium downloads it automatically)
- **Java Development Kit** (required by the Selenium server)

## Usage

```r
source("ssp_sp_scrape.R")
```

Downloaded files are saved to the `data/` directory. After downloading, use `intervention_map.R` to consolidate and visualize the data.

## Notes

- The script tries the current SSP/SP URL (`/estatistica/consultas`) first, then falls back to the legacy URL (`/transparenciassp/Consulta.aspx`).
- Year range covers 2003–2026. Adjust `year_range` in the script to extend it.
- The page element IDs (`cphBody_*`) are ASP.NET-generated. If the site is redesigned and IDs change, you will need to inspect the page and update the `buttons`, year, month, and export ID patterns in the script.
