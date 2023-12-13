#syntaxdocker/dockerfile:1

FROM ubuntu:latest

#setting non-interactive OS frontend 
ENV TZ=Asia/Kolkata

#Copying script
COPY 200ntfilter.pl /script/
COPY ETENLNC_docker.sh /script/
COPY tximport_deseq.R /script/
COPY tools /
COPY Genecare1 /etc/perl/

#installing pipeline dependencies
WORKDIR /
RUN mkdir -p /user_data/
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get upgrade -y
RUN for i in python3 python3-pip apt-utils wget make fastp hisat2 fastqc stringtie zenity samtools gffread subread salmon unzip r-base ncbi-blast+ r-cran-biocmanager r-cran-stringr r-bioc-deseq2 r-bioc-tximportData r-cran-ggplot2 r-cran-dplyr r-cran-readr r-bioc-tximport r-cran-gplots; do apt-get install -y $i; done
RUN for i in libmariadb-dev gcc python3-dev libcogl-pango-dev libcairo2-dev libtool linux-headers-amd64 musl-dev libffi-dev libssl-dev libjpeg-dev zlib1g-dev; do apt-get install -y $i; done
RUN apt-get install -y seqtk
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install six torch numpy biopython pandas --no-cache-dir
RUN python3 -m pip install Cython --no-cache-dir
RUN python3 -m pip install tqdm seekr --no-cache-dir
RUN chmod -R 777 /LPI/data/tools
RUN Rscript -e 'BiocManager::install("tximportData")'
RUN apt-get install r-cran-rcurl
RUN Rscript -e 'BiocManager::install("GenomeInfoDb")'
RUN Rscript -e 'BiocManager::install(c("GenomicRanges", "SummarizedExperiment", "genefilter", "geneplotter"))'
RUN Rscript -e 'BiocManager::install("DESeq2")'
RUN Rscript -e 'install.packages("tidyverse")'
RUN mkdir -p /fasta_data/
WORKDIR /CPC2/
RUN cd libs/libsvm/libsvm-3.18/ && make clean && make
WORKDIR /

#startup
CMD bash /script/script.sh

