#!/bin/sh
#SBATCH --mail-type=ALL
#SBATCH --mail-type=END
#SBATCH --mail-user=brscott4@asu.edu
#SBATCH --job-name="FIMO meme PRDM9 Hap2"
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --partition=general
#SBATCH --qos=public
#SBATCH --time=12:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=48

module load mamba/latest
source activate fimo_env

mkdir -p hap1_fimo
mkdir -p hap2_fimo

mkdir -p hap1_fimo_test

fimo --oc hap1_fimo_test --verbosity 1 --thresh 1.0E-4 /scratch/brscott4/gelada/recombination_hotspots/PRDM9_motifs.human.txt /scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hap1.p_ctg.dnazoo-masked.chr_named.fasta
# fimo --oc hap2_fimo --verbosity 1 --thresh 1.0E-4 /scratch/brscott4/gelada/recombination_hotspots/PRDM9_motifs.human.txt /scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hap2.p_ctg.dnazoo-masked.chr_named.fasta
