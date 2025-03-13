#!/bin/sh
#SBATCH --mail-type=ALL
#SBATCH --mail-type=END
#SBATCH --mail-user=brscott4@asu.edu
#SBATCH --job-name="rename contigs"
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --partition=htc
#SBATCH --qos=public
#SBATCH --time=2:00:00
#SBATCH --mem=24G

module load mamba/latest
source activate seqkit_env

hap1_map='/scratch/brscott4/gelada/recombination_hotspots/data/hap1_contig_to_chr_map.txt'
hap2_map='/scratch/brscott4/gelada/recombination_hotspots/data/hap2_contig_to_chr_map.txt'

FilteredHap1='/scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hap1.p_ctg.dnazoo-masked.fasta'
FilteredHap2='/scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hap2.p_ctg.dnazoo-masked.fasta'

seqkit replace -p "^(.*)" -r "{kv}" --kv-file ${hap1_map} ${FilteredHap1} -o ${FilteredHap1%.fasta}.HiC-scaffold_named.fasta
seqkit replace -p "^(.*)" -r "{kv}" --kv-file ${hap2_map} ${FilteredHap2} -o ${FilteredHap2%.fasta}.HiC-scaffold_named.fasta

conda deactivate
module load samtools-1.21-gcc-12.1.0

samtools faidx /scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hap1.p_ctg.dnazoo-masked.HiC-scaffold_named.fasta
samtools faidx /scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hap2.p_ctg.dnazoo-masked.HiC-scaffold_named.fasta

samtools faidx /scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hap1.p_ctg.dnazoo-masked.HiC-scaffold_named.fasta $(cat data/dnazoo_HiCscaffolds_hap1_full.txt) \
	 > /scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hap1.p_ctg.dnazoo-masked.chr_named.fasta

samtools faidx /scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hap2.p_ctg.dnazoo-masked.HiC-scaffold_named.fasta $(cat data/dnazoo_HiCscaffolds_hap2_full.txt) \
	 > /scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hap2.p_ctg.dnazoo-masked.chr_named.fasta
