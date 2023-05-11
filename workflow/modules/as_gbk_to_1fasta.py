# Adapted from HenrikSpiegel: extract_antismash_ibdmdb.py and antismash_as_fasta.py
# https://github.com/HenrikSpiegel/Screener/tree/main/scripts
# Script to get the sequences from gbk files that are the output of antismash
# and store them in a single fasta file

# Load modules

from pathlib import Path
import sys, os
import glob
from typing import List
from Bio import SeqIO
import argparse
from argparse import ArgumentParser

# Get the gbk file and extract the sequnce to store in a fasta file

def gbk_files_to_fasta(file_paths: List[str], output_file = "Data/contigs_5k/AS_contigs_combined.fa"):  # The file paths are going to be strings; the output file can be changed when calling the function, it is also a string
    out_fh = open(output_file, "w")
    try:
        for fp in file_paths:
            records = SeqIO.parse(fp, "genbank") # Returns the seq record iterator
            for record in records:
                contig = record.name.split("_")[0] # contig
                sample_parts = record.description.split("_") # sample name; note that if it is name_TR there can be problems
                if sample_parts[1] == "TR":
                    name = "_".join(sample_parts[0:2])
                else:
                    name = sample_parts[0]

                for feat in record.features:
                    if feat.type == "protocluster":
                        product = feat.qualifiers["product"][0] # Product is the expected output product
                        break
                fasta_entry=f">{name}_{contig}_{product}\n{record.seq}\n"
                # f">{name} {assigned} {record.description} this is for the fasta header, must look something like this: > nameoffile terpene P.barbatum 5.8S rRNA gene and ITS1 and ITS2 DNA.
                # then in the next line the corresponding sequnece;
                out_fh.write(fasta_entry)
    finally:
        out_fh.close()


# Get the list with the paths where the files are at

def get_files_path(parent_directory):
    AS_directories =glob.glob(os.path.join(parent_directory, "AS_*")) # Find all directories that start with "AS_" in the directory we provide
    gbk_file_paths = []
    for dir_path in AS_directories:
        for file_name in os.listdir(dir_path): # In every file from the directory finds those with extension .gbk
            if file_name.endswith(".gbk") and not file_name.endswith("scaffolds.gbk"): # to get only the as output files
                gbk_file_paths.append(os.path.join(dir_path, file_name))
    return gbk_file_paths



if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("-i", required=True, help="Dir where AS dir are at")
    parser.add_argument("-o", help="output.fa")
    args = parser.parse_args()
    if args.o:
        fa_filename = os.path.join(args.i, args.o)
    else:
        fa_filename = os.path.join(args.i, "BGC_combined.fa")
        print("output: -> ", fa_filename, file=sys.stderr)
    gbk_file_paths = get_files_path(args.i)
    gbk_files_to_fasta(gbk_file_paths, fa_filename)
