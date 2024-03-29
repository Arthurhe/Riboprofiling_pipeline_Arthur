# Arthur's pipeline for mapping ribo-profiling reads
#### generate bam files from fastq.gz files

### dependency
``` 
python (>= 3.6.8),
cutadapt (>= 2.1),
umi_tools (>= 0.5.5),
bowtie (>= 1.2.2)
```

### installation

download the repository  
```
cd PATH/TO/THE/REPOSITORY
conda env create -f ribo_profiling_pipeline_env.yml   #create the appropriate environment for the pipeline
chmod 755 codes/*   # make all the scripts executable
chmod run_pipeline.sh   # make all the scripts executable

```

### example

activate the environment we created
```
source activate ribo_profiling
```

create the bowtie reference according to http://bowtie-bio.sourceforge.net/manual.shtml#the-bowtie-build-indexer  
or download pre-computed reference from ftp://ftp.ccb.jhu.edu/pub/data/bowtie_indexes/
  
run the pipeline by
```
PATH/TO/run_pipeline.sh $Input $Output $Thread $Bowtie_ref
```
_Input_ = the path to your input fastq.gz file  
_Output_ = the path to your output directory  
_Thread_ = an integer larger than 0 indicates how many thread you want to use  
_Bowtie\_ref_ = the path to your bowtie reference file, same as what you will use for bowtie  
  
for example:  
```
~/tools/Riboprofiling_pipeline_Arthur/run_pipeline.sh 190321_Bcell/B_cell_R1.fastq.gz 190321_out/ 4 /home/software/bowtie-1.1.1/genomes/mm10_150921/mm10_150921
```
    
_inspired by codes from Vince Harjono (Zid lab UCSD)  
library prep protocol modified from: McGlincy, N. J., & Ingolia, N. T. (2017). Transcriptome-wide measurement of translation by ribosome profiling. Methods, 126, 112-129._   