#!/bin/bash

FILENAME=$1
OUTPATH=$2
CORE_NUM=$3
SCRIPT_DIR=$4

FILENAME_core=$(basename "${FILENAME%.fastq*}")

### Trim adapter region, gets rid of initial "N", and discards untrimmed reads and reads that are too short. Outputs report.
# Previous testing had ~400 million reads at approximately 3.25 hours
echo '>>> Beginning adapter trimming on:' $FILENAME
cutadapt -a file:${SCRIPT_DIR}/ref_seq/adapter.fasta -u 1 -m 20 -e 0.25 -O 5 --discard-untrimmed --cores=${CORE_NUM} -o ${OUTPATH}/${FILENAME_core}_trimmed.fastq.gz $FILENAME > ${OUTPATH}/${FILENAME_core}_cutadapt.log
echo '>>> Finished trimming file.'

# --untrimmed-output ${OUTPATH}/${FILENAME_core}_noadaptor.fastq.gz --too-short-output ${OUTPATH}/${FILENAME_core}_tooshort.fastq.gz