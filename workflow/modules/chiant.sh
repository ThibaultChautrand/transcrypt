for file in data/antismash/*/*.gbk ;
do
sequence_name=$(sed -n '/^DEFINITION/p' $file | tr -s ' ' | cut -d ' ' -f2);
sequence_to_replace=$(sed -n '/^LOCUS/p' $file | tr -s ' ' | cut -d ' ' -f2);
sed "s/$sequence_to_replace/$sequence_name/" $file > $file.conv;
done;