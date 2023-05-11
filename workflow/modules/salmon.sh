module load tools
module load salmon/1.4.0
for file in mapped_clusters/R*_MIBiG.bam
do salmon quant -t MIBiG/MIBiG_clusters.fasta -l A -a $file -o salmon_quant/$(basename $file _MIBiG.bam)
done
