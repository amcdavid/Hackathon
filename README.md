
<!-- README.md is generated from README.Rmd. Please edit that file -->

This contains the holdout data and other resources that must not be
shared publicly.

This also contains the code that scores submissions for the hackathon.

# Contents

  - Leaderboard.Rmd: rmarkdown after compiling results, copy to public
    repo when done
  - private/: hold out data labels and team manifest.
  - R/: code

# Use

``` r
source('drake/drake-plan.R')
make(plan)
```

This sets up a drake workflow to poll all repos in
`private/MANIFEST.csv`, score them, write Leaderboard.html, and copy to
the parent repo.

# Todo

  - Track project-specific using a yaml or otherwise configuration file
    rather than global variables in drake-plan.R.
  - Add a function to initialize a Hackathon private directory, copying
    down the drake workflow.

# Colophone

``` r
library(Hackathon)
sessionInfo()
```

    ## R version 4.0.0 (2020-04-24)
    ## Platform: x86_64-apple-darwin17.0 (64-bit)
    ## Running under: macOS Mojave 10.14.6
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRblas.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] Hackathon_0.0.0.9000
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.5      crayon_1.3.4    digest_0.6.25   R6_2.4.1       
    ##  [5] lifecycle_0.2.0 magrittr_1.5    evaluate_0.14   pillar_1.4.6   
    ##  [9] rlang_0.4.7     stringi_1.4.6   ellipsis_0.3.1  vctrs_0.3.2    
    ## [13] rmarkdown_2.3   tools_4.0.0     stringr_1.4.0   readr_1.3.1    
    ## [17] hms_0.5.3       xfun_0.16       yaml_2.2.1      compiler_4.0.0 
    ## [21] pkgconfig_2.0.3 htmltools_0.5.0 knitr_1.29      tibble_3.0.3
