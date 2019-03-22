#!/bin/bash
### Checks to see if your file exists; if not, then terminates.
FILENAME=$1
OUTPATH=$2
CORE_NUM=$3
BOWTIE_REF=$4

FILENAME_core=$(basename "${FILENAME%.fastq*}")

#get path of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ -e $FILENAME ]; then
	echo 'Running file:' $FILENAME
else
	echo $FILENAME 'does not exist.'
	exit 1
fi

if [ -e $FILENAME ]; then
	echo 'Output to directory:' $OUTPATH
else
	echo $OUTPATH 'does not exist.'
	exit 1
fi

#step 1. trim adapter
time ${SCRIPT_DIR}/codes/step_1_cutadapt.sh $FILENAME $OUTPATH $CORE_NUM $SCRIPT_DIR

#step 2.1 demultiplex the linker barcode
time ${SCRIPT_DIR}/codes/step_2_LinkerBarcodeDemux.sh $FILENAME $OUTPATH $CORE_NUM $SCRIPT_DIR

#step 2.2 get a list of outputed files
ls ${OUTPATH}/${FILENAME_core}_*.fastq.gz > ${OUTPATH}/${FILENAME_core}_intermediate_file_list.txt
#sed -i '/_noadaptor/d' ${OUTPATH}/${FILENAME_core}_intermediate_file_list.txt
#sed -i '/_tooshort/d' ${OUTPATH}/${FILENAME_core}_intermediate_file_list.txt
sed -i '/_trimmed/d' ${OUTPATH}/${FILENAME_core}_intermediate_file_list.txt
sed -i '/_UMIextracted/d' ${OUTPATH}/${FILENAME_core}_intermediate_file_list.txt

#step 3. rm UMI and attach to reads name
#parallaized by xargs
time cat ${OUTPATH}/${FILENAME_core}_intermediate_file_list.txt | \
xargs -P $CORE_NUM -I % ${SCRIPT_DIR}/codes/step_3_UMIextration.sh % $OUTPATH

#step 4. mapping all the files
for i in ${OUTPATH}/${FILENAME_core}_*_UMIextracted.fastq.gz
do bowtie -k 1 --best -S --threads $CORE_NUM -q --un ${i%.fastq.gz}_unmappable.fastq.gz $BOWTIE_REF $i ${i%.fastq.gz}.sam
done 

#step 2.2 get a list of mapped sam files
ls ${OUTPATH}/${FILENAME_core}_*.sam > ${OUTPATH}/${FILENAME_core}_sam_file_list.txt

#step 5. UMI collapse
time cat ${OUTPATH}/${FILENAME_core}_sam_file_list.txt | \
xargs -P $CORE_NUM -I % ${SCRIPT_DIR}/codes/step_5_UMIcollapsing.sh % $OUTPATH

echo "ribo-profiling reads mapping pipeline done"
