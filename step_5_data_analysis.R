library(dplyr)
library(tidyverse)

plink_data <- "target_dataset_capre"


# Missingness Statistics and plots construction

current_dir <- getwd()
callrate_path <- file.path(current_dir,"callrate")
dir.create(callrate_path)
output_missingness_file <- file.path(callrate_path,"missingness")

sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --missing --out %s", shQuote(plink_data), shQuote(output_missingness_file))
system(sys_cmd)

locus_file <- file.path(paste0(output_missingness_file,".lmiss"))
individual_file <- file.path(paste0(output_missingness_file,".imiss"))

plot_output_folder <- file.path(current_dir, "plots")
dir.create(plot_output_folder, recursive = T)
plot_file <- file.path(plot_output_folder, "raw_geno_mind.png")

lmiss <-read.table(locus_file, header = TRUE, stringsAsFactors = FALSE)
imiss <-read.table(individual_file, header = TRUE, stringsAsFactors = FALSE)

png(plot_file, width = 2400, height = 1200, res = 300)
par( mfrow = c(1,2), cex.main = 1.2, cex.lab = 1.0, cex.axis = 0.9, mar = c(5,5,3,1))

hist(lmiss$F_MISS*100, col = "cyan", main = "Locus Missingness Histogram", breaks = 100, xlab = "% of Locus Missingness",xlim = c(0,100))
abline(v = c(2, 5, 10), col = "red", lwd = 2, lty = 3)
hist(imiss$F_MISS*100, col = "cyan", main = "Individuals Missingness Histogram", breaks = 100, xlab = "% of Individuals Missingness",xlim = c(0,100))
abline(v = c(2, 5, 10), col = "red", lwd = 2, lty = 3)

dev.off()

# Initial Removal: - GENO 0.02 & Statistics on Missingness Update -

geno <- 0.02

sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --geno 0.02 --make-bed --out %s", shQuote(plink_data), shQuote(plink_data))
system(sys_cmd)


output_missingness_file <- file.path(callrate_path,"geno_002_missingness")

sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --missing --out %s", shQuote(plink_data), shQuote(output_missingness_file))
system(sys_cmd)

locus_file <- file.path(paste0(output_missingness_file,".lmiss"))
individual_file <- file.path(paste0(output_missingness_file,".imiss"))

plot_output_folder <- file.path(current_dir, "plots")
plot_file <- file.path(plot_output_folder, "geno_002_mind.png")

lmiss <-read.table(locus_file, header = TRUE, stringsAsFactors = FALSE)
imiss <-read.table(individual_file, header = TRUE, stringsAsFactors = FALSE)

png(plot_file, width = 2400, height = 1200, res = 300)
par( mfrow = c(1,2), cex.main = 1.2, cex.lab = 1.0, cex.axis = 0.9, mar = c(5,5,3,1))

hist(lmiss$F_MISS*100, col = "cyan", main = "Locus Missingness Histogram", breaks = 100, xlab = "% of Locus Missingness",xlim = c(0,100))
abline(v = c(2, 5, 10), col = "red", lwd = 2, lty = 3)
hist(imiss$F_MISS*100, col = "cyan", main = "Individuals Missingness Histogram", breaks = 100, xlab = "% of Individuals Missingness",xlim = c(0,100))
abline(v = c(2, 5, 10), col = "red", lwd = 2, lty = 3)

dev.off()



# Initial Removal: - MIND 0.02 & Statistics on Missingness Update -

mind <- 0.02

sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --mind 0.02 --make-bed --out %s", shQuote(plink_data), shQuote(plink_data))
system(sys_cmd)


output_missingness_file <- file.path(callrate_path,"mind_002_missingness")

sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --missing --out %s", shQuote(plink_data), shQuote(output_missingness_file))
system(sys_cmd)

locus_file <- file.path(paste0(output_missingness_file,".lmiss"))
individual_file <- file.path(paste0(output_missingness_file,".imiss"))

plot_output_folder <- file.path(current_dir, "plots")
plot_file <- file.path(plot_output_folder, "geno_002_mind_002.png")

lmiss <-read.table(locus_file, header = TRUE, stringsAsFactors = FALSE)
imiss <-read.table(individual_file, header = TRUE, stringsAsFactors = FALSE)

png(plot_file, width = 2400, height = 1200, res = 300)
par( mfrow = c(1,2), cex.main = 1.2, cex.lab = 1.0, cex.axis = 0.9, mar = c(5,5,3,1))

hist(lmiss$F_MISS*100, col = "cyan", main = "Locus Missingness Histogram", breaks = 100, xlab = "% of Locus Missingness",xlim = c(0,100))
abline(v = c(2, 5, 10), col = "red", lwd = 2, lty = 3)
hist(imiss$F_MISS*100, col = "cyan", main = "Individuals Missingness Histogram", breaks = 100, xlab = "% of Individuals Missingness",xlim = c(0,100))
abline(v = c(2, 5, 10), col = "red", lwd = 2, lty = 3)

