### Checks to see if your file exists; if not, then terminates.
FILENAME=$1
if [ -e $FILENAME ]; then
	echo 'Running file:' $FILENAME
else
	echo $FILENAME 'does not exist.'
	exit 1
fi

### Trim adapter region, gets rid of initial "N", and discards untrimmed reads and reads that are too short. Outputs report.
# Previous testing had ~400 million reads at approximately 3.25 hours
echo 'Beginning adapter trimming on:' $FILENAME
echo `time cutadapt -a file:adapter.fasta -u 1 -m 17 --discard-untrimmed -o trimmed_$FILENAME $FILENAME > adapter_trimming_report.txt`
echo 'Finished trimming file.'