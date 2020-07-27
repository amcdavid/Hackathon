globalVariables(c('pseudonym', 'gh_handle'))

#' Downlaod a manifest from googlesheets, add urls and save
#'
#' @param gslink link to googlesheet.  
#' You may need to authorize the googlesheets4 API or ortherwise get an API key
#' @param competition_name the name of the competition.
#' We will look for a repos with this name under the registered github handles.
#'
#' @return `logical` if the manifest is OK.
#' @export
#' @importFrom utils write.csv
#' @importFrom readr read_csv
update_gs_manifest = function(gslink, competition_name){
  sheet = googlesheets4::read_sheet(gslink)
  subsheet =  dplyr::select(sheet, gh_handle = 'Your github handle',pseudonym = 'Display pseudonym for rankings', email = 'Email Address')
  subsheet = dplyr::mutate(subsheet, pseudonym = ifelse(nchar(pseudonym)<1, gh_handle, pseudonym))
  subsheet = dplyr::mutate(subsheet,  readme_url = sprintf('https://raw.githubusercontent.com/%s/%s/master/README.md', gh_handle, competition_name),
         prediction_url = sprintf('https://raw.githubusercontent.com/%s/%s/master/prediction/prediction.csv', gh_handle, competition_name))
  write.csv(subsheet, file.path('private', 'MANIFEST.csv'), row.names = FALSE)
  verify_gs_manifest()
}

verify_gs_manifest = function(){
  manifest = read_csv(file.path('private', 'MANIFEST.csv'))
  if(any(is.na(manifest$gh_handle) | nchar(manifest$gh_handle)<1)) stop('bad values for github handles')
  if(any(is.na(manifest$pseudonym) | nchar(manifest$pseudonym)<1)) stop('bad values for display pseudonyms')
  TRUE
}

get_manifest = function(file = file.path('private', 'MANIFEST.csv')){
  read_csv(file)
}
