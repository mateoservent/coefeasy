interpretar_coeficiente <- function(modelo, x_nombre_completo, y_nombre_completo) {

  # Cargar las librerías necesarias
  if (!requireNamespace("car", quietly = TRUE)) {
    install.packages("car")
  }
  library(car)

  if (!requireNamespace("sandwich", quietly = TRUE)) {
    install.packages("sandwich")
  }
  library(sandwich)

  if (!requireNamespace("lmtest", quietly = TRUE)) {
    install.packages("lmtest")
  }
  library(lmtest)


  # Evaluar homocedasticidad
  bptest_result <- bptest(modelo)
  corregido <- FALSE

  if (bptest_result$p.value < 0.05) {
    # Hay evidencia de heterocedasticidad, corregir errores estándar
    modelo_coef <- coeftest(modelo, vcov = vcovHC(modelo, type = "HC2"))
    corregido <- TRUE
  } else {
    # No hay evidencia de heterocedasticidad, usar errores estándar regulares
    modelo_coef <- summary(modelo)
  }

  coef_valor <- coef(modelo)[2]
  coef_p_valor <- modelo_coef$coefficients[2, 4]

  if (coef_valor > 0) {
    direccion <- "un aumento"
  } else {
    direccion <- "una disminución"
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

  cambio <- paste("Por cada incremento unitario en", x_nombre_completo,
                  ", la", y_nombre_completo, "cambia en", round(coef_valor, 2), "unidades.")

  if(coef_p_valor >= 0.05) {
    alerta <- paste("¡Alerta! El coeficiente para", x_nombre_completo,
                    "no es estadísticamente significativo con un valor p de", round(coef_p_valor, 3), ".")
    cambio <- paste(alerta, cambio)
  }

  mensaje_interpretacion <- paste(cambio,
                                  "Con un nivel de confianza del", round(nivel_confianza, 2), "%,",
                                  "este efecto es", significatividad, "y", hipotesis, ".",
                                  "Esto sugiere que, con un nivel de significatividad de 0.05,",
                                  "la variable", x_nombre_completo, "es", significatividad,
                                  "en la predicción de", y_nombre_completo, ".")

  # Información sobre heterocedasticidad
  if (corregido) {
    mensaje_hetero <- "Se detectó heterocedasticidad en los residuos y se corrigieron los errores estándar."
  } else {
    mensaje_hetero <- "No se detectó heterocedasticidad en los residuos."
  }

  # Combinar los mensajes
  mensaje_final <- paste(mensaje_interpretacion, mensaje_hetero,
                         "Recuerde que esta función interpreta el resultado del modelo tal como ha sido presentado.")

  return(mensaje_final)
}



