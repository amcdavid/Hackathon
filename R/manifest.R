globalVariables(c('pseudonym', 'gh_handle'))


comma_sep = function(vec) paste(vec, collapse = ', ')

#' Downlaod a manifest from googlesheets, add urls and save
#'
#' @param sheet `data.frame` containing team registration info 
#' @param hack `Hackathon` used to determine github repository
#' @param repo_name `character` or a character
#'
#' @return `logical` if the manifest is OK.
#' @export
#'
#' @importFrom utils write.csv
#' @importFrom readr read_csv
update_gs_manifest = function(sheet, hack){
  sheet = dplyr::mutate(sheet, pseudonym = ifelse(not_a_string(contestant), gh_handle, contestant))
  if(!missing(hack) && inherits(h, 'Hackathon')){
    repo_name = hack$parms$name
  } else{
    if(!(is.character(repo_name) && length(repo_name) == 1)) stop('`repo_name` must be length 1 `character` or provide a Hackthon `hack`.')
  }
  
  sheet = dplyr::mutate(sheet,  readme_url = sprintf('https://raw.githubusercontent.com/%s/%s/master/README.md', gh_handle, repo_name),
         prediction_url = sprintf('https://raw.githubusercontent.com/%s/%s/master/prediction/prediction.csv', gh_handle, repo_name))
  write.csv(sheet, file.path('private', 'MANIFEST.csv'), row.names = FALSE)
  verify_gs_manifest()
}

verify_gs_manifest = function(){
  manifest = read_csv(file.path('private', 'MANIFEST.csv'))
  ok = TRUE
  if(any(bad_handle <- not_a_string(manifest$gh_handle))){
    warning('bad values for github handles on rows:', comma_sep(which(bad_handle)))
    ok = FALSE
  }
  if(any(bad_pseudonym <- not_a_string(manifest$pseudonym))){
    warning('bad values for display pseudonyms on rows:', comma_sep(which(bad_pseudonym)))
    ok = FALSE
  }
  return(ok)
}
