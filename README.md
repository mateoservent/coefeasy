
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Coeffeasy

<!-- badges: start -->

![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)\](<https://lifecycle.r-lib.org/articles/stages.html#experimental>)
[![CRAN
status](https://www.r-pkg.org/badges/version/Coeffeasy)](https://CRAN.R-project.org/package=Coeffeasy)
<!-- badges: end -->

`Coeffeasy` is an R package under development for making regression
coefficients more accessible. With this tool, you can read linear,
logistic, and multinomial regression coefficients accurately and
instantly. The package now automatically controls for heteroscedasticity
and offers the capability to choose the type of standard error for the
correction and group errors by cluster—all in a single, streamlined
function, and more enhancements are coming!

In the evolving landscape of statistical tools within the R environment,
`Coeffeasy` is an innovative R package designed to simplify and automate
the interpretation of regression coefficients. While there is a
well-known black box in more technical disciplines concerning empirical
behaviors of the real world, a similar situation arises for applied
profiles. While they may be deeply familiar with empirical behavior,
inferential tools can remain a black box, even for those who master
programming and are able to run the classic regressions. This package
addresses this technical knowledge gap.

`Coeffeasy` is a straightforward package designed primarily for, but not
limited to, statistics professors, graduate students, and
statistics-related practitioners. Historically, these practitioners
often sought expertise from specialists to navigate the intricacies of
regression results, recognizing that although an interpretation of
coefficients should follow a consistent design, the underlying knowledge
to read the results of a regression can be quite technical and
unambiguous in its presentation. Acknowledging this challenge,
`Coeffeasy` offers a systematic solution, primarily serving linear,
logistic models, and multinomial models. However, its developmental
trajectory is set to incorporate advanced models. As evidence-based
decision making continues to gain importance, `Coeffeasy` aims to help
close the knowledge gap, providing clear and accessible statistical
learning, and reinforcing the importance of both automation and
accessibility in contemporary data science.

## Installation

Coeffeasy can be installed using the development version of the package
from [github](https://github.com/your_github_username/Coeffeasy) with:

``` r
install.packages("remotes")
remotes::install_github("mateoservent/Coeffeasy")
```

## Example Linear Regression

In this example, we use `Coeffeasy_lm()` to interpret coefficients from
a linear regression on the mtcars dataset, analyzing how car weight
affects miles per gallon when controlling for horsepower and quarter
mile time.

``` r
library(Coeffeasy)

# Fit the linear regression model
model <- lm(mpg ~ wt + hp + qsec, data = mtcars)

# Use Coeffeasy's function to interpret the coefficients

# Using the default settings, which automatically deduce variable names and use an alpha of 0.05
Coeffeasy_lm(model) 

# Specifying the names of the response and predictor variables for a clearer interpretation, adjusting the significance level, and selecting a longer, more descriptive result
Coeffeasy_lm(model, y = "Miles per gallon", x = "Car weight (1000 lbs)", alpha = 0.01, short = F) 
```

## Example Logistic Regression

Second example, we use `Coeffeasy_logit()` to interpret coefficients
from a logistic regression on the same dataset. We will analyze how the
weight of the car affects the likelihood of a car having an automatic
transmission (1 = Automatic; 0 = Manual).

``` r
# Fit the logistic regression model
model_logit <- glm(am ~ wt, data = mtcars, family = "binomial")

# Using the default settings, which automatically deduce variable names and use an alpha of 0.05
Coeffeasy_logit(model_logit) 

# Specifying the names of the response and predictor variables for a clearer interpretation, and adjusting the significance level
Coeffeasy_logit(model_logit, y = "Automatic Transmission", x = "Car weight (1000 lbs)", alpha = 0.01) 
```
