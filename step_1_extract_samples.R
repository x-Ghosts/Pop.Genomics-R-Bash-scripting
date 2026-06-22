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
keep_above_50 <- fid_counts[fid_counts$Freq > 50,]

write.table(keep_above_50$Var1, "above_50.txt", quote = F, col.names = F, row.names = F)
