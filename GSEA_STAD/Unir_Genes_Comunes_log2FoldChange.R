rm(list=ls())
setwd("~/MASTER/TESIS/GSEA_STAD")

# Cargar las librerías necesarias
library(dplyr)

# Función principal
procesar_archivos <- function(archivo1, archivo2, archivo_salida) {
  # Leer los archivos CSV
  df1 <- read.csv(archivo1, stringsAsFactors = FALSE)
  df2 <- read.csv(archivo2, stringsAsFactors = FALSE)
  
  # Verificar que las columnas necesarias existan en ambos archivos
  if (!"Genes_Comunes" %in% colnames(df1)) {
    stop("El archivo 1 no tiene una columna llamada 'Genes_Comunes'.")
  }
  if (!"Gene_Symbol" %in% colnames(df2) || !"Log2_FoldChange" %in% colnames(df2)) {
    stop("El archivo 2 debe contener las columnas 'Gene_Symbol' y 'Log2_FoldChange'.")
  }
  
  # Realizar la comparación y añadir la columna Log2_FoldChange
  resultado <- df1 %>%
    left_join(df2, by = c("Genes_Comunes" = "Gene_Symbol")) %>%
    rename(Puntaje = Log2_FoldChange)
  
  # Guardar el resultado en un archivo de salida
  write.csv(resultado, archivo_salida, row.names = FALSE)
  
  return("Archivo procesado y guardado exitosamente.")
}

#LLamar la función
archivo1 <- "genes_comunes_negativos_STAD.csv"
archivo2 <- "datos_STAD_GEPIA_underexpressed_csv.csv"
archivo_salida <- "genes_comunes_negativos_STAD_log2FoldChange.csv"

procesar_archivos(archivo1, archivo2, archivo_salida)
