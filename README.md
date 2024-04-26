
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Coefeasy <img src="man/figures/coefeasy_logo.png" width="160px" align="right"/>

<!-- badges: start -->

![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)
[![CRAN
status](https://www.r-pkg.org/badges/version/Coeffeasy)](https://CRAN.R-project.org/package=Coeffeasy)
<!-- badges: end -->

`Coefeasy` is a simple R package under development for making regression
coefficients more accessible. With this tool, you can read linear and
logistic regression coefficients accurately and instantly. The package
offers results not only in English, but in multiple languages, and now
automatically controls for heteroscedasticity and offers the capability
to choose the type of standard error for the correction and group errors
by cluster—all in a single, streamlined function.

`Coefeasy` is a straightforward package designed primarily for, but not
limited to, professors and graduate students. Historically, although an
interpretation of coefficients should follow a consistent design, the
underlying knowledge to read the results of a regression can be quite
technical and unambiguous in its presentation. Acknowledging this
challenge, `coefeasy` offers a systematic solution, primarily serving
linear and logistic models. As evidence-based decision making continues
to gain importance, `coefeasy` aims to help close the knowledge gap,
providing clear and accessible statistical learning, and reinforcing the
importance of both automation and accessibility.

## Installation

Coeffeasy can be installed using the development version of the package
from [github](https://github.com/your_github_username/Coeffeasy) with:

``` r
install.packages("remotes")
remotes::install_github("mateoservent/coefeasy")
```

## Example Linear Regression

In this example, we use `coefeasy_lm()` to interpret coefficients from a
linear regression on the mtcars dataset, analyzing how car weight
affects miles per gallon when controlling for horsepower and quarter
mile time.

``` r
library(coefeasy)

# Fit the linear regression model
model <- lm(mpg ~ wt + hp + qsec, data = mtcars)

# Use Coeffeasy's function to interpret the coefficients

# Using the default settings, which automatically deduce variable names and use an alpha of 0.05
coefeasy_lm(model) 

# Specifying the names of the response and predictor variables for a clearer interpretation, adjusting the significance level, and selecting a longer, more descriptive result
coefeasy_lm(model, y = "Miles per gallon", x = "Car weight (1000 lbs)", alpha = 0.01, short = F) 

# To display results in another language, such as French, use the argument 'language="fr"' (beta).
```

## Example Logistic Regression

Second example, we use `coefeasy_logit()` to interpret coefficients from
a logistic regression on the same dataset. We will analyze how the
weight of the car affects the likelihood of a car having an automatic
transmission (1 = Automatic; 0 = Manual).

``` r
# Fit the logistic regression model
model_logit <- glm(am ~ wt, data = mtcars, family = "binomial")

# Using the default settings, which automatically deduce variable names and use an alpha of 0.05
coefeasy_logit(model_logit) 

# Specifying the names of the response and predictor variables for a clearer interpretation, and adjusting the significance level
coefeasy_logit(model_logit, y = "Automatic Transmission", x = "Car weight (1000 lbs)", alpha = 0.01) 
```
