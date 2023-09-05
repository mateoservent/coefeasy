#' Interpretation of Coefficients for Linear Regression Models
#'
#' This function provides an easy interpretation of coefficients from linear regression models,
#' considering potential heteroskedasticity.
#'
#' @param modelo An object of class `lm` representing the linear regression model.
#' @param x A character string specifying the predictor variable. If not specified, it tries to determine it from the model.
#' @param y A character string specifying the response variable. If not specified, it tries to determine it from the model.
#' @param alfa A numeric value for the significance level. Default is 0.05.
#'
#' @return A character string with the interpretation of the model coefficient,
#' potential heteroskedasticity in the residuals, and the corresponding correction of standard errors.
#'
#' @importFrom lmtest bptest coeftest
#'
#' @export
Coeffeasy_lm <- function(modelo, x = NULL, y = NULL, alfa = 0.05) {
  # Get the names of the model variables if they are not specified
  if (is.null(x) || is.null(y)) {
    variables <- as.character(attr(terms(modelo), "variables"))
    y_default <- variables[2]
    x_default <- variables[length(variables)]
  }

  if (is.null(x)) {
    x <- x_default
  }

  if (is.null(y)) {
    y <- y_default
  }

  # Evaluate homoscedasticity
  bptest_result <- lmtest::bptest(modelo)
  corrected <- FALSE

  if (bptest_result$p.value < 0.05) {
    # There's evidence of heteroskedasticity, correct standard errors
    modelo_coef <- lmtest::coeftest(modelo, vcov = vcovHC(modelo, type = "HC2"))
    corrected <- TRUE
  } else {
    # No evidence of heteroskedasticity, use regular standard errors
    modelo_coef <- summary(modelo)
  }

  coef_valor <- stats::coef(modelo)[2]
  coef_p_valor <- modelo_coef$coefficients[2, 4]
  if (coef_value > 0) {
    direction <- "increases"
  } else {
    direction <- "decreases"
  }

  confidence_level <- (1 - coef_p_value) * 100

  if (coef_p_value < 0.01) {
    significance <- paste("highly significant (p <", 0.01, ")")
    hypothesis <- "null hypothesis is rejected"
  } else if (coef_p_value < 0.05) {
    significance <- paste("significant (p <", 0.05, ")")
    hypothesis <- "null hypothesis is rejected"
  } else {
    significance <- paste("not significant (p =", round(coef_p_value, 3), ")")
    hypothesis <- "null hypothesis is not rejected"
  }

  change <- paste("For every unit increase in", x,
                  ", the variable", y, direction, "by", round(coef_value, 2), "units.")

  if(coef_p_value >= 0.05) {
    alert <- paste("Alert, the coefficient for", x,
                   "is not statistically significant with a p-value of", round(coef_p_value, 3), ".")
    change <- paste(alert, change)
  }

  coef_value <- stats::coef(model)[2]
  coef_p_value <- summary(model)$coefficients[2, 4]

  p_value_text <- ifelse(coef_p_value < 0.001, paste("<", 0.001), sprintf("%.3f", coef_p_value))

  if (coef_value > 0) {
    direction <- "increases"
  } else {
    direction <- "decreases"
  }

  impact_determination <- ifelse(coef_p_value < alpha, "significant", "not significant")
  hypothesis_decision <- ifelse(coef_p_value < alpha, "is rejected", "is not rejected")

  change <- paste("For every unit increase in the predictor", x, ", the variable", y, direction, "by", round(coef_value, 2), "units.")

  interpretation_message <- paste(change,
                                  "This effect has a p-value of", p_value_text, "and, using a significance level of", alpha, ",",
                                  hypothesis_decision, "the null hypothesis and it indicates that the variable", x,
                                  "has a", impact_determination, "impact on predicting", y, ".")

  mensaje_hetero <- NULL

  if (coef_p_valor < alfa) {
    # Solo revisar y reportar heterocedasticidad si el modelo es significativo.
    bptest_result <- lmtest::bptest(modelo)
    corregido <- FALSE

    if (bptest_result$p.value < 0.05) {
      # Hay evidencia de heterocedasticidad, corregir errores estandar
      modelo <- lmtest::coeftest(modelo, vcov = vcovHC(modelo, type = "HC2"))
      corregido <- TRUE
      mensaje_hetero <- "Se detecto heterocedasticidad en los residuos y se corrigieron los errores estandar."
    } else {
      mensaje_hetero <- "No se detecto heterocedasticidad en los residuos."
    }
  }

  # Combinar los mensajes si el mensaje_hetero existe
  if (!is.null(mensaje_hetero)) {
    mensaje_final <- paste(mensaje_interpretacion, mensaje_hetero,
                           "Recuerde que esta funcion interpreta el resultado del modelo tal como ha sido presentado.")
  } else {
    mensaje_final <- paste(mensaje_interpretacion,
                           "Recuerde que esta funcion interpreta el resultado del modelo tal como ha sido presentado.")
  }

  return(mensaje_final)
}
