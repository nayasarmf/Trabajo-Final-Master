rm(list=ls())
setwd("~/MASTER/TESIS/GSEA_SKCM")

# Cargar las librerías necesarias
library(clusterProfiler)
library(org.Hs.eg.db)
library(enrichplot)
library(ggplot2)

# Cargar el archivo CSV con los genes comunes
file_path <- "genes_comunes_negativos_SKCM_log2FoldChange.csv"
genes_data <- read.csv(file_path, stringsAsFactors = FALSE)

# Validar que las columnas necesarias existan
if (!"Genes_Comunes" %in% colnames(genes_data) || !"Puntaje" %in% colnames(genes_data)) {
  stop("El archivo CSV debe contener las columnas 'Genes_Comunes' y 'Puntaje'.")
}

# Convertir los nombres de los genes al formato de Entrez ID
entrez_ids <- bitr(genes_data$Genes_Comunes, fromType = "SYMBOL", toType = "ENTREZID", OrgDb = org.Hs.eg.db)

# Combinar Entrez IDs con los puntajes
entrez_scores <- merge(entrez_ids, genes_data, by.x = "SYMBOL", by.y = "Genes_Comunes")

# Crear la lista ordenada de genes para GSEA
gene_list <- sort(setNames(entrez_scores$Puntaje, entrez_scores$ENTREZID), decreasing = TRUE)

# Verificar que la lista no esté vacía
if (length(gene_list) == 0) {
  stop("La lista de genes para el análisis está vacía. Verifica los datos de entrada.")
}

# Análisis de enriquecimiento GO
ego <- enrichGO(gene = entrez_ids$ENTREZID, 
                OrgDb = org.Hs.eg.db, 
                ont = "ALL", 
                pvalueCutoff = 0.05, 
                readable = TRUE)

# Visualización de resultados GO Enrichment
if (!is.null(ego) && nrow(as.data.frame(ego)) > 0) {
  dotplot(ego, showCategory = 20) + ggtitle("GO Enrichment Analysis SKCM Underexpressed Genes")
  ggsave("GO_Enrichment_Analysis_negativos_SKCM.png", width = 12, height = 12)
  write.csv(as.data.frame(ego), "GO_Enrichment_Results_negativos_SKCM.csv", row.names = FALSE)
} else {
  warning("No se encontraron términos enriquecidos en el análisis GO.")
}

# Análisis de enriquecimiento KEGG
kegg_enrichment <- enrichKEGG(gene = entrez_ids$ENTREZID, 
                              organism = "hsa", 
                              pvalueCutoff = 0.05)

# Visualización de resultados KEGG Enrichment
if (!is.null(kegg_enrichment) && nrow(as.data.frame(kegg_enrichment)) > 0) {
  dotplot(kegg_enrichment, showCategory = 20) + ggtitle("KEGG Pathway Enrichment SKCM Underexpressed Genes")
  ggsave("KEGG_Pathway_Enrichment_negativos_SKCM.png", width = 10, height = 9)
  write.csv(as.data.frame(kegg_enrichment), "KEGG_Enrichment_Results_negativos_SKCM.csv", row.names = FALSE)
} else {
  warning("No se encontraron rutas enriquecidas en el análisis KEGG.")
}

cat("Análisis completado. Los resultados relevantes han sido guardados como archivos CSV y las gráficas como PNG.\n")