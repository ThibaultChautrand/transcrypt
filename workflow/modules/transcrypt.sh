eval "$(command conda 'shell.bash' 'hook' 2> /dev/null)"
conda activate snakemake-transcrypt

cd /home/projects/dtu_00009/people/thihcha/transcrypt
module load tools anaconda3/2023.03 snakemake/7.18.2 mamba-org/mamba/0.24.0
snakemake -c 16 --keep-going data/mapped_clusters/counts/R{13..132}_MIBiG.tsv

