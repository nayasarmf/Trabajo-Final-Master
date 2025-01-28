rm(list=ls())
setwd("~/MASTER/TESIS/codigo_LUAD")

# Cargar las librerías necesarias
library(dplyr)

# Función para procesar los archivos CSV
procesar_archivos <- function(archivo_geneid, archivo_hugo, archivo_salida) {
  # Leer los archivos CSV
  geneid_data <- read.csv(archivo_geneid, stringsAsFactors = FALSE)
  hugo_data <- read.csv(archivo_hugo, stringsAsFactors = FALSE)
  
  # Verificar que las columnas necesarias existen
  if (!("GeneID" %in% colnames(geneid_data))) {
    stop("El archivo GeneID no contiene la columna 'GeneID'.")
  }
  
  if (!("Hugo_Symbol" %in% colnames(hugo_data)) || !("Entrez_Gene_Id" %in% colnames(hugo_data))) {
    stop("El archivo Hugo no contiene las columnas 'Hugo_Symbol' o 'Entrez_Gene_ID'.")
  }
  
  # Filtrar los valores coincidentes
  resultado <- geneid_data %>%
    inner_join(hugo_data, by = c("GeneID" = "Entrez_Gene_Id")) %>%
    select(GeneID, GeneName = Hugo_Symbol)
  
  # Guardar el resultado en un archivo CSV
  write.csv(resultado, archivo_salida, row.names = FALSE)
  
  cat("Archivo guardado exitosamente en:", archivo_salida, "\n")
}


# Cambiar los nombres de archivo por los correspondientes en el sistema
archivo_geneid <- "genes_seleccionados_positivos_LUAD_CBP.csv"  # Archivo con la columna GeneID
archivo_hugo <- "datos_Hugo_Symbol_LUAD_CBP.csv"      # Archivo con las columnas Hugo_Symbol y Entrez_Gene_ID
archivo_salida <- "genes_seleccionados_positivos_LUAD_CBP_nombres.csv"       # Nombre del archivo de salida

# Llamar a la función
procesar_archivos(archivo_geneid, archivo_hugo, archivo_salida)