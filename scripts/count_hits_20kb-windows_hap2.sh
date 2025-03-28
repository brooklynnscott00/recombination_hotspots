#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-type=END
#SBATCH --mail-user=brscott4@asu.edu
#SBATCH --job-name="count the number of hits in 20kb windows forhap2"
#SBATCH --output=out/slurm-%j.out
#SBATCH --error=out/slurm-%j.err
#SBATCH --partition=htc
#SBATCH --qos=public
#SBATCH --time=1:00:00
#SBATCH --mem=4G

module load bedtools2/2.31.1

fasta_index="/scratch/brscott4/gelada/data/genome/dna_zoo_central_gelada_assembly/Theropithecus_gelada_HiC.1Mbp.fa.gz.fai"

max_qvalue=1
window_size=20000

mkdir -p hap2_PRDM9_hits

# Define chromosome names
for scaffold in HiC_scaffold_{1..21}; do
  grep '^MOTIF' PRDM9_motifs.human.txt | cut -f 2 -d ' ' | while read MOTIF; do
    echo ${scaffold} ${MOTIF}
    bedtools intersect \
      -a <(bedtools makewindows -g <(cat ${fasta_index} | grep -P "${scaffold}\t" | cut -f 1,2) -w ${window_size}) \
      -b <(grep -P "^$scaffold\t" hap2_fimo/TID_1039885_H2.fixed.PRDM9.bed | grep -P "$MOTIF\t" | awk -v max_qvalue=$max_qvalue '$8 <= max_qvalue') -c | \
      awk -v OFS='\t' -v motif=$MOTIF '{print($0,motif)}' \
      >> hap2_PRDM9_hits/TID_1039885_H2.PRDM9.${window_size}.bed
  done
done

