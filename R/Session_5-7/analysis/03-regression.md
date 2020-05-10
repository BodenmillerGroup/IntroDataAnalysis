---
title: "03-regression"
author: "nilseling"
date: "2020-05-09"
output: workflowr::wflow_html
editor_options:
  chunk_output_type: console
---

## Introduction

In todays session, we will focus on applied statistics in R. 
As an example (statistics is a huuuuuuuuge field), I will go through different regression models.
In particular, these will be simple linear regression, multiple linear regression, analysis of variance, logistic regression, multinomial logistic regression and random forrest (as popular non-parametric regression example).
I will also try to explain the underlying mathematical derivations to some extend.
This tutorial is heavily based on the instructions [here](https://daviddalpiaz.github.io/appliedstats/).

## Linear regression

In the first section, we will discuss linear regression problems using two different car-related datasets.

### Simple linear regression

Here, I will give an introdcution to the most simple regression model available: the simple linear regression.
I will also explain the different values returned by the model.

As an example datasets, we will use the `cars` data.
`?cars` returns: The data give the speed of cars and the distances taken to stop. Note that the data were recorded in the 1920s.

```{r cars-data}
str(cars)
```

In any regression problem, it is crucial to first understand the relationship between the response variable (or "dependent" variable; or target; on the y-axis) and the explanatory variable (or "independent" variable; or predictor; on the x-axis):

```{r}
library(tidyverse)
cars %>% 
  ggplot() + geom_point(aes(speed, dist))
```

We now want to model the relationship between the response variable `dist` and the explanatory variable `speed` in the form of:

$dist = f(speed) + \epsilon$

Here, $f(speed)$ is a function that depends on speed (or a constant) and $\epsilon$ is a "residual error" that accounts for unexplained variability in the model.
By plotting the data, we know, that the data shows a linear dependence - we can therefore use a function that depends linearly on `speed` to model `dist`:

$dist = \beta_0 + \beta_1 \cdot speed + \epsilon$

In correct mathematical notation, the equation would be:

$Y = \beta_0 + \beta_1 X + \epsilon$

or:

$Y_i = \beta_0 + \beta_1 x_i + \epsilon_i$

where $\epsilon_i \sim N(0, \sigma^2)$

The last equation means that the error is a independent and identically distributed (iid) randomw variable with mean 0 and standard deviation $\sigma^2$.

To fit a linear regression, we make the following assumptions:

* Linear: the relationship between $Y$ and $x$ is linear
* Independent: The errors $\epsilon$ are independent
* Normal: the errors $\epsilon$ are normal distributed
* Equal variance: at each value of x, the variance of $Y$ is equal to $\sigma^2$

**Fitting a linear regression in R**

To fit a linear regression in R, we can use the `lm` function of the `stats` package.

```{r fit-cars}
stop_dist_model <- lm(dist ~ speed, data = cars)
```

There are now several ways of visualizing the fitting results:

```{r show-results}
stop_dist_model
summary(stop_dist_model)
```

Before we go into detail what these results mean, I want to introduce the `broom` package to tidying up these results:

```{r broom-tidy}
library(broom)
# Tidy output of the regression parameters
broom::tidy(stop_dist_model)

# Tidy output of the fitting results
broom::glance(stop_dist_model)

# Tidy output of the fitted values
head(broom::augment(stop_dist_model))
```

Using the `broom` package, we can now plot the fitted line to the data:

```{r plot-lm}
augment(stop_dist_model) %>%
  ggplot() + geom_point(aes(speed, dist)) +
  geom_line(aes(speed, .fitted), colour = "red", lwd = 2) + 
  geom_segment(aes(speed, dist, xend = speed, yend = .fitted)) +
  geom_label(aes(5, 120, label = paste("R2:", round(r.squared, 2))), 
             data = glance(stop_dist_model)) +
  geom_label(aes(5, 110, label = paste("p-value:", format(p.value, digits = 2))), 
             data = glance(stop_dist_model)) 
```

**Calculating the results by hand**

To fully understand, what the regression results mean, we will next calculate these values by hand.

To achieve the best linear model fit, we want to minimize the sum of all squared distances between the regression line and the data points:

$argmin \sum_{i=1}^n(y_i - f(x_i))^2 = argmin \sum_{i=1}^n(y_i - (\beta_0 + \beta_1x_i))^2$

Note: the error is defined as: $\epsilon_i = y_i - (\beta_0 + \beta_1x_i)$
We basically try to minimize the sum of squared errors.

The full mathematical derivation can be found [here](https://daviddalpiaz.github.io/appliedstats/simple-linear-regression.html)

As a summary, we need to (i) calculate the partial derivatives of $(y_i - (\beta_0 + \beta_1x_i))^2$ for $\beta_0$ and $\beta_1$, (ii) set them to 0 and solve the resulting set of linear equations.

The result is the following:

$\hat{\beta}_1 = \dfrac{\sum_{i=1}^n(x_i-\bar{x})(y_i-\bar{y})}{\sum_{i=1}^n(x_i-\bar{x})^2}=\dfrac{S_{xy}}{S_{xx}}$

and

$\hat{\beta}_0 = \bar{y} - \hat{\beta_1}\bar{x}$

As homework, you can try to derive these equations.

Note: the "hat" on the betas means "estimate" since we do not know the true underlying regression parameters - more samples will change the estimates.

**Calculating the regression coefficients in R**

We define the variables x and y to be in line with the math above:

```{r regression-coefficients}
x <- cars$speed
y <- cars$dist

Sxy <- sum((x - mean(x)) * (y - mean(y)))
Sxx <- sum((x - mean(x)) ^ 2)

beta_hat_1 <- Sxy / Sxx
beta_hat_0 <- mean(y) - beta_hat_1 * mean(x)

c(beta_hat_0, beta_hat_1)

# Compare to fitted model
stop_dist_model
```

**Calculating the residual error in R**

We can also manually calculate the residual error in R.
The residuals can be obtained from the modelled fit using the `residuals` accessor function:

```{r residual-error}
stop_dist_residuals <- residuals(stop_dist_model)

manual_residuals <- y - (beta_hat_0 + beta_hat_1 * x)

# Test for equality
all.equal(as.numeric(stop_dist_residuals), manual_residuals)
```

**Calculating the residual standard error**

So far, we have calculated $\hat{\beta_1}$ and $\hat{\beta_0}$.
Now, we want to estimate the variance $\sigma^2$ of the model.
An estimate for $\sigma^2$ is defined as:

$s_e^2 = \frac{1}{n-2}\sum_{i=1}^n(y_i - \hat{y})^2=\frac{1}{n-2}\sum_{i=1}^n\epsilon_i^2$


We can now calculate this in R:






### Multiple linear regression

### ANOVA

## Classification examples

### Logistic regression

### Multinomial logisitic regression

### Random forrest

```{r}

```

