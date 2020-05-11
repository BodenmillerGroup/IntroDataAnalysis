# -----------------------------------------------------------------------------
# Auxiliary functions
# -----------------------------------------------------------------------------

# Check inputs to my_plotPCA function
.inputCheck <- function(pca, colour_by){
  # Test class
  if (!is(pca, "prcomp")) {
    stop("'pca' not of type 'prcomp'")
  }

  # Check length
  if (nrow(pca$x) != length(colour_by)){
    stop("'colour_by' not of same length as data points in 'pca'")
  }
}

library(ggplot2)
# Function to plot a PCA nicely
# pca: an object of type prcomp
# colour_by: an optional vector with same length as data points in pca
my_plotPCA <- function(pca, colour_by){

  # Check inputs
  .inputCheck(pca, colour_by)

  # Build data frame
  cur_df <- data.frame(PC1 = pca$x[,1],
                       PC2 = pca$x[,2],
                       colour = colour_by)

  # Calculate the variance explained
  cur_var <- pca$sdev ^ 2
  cur_var_expl <- (cur_var / sum(cur_var)) * 100
  cur_var_expl <- round(cur_var_expl, digits = 2)

  # Plot the results
  ggplot(cur_df) +
    geom_point(aes(PC1, PC2, colour = colour)) +
    xlab(paste0("PC1 ", cur_var_expl[1], "% var explained")) +
    ylab(paste0("PC2 ", cur_var_expl[2], "% var explained"))
}

# Function to read in example data for multiple linear regression example
# This code has been copied from here:
# https://daviddalpiaz.github.io/appliedstats/multiple-linear-regression.html

readInCars <- function(){
  # read the data from the web
  autompg = read.table(
    "http://archive.ics.uci.edu/ml/machine-learning-databases/auto-mpg/auto-mpg.data",
    quote = "\"",
    comment.char = "",
    stringsAsFactors = FALSE)
  # give the dataframe headers
  colnames(autompg) <- c("mpg", "cyl", "disp", "hp", "wt", "acc", "year", "origin", "name")
  # remove missing data, which is stored as "?"
  autompg <- subset(autompg, autompg$hp != "?")
  # remove the plymouth reliant, as it causes some issues
  autompg <- subset(autompg, autompg$name != "plymouth reliant")
  # give the dataset row names, based on the engine, year and name
  rownames(autompg) <- paste(autompg$cyl, "cylinder", autompg$year, autompg$name)
  # remove the variable for name, as well as origin
  autompg <- subset(autompg, select = c("mpg", "cyl", "disp", "hp", "wt", "acc", "year"))
  # change horsepower from character to numeric
  autompg$hp <- as.numeric(autompg$hp)

  return(autompg)
}