dev.off()

# Allele Frequency - Statistics: Estimation of Minor Allele Counts

maf <- 0.05

output_stats_folder <- file.path(current_dir, "frequency")
dir.create(output_stats_folder, recursive = T)
output_frequency_file <- file.path(output_stats_folder,"frequency")

sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --freq --out %s", shQuote(plink_data), shQuote(output_frequency_file))
system(sys_cmd)

freq_file <- file.path(paste0(output_frequency_file,".frq"))
plot_file <- file.path(plot_output_folder, "maf_gm002.png")
frq <-read.table(freq_file, header = TRUE, stringsAsFactors = FALSE)

png(plot_file, width = 2400, height = 1200, res = 300)
par( mfrow = c(1,1), cex.main = 1.2, cex.lab = 1.0, cex.axis = 0.9, mar = c(5,5,3,1))

hist(frq$MAF, main = "Histogram of Minor Allele Frequency - 0.05", xlab = "Frequency of the Minor Allele observed", xlim = c(0,0.5), col = "green", breaks = 50)
abline(v=c(0,0.01,0.02,0.05), col="blue", lwd=2, lty=3)
dev.off()

sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --maf %s --make-bed --out %s", shQuote(plink_data), shQuote(maf), shQuote(plink_data))
system(sys_cmd)


# Hardy-Weinberg Equilibrium test - (Applied in the total dataset to look for extreme artifact outliers - RECOMMENDED TO APPLY PER POPULATION)

hwe <- 1e-4
# ---> Evaluate the results in the test_result via the console. If variants removal is empirically logic, proceed to apply in the final dataset, otherwise skip to the next step:
test_file <- "test_plink"
test_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --hwe %s --make-bed --out %s", shQuote(plink_data), shQuote(hwe), shQuote(test_file))
system(test_cmd) # In our dataset case, we removed 14 variants.

sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --hwe %s --make-bed --out %s", shQuote(plink_data), shQuote(hwe), shQuote(plink_data))
system(sys_cmd) 

#  Linkage Disequilibrium Pruning (TO BE RELEASED LATER)


# Identity by Descent - (Checking for duplicates samples)

output_genome_folder <- file.path(current_dir, "genome")
dir.create(output_genome_folder, recursive = T)
output_genome_file <- file.path(output_genome_folder,"genome")
output_missingness_file <- file.path(callrate_path,"missingness_gmm")

sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --genome full --out %s", shQuote(plink_data), shQuote(output_genome_file))
system(sys_cmd)
sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --missing --out %s", shQuote(plink_data), shQuote(output_missingness_file))
system(sys_cmd) #Very important to extract the best individuals with the lowest missing frequency

genome_file <- file.path(paste0(output_genome_file,".genome"))
ind_missing_file <- file.path(paste0(output_missingness_file,".imiss"))
plot_file <- file.path(plot_output_folder, "genome.png")

genome <-read.table(genome_file, header = TRUE, stringsAsFactors = FALSE)
ind_imiss <- read.table(ind_missing_file, header = TRUE, stringsAsFactors = FALSE)

png(plot_file, width = 2400, height = 1200, res = 300)
par( mfrow = c(1,1), cex.main = 0.9, cex.lab = 0.9, cex.axis = 0.8, mar = c(5,5,3,1))
hist(genome$PI_HAT, ylab = "Number of Pairs IID1 & IID2 observed", xlab = "IBD Proportions - Z2 + 0.5*Z1", main = "Identity By Descent - Pairwise distance sharings between individuals at the genome scale - Autosomes only", col = "yellow", xlim = c(0,1))
dev.off()

duplicates_samples <- genome %>%
  filter(PI_HAT >= 0.99)
duplicates_samples$missing_IID1 <- ind_imiss$F_MISS[match(duplicates_samples$IID1, ind_imiss$IID)]
duplicates_samples$missing_IID2 <- ind_imiss$F_MISS[match(duplicates_samples$IID2, ind_imiss$IID)]
duplicates_samples <- duplicates_samples %>%
  relocate(missing_IID1, .after = IID1) %>%
  relocate(missing_IID2, .after = IID2) %>%
  mutate(remove_indiv = ifelse(missing_IID1 > missing_IID2, IID1, IID2)) %>%
  relocate(remove_indiv, .after = PI_HAT)
duplicates_samples <- duplicates_samples %>%
  select(FID1,remove_indiv)
write.table(duplicates_samples, "duplicate_samples.txt", sep = " ", quote = F, row.names = F, col.names = F)

remove_duplicates_file <- file.path(current_dir,"duplicate_samples.txt")
sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --remove %s --make-bed --out %s", shQuote(plink_data), shQuote(remove_duplicates_file), shQuote(plink_data))
system(sys_cmd) #Very important to extract the best individuals with the lowest missing frequency
