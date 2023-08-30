Coeffeasy_logit <- function(modelo, x = NULL, y = NULL, alfa = 0.05) {

  # Obtener los nombres de las variables del modelo si no son especificados
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

  coef_valor <- coef(modelo)[2]
  coef_p_valor <- summary(modelo)$coefficients[2, 4]

  # Transformar log-odds a probabilidades
  probabilidad <- exp(coef_valor) / (1 + exp(coef_valor))

  if (coef_valor > 0) {
    direccion <- "aumenta"
  } else {
    direccion <- "disminuye"
  }

  p_valor_texto <- ifelse(coef_p_valor < 0.001, paste("<", 0.001), sprintf("%.3f", coef_p_valor))

  determinacion_impacto <- ifelse(coef_p_valor < alfa, "significativo", "no significativo")
  decision_hipotesis <- ifelse(coef_p_valor < alfa, "se rechaza", "no se rechaza")

  cambio <- paste("Si", x, "sube en una unidad, la probabilidad de", y, direccion, "en", round(probabilidad * 100, 2), "puntos porcentuales.")

  lectura_accesible <- paste("si", x, "aumenta, es más probable que", y, "ocurra.")

  mensaje_interpretacion <- paste(cambio, "Esto significa que", lectura_accesible,
                                  "Este efecto tiene un p-valor de", p_valor_texto, "y, al usar un nivel de significatividad de", alfa, ",",
                                  decision_hipotesis, "la hipótesis nula. Esto sugiere que", x,
                                  "impacta significativamente en las posibilidades de", y, ".",
                                  "Recuerde que esta función interpreta el resultado del modelo tal como ha sido presentado.")

  return(mensaje_interpretacion)
}
