# Session 4: Biocondcutor and the SingleCellExperiment

In this session, I will give an introduction to `Bioconductor` and how to perform single-cell analysis using `Bioconductor` packages.
This session introduces the concept of "object-oriented" programming - or at least how to understand it in R.
We will use the `SingleCellExperiment` class object as an example - however the skills learned in this session can be easily applied to other high-dimensional data analysis tasks.
The `SingleCellExperiment` class is a so called `S4` class object and the prefered object type in Bioconductor.
Check out [https://adv-r.hadley.nz/oo.html](https://adv-r.hadley.nz/oo.html) for in depth explanations on opbject-oriented programming in R.

Why do we want to use the `SingleCellExperiment` object?

* It allows consistent sub-setting of cells and markers without breaking the connection between expression counts and metadata
* It allows efficient on-disk storing in form of `.rds` files
* Everything is in one place
* By now, more than 70 packages provide functions to alter the `SingleCellExperiment` object - you don't need to implement functions yourself

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
BiocManager::install("BodenmillerGroup/Rphenograph")
```

Bioconductor packages are released twice a year - once in April/May, once in October.
Unless you are developing Bioconductor packages, you won't need to use Bioconductor devel.
But here are more information: [Bioc devel](https://www.bioconductor.org/developers/how-to/useDevel/)

## The `SingleCellExperiment` class

Here, I will use the `SingleCellExperiment` class object as an example for object-oriented data analysis in R.
Other widely used objects are [SummarizedExperiment](https://www.bioconductor.org/packages/release/bioc/html/SummarizedExperiment.html) containers, from which the `SingleCellExperiment` class inherits. 

To work with the object, I will mostly follow the [Orchestrating Single-Cell Analysis with Bioconductor](https://osca.bioconductor.org/) workflow, an excellent resource to do single-cell data analysis in R using Bioconductor.

**Of note:** The workflow was written for single-cell RNA sequencing data and some concepts (e.g. normalization) do not apply to CyTOF data analysis.

Here, we will start with the [data analysis infrastructure](https://osca.bioconductor.org/data-infrastructure.html) section of the OSCA workflow.

### Read in data

We will first read in the data that we want to analyse.
For convenience, I stored the raw expression counts (mean pixel intensity per cell) in one .csv file, the marker-specific metadata in one .csv file and the cell-specific metadata in one .csv file.

```{r read-in-data}
# Read in counts
pancreas_counts <- read.csv("~/Github/IntroDataAnalysis/Data/pancreas_counts.csv", 
                            stringsAsFactors = FALSE, row.names = 1)
head(pancreas_counts)
dim(pancreas_counts)

# Read in cell metadata
cell_meta <- read.csv("~/Github/IntroDataAnalysis/Data/pancreas_cellmeta.csv", 
                      stringsAsFactors = FALSE, row.names = 1)
head(cell_meta)

# Read in marker metadata
marker_meta <- read.csv("~/Github/IntroDataAnalysis/Data/pancreas_markermeta.csv", 
                      stringsAsFactors = FALSE, row.names = 1)
head(marker_meta)
```

In most cases, it is safe to compare the order of rows and columns:

```{r check-ordering}
identical(rownames(pancreas_counts), rownames(cell_meta))
identical(colnames(pancreas_counts), rownames(marker_meta))

# Check why the colnames and rownames don't match
colnames(pancreas_counts)
rownames(marker_meta)

# Fix colnames
colnames(pancreas_counts) <- gsub("\\.", "-", colnames(pancreas_counts))
identical(colnames(pancreas_counts), rownames(marker_meta))
```

In general, it is recommended not to use spaces or special characters when labelling markers or cells.

### Build `SingleCellExperiment` object

As you can imagine, it would be a bit annoying to handle three different objects side-by-side.
That's why we can store everything in one single container: the `SingleCellExperiment` object.

```{r SingleCellExperiment}
library(SingleCellExperiment)

sce <- SingleCellExperiment(assays = list(counts = t(pancreas_counts)), colData = cell_meta)
sce

colnames(sce)
rownames(sce)

dim(sce)
ncol(sce)
nrow(sce)
```

The `SingleCellExperiment` stores cells in the columns and markers in rows.

We can now also store the cell- and marker-specific metadata in the SCE object.
These need to be `DataFrame` objects - a Bioconductor-specific class similar to `tibble`, `data.table` and `data.frame`.

```{r SingleCellExperiment-2}
library(S4Vectors)
colData(sce) <- DataFrame(cell_meta)
rowData(sce) <- DataFrame(marker_meta)

sce
```

We have now successfully created a `SingleCellExperiment`!

### Add other assays

We have now stored the raw counts in the SCE object.

```{r assay-1}
assays(sce)
assayNames(sce)
dim(counts(sce))
```

For dimensionality reduction and clustering, it is often preferred to work with distributions that are normal-like.
We can now also store transformed and scaled counts in the same object:

```{r transformation}
assay(sce, "exprs") <- asinh(counts(sce) / 1)
assay(sce, "scaled") <- t( scale( t( assay(sce, "exprs") ) ) )

rowMeans(assay(sce, "scaled"))
rowVars(assay(sce, "scaled"))
```

## Dimensionality reduction

In this section, we will learn how to perform common dimensionality reduction methods using the `scater` package.
We will start by peforming a principal component analysis.
For this, we can use the `runPCA` function provided by the `scater` package.

```{r PCA}
library(scater)
sce <- runPCA(sce, exprs_values = "exprs", ncomponents = 10, subset_row = !(rownames(sce) %in% c("H3", "Ir191", "Ir193")))
reducedDims(sce)$PCA
```

We can also compute a TSNE using the `runTSNE` function. 
Of note: you need to set a seed for reproducibility.
Also, the default `perplexity` value for the `runTSNE` function is the number of cells divided by 5.
This is far larger than the default value for `Rtsne`, which is 30 but should preserve the overall structure better.
However, it is recommended setting different seeds and different `perplexity` parameters to check the effect of those on the visual appearance of the TSNE.

```{r TSNE}
set.seed(12345)
sce <- runTSNE(sce, exprs_values = "exprs", subset_row = !(rownames(sce) %in% c("H3", "Ir191", "Ir193")))

reducedDims(sce)
```

Finally, we can also compute a UMAP:

```{r umap}
set.seed(12345)
sce <- runUMAP(sce, exprs_values = "exprs", subset_row = !grepl("H3|Ir", rownames(sce)))

reducedDims(sce)
```

Again, you need to play around with the seed and the `n_neighbors` and the `min_dist` parameter to see how this affects the visual appearance.
In general, the non-linear dimensionality reduction methods (tSNE, UMAP) only offer a visual tool and should not be used for clustering.

## Visualization

The scater package offers a number of functions to visualize the `SingleCellExperiment` object.

The `plotExpression` function plots expression values stored in the `SingleCellExperiment` object:

```{r plotExpression}
plotExpression(sce, features = c("PIN", "CDH"), exprs_values = "exprs", other_fields = "ImageNumber") +
    facet_wrap(~ImageNumber)

plotExpression(sce, features = c("PIN", "CDH"), x = "CellType", exprs_values = "exprs", 
               colour_by = "CellType") + theme(axis.text.x = element_text(angle = 45, hjust = 1))

plotExpression(sce, features = "CDH", x = "PIN", exprs_values = "exprs", 
               colour_by = "CellType") + theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

The `plotHeatmap` function provides a wrapper function to `pheatmap` to visualize expression counts.

```{r plotHeatmap}
library(viridis)
plotHeatmap(sce, features = c("CDH", "PIN"), exprs_values = "exprs", colour_columns_by = "CellType")

plotHeatmap(sce, features = c("CDH", "PIN"), exprs_values = "exprs", 
            colour_columns_by = "CellType", columns = which(sce$CellType == "beta"))
```

The `plotReducedDims` function allows you to plot the different dimensionality reduced embeddings:

```{r plotReducedDims}
plotReducedDim(sce, "TSNE", colour_by = "CellType")
plotReducedDim(sce, "TSNE", colour_by = "case")
plotReducedDim(sce, "TSNE", colour_by = "PIN", by_exprs_values = "exprs")
plotReducedDim(sce, "TSNE", colour_by = "PIN", by_exprs_values = "exprs", shape_by = "case") +
    scale_shape_manual(values = c(16, 16, 16))

plotReducedDim(sce, "UMAP", colour_by = "CellType")
plotReducedDim(sce, "UMAP", colour_by = "case")
plotReducedDim(sce, "UMAP", colour_by = "PIN", by_exprs_values = "exprs")

plotReducedDim(sce, "PCA", colour_by = "CellType")
plotReducedDim(sce, "PCA", colour_by = "case")
plotReducedDim(sce, "PCA", colour_by = "PIN", by_exprs_values = "exprs")
```

The good thing is that the returned plots are `ggplot2` objects and can be further altered.

## Clustering

Graph-based clustering methods are preferred due to higher speed (https://osca.bioconductor.org/clustering.html)[https://osca.bioconductor.org/clustering.html].
But there are a few considerations:

* How many neighbors are considered when constructing the graph.
* What scheme is used to weight the edges.
* Which community detection algorithm is used to define the clusters.

We will first use `scran` to build a shared-nearest neighbour graph and perform community detection using the louvain method.

```{r snn}
library(scran)
cur_graph <- scran::buildSNNGraph(sce, k = 10, assay.type = "exprs", 
                                  subset.row = !(rownames(sce) %in% c("H3", "Ir191", "Ir193")))
cur_clusters <- igraph::cluster_louvain(cur_graph)$membership
table(cur_clusters)

# Store clusters in sce object
sce$snn_clusters <- factor(cur_clusters)

# TSNE and umap visualization
plotReducedDim(sce, "TSNE", colour_by = "snn_clusters")
plotReducedDim(sce, "UMAP", colour_by = "snn_clusters")
```

Next, we will use the `Rphenograph` package for clustering.
`Rphenograph` is also graph-based but weights edges between two nodes based on the jaccard similarity between the two sets of neighbors.
In general, this approach produces finer clusters.
When using `approx=TRUE`, you need to set a seed.

```{r Rphenograph}
library(Rphenograph)
cur_graph <- Rphenograph(t(assay(sce, "exprs")[!(rownames(sce) %in% c("H3", "Ir191", "Ir193")),]), k = 30)
cur_clusters <- igraph::membership(cur_graph[[2]])

# Store clusters in sce object
sce$rphenograph_clusters <- factor(cur_clusters)

# TSNE and umap visualization
plotReducedDim(sce, "TSNE", colour_by = "rphenograph_clusters")
plotReducedDim(sce, "TSNE", colour_by = "rphenograph_clusters", text_by = "rphenograph_clusters")
plotReducedDim(sce, "UMAP", colour_by = "rphenograph_clusters")

# Compare overlap between clusters
table(sce$snn_clusters, sce$rphenograph_clusters)
```

Finally, I will also show the use-case of the `flowSOM` function for clustering.
This is provided by the `CATALYST` package.
However, the `SingleCellExperiment` object needs to be slightly altered to make it compatible with `CATALYST`.
By default, `flowSOM` will use the `assay(sce, "exprs")` slot.

```{r flowSOM}
library(CATALYST)

# Select features for clustering
cur_features <- rownames(sce)[!(rownames(sce) %in% c("H3", "Ir191", "Ir193"))]

# We need to set a marker_class
rowData(sce)$marker_class <- "type"

# Cluster using flowSOM 
sce <- cluster(sce, features = cur_features, xdim = 10, ydim = 10, maxK = 20, seed = 12345)

rowData(sce)
colData(sce)

# Scater methods no longer support visualization of cluster results
plotReducedDim(sce, "TSNE", colour_by = "cluster_id")

# Use CATALYST specific functions
colData(sce)$sample_id <- colData(sce)$case
metadata(sce)$experiment_info <- data.frame(sample_id = unique(colData(sce)$case))
CATALYST::plotDR(sce, dr = "TSNE", color_by = "meta8")
```

## Summarizing the counts

Finally, we can average the counts per cluster (or any other entry to `colData(sce)`).

```{r}
cur_average <- scater::aggregateAcrossCells(sce, ids = sce$snn_clusters, 
                                            use_exprs_values = "counts", 
                                            average = TRUE, subset_row = cur_features)
assay(cur_average, "exprs") <- asinh(assay(cur_average, "counts") / 1)
plotHeatmap(cur_average, exprs_values = "exprs", 
            colour_columns_by = "snn_clusters")
```
