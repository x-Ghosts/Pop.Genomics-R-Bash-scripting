#!/bin/bash

# This script functions when ADMIXTURE software is installed in the binaries of the system: /usr/local/bin/admixture
# In case of not being installed, replace "admixture" in the command on Line "32" to "./admixture"
# Ensure to have the possibilities to run the file with all your permissions.


dataset_outdir="admixture_analysis"
dataset_name="target_dataset_capre"
cpu_cores=22
min_K=2 #default, you can edit here
max_K=20


echo "Current DIR: $(pwd)"
echo ""

echo "Creating ADMIXTURE ENVIRONMENT DIR:"
mkdir -p "$dataset_outdir"
cp "${dataset_name}".* "$dataset_outdir"/
echo "Created !"


cd "$dataset_outdir" || exit 1

# Admixture Iteration loop

echo "Initialization of Population Structure Analysis - ADMIXTURE - DIR: $(pwd)"
echo ""

for K in $(seq "$min_K" "$max_K"); do
	echo "Admixture is running at K=$K"
	admixture --cv "${dataset_name}".bed $K -j$cpu_cores | tee log.${K}.log
	echo "Admixture completed for K=$K"
	echo ""
done

echo ""
echo "End of admixture."
