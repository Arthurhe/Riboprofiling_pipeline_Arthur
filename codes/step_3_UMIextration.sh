#!/bin/bash

FILENAME=$1
OUTPATH=$2

FILENAME_core=$(basename "${FILENAME%.fastq*}")

### extract UMI from reads
echo '>>> Beginning UMI extraction for '${FILENAME_core}
umi_tools extract --bc-pattern=N --stdin=${FILENAME} -L extract.log --stdout ${OUTPATH}/${FILENAME_core}_leftUMIextracted.fastq.gz
umi_tools extract --bc-pattern=NNNNN --3prime -L extract.log --stdin=${OUTPATH}/${FILENAME_core}_leftUMIextracted.fastq.gz --stdout ${OUTPATH}/${FILENAME_core}_UMIextracted.fastq

#sed run from the 1st line, every 4 line (1~4), remove the 2nd "_" (s/_//2), edit in place (-i)
sed -i '1~4s/_//2' ${OUTPATH}/${FILENAME_core}_UMIextracted.fastq
gzip -f ${OUTPATH}/${FILENAME_core}_UMIextracted.fastq

rm ${OUTPATH}/${FILENAME_core}_UMIextracted.fastq
rm ${OUTPATH}/${FILENAME_core}_leftUMIextracted.fastq.gz
echo '>>> Finished UMI extraction for '${FILENAME_core}
