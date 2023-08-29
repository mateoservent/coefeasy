# Función para graficar coeficientes e intervalo de confianza 
plot_coeficiente_intervalo <- function(modelo1, modelo2, coef_name) {
  library(ggplot2)
  # Para el primer modelo
  coeficiente1 <- coef(modelo1)
  intervalo1 <- confint(modelo1)
  data.ci1 <- data.frame(modelo = "Modelo 1",
                         coeficiente = names(coeficiente1),
                         valor = coeficiente1,
                         lower = intervalo1[, 1],
                         upper = intervalo1[, 2])
  
  # Para el segundo modelo
  coeficiente2 <- coef(modelo2)
  intervalo2 <- confint(modelo2)
  data.ci2 <- data.frame(modelo = "Modelo 2",
                         coeficiente = names(coeficiente2),
                         valor = coeficiente2,
                         lower = intervalo2[, 1],
                         upper = intervalo2[, 2])
  
  # Combinar  dataframes
  data.ci <- rbind(data.ci1, data.ci2)
  
  # Filtrar por el coeficiente de interés
  data.subset <- subset(data.ci, coeficiente == coef_name)
  
  p <- ggplot(data.subset, aes(x = modelo, y = valor, color = modelo)) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "gray15") +
    geom_pointrange(aes(ymin = lower, ymax = upper)) +
    coord_flip() +
    labs(x = "", y = "", title = paste("Comparación de Coeficientes e Intervalos de Confianza para", coef_name)) +
    scale_color_manual(values = c("royalblue3", "firebrick3"))
  
  print(p)
}




