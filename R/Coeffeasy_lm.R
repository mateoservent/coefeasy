#' Interpretation of Coefficients for Linear Regression Models
#'
#' This function provides an easy interpretation of coefficients from linear regression models,
#' considering potential heteroskedasticity.
#'
#' @param model An object of class `lm` representing the linear regression model.
#' @param x A character string specifying the predictor variable.
#' @param y A character string specifying the response variable.
#' @param alpha A numeric value for the significance level. Default is 0.05.
#' @param error A character string specifying the type of heteroskedasticity consistent standard errors. Default is "HC2".
#' @param cluster A value to specify the clustering variable. Default is NULL.
#'
#' @importFrom lmtest bptest coeftest
#' @import sandwich
#' @export
Coeffeasy_lm <- function(model, x = NULL, y = NULL, alpha = 0.05, error = "HC2", cluster = NULL) {
  # Get the names of the model variables if they are not specified
  if (is.null(x) || is.null(y)) {
    variables <- as.character(attr(terms(model), "variables"))
    y_default <- variables[2]
    x_default <- variables[length(variables)]
  }

  if (is.null(x)) x <- x_default
  if (is.null(y)) y <- y_default

  # Check for heteroskedasticity
  bptest_result <- lmtest::bptest(model)
  hetero_message <- "No heteroscedasticity was detected in the residuals."

  if (bptest_result$p.value < alpha) {
    # Heteroskedasticity detected, correct standard errors
    if (!is.null(cluster)) {
      # Apply cluster robust standard errors if cluster is provided
      vcov_matrix <- sandwich::vcovCL(model, cluster = cluster, type = error)
      hetero_message <- paste("Heteroscedasticity was detected in the residuals and standard errors were corrected with", error, "formula using clustering on", all.vars(cluster), ".")
    } else {
      vcov_matrix <- sandwich::vcovHC(model, type = error)
      hetero_message <- paste("Heteroscedasticity was detected in the residuals and standard errors were corrected with", error, "formula.")
    }
    model_coef <- lmtest::coeftest(model, vcov = vcov_matrix)
  } else {
    model_coef <- summary(model)$coefficients  # This will get the coefficient matrix
  }

  coef_value <- model_coef[2, 1]
  coef_p_value <- model_coef[2, 4]

  direction <- ifelse(coef_value > 0, "increases", "decreases")
  p_value_text <- ifelse(coef_p_value < 0.001, paste("<", 0.001), sprintf("%.3f", coef_p_value))
  impact_determination <- ifelse(coef_p_value < alpha, "significant", "not significant")
  hypothesis_decision <- ifelse(coef_p_value < alpha, "is rejected", "is not rejected")

  interpretation_message <- paste("For every unit increase in the predictor", x, ", the variable", y, direction,
                                  "by", round(coef_value, 2), "units. This effect has a p-value of", p_value_text,
                                  "and, using a significance level of", alpha, ",", hypothesis_decision,
                                  "the null hypothesis and it indicates that the variable", x, "has a",
                                  impact_determination, "impact on predicting", y, ".")

  # Combine the messages
  final_message <- paste(interpretation_message, hetero_message,
                         "Remember that this function interprets the model result as it has been presented.")

  return(final_message)
}
