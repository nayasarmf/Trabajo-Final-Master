rm(list=ls())
setwd("~/MASTER/TESIS/codigo_LUAD")

# Cargar librerías necesarias
library(dplyr)
library(rentrez) # Librería para interactuar con la base de datos de NCBI

# Paso 1: Leer el archivo CSV
archivo <- "datos_LUAD_CBP_csv.csv"
datos <- read.csv(archivo, header = TRUE)

# Paso 2: Eliminar filas con valores NA o nulos
datos_limpios <- na.omit(datos)

# Paso 3: Identificar genes con valores positivos (>0) en más de la mitad de las columnas y al menos un valor >= 1
# Filtrar valores mayores a 0
num_columnas <- ncol(datos_limpios) - 1  # Excluir la columna de IDs
umbral <- floor(0.5 * num_columnas)     # Definir umbral de más de la mitad de las columnas

# Aplicar condiciones por fila
genes_seleccionados <- datos_limpios %>%
  rowwise() %>%
  filter(sum(c_across(-1) < 0) > umbral & any(c_across(-1) <= -2)) %>% # Bottom genes
  ungroup()

# Renombrar columnas: la primera columna como "GeneID" y las demás como "Var1", "Var2", etc.
colnames(genes_seleccionados) <- c("GeneID", paste0("Var", 1:(ncol(genes_seleccionados) - 1)))

# Paso 4: Mostrar la lista de genes seleccionados con sus IDs
print("Genes seleccionados (más de la mitad de las columnas con valores >0 y al menos un valor >=1):")
print(genes_seleccionados$GeneID)  # Mostrar solo los IDs de los genes

# Guardar los resultados en un archivo
genes_csv <- data.frame(GeneID = genes_seleccionados$GeneID)
write.csv(genes_csv, "genes_seleccionados_negativos_LUAD_CBP.csv", row.names = FALSE)

# Paso 5: Leer el archivo creado y buscar nombres de genes en NCBI
archivo_genes <- "genes_seleccionados_negativos_LUAD_CBP.csv"
genes_ids <- read.csv(archivo_genes)$GeneID

# Función para buscar el nombre de un gen en NCBI
obtener_nombre_gen <- function(gene_id) {
  resultado <- entrez_summary(db = "gene", id = gene_id)
  return(resultado$name)
}

# Obtener los nombres de los genes utilizando la API de NCBI
genes_nombres <- sapply(genes_ids, function(id) {
  tryCatch({
    obtener_nombre_gen(id)
  }, error = function(e) {
    NA  # Si hay un error, retornar NA
  })
})

# Crear un nuevo data frame con IDs y nombres de los genes
resultado_final <- data.frame(GeneID = genes_ids, GeneName = genes_nombres)

# Guardar los resultados en un nuevo archivo CSV
write.csv(resultado_final, "genes_seleccionados_negativos_LUAD_CBP_nombres.csv", row.names = FALSE)

print("Proceso completado. Archivo 'genes_seleccionados_negativos_LUAD_CBP_nombres.csv' creado.")
