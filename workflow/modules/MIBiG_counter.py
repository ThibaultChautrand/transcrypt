#!/usr/bin/python3
#-*- coding : uft-8 -*-
import requests,re, json
import pandas as pd
import numpy as np

#/media/thibault/VERBATIM HD/Data/RGI

# Sample list
samples=["R1"]

#


#


#for sample in samples:
#    df1 = pd.read_csv("sample+".txt",sep = '\t')
#    df2 = pd.read_csv("/media/thibault/VERBATIM HD/Data/SAMBAM/"+sample+".counts",sep = '\t', header=None)
#    df_rgi= df1[["Contig","AMR Gene Family"]]
#    df_counts=df2.iloc[:,[0,1]]
#    df_rgi['Contig'] = df_rgi['Contig'].str.replace('_.*$','', regex=True)
#    dic_rgi=dict(zip(df_rgi.Contig, df_rgi["AMR Gene Family"]))
#    dic_counts=dict(zip(df_counts[0], df_counts[1]))
#    dic_out={}
#    for i in dic_counts:
#        if i in dic_rgi:
#            if i not in dic_out:
##                dic_out[dic_rgi[i]]=int(dic_counts[i])
 #           else:
 #               dic_out[dic_rgi[i]]+=int(dic_counts[i])
 #   dic_out = dict(sorted(dic_out.items()))
 #   for i in dic_out:
 #       if i not in dic_tot:
#            dic_tot[i]=[]

#for sample in samples:
##    df1 = pd.read_csv("/media/thibault/VERBATIM HD/Data/RGI/RGI_"+sample+".txt",sep = '\t')
#    df2 = pd.read_csv("/media/thibault/VERBATIM HD/Data/SAMBAM/"+sample+".counts",sep = '\t', header=None)
#    df_rgi= df1[["Contig","AMR Gene Family"]]
#    df_counts=df2.iloc[:,[0,1]]
#    df_rgi['Contig'] = df_rgi['Contig'].str.replace('_.*$','', regex=True)
#    dic_rgi=dict(zip(df_rgi.Contig, df_rgi["AMR Gene Family"]))
#    dic_counts=dict(zip(df_counts[0], df_counts[1]))
#    dic_out={}
#    for i in dic_counts:
#        if i in dic_rgi:
#            if i not in dic_out:
#                dic_out[dic_rgi[i]]=int(dic_counts[i])
#            else:
#                dic_out[dic_rgi[i]]+=int(dic_counts[i])
#    dic_out = dict(sorted(dic_out.items()))
#    for i in dic_tot:
#        if i in dic_out:
#            dic_tot[i].append(dic_out[i])
#        elif i!="Gene_clusters":
#            dic_tot[i].append(0)
#print(dic_tot)
#with open("RGI_counts.tsv","w") as file:
#    for i in dic_tot:
#        file.write(i+"\t")
#        for j in range(len(dic_tot[i])):
#            file.write(str(dic_tot[i][j])+"\t")
#        file.write("\n")
