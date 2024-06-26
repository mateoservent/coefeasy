#' Interpretation of Coefficients for Linear Regression Models
#'
#' This function provides an easy interpretation of coefficients from linear regression models.
#' It also checks for potential heteroskedasticity and uses, by default, the HC2 correction to
#' the standard errors if it is detected. Additionally, it allows for multilingual output by leveraging the
#' `polyglotr` package to translate the interpretation message.
#'
#' @param model An object of class `lm` representing the linear regression model.
#' @param x A character string specifying the name of the predictor variable.
#' @param y A character string specifying the response variable.
#' @param alpha A numeric value for the significance level. Default is 0.05.
#' @param error A character string specifying the type of heteroskedasticity consistent standard errors. Default is "HC2".
#' @param cluster A value to specify the clustering variable. Default is NULL.
#' @param short A logical flag indicating if the output message should be shorter and more concise. Default is TRUE.
#' @param language A character string indicating the desired output language. Default is "en" (English). Uses Google Translate via the `polyglotr` package.
#'
#' @importFrom lmtest bptest coeftest
#' @importFrom polyglotr google_translate
#' @import sandwich
#' @export

coefeasy_lm <- function(model, x = NULL, y = NULL, alpha = 0.05, error = "HC2", cluster = NULL, short = T, language = "en") {

  # Extract variable names from the model formula
  variables <- all.vars(model$call$formula)
  y_default <- variables[1] # This is the dependent variable
  x_default <- variables[2] # This is the first independent variable by default

  # Check if x is provided. If not, use the default x
  if (is.null(x)) {
    x <- x_default
  }

  # Check if y is provided. If not, use the default y
  if (is.null(y)) {
    y <- y_default
  }

  # Check for heteroskedasticity
  bptest_result <- lmtest::bptest(model)
  hetero_message <- "No heteroscedasticity was detected in the residuals using the Breusch-Pagan Test."

  if (bptest_result$p.value < alpha) {
    # Heteroskedasticity detected, correct standard errors
    if (!is.null(cluster)) {
      # Apply cluster robust standard errors if cluster is provided
      vcov_matrix <- sandwich::vcovCL(model, cluster = cluster, type = error)
      hetero_message <- paste("Heteroscedasticity was detected in the residuals and standard errors were corrected with", error, "formula using the following cluster variable", all.vars(cluster), ".")
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
  hypothesis_decision <- ifelse(coef_p_value < alpha, "reject", "not reject")

  if (short) {
    interpretation_message <- paste("The fitted model suggests that for every one-unit increase in the predictor", x, ", the average value of", y, "is expected to", direction, "by", round(coef_value, 2), "units, holding all other variables constant. The test of the hypothesis that the regression coefficient on", x, "is zero receives a p-value of", p_value_text, "and, using a significance level of", alpha, ", encourages the researcher to", hypothesis_decision, "this null hypothesis.")
  } else {
    interpretation_message <- paste("The model fit implies that, for two observations differing by 1 unit in the predictor", x, ", the average of the variable", y, direction,
                                    "differs by", round(coef_value, 2), "units after removing the additive and linear relationships between", x," and all other variables and after removing the linear and additive relationship between", y, "and all of the other variables. The test of the hypothesis that the regression coefficient on", x, "is zero receives a p-value of", p_value_text,
                                    "and, using a significance level of", alpha, ", encourages the researcher to", hypothesis_decision, "this null hypothesis.")
  }

  # Combine the messages
  final_message <- paste(interpretation_message, hetero_message)


  # Translate the message if language is not "en"
  if (language != "en") {
    final_message_translated <- polyglotr::google_translate(final_message, target_language = language, source_language = "en")
    return(final_message_translated)
  } else {
    return(final_message)
  }

}
