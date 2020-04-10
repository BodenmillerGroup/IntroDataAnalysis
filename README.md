# Introduction to data analysis in R and python

The main purpose of this repository is to collect example data and instruction scripts to highlight key features of the R and python programming languages.
Training sessions are divided into [R](../master/R) and [python](../master/python) training.
All example data are centrally available from the [Data](../master/Data) folder.

**Disclaimer:** We prepared these sessions to give a very broad introduction to the R and python programming language.
These sessions should not replace university courses and might not contain all relevant topics.

## Things to install

To maximise the time spend on actual hands-on training in both languages, please install the following software specified for the different sessions:

### R

**Session 1:**

* Install R from [https://cran.r-project.org/](https://cran.r-project.org/) or via brew (`brew install r`) or make sure that you have R version 3.6.1 (or higher) installed.
* Install RStudio Desktop from [https://rstudio.com/products/rstudio/](https://rstudio.com/products/rstudio/)
* Test the install by opening RStudio and typing:

```r
example(readline)
```

To knit an Rmardown (.Rmd) files, you need to install `rmarkdown` via `install.packages("rmarkdown")`.

**Session 2:**

* Clone this repository

Via terminal:

1. Create a `Github` folder on your local machine.
2. Enter the folder
3. Clone the repository

```shell
cd ~
mkdir Github
cd Github
git clone https://github.com/BodenmillerGroup/IntroDataAnalysis.git
```

Via Github Desktop (e.g. on Windows):

Follow [these guidelines](https://help.github.com/en/desktop/contributing-to-projects/cloning-a-repository-from-github-to-github-desktop)

* Install the `openxlsx` package in R by typing:

```r
install.packages("openxlsx")
```

**Session 3**

Please install the `tidyverse`  and `nycflights13` libraries via:

```r
install.packages("tidyverse")
install.packages("nycflights13")
```

You might in addition need to install the `DBI` library:

```r
install.packages("DBI")
```

Please also install the `cowplot` and `patchwork` libraries via:

```r
install.packages("cowplot")
install.packages("patchwork")
```


## Joint sessions

* March 24, Introduction to Data Analysis Environments  
  https://docs.google.com/presentation/d/17gDZuQkWH9Jkwg5skAIT3o__fQaGOYgAJ5Ri46Api1M/edit?usp=sharing
* April 14, Version control with Git
