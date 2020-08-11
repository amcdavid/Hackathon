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

my_error = function(x){
  class(x) = 'my_error'
  return(x)
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
collect_predictions = function(url){
  dest = tempfile()
  tt = try(download.file(url, destfile = dest, quiet = TRUE))
  if(inherits(tt, 'try-error')) return(my_error(as.character(tt)))
  tt = try(parse_predictions(dest))
  if(inherits(tt, 'try-error')) return(my_error(sprintf("Couldn't load prediction csv: %s", as.character(tt))))
  return(tt)
}

#' @describeIn collect_predictions calculate MSE and run a bootstrap
calculate_mse = function(prediction, target, bootstrap_indices){
  if(!inherits(prediction, 'my_error')){
    tt = try({
      if(inherits(prediction, 'my_error')) stop(prediction)
      if(!inherits(prediction, 'data.frame')) stop('Bad format in predictions')
      px = prediction[[1]]
      if(length(px) != length(target)) stop("Wrong length for predictions")
      mse = function(x, target) mean((x - target)^2)
      val = mse(px, target)
      if(is.na(val)) stop("Non numeric values in predictions")
      boot_t = as.matrix(purrr::map_dbl(bootstrap_indices, function(i) mse(px[i], target[i])))
      boot_obj = list(t0 = val, t = boot_t, R = length(bootstrap_indices))
      ci = boot::boot.ci(boot_obj, type = 'perc', conf = .8)
    })
  }
 
  if(inherits(prediction, 'my_error') || inherits(tt, 'try-error')) return(tibble(val = Inf, '10%' = Inf, '90%' = Inf, message = as.character(tt)))
  tibble(val = val, '10%' = ci$percent[4], '90%' = ci$percent[5], message = 'OK')
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