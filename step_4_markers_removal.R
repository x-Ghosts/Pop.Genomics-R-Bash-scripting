library(dplyr)
library(tidyverse)

# setwd([1] ".../datasets_v2/data_analysis") -> PLINK files must be in this dir.

file_name_remove <- "markers_to_remove.txt"
plink_data <- "target_dataset_capre"

# Extracting from the whole merged dataset variant with missing information, such bp pos, Alleles, etc.
bim_file <- read.table("target_dataset_capre.bim", header = F, sep = "\t", stringsAsFactors = F)

no_bp <- bim_file %>%
  filter(V4 == 0)
no_chr <- bim_file %>%
  filter(V1 == 0)
no_allele_a1_a2 <- bim_file %>%
  filter(V5 == 0 & V6 == 0)
no_allele_a1 <- bim_file %>% 
  filter(V5 == 0)

homozyg_allele <- bim_file[bim_file$V5 == bim_file$V6, ] #in our case it retunrs the A1=0 & A2=0 which is the pure missing genotype
snps_to_remove <- unique(c(no_bp$V2,no_chr$V2,no_allele_a1_a2$V2,no_allele_a1$V2,homozyg_allele$V2))
write.table(snps_to_remove, file_name_remove, quote = F, row.names = F, col.names = F)


# System Command : PLINK filter
sys_cmd <- sprintf("plink --cow --allow-extra-chr --nonfounders --allow-no-sex --bfile %s --exclude %s --make-bed --out %s", shQuote(plink_data), shQuote(file_name_remove), shQuote(plink_data))
system(sys_cmd)
