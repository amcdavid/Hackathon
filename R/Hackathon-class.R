#' Construct a Hackathon object
#'
#' This encapulates a directory structure containing configuration and private data.
#' Various methods support scoring and updating the Hackathon.
#' 
#' @param parms list of parameters for the hackathon
#' @param competitor_tbl data.frame/tibble of competitors
#' @param truth data.frame/tibble of secret truth data
#'
#' @return S3 object
#' @export
#' @seealso setup_hack
#' @seealso load_hack
#' @import tibble
Hackathon = function(parms, competitor_tbl, truth) {
  obj = list(parms = parms)
  if (missing(competitor_tbl)) {
    competitor_tbl = tibble()
    tt = try({
      comp_tbl_path = file.path(parms$path, 'private', 'MANIFEST.csv')
      competitor_tbl = readr::read_csv(comp_tbl_path)
    }, silent = TRUE)
    if (inherits(tt, 'try-error')) warning("Unable to load `competition_tbl`")
  }
  obj[['competitor_tbl']] = competitor_tbl
  if(missing(truth)) truth = tibble()
  obj[['truth']] = truth
  class(obj) = 'Hackathon'
  obj
}

req_comp_tbl_fields = c('url', 'contestant') 
not_a_string = function(x) is.na(x) | !is.character(x) | nchar(x) < 1

valid_comp_tbl = function(obj){
  if(!inherits(tbl <- obj[['competitor_tbl']], 'data.frame')) stop("`competition_tbl` must inherit from data.frame")
  if(length(omitted <- setdiff(req_comp_tbl_fields,  names(tbl))) > 0) 
    stop("Fields ", paste0(omitted, collapse = ', '), ' were not found in `competition_tbl`.')
  for(f in req_comp_tbl_fields){
    if(any(bad <- not_a_string(tbl[[f]]))){
      stop("Illegal values in rows ", paste0(head(which(bad)), collapse = ', '), ' of `', f, '` .')
    }
  }
  
  # Falling through means we're good!
  TRUE
}

#' @describeIn Hackaton show information about the object
#'
#' @param x Hackaton
#'
#' @export
print.Hackathon = function(x) {
  cat("A '",
      x$parms$name,
      "' Hackathon with ",
      nrow(x[['competitor_tbl']]),
      " competitors and ", 
      nrow(x[['truth']]), " secret observations.\n", sep = "")
}