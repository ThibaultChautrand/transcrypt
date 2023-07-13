#!/usr/bin/python3

import re
import sys
import numpy as np
import pandas as pd

def kallisto_concatenate(tsv_files,database="AS",output="output.tsv"):
    #concatenate the multiple kallisto abundance.tsv files into one tsv file.
    
    if database!="AS" and database!="MIBiG":
        print("Unkown database. Usage: kallisto_concat.py [AS,MIBiG] <files>")
    else:
        clusters=[]
        samples=[]
        matrix=[]
        for line in open(tsv_files[0],"r"):
            clusters.append(line[:-1].split("\t")[0])
        for file in tsv_files:
            counts=[]
            #the sample name of the column is the name of the folder in which the abundance file is located.
            samples.append(re.search("[^/(AS_)(MIBiG_)]*/abundance.tsv$",file).group().replace("/abundance.tsv",""))
            for line in open(file, "r"):
                counts.append(line[:-1].split("\t")[4])
            matrix.append(counts[1:])
        df=pd.DataFrame(matrix, columns=clusters[1:], index=samples)
        df=df.transpose()
        df.to_csv(output, sep="\t")
    return(True)

kallisto_concatenate(sys.argv[2:], database=sys.argv[1], output=sys.argv[1]+"_counts.tsv")