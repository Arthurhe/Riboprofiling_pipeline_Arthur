#!/bin/bash

FILENAME=$1
OUTPATH=$2

FILENAME_core=$(basename "${FILENAME%_UMIextracted.sam}")

### extract UMI from reads
echo '>>> Beginning UMI collapsing for '${FILENAME_core}
umi_tools dedup --stdin=${FILENAME} --in-sam --log=${OUTPATH}/${FILENAME_core}_UMIcollapsing.log > ${OUTPATH}/${FILENAME_core}_UMIcollapsed.bam
echo '>>> Finished UMI collapsing for '${FILENAME_core}