cd /home/projects/dtu_00009/people/thihcha/transcrypt/data
module load tools
module load kallisto/0.46.0
for folder in metatranscriptomes/R*
do kallisto quant -i MIBiG/MIBiG_index.idx -o kallisto_out/MIBiG_$(basename $folder).kcount $folder/*.fq.gz
done
