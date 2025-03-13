#!/bin/sh
#SBATCH --mail-type=ALL
#SBATCH --mail-type=END
#SBATCH --mail-user=brscott4@asu.edu
#SBATCH --job-name="FIMO meme PRDM9"
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --partition=htc
#SBATCH --qos=public
#SBATCH --time=2:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=48G

module load mamba/latest
source activate fimo_env

fimo --oc /scratch/brscott4/gelada/recombination_hotspots/ --verbosity 1 --thresh 1.0E-4 /scratch/brscott4/gelada/recombination_hotspots/PRDM9_motifs.human.txt /lizardfs/guarracino/chromosome_communities/recombination_hotspots/chm13v2.fa"

