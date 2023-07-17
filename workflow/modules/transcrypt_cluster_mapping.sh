#!bin/sh
mamba activate snakemake
cd $PBS_O_WORKDIR
snakemake -n mapped_clusters_sorted/test.bam.bai
mamba deactivate