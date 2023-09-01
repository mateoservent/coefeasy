Coeffeasy_lm <- function(modelo, x = NULL, y = NULL, alfa = 0.05) {


  # Obtener los nombres de las variables del modelo si no son especificados
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

  # Evaluar homocedasticidad
  bptest_result <- lmtest::bptest(modelo)
  corregido <- FALSE

  if (bptest_result$p.value < 0.05) {
    # Hay evidencia de heterocedasticidad, corregir errores estándar
    modelo_coef <- lmtest::coeftest(modelo, vcov = vcovHC(modelo, type = "HC2"))
    corregido <- TRUE
  } else {
    # No hay evidencia de heterocedasticidad, usar errores estándar regulares
    modelo_coef <- summary(modelo)
  }

  coef_valor <- stats::coef(modelo)[2]
  coef_p_valor <- modelo_coef$coefficients[2, 4]

  if (coef_valor > 0) {
    direccion <- "aumenta"
  } else {
    direccion <- "disminuye"
  }

  nivel_confianza <- (1 - coef_p_valor) * 100

  if (coef_p_valor < 0.01) {
    significatividad <- paste("altamente significativo (p <", 0.01, ")")
    hipotesis <- "se rechaza la hipótesis nula"
  } else if (coef_p_valor < 0.05) {
    significatividad <- paste("significativo (p <", 0.05, ")")
    hipotesis <- "se rechaza la hipótesis nula"
  } else {
    significatividad <- paste("no es significativo (p =", round(coef_p_valor, 3), ")")
    hipotesis <- "no se rechaza la hipótesis nula"
  }

  cambio <- paste("Por cada incremento unitario en", x,
                  ", la variable", y, direccion, "en", round(coef_valor, 2), "unidades.")

  if(coef_p_valor >= 0.05) {
    alerta <- paste("¡Alerta! El coeficiente para", x,
                    "no es estadísticamente significativo con un valor p de", round(coef_p_valor, 3), ".")
    cambio <- paste(alerta, cambio)
  }

  coef_valor <- stats::coef(modelo)[2]
  coef_p_valor <- summary(modelo)$coefficients[2, 4]

  p_valor_texto <- ifelse(coef_p_valor < 0.001, paste("<", 0.001), sprintf("%.3f", coef_p_valor))

  if (coef_valor > 0) {
    direccion <- "aumenta"
  } else {
    direccion <- "disminuye"
  }

  determinacion_impacto <- ifelse(coef_p_valor < alfa, "significativo", "no significativo")
  decision_hipotesis <- ifelse(coef_p_valor < alfa, "se rechaza", "no se rechaza")

  cambio <- paste("Por cada incremento unitario en el predictor", x, ", la variable", y, direccion, "en", round(coef_valor, 2), "unidades.")

  mensaje_interpretacion <- paste(cambio,
                                  "Este efecto tiene un p-valor de", p_valor_texto, "y, al usar un nivel de significatividad de", alfa, ",",
                                  decision_hipotesis, "la hipótesis nula y se indica que la variable", x,
                                  "tiene un impacto", determinacion_impacto, "en la predicción de", y, ".")

  mensaje_hetero <- NULL

  if (coef_p_valor < alfa) {
    # Solo revisar y reportar heterocedasticidad si el modelo es significativo.
    bptest_result <- lmtest::bptest(modelo)
    corregido <- FALSE

    if (bptest_result$p.value < 0.05) {
      # Hay evidencia de heterocedasticidad, corregir errores estándar
      modelo <- lmtest::coeftest(modelo, vcov = vcovHC(modelo, type = "HC2"))
      corregido <- TRUE
      mensaje_hetero <- "Se detectó heterocedasticidad en los residuos y se corrigieron los errores estándar."
    } else {
      mensaje_hetero <- "No se detectó heterocedasticidad en los residuos."
    }
  }

  # Combinar los mensajes si el mensaje_hetero existe
  if (!is.null(mensaje_hetero)) {
    mensaje_final <- paste(mensaje_interpretacion, mensaje_hetero,
                           "Recuerde que esta función interpreta el resultado del modelo tal como ha sido presentado.")
  } else {
    mensaje_final <- paste(mensaje_interpretacion,
                           "Recuerde que esta función interpreta el resultado del modelo tal como ha sido presentado.")
  }

  return(mensaje_final)
}
