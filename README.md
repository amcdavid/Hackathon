
<!-- README.md is generated from README.Rmd. Please edit that file -->

# “Hackathon” predictive modeling competitions on github

By a “Hackathon” I mean a lightweight kaggle-style predictive modeling
competition, e.g. for class projects.

This contains code to

-   create project structures to run such a competition
-   collect submission from github
-   score submissions
-   and maintain a leaderboard (that uses github pages).

Variants of this code have been used several times by the author run
such competitions. See the very WIP vignette.

# Colophone

``` r
library(Hackathon)
sessionInfo()
```

    ## R version 4.1.1 (2021-08-10)
    ## Platform: x86_64-apple-darwin17.0 (64-bit)
    ## Running under: macOS Mojave 10.14.6
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.1/Resources/lib/libRblas.0.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.1/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] Hackathon_0.0.0.9003
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] knitr_1.37       magrittr_2.0.1   hms_1.1.1        tidyselect_1.1.1
    ##  [5] R6_2.5.1         rlang_0.4.12     fastmap_1.1.0    fansi_1.0.0     
    ##  [9] stringr_1.4.0    dplyr_1.0.7      tools_4.1.1      xfun_0.29       
    ## [13] utf8_1.2.2       DBI_1.1.2        htmltools_0.5.2  ellipsis_0.3.2  
    ## [17] assertthat_0.2.1 yaml_2.2.1       digest_0.6.29    tibble_3.1.6    
    ## [21] lifecycle_1.0.1  crayon_1.4.2     tzdb_0.2.0       readr_2.1.1     
    ## [25] purrr_0.3.4      vctrs_0.3.8      glue_1.6.0       evaluate_0.14   
    ## [29] rmarkdown_2.11   stringi_1.7.6    compiler_4.1.1   pillar_1.6.4    
    ## [33] generics_0.1.1   pkgconfig_2.0.3
