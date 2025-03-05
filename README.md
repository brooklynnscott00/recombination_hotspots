## Gelada PRDM9 binding motif analysis

#### Download human PRDM9 binding motifs

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

#### step 1

``` shell 
# full path to the fasta files
HAP1_BAM='/scratch/brscott4/gelada/data/mapped_reads/dnazoo/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.1Mbp.sorted.bam'
HAP2_BAM='/scratch/brscott4/gelada/data/mapped_reads/dnazoo/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.1Mbp.sorted.bam'

# full path to the binding motifs
PRDM9_MOTIFS='/scratch/brscott4/gelada/recombination_hotspots/PRDM9_motifs.human.txt'
```
Here I am just defining the paths to all the files that I want to reference later and assigning them to a variable name. This way I don't have to list the full file path

#### step2

```shell
# convert all mapped reads to a fasta file, excluding unmapped regions
sbatch -p htc -c 1 --mem 26G --job-name bam2fasta --wrap "module load samtools-1.16-gcc-11.2.0; samtools fasta -o /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.fa $HAP1_BAM" # 23620252

sbatch -p htc -c 1 --mem 26G --job-name bam2fasta --wrap "module load samtools-1.16-gcc-11.2.0; samtools fasta -o /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.fa $HAP2_BAM" # 23620255
```
Our genome is split into 2 haplotypes. I can explain more later about why we did this, but it means that we have to run all of our analyses on both copies. These scripts convert what's called a BAM file into a FASTA file, which is the format that FIMO requires as input

----------------
**currently here, waiting for the above jobs to run**
**next steps**

```shell
bgzip /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.fa
bgzip /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.fa

sbatch -p htc -c 1 --mem 26G --job-name bam2fasta --wrap "module load samtools-1.16-gcc-11.2.0; samtools faidx /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.fa.gz; $(grep chm /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.fa.gz.fai | cut -f 1) > TID_1039885.hap1.fa"

sbatch -p htc -c 1 --mem 26G --job-name bam2fasta --wrap "module load samtools-1.16-gcc-11.2.0; samtools faidx /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.fa.gz; $(grep chm /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.fa.gz.fai | cut -f 1) > TID_1039885.hap2.fa"
```

