rm(list=ls())
setwd("~/MASTER/TESIS/comparacion_STAD")

# Cargar las bibliotecas necesarias
library(dplyr)

# Función principal
comparar_genes <- function(archivo1, archivo2, output_file) {
  # Leer los archivos CSV
  data1 <- read.csv(archivo1, stringsAsFactors = FALSE)
  data2 <- read.csv(archivo2, stringsAsFactors = FALSE)
  
  # Asegurarse de que las columnas GeneID y Gene_Symbol existan
  if (!"GeneName" %in% colnames(data1)) {
    stop("El archivo 1 no contiene la columna 'GeneName'")
  }
  if (!"Gene_Symbol" %in% colnames(data2)) {
    stop("El archivo 2 no contiene la columna 'Gene_Symbol'")
  }
  
  # Filtrar los genes comunes
  genes_comunes <- intersect(data1$GeneName, data2$Gene_Symbol)
  
  # Crear un nuevo data frame con los genes comunes
  resultado <- data.frame(Genes_Comunes = genes_comunes)
  
  # Guardar el resultado en un archivo CSV
  write.csv(resultado, output_file, row.names = FALSE)
  
  cat("Archivo generado exitosamente en:", output_file, "\n")
}

# Reemplazar con las rutas reales de los archivos
archivo1 <- "genes_seleccionados_positivos_STAD_CBP_nombres.csv"
archivo2 <- "datos_STAD_GEPIA_overexpressed_csv.csv"
output_file <- "genes_comunes_positivos_STAD.csv"

comparar_genes(archivo1, archivo2, output_file)
