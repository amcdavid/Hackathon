% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/manifest.R
\name{update_gs_manifest}
\alias{update_gs_manifest}
\title{Downlaod a manifest from googlesheets, add urls and save}
\usage{
update_gs_manifest(sheet, hack)
}
\arguments{
\item{sheet}{\code{data.frame} containing team registration info}

\item{hack}{\code{Hackathon} used to determine github repository}

\item{repo_name}{\code{character} or a character}
}
\value{
\code{logical} if the manifest is OK.
}
\description{
Downlaod a manifest from googlesheets, add urls and save
}
