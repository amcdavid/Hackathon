create_directory = function(path){
  if (!dir.exists(path)) {
    message('Creating ', path)
    dir.create(path)
  }
}

setup_hack = function(path, name = path, desc){
  yaml::write_yaml(list(name = name, desc = desc), file.path(path, 'competition.yml'))
  create_directory(file.path(path, 'private'))
  load_hack(path)
}

load_hack = function(path = '.', ...){
  parms = yaml::read_yaml(file.path(path, 'competition.yml'))
  Hackathon(parms, ...)
}

resample_private = function(hack){
  
}


#' Load a csv from remote or local
#'
#' @param row list (one row) from the MANIFEST.  `url` needs to be set.
#'
#' @return `tibble`
#' @export
#'
get_local_or_remote_csv = function(row){
    readr::read_csv(row$url)
}

#' @describeIn get_local_or_remote_csv load tsv from remote or local
get_local_or_remote_tsv = function(row){
    readr::read_tsv(row$url)
}

score_mse = function(prediction, truth){
  mean( (prediction$prediction - truth$prediction)^2)
}

score_hack = function(hack, get_prediction_by_manifest = get_local_or_remote_csv, score_prediction, truth = hack[['truth']], ...){
  stopifnot(inherits(hack, 'Hackathon'))
  valid_comp_tbl(hack)
  tbl = hack[['competitor_tbl']]
  
  safe_get = purrr::safely(get_prediction_by_manifest, tibble())
  safe_score = purrr::safely(score_prediction, tibble())
  load_errors = character()
  score_errors =  character()
  score = list()
  # memoise this?
  for(i in seq_len(nrow(tbl))){
    row = tbl[i,]
    p = safe_get(row)
    load_errors[i] = if(is.null(p$error)) 'Load OK' else as.character(p$error)
    s = safe_score(p$result, truth, ...)
    score_errors[i] = if(is.null(s$error)) 'Score OK' else as.character(s$error)
    score[[i]] = s$result
  }
  out = bind_rows(score) %>% bind_cols(tbl)
  bind_cols(out, tibble(load_errors, score_errors))
}

render_hack = function(hack){
  
}

publish_hack = function(hack){
  
}

