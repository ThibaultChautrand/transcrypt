#!/bin/sh
#PBS -W group_list=dtu_00009 -A dtu_00009 nodes=1:thinnode:ppn=8,mem=8gb,walltime=1200

cp -r /home/projects/dtu_00009/people/anpmed/ana_data/downloads_HMP2_metatranscriptomes/*.gz /home/projects/dtu_00009/people/thihcha/transcrypt/data/metatranscriptomes/
