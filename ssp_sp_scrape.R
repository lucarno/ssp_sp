rm(list = ls())
library(RSelenium)

# ── Configuration ─────────────────────────────────────────────────────────────
# Where to save downloaded .xlsx files (create if needed)
download_dir <- file.path(getwd(), "data")
if (!dir.exists(download_dir)) dir.create(download_dir, recursive = TRUE)

# ── Launch Chrome via RSelenium ───────────────────────────────────────────────
# Set Chrome preferences so files download to our data/ folder automatically.
chrome_prefs <- list(
  "download.default_directory"   = normalizePath(download_dir),
  "download.prompt_for_download" = FALSE,
  "download.directory_upgrade"   = TRUE
)
extra_caps <- list(chromeOptions = list(prefs = chrome_prefs))

res <- rsDriver(
  port      = 4567L,
  browser   = "chrome",
  chromever = "latest",
  extraCapabilities = extra_caps,
  verbose   = TRUE
)
remDr <- res[["client"]]

# ── Helper: wait for an element (up to `timeout` seconds) ────────────────────
wait_for_element <- function(remDr, using, value, timeout = 15) {
  for (i in seq_len(timeout)) {
    el <- tryCatch(
      remDr$findElement(using = using, value = value),
      error = function(e) NULL
    )
    if (!is.null(el)) return(el)
    Sys.sleep(1)
  }
  return(NULL)
}

# ── Crime-category button IDs ────────────────────────────────────────────────
# These are the ASP.NET element IDs on the SSP/SP consultas page.
# If the site has been redesigned and IDs have changed, update them here.
buttons <- c(
  "cphBody_btnMortePolicial",
  "cphBody_btnFurtoVeiculo",
  "cphBody_btnRouboVeiculo",
  "cphBody_btnFurtoCelular",
  "cphBody_btnRouboCelular",
  "cphBody_btnIML"
)

# Year indices: index 3 = 2003, index 26 = 2026. Adjust upper bound as needed.
year_range <- 3:26

# ── Main scraping loop ───────────────────────────────────────────────────────
for (k in buttons) {
  cat("\n=== Category:", k, "===\n")

  # Navigate to the consultas page (try the current URL first; fall back to the
  # legacy path if the site has not migrated element IDs yet).
  remDr$navigate("https://www.ssp.sp.gov.br/estatistica/consultas")
  Sys.sleep(3)

  categoria <- wait_for_element(remDr, "id", k)
  if (is.null(categoria)) {
    # Fall back to the legacy URL
    cat("  Element not found on new URL; trying legacy URL...\n")
    remDr$navigate("https://www.ssp.sp.gov.br/transparenciassp/Consulta.aspx")
    Sys.sleep(3)
    categoria <- wait_for_element(remDr, "id", k)
  }
  if (is.null(categoria)) {
    cat("  SKIP: could not find button", k, "on either URL.\n")
    next
  }
  categoria$clickElement()
  Sys.sleep(2)

  for (i in year_range) {
    year_id <- paste0("cphBody_lkAno", i)
    year_el <- tryCatch(
      remDr$findElement(using = "id", value = year_id),
      error = function(e) NULL
    )
    if (is.null(year_el)) {
      cat("  Year", 2000 + i, "- not available, skipping.\n")
      next
    }

    cat("  Year", 2000 + i, "\n")
    year_el$clickElement()
    Sys.sleep(2)

    for (j in 1:12) {
      month_id <- paste0("cphBody_lkMes", j)
      month_el <- wait_for_element(remDr, "id", month_id, timeout = 5)
      if (is.null(month_el)) {
        cat("    Month", j, "- element not found, skipping.\n")
        next
      }
      cat("    Month", j, "- downloading... ")
      month_el$clickElement()
      Sys.sleep(2)

      export_el <- wait_for_element(remDr, "id", "cphBody_ExportarBOLink", timeout = 10)
      if (!is.null(export_el)) {
        export_el$clickElement()
        Sys.sleep(10)  # wait for download to finish
        cat("done.\n")
      } else {
        cat("export link not found.\n")
      }
    }
  }
}

# ── Clean up ──────────────────────────────────────────────────────────────────
cat("\nScraping complete. Files saved to:", download_dir, "\n")
remDr$close()
res[["server"]]$stop()
