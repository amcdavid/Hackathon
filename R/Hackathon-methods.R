create_directory = function(path){
  if (!dir.exists(path)) {
    message('Creating ', path)
    dir.create(path)
  }
}

#' Initialize a Hackathon directory and YAML
#'
#' @param parent_path path (relative to working directory) to write Hackathon project
#' @param name Name of hackathon
#' @param desc Show description
#'
#' @return [Hackathon]
#' @export
#'
#' @examples
#' h = setup_hack('.', 'Example', 'Test')
#' h
setup_hack = function(parent_path = '.', name, desc){
  hack_root = file.path(parent_path, name)
  yaml::write_yaml(list(name = name, desc = desc, path = hack_root), file.path(hack_root, 'competition.yml'))
  create_directory(file.path(hack_root, 'private'))
  # interpolate and copy markdown
  load_hack(hack_root)
}

#' @describeIn setup_hack load existing hackathon 
#' @param hack_root path containing competition.yml file
#' @export
load_hack = function(hack_root = '.', ...){
  parms = yaml::read_yaml(file.path(hack_root, 'competition.yml'))
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
    readr::read_csv(row$prediction_url)
}

#' @describeIn get_local_or_remote_csv load tsv from remote or local
get_local_or_remote_tsv = function(row){
    readr::read_tsv(row$prediction_url)
}

score_mse = function(prediction, truth){
  tibble(mse = mean( (prediction$prediction - truth$prediction)^2))
}


#' Score a Hackathon by crawling a manifest
#' 
#' For each row in the manifest, read the prediction via `get_prediction_by_manifest` 
#' and score it via `score_prediction`. 
#' Both the reader and scorer function are wrapped in `purrr::safely` to trap errors, 
#' which are added as fields to the score table
#' @param hack `Hackathon`
#' @param get_prediction_by_manifest a function operating on a row of the manifest, returning an object that will be scored by `score_prediction`
#' @param score_prediction a function operating on a loaded prediction and `truth`.  Returns a `data.frame`.
#' @param truth 
#' @param ... passed to `score_prediction`
#' @return `tibble`
#' @export
#' @importFrom dplyr ungroup mutate left_join bind_rows bind_cols tibble
score_hack = function(hack, get_prediction_by_manifest = get_local_or_remote_csv, score_prediction, truth = hack[['truth']], ...){
  stopifnot(inherits(hack, 'Hackathon'))
  valid_comp_tbl(hack)
  tbl = ungroup(hack[['competitor_tbl']]) %>% mutate(seq_id = as.character(seq_len(nrow(.))))
  
  safe_get = purrr::safely(get_prediction_by_manifest, tibble())
#  safe_score = purrr::safely(function(result, truth) score_prediction(result, truth, ...), tibble())
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
  names(score) = seq_along(score)
  browser()
  if( length(score) > 0 ){
  out = left_join(tbl, bind_rows(score, .id = 'seq_id'), by = 'seq_id')
  } else{
    out = tibble()
  }
  bind_cols(out, tibble(load_errors, score_errors))
}

render_hack = function(scores_tbl){
  rmarkdown::render()
  
}

publish_hack = function(hack){
  
}

