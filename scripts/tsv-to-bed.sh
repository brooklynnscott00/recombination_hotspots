#!/bin/sh
#SBATCH --mail-type=ALL
#SBATCH --mail-type=END
#SBATCH --mail-user=brscott4@asu.edu
#SBATCH --job-name="tsv to bed"
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --partition=htc
#SBATCH --qos=public
#SBATCH --time=1:00:00
#SBATCH --mem=4G

# load required modules 
module load bedtools2/2.31.1

hap2_fimo/TID_1039885_H2.PRDM9.tsv

grep '^#' hap1_fimo/TID_1039885_H1.PRDM9.tsv -v | sed '1d' | sed '/^$/d' | awk -v OFS='\t' '{print($2,$3-1,$4,$1,$6,$5,$7,$8,$9)}' | bedtools sort > hap1_fimo/TID_1039885_H1.PRDM9.bed

grep '^#' hap2_fimo/TID_1039885_H2.PRDM9.tsv -v | sed '1d' | sed '/^$/d' | awk -v OFS='\t' '{print($2,$3-1,$4,$1,$6,$5,$7,$8,$9)}' | bedtools sort > hap2_fimo/TID_1039885_H2.PRDM9.bed
