#!/bin/bash

FILENAME=$1
OUTPATH=$2
#CORE_NUM=$3 core number not supported for multiple output
SCRIPT_DIR=$4

FILENAME_core=$(basename "${FILENAME%.fastq*}")


### Demultiplexes according to barcode. Outputs report.
# Previous testing had ~400 million reads at approximately 2 hours
echo '>>> Beginning demultiplexing.'
cutadapt -a file:${SCRIPT_DIR}/ref_seq/barcodes.fasta -e 0.2 -o ${OUTPATH}/${FILENAME_core}_{name}.fastq.gz ${OUTPATH}/${FILENAME_core}_trimmed.fastq.gz > ${OUTPATH}/${FILENAME_core}_demultiplex.log
echo '>>> Finished demultiplexing.' 