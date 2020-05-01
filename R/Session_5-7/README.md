# Session_5-7

In the following sessions, I will keep code organized in a way how I would usually do it when analysing data.
Based on the feedback received for the previous sessions, I will continue with the following topics:

**Session 5:** 
* Changes to R version 4.0
* Introduction to the `workflowr` package
* General recommendations on how to keep your code organized
* How to write documented code and auxiliary functions

**Session 6:**
* Linear regression
* Machine learning basics

**Session 7:**
* More on `ggplot2` 
* Reproducible and publication ready figures 

## Changes in R version 4.0

R version 4 has been released on 24th of April ([https://cran.r-project.org/doc/manuals/r-devel/NEWS.html](https://cran.r-project.org/doc/manuals/r-devel/NEWS.html))
Bioconductor version 3.11 was released on 28th of April and you can check out new packages here: [https://bioconductor.org/news/bioc_3_11_release/](https://bioconductor.org/news/bioc_3_11_release/)

The main changes to R version 4.0 are as follows:

1.  `matrix` objects now also inherit from class `array`.
This means that the `class` of a `matrix` object returns two characters:

```r
mat <- matrix(1)
class(mat)
# [1] "matrix" "array" 
is.matrix(mat)
# [1] TRUE
is.array(mat)
# [1] TRUE
```

2. There is a new way to displaying "raw" characters:

```r
test <- r"(This is a "test". I 'want' to use special characters such as \)"
test
# [1] "This is a \"test\". I 'want' to use special characters such as \\"
```

3. `stringsAsFactors` is finally set to `FALSE`:

```r
dat <- data.frame(x = 1:3, y = c("dog", "cat", "mouse"))
dat$y
# [1] "dog"   "cat"   "mouse"
```

4. The default colours in R changed for the better
