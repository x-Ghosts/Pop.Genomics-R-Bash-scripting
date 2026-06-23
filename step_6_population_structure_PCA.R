library(BITEV2)
library(tidyverse)
library(ggplot2)
library(ggrepel)
options(scipen = 999)

# Principle Component Analysis - Population Structure

current_dir <- getwd() # DIR must be ".../data_analysis" as current.

pca_path <- file.path(current_dir,"pca")
dir.create(pca_path)
output_pca_file <- file.path(pca_path,"pca")
plink_data <- "target_dataset_capre"

num_of_individuals <- nrow(read.table(paste0(plink_data,".fam"), header = F, sep = " ", stringsAsFactors = F))

sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --pca %s --out %s", shQuote(plink_data), shQuote(num_of_individuals), shQuote(output_pca_file))
system(sys_cmd)

# Variance Computation, and Plot generation:

pc1 <- 1
pc2 <- 3
num_pc <- 20

eigenval_file <- file.path(paste0(output_pca_file,".eigenval"))
eigenvec_file <- file.path(paste0(output_pca_file,".eigenvec"))
plot_output_folder <- file.path(current_dir, "plots")
plot_var_file <- file.path(plot_output_folder, "variance.png")

pc_val <- read.table(eigenval_file, header = FALSE, stringsAsFactors = FALSE)
pc_vec <- read.table(eigenvec_file, header = FALSE, stringsAsFactors = FALSE)


total_var <- sum(pc_val$V1) # Explained variance
var_percent <- pc_val$V1 / total_var * 100

png(plot_var_file, width = 2400, height = 1200, res = 300)
par( mfrow = c(1,1), cex.main = 1.2, cex.lab = 1.0, cex.axis = 0.9, mar = c(5,5,3,1))
barplot(
  var_percent[1:num_pc],
  names.arg = paste0("PC", 1:num_pc),
  col = "steelblue",
  las = 2,
  xlab = "Principal Component",
  ylab = "Variance Explained (%)",
  main = "Variance Explained by top 20 Components"
)
dev.off()

pc_df <- data.frame(
  FID = pc_vec$V1,
  IID = pc_vec$V2,
  PC1 = pc_vec[, pc1 + 2],
  PC2 = pc_vec[, pc2 + 2],
  stringsAsFactors = FALSE
)

centroids <- pc_df %>%
  group_by(FID) %>%
  summarise(
    PC1 = mean(PC1, na.rm = TRUE),
    PC2 = mean(PC2, na.rm = TRUE),
    .groups = "drop"
  )

p <- ggplot(pc_df, aes(x = PC1, y = PC2, color = FID)) +
  geom_point(size = 2, alpha = 0.9) +
  geom_label_repel(
    data = centroids,
    aes(x = PC1, y = PC2, label = FID, color = FID),
    fill = "white",
    fontface = "bold",
    size = 4,
    box.padding = 0.35,
    point.padding = 0.2,
    label.padding = 0.20,
    label.size = 0.35,
    max.overlaps = Inf,
    show.legend = FALSE
  ) +
  labs(
    title = "PCA of Mediterranean Goats:",
    x = paste0("PC", pc1, " (", round(var_percent[pc1], 2), "%)"),
    y = paste0("PC", pc2, " (", round(var_percent[pc2], 2), "%)")
  ) +
  theme_minimal(base_size = 14)

print(p)
path_PCA <- file.path(paste0(plot_output_folder,"/PCA_",pc1,"_",pc2,".png"))
ggsave(path_PCA, plot = p, width = 16, height = 8, dpi = 300)

#################################################################################################################
#################################################################################################################
#################################################################################################################
#################################################################################################################

# Population Structure based on Continental Split:

african_codes <- c("ALG","BAR","BRK","DRA","GHA","MOR","NBN","NDA","NOR","OSS","SID","TUN","CAM","DJA",
                   "GUE","MAU","NAI","PEU","RSK","SAH","SDN","SHL","TAR","WAD")
european_codes <- c("BEY", "CRS", "FSS", "MLG", "PAL", "PTV", "PVC", "PYR","RAS", "SP_MGRANA", "ARG", "ASP",
                    "BIA", "BIO", "CAP", "DDS", "FAC", "FUL","GAR","GCI", "GIR","IT_GARFAG","JON","LIV","MAL",
                    "MES", "MLS", "MLT", "MON", "NIC", "NVE", "ORO", "RCC", "RME", "SAR", "TER", "VAL", "VLS","VSS")


pc_df <- data.frame(
  FID = pc_vec$V1,
  IID = pc_vec$V2,
  PC1 = pc_vec[, pc1 + 2],
  PC2 = pc_vec[, pc2 + 2],
  stringsAsFactors = FALSE
)

pc_df$Component <- ifelse(
  pc_df$FID %in% african_codes,
  "AFRICA",
  "EUROPE"
)

centroids <- pc_df %>%
  group_by(FID, Component) %>%
  summarise(
    PC1 = mean(PC1, na.rm = TRUE),
    PC2 = mean(PC2, na.rm = TRUE),
    .groups = "drop"
  )

p <- ggplot(pc_df, aes(x = PC1, y = PC2, color = Component)) +
  geom_point(size = 2, alpha = 0.9) +
  geom_label_repel(
    data = centroids,
    aes(x = PC1, y = PC2, label = FID, color = Component),
    fill = "white",
    fontface = "bold",
    size = 4,
    box.padding = 0.35,
    point.padding = 0.2,
    label.padding = 0.20,
    label.size = 0.35,
    max.overlaps = Inf,
    show.legend = FALSE
  ) +
  scale_color_manual(
    values = c(
      "AFRICA" = "red",
      "EUROPE" = "blue"
    )
  ) +
  labs(
    title = "PCA of Mediterranean Goats:",
    x = paste0("PC", pc1, " (", round(var_percent[pc1], 2), "%)"),
    y = paste0("PC", pc2, " (", round(var_percent[pc2], 2), "%)"),
    color = "Continent component"
  ) +
  theme_minimal(base_size = 14)

print(p)

path_PCA_component <- file.path(paste0(plot_output_folder, "/comp_PCA_", pc1, "_", pc2, ".png"))
ggsave(path_PCA_component, plot = p, width = 16, height = 8, dpi = 300)
