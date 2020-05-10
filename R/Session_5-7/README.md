# Session_5-7

In the following sessions, I will keep code organized in a way how I would usually do it when analysing data.
Based on the feedback received for the previous sessions, I will continue with the following topics:

**Session 5:** 

* Changes to R version 4.0
* Introduction to the `workflowr` package
* General recommendations on how to keep your code organized
* How to write documented code and auxiliary functions

To follow this session, please read through this README and see [here](./analysis/01-readData.Rmd) and [here](./analysis/02-analyseData.Rmd).

**Session 6:**

* Linear regression (simple linear regression, multiple linear regression, anova)

To follow this session, please have a look at the [03-regression.Rmd](./analysis/03-regression.Rmd) script.
For the full extend of instructions, please visit [this](https://daviddalpiaz.github.io/appliedstats/) site.
The statistics lecture was written by David Dalpiaz and is distributed under the [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/) license.
I have only taken parts of the original document.

Please in install the `broom` package for tidying your fitting results:

```r
install.packages("broom")
```

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

## Reproducible workflow in R

Here, I will give an introduction to the `workflowr` package and how to use it.
Please refer to the instructions on CRAN ([https://cran.r-project.org/web/packages/workflowr/vignettes/wflow-01-getting-started.html](https://cran.r-project.org/web/packages/workflowr/vignettes/wflow-01-getting-started.html)) and the online documentation ([https://jdblischak.github.io/workflowr/](https://jdblischak.github.io/workflowr/)) for extensive instructions.
I like working with `workflowr` since it provides a default working environment that keeps your code structured and reproducible.

First, let's install `workflowr`:

```r
install.packages("workflowr")
library("workflowr")
```

Please make sure that you have Github correctly set up.
If you have not yet created a Git repository on your computer you can run the follwoing in your R console:

```r
wflow_git_config(user.name = "Your Name", user.email = "email@domain")
```
As a demonstration, the current `workflowr` project is set up inside an already existing Git repository. 
This is possible, however the recommended way is to initialize a new repository:

```r
wflow_start("~/Github/my_workflowr_project")
```
For the sake of training purposes, I will create a new project inside my existing training GitHub repository:

```r
wflow_start("~/Github/GithubTest/my_workflowr_project", git = FALSE)
```
This command will create all files and sub-directories except the `.git` folder, which contains all information about commits and all information regarding version control.
Each Git repository should only have one `.git` folder in it's root directory.

### What are the created files?

The **required** folders:

* **analysis/**: This directory contains all the source R Markdown files for implementing the data analyses for your project. It also contains a special R Markdown file, index.Rmd, that does not contain any R code, but will be used to generate index.html, the homepage for your website. In addition, this directory contains the important configuration file `_site.yml`, which you can use to edit the theme, navigation bar, and other website aesthetics (for more details see the documentation on [R Markdown websites](https://bookdown.org/yihui/rmarkdown/rmarkdown-site.html)). Do not delete `index.Rmd` or `_site.yml`.
* **docs/**: This directory contains all the HTML files for your website. The HTML files are built from the R Markdown files in analysis/. Furthermore, any figures created by the R Markdown files are saved here. Each of these figures is saved according to the following pattern: docs/figure/<insert Rmd filename>/<insert chunk name>-#.png, where # corresponds to which of the plots the chunk generated (since one chunk can produce an arbitrary number of plots).

* **_workflowr.yml**: A workflow-specific configuration file specifying a seed to use when kintting your analysis code and a root directory for execution.

* **my_workflow_project.Rproj**: R project file that stores the configuration for you current R project - won't go into this is detail here.

The **optional** folder:

* **data/**: This directory is for raw data files.
* **code/**: This directory is for code that might not be appropriate to include in R Markdown format (e.g. for pre-processing the data, or for long-running code). Or for auxiliary functions.
* **output/**: This directory is for processed data files and other outputs generated from the code and data. For example, scripts in code/ that pre-process raw data files from data/ should save the processed data files in output/. (We are not goinf to use this).

The .Rprofile file is a regular R script that is run once when the project is opened. 
It contains the call `library("workflowr")`, ensuring that workflowr is loaded automatically each time a workflowr-project is opened.

### Adding thing to the .gitignore file

Now, it's good to become familar with the `.gitignore` file. 
Let's open it and we can see that there are already a couple of things inside.
They are there to avoid committing things that haven't been generated by calling `wflow_build`.
We add another line at the end: `data/*` to exclude all files in the data folder.
For now, we will add everything that is inside the `data/` folder to .gitignore.

After these alterations, I would recommend committing the changes:

```bash
git status
git add --all
git commit -m "My initial commit"
```

## Code organization and recommendations

The structure created by the `workflowr` package is ideal for data analysis.
In general, you want to keep a detailed description of you repository in a top-level `README.md` file.
This will face other users and makes your GitHub repo look very professional.
Furthermore, you should also add `README.md` files to each sub-folder explaining what visitors can find in these sub-folders.

Keep all your analysis files (in form of Rmarkdown (.Rmd)) in the `analysis/` folder (and nothing else except the `README.md`).
I personally exclude any `.png`, `.html` and other non-code files from my repository as they can get quite large and are not "code".
However, to later on build a website (one of the features fo `workflowr`), you will need to keep the `.html` and `.png` files in the `docs/` folder.
This also makes it easier to share results with collaborators.
Please make sure to always commit and push your local changes.

There are also a number of general recommendations regarding R code.
A very extensive explanation can be found here: [https://www.r-bloggers.com/%F0%9F%96%8A-r-coding-style-guide/](https://www.r-bloggers.com/%F0%9F%96%8A-r-coding-style-guide/)
Please read this through and adhere to it. 
It makes your code readable and avoids bugs.

One thing that they don't mention:
When writing markdown (and LaTeX), use one line per sentence - it makes your text readable on Github and does not interfere when compiling the document.

## Testing the `workflowr` package

Let's add a few lines of code to an analysis script in the `analysis/` folder.
Open the .Rproj file in RStudio and type in your console:

```r
wflow_open("analysis/01-readData.Rmd")
```

More instructions are found in the newly generated file here: [01-readData.Rmd](./analysis/01-readData.Rmd)

To build your workflow, run the follwowing code in your R console:

```r
wflow_build()
```

This command runs the different .Rmd files in the `analysis/` folder in separate R sessions and sets a common seed to make the analysis reproducible.
It furthermore records the `sessionInfo` at the end of each R session.
Let's have a look at the `docs/` folder.

You can now commit the changes.

If you want to re-run the whole analysis, just delete all .html files in the `docs/` folder and type `wflow_publish`.

### Adding the new page to the navigation bar

To add the newly created page `01-readData` to the navigation bar when opening for example the `index.html` file, just open the `analysis/_site.yml` file.
Here you can add the following lines:

```bash
- text: Reading in Data
  href: 01-readData.html
```

Since the navigation bar is part of each .html, you will need to delete all htmls in the `docs` folder and re-run the `wflow_build()` command.

## Adding more complicated analysis chunks

In the next section, I will show you how to generate "auxiliary" functions that can be sourced into  a `.Rmd` file.
Let's open a new .Rmd file inside the workflow:

```r
wflow_open("analysis/02-analyseData.Rmd")
```

See further instructions in the newly generated file [here](./analysis/02-analyseData.Rmd).

After calculating the PCA, I will open a new `.R` script in the `code/` folder that stored "auxiliary" (helper) functions.
Take a look [here](./code/auxiliary.R).

I added a `my_plotPCA` function that plots and colours the PCA based on a given input.
I also added a hidden (marked by the dot at the beginning of `.inputCheck`) that checks the user input.
This file can be sourced at the beginning of the data analysis script via the `source` function.
