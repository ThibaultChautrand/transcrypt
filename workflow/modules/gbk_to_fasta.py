from Bio import SeqIO

with open("data/as_clusters.gbk", "rU") as input_handle:
    with open("as_clusters.fasta", "w") as output_handle:
        sequences = SeqIO.parse(input_handle, "genbank")
        SeqIO.write(sequences, output_handle, "fasta")

print(count)
