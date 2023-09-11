#' Easily interpret the coefficients of a logistic model.
#'
#' This function takes a logistic model and returns a simplified interpretation
#' of the coefficients, focusing especially on the change in probability
#' associated with a unit change in the predictor variable.
#'
#' @param modelo A glm object with binomial family (logistic model).
#' @param x Name of the predictor variable of interest (character). If NULL, the function will try to identify it automatically.
#' @param y Name of the response variable (character). If NULL, the function will try to identify it automatically.
#' @param alpha Significance level for hypothesis testing. The default value is 0.05.
#'
#' @return A text string with the interpretation of the logistic model's coefficients.
#'
#' @export
Coeffeasy_logit <- function(modelo, x = NULL, y = NULL, alpha = 0.05) {
  # Get the names of the model variables if they are not specified
  if (is.null(x) || is.null(y)) {
    variables <- as.character(attr(terms(modelo), "variables"))
    y_default <- variables[2]
    x_default <- tail(variables, n=1)
  }

  if (is.null(x)) {
    x <- x_default
  }

  if (is.null(y)) {
    y <- y_default
  }

  coef_value <- stats::coef(modelo)[2]
  coef_p_value <- summary(modelo)$coefficients[2, 4]

  # Convert log-odds to probabilities
  probability <- exp(coef_value) / (1 + exp(coef_value))

  if (coef_value > 0) {
    direction <- "increases"
  } else {
    direction <- "decreases"
  }

  p_value_text <- ifelse(coef_p_value < 0.001, paste("<", 0.001), sprintf("%.3f", coef_p_value))

  significance_impact <- ifelse(coef_p_value < alpha, "significant", "not significant")
  hypothesis_decision <- ifelse(coef_p_value < alpha, "is rejected", "is not rejected")

  change <- paste("If", x, "increases by one unit, the probability of", y, direction, "by", round(probability * 100, 2), "percentage points.")


  interpretation_message <- paste(change,
                                  "This effect has a p-value of", p_value_text, "and, using a significance level of", alpha, ",",
                                  "the null hypothesis", hypothesis_decision, ". This suggests that", x,
                                  "significantly affects the chances of", y, ".",
                                  "Remember that this function interprets the model's result as it has been presented.")

  return(interpretation_message)
}
