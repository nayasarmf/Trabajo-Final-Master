rm(list=ls())
setwd("~/MASTER/TESIS/DiagramaVenn_LUAD")

# Cargar las librerías necesarias
library(ggVennDiagram)
library(ggplot2) # Asegurarse de cargar ggplot2 para funciones de escalado

# Función para generar el diagrama de Venn 3D
generar_diagrama_venn <- function(archivo1, archivo2, columna1, columna2, output_file) {
  # Leer los archivos CSV
  datos1 <- read.csv(archivo1, stringsAsFactors = FALSE)
  datos2 <- read.csv(archivo2, stringsAsFactors = FALSE)
  
  # Extraer las columnas de interés
  lista1 <- unique(datos1[[columna1]])
  lista2 <- unique(datos2[[columna2]])
  
  # Crear un data frame para ggVennDiagram
  listas <- list(
    cBioPortal = lista1,
    GEPIA = lista2
  )
  
  # Crear el diagrama de Venn en 3D
  p <- ggVennDiagram(listas, label = "count", label_alpha = 0, edge_size = 0.5) +
    scale_fill_gradient(low = "#E41A1C", high = "#377EB8") +
    theme_minimal() +
    labs(title = "Diagrama de Venn Genes LUAD sobreexpresados")
  
  # Guardar el gráfico
  ggsave(output_file, plot = p, width = 12, height = 12, dpi = 300)
  
  cat("Diagrama de Venn guardado en:", output_file, "\n")
}

# Reemplazar los nombres de los archivos y las columnas
archivo1 <- "genes_seleccionados_positivos_LUAD_CBP_nombres.csv"   # Cambiar por la ruta de tu primer archivo CSV
archivo2 <- "datos_LUAD_GEPIA_overexpressed_csv.csv"   # Cambiar por la ruta de tu segundo archivo CSV
columna1 <- "GeneName"       # Cambiar por el nombre de la columna del primer archivo
columna2 <- "Gene_Symbol"    # Cambiar por el nombre de la columna del segundo archivo
output_file <- "diagrama_venn_LUAD_sobreexpresado.png" # Nombre del archivo de salida

# Llamar a la función
generar_diagrama_venn(archivo1, archivo2, columna1, columna2, output_file)