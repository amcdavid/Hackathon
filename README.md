
<!-- README.md is generated from README.Rmd. Please edit that file -->

This contains the holdout data and other resources that must not be
shared publicly.

This also contains the code that scores submissions for the hackathon.

# Contents

  - Teams-Manifest.csv: list of teams used to poll git repos
  - Results.Rmd: rmarkdown after compiling results, copy to public repo
    when done
  - R/: code
  - private\_data/: hold out data labels

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
    ##  [1] compiler_4.0.0  magrittr_1.5    tools_4.0.0     htmltools_0.5.0
    ##  [5] yaml_2.2.1      stringi_1.4.6   rmarkdown_2.3   knitr_1.29     
    ##  [9] stringr_1.4.0   xfun_0.15       digest_0.6.25   rlang_0.4.7    
    ## [13] evaluate_0.14
