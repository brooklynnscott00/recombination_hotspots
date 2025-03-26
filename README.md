# Gelada PRDM9 binding motif analysis

## Download human PRDM9 binding motifs

From the terminal, in the location where you want to download the datset, run the command:

```wget https://raw.githubusercontent.com/AndreaGuarracino/readcombination/refs/heads/master/prdm9_binding_motifs/PRDM9_motifs.human.txt```

The position weigh matrices (PWMs) representing these motifs are obtained from and have already been filtered to only include human binding motifs [Altemose et a.2017](https://elifesciences.org/articles/28383)

## Install required software
Download [FIMO (find individual motif occurences)](https://meme-suite.org/meme/doc/fimo.html)

```shell
# install fimo
mamba create -n fimo_env -c bioconda -c conda-forge meme
source activate fimo_env

```
This is all just instructions for how to install the software that will essentially scan the gelada genome to identify the postition of the binding motifs. You can ignore this for now, but it would be useful for anyone who might want to reproduce these analyses

## search for motifs in haplotype1 and haplotype2 assemblies 

### Step 1 

``` shell 
# full path to the bam files
HAP1_BAM='/scratch/brscott4/gelada/data/mapped_reads/dnazoo/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.1Mbp.sorted.bam'
HAP2_BAM='/scratch/brscott4/gelada/data/mapped_reads/dnazoo/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.1Mbp.sorted.bam'

# full path to the binding motifs
PRDM9_MOTIFS='/scratch/brscott4/gelada/recombination_hotspots/PRDM9_motifs.human.txt'
```
Here I am just defining the paths to all the files that I want to reference later and assigning them to a variable name. This way I don't have to list the full file path

### Step 2 Prepare input files

```shell
# convert all mapped reads to a fasta file, excluding unmapped regions
sbatch sripts/bam2fasta.sh # job ID 23620655 (DONE)
```
Our genome is split into 2 haplotypes. I can explain more later about why we did this, but it means that we have to run all of our analyses on both copies. These scripts convert what's called a BAM file into a FASTA file, which is what we need as input for FIMO

```shell
# bgzip fasta files (DONE)
module load htslib-1.16-gcc-11.2.0
bgzip /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.fa
bgzip /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.fa

# use samtools to index fasta files
sbatch -p htc -c 1 --mem 26G --job-name bam2fasta --wrap "module load samtools-1.16-gcc-11.2.0; samtools faidx /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.fa.gz" # job ID: 23620714 (DONE)

sbatch -p htc -c 1 --mem 26G --job-name bam2fasta --wrap "module load samtools-1.16-gcc-11.2.0; samtools faidx /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.fa.gz" # job ID: 23620720 (DONE)
```
Some data preparation

```shell
# extract sequence headers from mapped fasta file for haplotype 1
zgrep ">" data/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.fa.gz | sed 's/>//' > data/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.mapped_headers.txt

# extract sequences headers from mapped fasta file for haplotype 2
zgrep ">" data/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.fa.gz | sed 's/>//' > data/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.mapped_headers.txt
```

```shell
sbatch scripts/make-masked-fasta.sh # jobID 23797681
```
This is all a bit complicated, we can go over it more in person but essentially we are making sure that the fasta file only includes reads that have been successfully mapped to the gelada reference genome

```shell
module load samtools-1.21-gcc-12.1.0
HAP1_BAM='/scratch/brscott4/gelada/data/mapped_reads/dnazoo/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.1Mbp.sorted.bam'
HAP2_BAM='/scratch/brscott4/gelada/data/mapped_reads/dnazoo/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.1Mbp.sorted.bam'

# create a contig to chromosome map from the mapped bam files
samtools view -F 4 ${HAP1_BAM} | awk '{print $1 "\t" $3 "_" $1}' | sort -u > data/hap1_contig_to_chr_map.txt
samtools view -F 4 ${HAP2_BAM} | awk '{print $1 "\t" $3 "_" $1}' | sort -u > data/hap2_contig_to_chr_map.txt
```

```shell
printf "HiC_scaffold_%s\n" {1..21} > data/dnazoo_HiCscaffolds.txt

grep -f <(cut -d'_' -f1 data/dnazoo_HiCscaffolds.txt)     /scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hap1.p_ctg.dnazoo-masked.HiC-scaffold_named.fasta.fai     | cut -f1 > data/dnazoo_HiCscaffolds_hap1_full.txt

grep -f <(cut -d'_' -f1 data/dnazoo_HiCscaffolds.txt)     /scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hap2.p_ctg.dnazoo-masked.HiC-scaffold_named.fasta.fai     | cut -f1 > data/dnazoo_HiCscaffolds_hap2_full.txt

sbatch scripts/seqkit-replace_rename-contigs.sh # jobID 23799587 
```
These rename the sequences headers to match the chromosome that each sequences was successfully mapped to

### Step 3 run fimo 

```shell
sbatch scripts/fimo-run.sh
```
(FIMO Hap1)
jobID: 23824225     **DONE**
(FIMO Hap2)
jobID: 23824239     **DONE**

```shell
mv hap1_fimo/fimo.gff hap1_fimo/TID_1039885_H1.PRDM9.gff
mv hap1_fimo/fimo.html hap1_fimo/TID_1039885_H1.PRDM9.html
mv hap1_fimo/fimo.tsv hap1_fimo/TID_1039885_H1.PRDM9.tsv
mv hap1_fimo/cisml.xml hap1_fimo/cisml.TID_1039885_H1.PRDM9.xml
mv hap1_fimo/best_site.narrowPeak hap1_fimo/best_site.TID_1039885_H1.PRDM9.narrowPeak
mv hap1_fimo/fimo.xml hap1_fimo/TID_1039885_H1.PRDM9.xml

mv hap2_fimo/fimo.gff hap2_fimo/TID_1039885_H2.PRDM9.gff
mv hap2_fimo/fimo.html hap2_fimo/TID_1039885_H2.PRDM9.html
mv hap2_fimo/fimo.tsv hap2_fimo/TID_1039885_H2.PRDM9.tsv
mv hap2_fimo/cisml.xml hap2_fimo/cisml.TID_1039885_H2.PRDM9.xml
mv hap2_fimo/best_site.narrowPeak hap2_fimo/best_site.TID_1039885_H2.PRDM9.narrowPeak
mv hap2_fimo/fimo.xml hap2_fimo/TID_1039885_H2.PRDM9.xml
```
Rename files -- might need to re do hap1 depending on how the test run goes 
