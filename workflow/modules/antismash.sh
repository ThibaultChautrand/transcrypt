cd /home/projects/dtu_00009/people/thihcha/transcrypt/data/
module load tools antismash/6.0.0
for file in metagenomes/*
do antismash $file --genefinding-tool prodigal-m
done
