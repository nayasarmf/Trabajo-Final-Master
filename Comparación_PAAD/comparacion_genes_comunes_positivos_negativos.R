rm(list=ls())
setwd("~/MASTER/TESIS/comparacion_PAAD")

# Cargar las bibliotecas necesarias
library(dplyr)

# Función principal
comparar_genes <- function(archivo1, archivo2, output_file) {
  # Leer los archivos CSV
  data1 <- read.csv(archivo1, stringsAsFactors = FALSE)
  data2 <- read.csv(archivo2, stringsAsFactors = FALSE)
  
  # Filtrar los genes comunes
  genes_comunes <- intersect(data1$Genes_Comunes, data2$Genes_Comunes)
  
  # Crear un nuevo data frame con los genes comunes
  resultado <- data.frame(Genes_Comunes = genes_comunes)
  
  # Guardar el resultado en un archivo CSV
  write.csv(resultado, output_file, row.names = FALSE)
  
  cat("Archivo generado exitosamente en:", output_file, "\n")
}

# Reemplazar con las rutas reales de los archivos
archivo1 <- "genes_comunes_positivos_PAAD.csv"
archivo2 <- "genes_comunes_negativos_PAAD.csv"
output_file <- "genes_comunes_positivos_negativos_PAAD.csv"

comparar_genes(archivo1, archivo2, output_file)
