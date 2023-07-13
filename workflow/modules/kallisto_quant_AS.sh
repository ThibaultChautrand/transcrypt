cd /home/projects/dtu_00009/people/thihcha/transcrypt/data
module load tools
module load kallisto/0.46.0
for folder in metatranscriptomes/R*
do kallisto quant -i AS/AS_index.idx -o kallisto_out/$(basename $folder).kcounts $folder/*.fq.gz
done
