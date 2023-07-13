#PBS -t 0-1340%10
#PBS -N run_antismash_copsac
#PBS -e as.err
#PBS -o as.log
#PBS -l nodes=1:ppn=40
#PBS -l mem=180gb
#PBS -l walltime=99:00:00
module load tools
module load antismash/6.0.0
 
cd /home/projects/dtu_00009/people/anpmed/Data/contigs_5k

# Gets a list of the file from the directory that have scaffolds.fasta in the name and removes the ones with the word done
ls  -d -p *scaffolds.fasta | grep -v /| grep -v done > list.txt

# Reads the file names from 'list.txt' into an array  called rows
readarray -t rows < list.txt

# Selects the file to be processed based on the value of the PBS_ARRAYID environment variable
file=${rows[${PBS_ARRAYID}]}

# Checks if the directory "AS_${file}" already exists
if [  -d "AS_${file}" ]; then

    echo "File not found!"

    exit 0

fi

# Run antismash command on the selected input file, and saves the output in a directory named "AS_${file}"
antismash ${file} --output-dir "AS_${file}" --genefinding-tool prodigal-m
