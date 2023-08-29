interpretar_coeficiente <- function(modelo) {

  # Obtenemos los coeficientes y sus estadísticas
  summary_modelo <- summary(modelo)

  # Tomamos el primer coeficiente (excluyendo el intercepto)
  coef_nombre <- names(coef(modelo))[2]
  coef_valor <- coef(modelo)[2]
  coef_p_valor <- summary_modelo$coefficients[2, 4]

  # Obtener el nombre de la variable dependiente
  dep_variable <- as.character(formula(modelo)[2])

  # Interpretar el signo del coeficiente
  if (coef_valor > 0) {
    direccion <- "un aumento"
  } else {
    direccion <- "una disminución"
  }

  # Interpretar la significatividad y el nivel de confianza
  nivel_confianza <- (1 - coef_p_valor) * 100

  if (coef_p_valor < 0.01) {
    significatividad <- paste("altamente significativo (p <", 0.01, ")")
    hipotesis <- "se rechaza la hipótesis nula, indicando que hay evidencia suficiente para decir que la variable tiene un efecto sobre la respuesta"
  } else if (coef_p_valor < 0.05) {
    significatividad <- paste("significativo (p <", 0.05, ")")
    hipotesis <- "se rechaza la hipótesis nula, sugiriendo que es probable que la variable tenga un impacto en la respuesta"
  } else {
    significatividad <- paste("no es significativo (p =", round(coef_p_valor, 3), ")")
    hipotesis <- "no se rechaza la hipótesis nula, lo que significa que no hay evidencia suficiente para afirmar que la variable tiene un efecto sobre la respuesta"
  }

  # Calcula la proporción de cambio
  cambio <- paste("Por cada incremento unitario en", coef_nombre,
                  "la", dep_variable, "cambia en", round(coef_valor, 2), "unidades.")

  # Alerta en caso de que la significatividad no sea menor a 0.05
  if(coef_p_valor >= 0.05) {
    alerta <- paste("¡Alerta! El coeficiente para", coef_nombre,
                    "no es estadísticamente significativo con un valor p de", round(coef_p_valor, 3), ".")
    cambio <- paste(alerta, cambio)
  }

  # Componer el mensaje en lenguaje natural
  mensaje <- paste(cambio,
                   "Con un nivel de confianza del", round(nivel_confianza, 2), "%,",
                   "este efecto es", significatividad, "y", hipotesis, ".",
                   "Recuerde que esta función interpreta el resultado del modelo tal como ha sido presentado.")

  return(mensaje)
}

# Ejemplo de uso:
modelo <- lm(mpg ~ wt, data = mtcars)

modelo1 <- lm(qsec ~ gear, data = mtcars)

interpretar_coeficiente(modelo1)
