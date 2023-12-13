#!/bin/bash

base=/home/cluster/nath/niper/ETENLNC/mrna_quant/quant
run=TamvsControl

Rscript tximport_deseq.R $base $run vst

#Fixes left shift
mv -v "$run"\ .csv bak_"$run"\ .csv
echo -n "Gene_ID", > $run.csv
cat bak_"$run"\ .csv >> $run.csv

#Filters significant DEGs
cat $run.csv | awk -F ',' '$7<0.05{print$0}' > "$run"_significant.csv

#FIlters significant upregulated and downregulated DEGs
awk -F ',' '$3>0{print$0}' "$run"_significant.csv > "$run"_significant_up.csv
awk -F ',' '$3<0{print$0}' "$run"_significant.csv > "$run"_significant_down.csv
cat "$run"_significant_down.csv "$run"_significant_up.csv > "$run"_significant_DE.csv
