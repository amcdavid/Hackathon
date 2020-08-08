#' @describeIn eval_predictions get last-modified header 
#' @export
last_modified = function(url){
  h = httr::HEAD(url)
  h$headers[["last-modified"]]
}


#' @describeIn eval_predictions check for README.md
#' @export
has_readme = function(url){
  tt = try(ok <- download.file(url, destfile = tempfile(), quiet = TRUE))
  if(inherits(tt, 'try-error')) return(FALSE) else return(ok==0)
}


parse_predictions = readr::read_csv

#' Download and evaluate prediction
#'
#' @param url url to prediction file
#' @param target vector of truth
#'
#' @return parsed predictions
#' @export
#'
#' @importFrom utils download.file
eval_predictions = function(url, target){
  dest = tempfile()
  tt = try(download.file(url, destfile = dest, quiet = TRUE))
  if(inherits(tt, 'try-error')) return(as.character(tt))
  tt = try(parse_predictions(dest))
  if(inherits(tt, 'try-error')) return(sprintf("Couldn't load prediction csv: %s", as.character(tt)))
  tt = try(calculate_mse(tt, target))
  if(inherits(tt, 'try-error')) return(sprintf("Bad format in predictions: %s", as.character(tt)))
  return(tt)
}


calculate_mse = function(prediction, target){
  if(!inherits(prediction, 'data.frame')) stop('Bad format in predictions')
  x = prediction[[1]]
  if(length(x) != length(target)) stop("Wrong length for predictions")
  val = mean((x-target)^2)
  if(is.na(val)) stop("Non numeric values in predictions")
  val
}

rmarkdown = function(input, output_file, ...){
  callr::r(function(...) rmarkdown::render(...),
           args = list(
             input = input,
             output_file = output_file)
  )
}

# rmarkdown = function(input, output_file, ...){
#   callr::r(rmarkdown::render(input, output_file = output_file, ...))
# }


#rmarkdown = rmarkdown::render

update_public = function(board, path){
  #board_files = paste0(gsub('.md$', '', board), '_files/', collapse = '')
  #board_and_files = c(board, list.files(pattern = board_files))
  system2(system.file('sh', 'update_parent_repo.sh', package = 'Hackathon'), args = path)
  #file.copy(board_and_files, path, recursive = TRUE, copy.date = TRUE)
}