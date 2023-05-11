#!/usr/bin/python3
#-*- coding : uft-8 -*-

from Bio import SeqIO
import sys


def index_genbank_features(gb_record, feature_type, qualifier) :
    answer = dict()
    for (index, feature) in enumerate(gb_record.features) :
        if feature.type==feature_type :
            if qualifier in feature.qualifiers :
                #There should only be one locus_tag per feature, but there
                #are usually several db_xref entries
                for value in feature.qualifiers[qualifier] :
                    if value in answer :
                        print ("WARNING - Duplicate key %s for %s features %i and %i" \
                           % (value, feature_type, answer[value], index))
                    else :
                        answer[value] = index
    return(answer)

files=sys.argv[1:]

with open("MIBiG_functions.tsv","w") as output:
    for file in files:
        record=SeqIO.read(open(file,"r"),"genbank")
        #record_taxonomy=
        print(record.features[5].qualifiers['product'])
        break