has_readme = function(url){
  tt = try(download.file(url, destfile = tempfile(), quiet = TRUE))
  if(inherits(tt, 'try-error')) return(1) else tt
}


parse_predictions = readr::read_csv

#' Download predictions
#'
#' @param url url to prediction file
#'
#' @return parsed predictions
#' @export
#'
#' @examples
#' download_predictions('https://raw.githubusercontent.com/Rochester-Biomedical-DS/Hackathon-Summer-2020/master/prediction/prediction.csv')
#' @importFrom utils download.file
download_predictions = function(url){
  dest = tempfile()
  tt = try(download.file(url, destfile = dest, quiet = TRUE))
  if(inherits(tt, 'try-error')) return(as.character(tt))
  tt = try(parse_predictions(dest))
  if(inherits(tt, 'try-error')) return("Bad prediction format.")
  return(tt)
}


calculate_mse = function(prediction, target){
  if(!inherits(prediction, 'data.frame')) return(NA_real_)
  x = prediction[[1]]
  mean((x-target)^2)
}

rmarkdown = function(input, output_file, ...){
  callr::r(function(...) rmarkdown::render(...),
           args = list(
             input = input,
             output_file = output_file)
  )
}

update_public = function(board, path){
  board_files = paste0(gsub('.md$', '', board), '_files/', collapse = '')
  board_and_files = c(board, list.files(pattern = board_files))
  file.copy(board_and_files, path, recursive = TRUE, copy.date = TRUE)
}