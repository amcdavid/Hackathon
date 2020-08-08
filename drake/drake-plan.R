library(drake)
library(dplyr)
# direct survey results
# gs_sheet = "https://docs.google.com/spreadsheets/d/1mK5UgNIRrdSxVyb3L9MfD59XzR0Q0MQfyCpvccuiPZI/edit#gid=2103763262"
# Amanda's manually annotated sheet
gs_sheet = "https://docs.google.com/spreadsheets/d/1IqExTcI1qWg6UVMKstP6QELgtvEeHfqo4WgJrZP0qQo/edit#gid=0"
competition_name = 'Hackathon-Summer-2020'
public_repo_path = file.path('../', competition_name)

# download fresh copy
update_manifest = FALSE
if(update_manifest){
  sheet = googlesheets4::read_sheet(gs_sheet)
  subsheet =  sheet %>% dplyr::filter(Valid == TRUE) %>% dplyr::select(gh_handle = 'Github handle', pseudonym, email = 'Captain e-mail') 
  update_gs_manifest(subsheet,competition_name)
}
# 
# 

manifest_file = file.path('private', 'MANIFEST.csv')

# truth
truth_file = file.path('private', 'TEST_TARGET.csv')


truth = readr::read_csv(truth_file)[[1]]
manifest = readr::read_csv(manifest_file)


plan = drake_plan(
    config = target(list(competition_name = competition_name, manifest = manifest, public_repo_path = public_repo_path)),
    readme_ok = target(has_readme(readme_url), transform= map(.data = !!manifest, .id =  gh_handle), trigger = trigger(change = last_modified(readme_url))),
    #readmes = target(c(readme_ok), transform = combine(readme_ok)),
    scores = target(eval_predictions(prediction_url, truth), transform = map(.data = !!manifest, .id =  gh_handle), trigger = trigger(change = last_modified(prediction_url))),
    result_table = target(bind_cols(manifest, tibble(readme_ok = c(readme_ok), scores = list(scores))), transform = combine(readme_ok, scores)),
    # might need to `combine` these
    leaderboard = Hackathon:::rmarkdown(
      knitr_in("Leaderboard.Rmd"),
      output_file = file_out("Leaderboard.html"),
      quiet = TRUE
    ),
    update_parent = target(Hackathon:::update_public(file_in("Leaderboard.html"), public_repo_path))
    )
