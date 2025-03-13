# Gelada PRDM9 binding motif analysis

## Download human PRDM9 binding motifs

From the terminal, in the location where you want to download the datset, run the command:

```wget https://raw.githubusercontent.com/AndreaGuarracino/readcombination/refs/heads/master/prdm9_binding_motifs/PRDM9_motifs.human.txt```

The position weigh matrices (PWMs) representing these motifs are obtained from and have already been filtered to only include human binding motifs [Altemose et a.2017](https://elifesciences.org/articles/28383)

## Install required software
Download [FIMO (find individual motif occurences)](https://meme-suite.org/meme/doc/fimo.html)

```shell
# install meme suite
cd /scratch/brscott4/downloads/
wget -c https://meme-suite.org/meme/meme-software/5.5.0/meme-5.5.0.tar.gz
tar -xf meme-5.5.0.tar.gz
cd /scratch/brscott4/downloads/meme-5.5.0
./configure --prefix=$HOME/meme --enable-build-libxml2 --enable-build-libxslt
make
```
This is all just instructions for how to install the software that will essentially scan the gelada genome to identify the postition of the binding motifs. You can ignore this for now, but it would be useful for anyone who might want to reproduce these analyses

## search for motifs in haplotype1 and haplotype2 assemblies 

### step 1 (DONE)

``` shell 
# full path to the bam files
HAP1_BAM='/scratch/brscott4/gelada/data/mapped_reads/dnazoo/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.1Mbp.sorted.bam'
HAP2_BAM='/scratch/brscott4/gelada/data/mapped_reads/dnazoo/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.1Mbp.sorted.bam'

# full path to the binding motifs
PRDM9_MOTIFS='/scratch/brscott4/gelada/recombination_hotspots/PRDM9_motifs.human.txt'
```
Here I am just defining the paths to all the files that I want to reference later and assigning them to a variable name. This way I don't have to list the full file path

### step 2 Prepare input files

```shell
# convert all mapped reads to a fasta file, excluding unmapped regions
sbatch sripts/bam2fasta.sh # job ID 23620655 (DONE)
```
Our genome is split into 2 haplotypes. I can explain more later about why we did this, but it means that we have to run all of our analyses on both copies. These scripts convert what's called a BAM file into a FASTA file

```shell
# bgzip fasta files (DONE)
module load htslib-1.16-gcc-11.2.0
bgzip /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.fa
bgzip /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.fa

# use samtools to index fasta files
sbatch -p htc -c 1 --mem 26G --job-name bam2fasta --wrap "module load samtools-1.16-gcc-11.2.0; samtools faidx /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.fa.gz" # job ID: 23620714 (DONE)

sbatch -p htc -c 1 --mem 26G --job-name bam2fasta --wrap "module load samtools-1.16-gcc-11.2.0; samtools faidx /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.fa.gz" # job ID: 23620720 (DONE)
```

```shell
# extract sequence headers from mapped reads for hap1
zgrep ">" data/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.fa.gz | sed 's/>//' > data/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.mapped_headers.txt

# extract sequences headers from mapped reads for hap2
zgrep ">" data/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.fa.gz | sed 's/>//' > data/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.mapped_headers.txt
```

```shell
sbatch scripts/make-masked-fasta.sh # jobID 23797681
```


**currently here, waiting for the above jobs to run**
**next steps**

# these grep files are most likely looking for the chromosome IDs so look for unique chrIDs first and then change the command to grep for autosomes
; $(grep chm /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.fa.gz.fai | cut -f 1) > TID_1039885.hap1.fa" # job ID 23620329



; $(grep chm /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.fa.gz.fai | cut -f 1) > TID_1039885.hap2.fa" # job ID 23620332
```


