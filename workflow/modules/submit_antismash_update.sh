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


update_list=""

# Loop through all files that end with 'scaffolds.fasta'
for file in *scaffolds.fasta; do

  # Check if an AS_{file} directory already exists
  if [ -f "$file" ] && [ ! -d "AS_${file}" ]; then
        update_list="$update_list\n${file}"
  fi

done

# Save the update list to a file
echo -e "$update_list" | sed '/^$/d' > update_list.txt

# Reads the file names from 'update_list.txt' into an array  called rows
readarray -t rows < update_list.txt

# Selects the file to be processed based on the value of the PBS_ARRAYID environment variable
file=${rows[${PBS_ARRAYID}]}

# Checks if the directory "AS_${file}" already exists
if [  -d "AS_${file}" ]; then

    echo "File not found!"

    exit 0

fi

# Run antismash command on the selected input file, and saves the output in a directory named "AS_${file}"
antismash ${file} --output-dir "AS_${file}" --genefinding-tool prodigal-m
