---
title: "Session 3: tidyverse and publication-ready figures"
author: "Nils"
date: "`r Sys.Date()`"
output: html_notebook
---

In this session, I will give an introduction to `Bioconductor` and how to perform single-cell analysis using `Bioconductor` packages.
This session introduces the concept of "object-oriented" programming - or at least how to understand it in R.
We will use the `SingleCellExperiment` class object as an example - however the skills learned in this session can be easily applied to other high-dimensional data analysis tasks.
The `SingleCellExperiment` class is a so called `S4` class object and the prefered object type in Bioconductor.
Check out [https://adv-r.hadley.nz/oo.html](https://adv-r.hadley.nz/oo.html) for in depth explanations on opbject-oriented programming in R.

## Bioconductor

Bioconductor provides tools for the analysis and comprehension of high-throughput genomic data. Bioconductor uses the R statistical programming language, and is open source and open development. It has two releases each year, and an active user community.

Check out the [https://bioconductor.org/](https://bioconductor.org/) website.

Bioconductor version 3.10 offers 1823 [software packages](https://bioconductor.org/packages/release/BiocViews.html#___Software), 957 [Annotation packages](https://www.bioconductor.org/packages/release/BiocViews.html#___AnnotationData), 385 [ExperimentData packages](https://www.bioconductor.org/packages/release/BiocViews.html#___ExperimentData) and 27 [Workflows](https://www.bioconductor.org/packages/release/BiocViews.html#___Workflow).

Bioconductor packages can be conveniently installed using `BiocManager`:

```{r BiocManager}
install.packages("BiocManager")
BiocManager::install("SingleCellExperiment")

# Should be '3.10'
BiocManager::version()

# Should be true
BiocManager::valid()
```

I prefer using the `BiocManager::install` since it checks if there are outdated packages - important to include bug fixes.
The `BiocManager::install` function also allows you to install CRAN and Github packages.

```{r BiocManager-2}
BiocManager::install("igraph")
BiocManager::install("JinmiaoChenLab/Rphenograph")
```

Bioconductor packages are released twice a year - once in April/May, once in October.
Unless you are developing Bioconductor packages, you won't need to use Bioconductor devel.
But here are more information: [Bioc devel](https://www.bioconductor.org/developers/how-to/useDevel/)

## The toy dataset

The toy data is kindly provided by Nicolas Damond.
It contains expression data of 12274 cells and 38 proteins. 
The raw files are stored in the [Data](../../Data) folder.

## The `SingleCellExperiment` class

Here, I will use the `SingleCellExperiment` class object as an example for object-oriented data analysis in R.
Other widely used objects are [SummarizedExperiment](https://www.bioconductor.org/packages/release/bioc/html/SummarizedExperiment.html) containers, from which the `SingleCellExperiment` class inherits. 

To work with the object, I will mostly follow the [Orchestrating Single-Cell Analysis with Bioconductor](https://osca.bioconductor.org/) workflow, an excellent resource to do single-cell data analysis in R using Bioconductor.

**Of note:** The workflow was written for single-cell RNA sequencing data and some concepts (e.g. normalization) do not apply to CyTOF data analysis.

Here, we will start with the [data analysis infrastructure](https://osca.bioconductor.org/data-infrastructure.html)



## Dimensionality reduction


## Visualization


## Clustering

knn

Rphenograph

flowSOM



