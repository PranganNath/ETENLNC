#!/bin/bash

#SBATCH --job-name=JOB1
#SBATCH --output=JOB1.out
#SBATCH --ntasks=100
                                                                    
echo "
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄


      ▀███▀▀▀██████▀▀██▀▀██████▀▀▀███▀███▄   ▀███▀████▀   ▀███▄   ▀███▀ ▄▄█▀▀▀█▄█
        ██    ▀██▀   ██   ▀█ ██    ▀█  ███▄    █   ██       ███▄    █ ▄██▀     ▀█
        ██   █       ██      ██   █    █ ███   █   ██       █ ███   █ ██▀       ▀
        ██████       ██      ██████    █  ▀██▄ █   ██       █  ▀██▄ █ ██         
        ██   █  ▄    ██      ██   █  ▄ █   ▀██▄█   ██     ▄ █   ▀██▄█ ██▄        
        ██     ▄█    ██      ██     ▄█ █     ███   ██    ▄█ █     ███ ▀██▄     ▄▀
      ▄██████████  ▄████▄  ▄█████████████▄    ██ █████████████▄    ██   ▀▀█████▀ 
      - Team EvolOMICS
         
     	   END TO END NOVEL LNCRNA IDENTIFICATION AND QUANTIFICATION PIPELINE	   

▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
"

#Please enter the strandedness of your data. Use 'RF' for reverse-stranded, 'FR' for forward-stranded and 'UN' for unstranded
strand=

#Please enter your reference genome (.fa) location
ref_fa=

#Please enter the location to FASTP directory
fastp= 

#Please enter the maximum number of threads to run this pipeline
threads=

hisat2-build -p $threads $ref_fa index

find $fastp -name "*_trimmed.fastq.gz" | sort | paste - - | while read A B

do

a=`basename ${A} | awk -F "." '{print $1}' | awk -F "_" '{print $1}'`

case $strand in 
	RF ) 
	hisat2 --rna-strandness R --threads $threads --dta -x index -1 ${A} -2 ${B} -S $a.sam;;
	FR )
	hisat2 --rna-strandness F --threads $threads --dta -x index -1 ${A} -2 ${B} -S $a.sam;;
	UN ) 
	hisat2 --threads $threads --dta -x index -1 ${A} -2 ${B} -S  $a.sam;;
	* ) 
	echo "Please check the strandedness"
	echo "HISAT2: Please check the strandedness" >> ~/$run/summary.txt;;
esac

done

echo "Alignment Complete"

exit
