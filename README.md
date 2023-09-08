# Coeffeasy
`Coeffeasy` is an R package under development for making regression coefficients more accessible. With this tool, you can read linear, logistic, and multinomial regression coefficients accurately and instantly, and more enhancements are coming!

In the evolving landscape of statistical tools within the R environment, `Coeffeasy` is an innovative R package designed to simplify and automate the interpretation of regression coefficients. Historically, statistics-related practitioners often sought expertise from specialists to navigate the intricacies of regression results, recognizing that although an interpretation of coefficients should follow a consistent design, the underlying knowledge to read the results of a regression can be quite technical and unambiguous in its presentation. Recognizing this challenge, `Coeffeasy` offers a systematic solution, primarily serving linear and logistic models. However, its developmental trajectory is set to incorporate advanced models such as Regression Discontinuity Design (RDD), Difference-in-Differences (DiD), Time Series data, and Experimental calculations like difference in means. A standout feature is its multilingual output capability, ensuring that the fundamental principles of statistical interpretation are comprehensible to a diverse, global user base. As data-driven decision-making continues to gain prominence, `Coeffeasy` aims to bridge the knowledge gap, providing clear and accessible statistical insights, reinforcing the importance of both automation and accessibility in contemporary data science.


## Installation

Coeffeasy can be installed using the development version of the package from [github](https://github.com/your_github_username/Coeffeasy) with:


``` r
install.packages("remotes")
remotes::install_github("mateoservent/Coeffeasy")

```

## Example 

In this example, we use Coeffeasy_lm() to interpret coefficients from a linear regression on the mtcars dataset, analyzing how car weight affects miles per gallon when controlling for horsepower and quarter mile time.

``` r

library(Coeffeasy)

# Fit the linear regression model
model <- lm(mpg ~ wt + hp + qsec, data = mtcars)

# Use Coeffeasy's function to interpret the coefficients

# Using the default settings, which automatically deduce variable names and use an alpha of 0.05
Coeffeasy_lm(model) 

# Specifying the names of the response and predictor variables for a clearer interpretation, and adjusting the significance level
Coeffeasy_lm(model, y = "Miles per gallon", x = "Car weight (1000 lbs)", alpha = 0.01) 


```


