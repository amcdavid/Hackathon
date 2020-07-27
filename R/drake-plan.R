gs_sheet = "https://docs.google.com/spreadsheets/d/1mK5UgNIRrdSxVyb3L9MfD59XzR0Q0MQfyCpvccuiPZI/edit#gid=2103763262"
competition_name = 'Hackathon-Summer-2020'
public_repo_path = file.path('../', competition_name)

# download fresh copy
# update_gs_manifest(gs_sheet,competition_name)
manifest_file = file.path('private', 'MANIFEST.csv')

# truth
truth_file = file.path('private', 'TEST_TARGET.csv')

#' Get the plan
#'
#' @return plan
#' @export
#' @import drake
get_plan <- function(){
  drake_plan(
    truth = read_csv(file_in(truth_file)),
    manifest = get_manifest(file_in(manifest_file)),
    readme_ok = target(has_readme(file_in(url)), transform(map(url = !!manifest$readme_url))),
    predictions = target(download_predictions(file_in(url)), transform = map(url = !!manifest$prediction_url)),
    score = target(calculate_mse(predictions, truth, transform = map(predictions))),
    # might need to `combine` these
    leaderboard = rmarkdown(
      knitr_in("Leaderboard.Rmd"),
      output_file = file_out("Leaderboard.md"),
      quiet = TRUE
    ),
    update_public(file_in("Leaderboard.md"), public_repo_path)
    )
}