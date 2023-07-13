#!/bin/bash

# Check if the correct number of arguments were provided
if [[ $# -lt 7 ]]; then
  echo "Usage: $0 <fasta_dir> <fasta_file> <blast_dir> <blast_file> <mcl_output_dir> <heatmap_dir> <representative_dir>"
  exit 1
fi

fasta_dir=$1
fasta_file=$2
blast_dir=$3
blast_file=$4
mcl_dir=$5
heatmap_dir=$6
representative_dir=$7


## Load modules
module load tools
module load anaconda3/2021.11
module load perl
module load ncbi-blast/2.12.0+
module load mcl/14-137



###############################
######## 1 FASTA FILE #########
###############################

python as_gbk_to_1fasta.py -i ${fasta_dir} -o ${fasta_file}


###############################
########## BLAST ##############
###############################




# Check if the fasta file exists
if [[ ! -f "${fasta_dir}/${fasta_file}" ]]; then
  echo "Error: Fasta file '${fasta_file}' not found in directory '${fasta_dir}'"
  exit 1
fi

# Create the blast directory if it does not exist
if [[ ! -d "${blast_dir}" ]]; then
  mkdir "${blast_dir}"
fi



# Create the db
makeblastdb -in "${fasta_dir}/${fasta_file}" -parse_seqids -max_file_sz '4GB' -blastdb_version 5 -title "Database" -dbtype nucl -out "${blast_dir}"
# Run blast
blastn -query "${fasta_dir}/${fasta_file}" -db "${blast_dir}" -task dc-megablast -outfmt "6 qaccver saccver qstart qend sstart send pident length qcovs qcovhsp mismatch evalue bitscore" -subject_besthit >> "${blast_dir}/${blast_file}"

# We add the names of the columns, because blast does not provide them and they are needed for the subsequent python script
sed -i '1i qaccver\tsaccver\tqstart\tqend\tsstart\tsend\tpident\tlength\tqcovs\tqcovhsp\tmismatch\tevalue\tbitscore' "${blast_dir}/${blast_file}"

# Run python script for symetrising
python symmetrise_blastn.py --blast "${blast_dir}/${blast_file}" --fasta "${fasta_dir}/${fasta_file}"


###############################
########## MCL ################
###############################


# Check if the blast file exists
if [[ ! -f "${blast_dir}/${blast_file}" ]]; then
  echo "Error: The file with the blast results '${blast_file}' not found in directory '${blast_dir}'"
  exit 1
fi

# Create the mcl directory if it does not exist
if [[ ! -d "${mcl_dir}" ]]; then
  mkdir "${mcl_dir}"
fi


# convert blast to abc format (seq1, seq2, score(hereEvalue)) http://micans.org/mcl/man/clmprotocols.html#blast
# Also skipping the header line
cut -f "1,2,12" "${blast_dir}/${blast_file}" | tail -n +2  > "${mcl_dir}/blast_result.abc"
#load using mcxload to create networkfile (.mci) and dictionary file (.tab)
mcxload -abc "${mcl_dir}/blast_result.abc" --stream-mirror --stream-neg-log10 -stream-tf 'ceil(200)' -o "${mcl_dir}/blast_result.mci" -write-tab "${mcl_dir}/blast_result.tab"
# Run the clustering
mcl "${mcl_dir}/blast_result.mci" -I 1.4  -use-tab "${mcl_dir}/blast_result.tab" -odir "${mcl_dir}"
mcl "${mcl_dir}/blast_result.mci" -I 2  -use-tab "${mcl_dir}/blast_result.tab" -odir "${mcl_dir}"
mcl "${mcl_dir}/blast_result.mci" -I 4  -use-tab "${mcl_dir}/blast_result.tab" -odir "${mcl_dir}"
mcl "${mcl_dir}/blast_result.mci" -I 6  -use-tab "${mcl_dir}/blast_result.tab" -odir "${mcl_dir}"
# collect-to-jsons.
python mcl_conv_json.py --mcl-files ${mcl_dir}/*mci.I*

###############################
########## HEATMAP ############
###############################
python heatmap.py --blast ${blast_dir}/pairwise_table_symmetric.tsv --mcl-cluster-dir ${mcl_dir} -o ${heatmap_dir}



###############################
### CLUSTER REPRESENTATIVES ###
###############################

# Create the cluster representatives directory if it does not exist
if [[ ! -d "${representative_dir}" ]]; then
  mkdir "${representative_dir}"
fi

python get_cluster_representatives.py --family-json ${mcl_dir}/*mci.I40.json --similarity-matrix ${blast_dir}/pairwise_table_symmetric.tsv  --antismash-fasta-file ${fasta_dir}/${fasta_file} --outfile "${representative_dir}/cluster_repre.fa"




