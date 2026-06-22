library(tidyverse)
library(ggplot2)
library(dplyr)
library(ggbreak)


# Animal distribution in the dataset:

fam <- read.table("target_dataset_capre.fam", header = FALSE, stringsAsFactors = FALSE)
# Count individuals per population (FID = column 1)
fid_counts <- table(fam$V1)

# Plot
barplot(fid_counts,
        main = "Population distribution (FID)",
        xlab = "Population",
        ylab = "Number of individuals",
        las = 2)  # rotate labels


# Extract Individuals above number of 30:

# Count samples per FID
fid_counts <- table(fam$V1)
fid_counts <- as.data.frame(fid_counts)
keep_above_30 <- fid_counts[fid_counts$Freq > 30,]

write.table(keep_above_30$Var1, "above_30.txt", quote = F, col.names = F, row.names = F)


# Keep only populations with > 30 individuals
pops <- names(fid_counts[fid_counts > 1])

# Define groups
africa_north <- c("ALG","BAR","BRK","DRA","GHA","MOR","NBN","NDA","NOR","OSS","SID","TUN")
fr_spain <- c("BEY","CRS","FSS","MLG","PAL","PTV","PVC","PYR","RAS","SP_MGRANA")
italy_specific <- c("IT_GARFAG")

# Build annotation table
annotation <- data.frame(
  FID = pops,
  N = as.integer(fid_counts[pops]),   # 👈 number of samples
  stringsAsFactors = FALSE
)

# Assign regions
annotation$Region <- "Italy"  # default
annotation$Region[annotation$FID %in% africa_north] <- "Africa_North"
annotation$Region[annotation$FID %in% fr_spain] <- "France_Spain"
annotation$Region[annotation$FID %in% italy_specific] <- "Italy"

# View result
annotation


write.csv(annotation, "dataset.csv", quote = FALSE, sep = ",")
