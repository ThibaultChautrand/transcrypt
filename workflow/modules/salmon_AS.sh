module load tools
module load salmon/1.4.0
for file in mapped_clusters/R*_AS.bam
do salmon quant -t AS/AS_clusters.fasta -l A -a $file -o salmon_quant/AS_$(basename $file _AS.bam)
done
