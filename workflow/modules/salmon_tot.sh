module load tools
module load salmon/1.5.2
cd /home/projects/dtu_00009/peoples/thihcha/transcrypt/data
salmon quant -p 1 -t MIBiG/MIBiG_clusters.fasta -l A -a mapped_clusters/R*.bam -o salmon_quant/R1_MIBiG.bam
