#!/bin/sh
#SBATCH --mail-type=ALL
#SBATCH --mail-type=END
#SBATCH --mail-user=brscott4@asu.edu
#SBATCH --job-name="bam2fasta"
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --partition=htc
#SBATCH --qos=public
#SBATCH --time=1:00:00
#SBATCH --mem=24G

# load required modules 
module load samtools-1.16-gcc-11.2.0

# file paths
HAP1_BAM='/scratch/brscott4/gelada/data/mapped_reads/dnazoo/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.1Mbp.sorted.bam'
HAP2_BAM='/scratch/brscott4/gelada/data/mapped_reads/dnazoo/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.1Mbp.sorted.bam'

samtools fasta -F 4 $HAP1_BAM > /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.fa 
samtools fasta -F 4 $HAP2_BAM > /scratch/brscott4/gelada/recombination_hotspots/data/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.fa
