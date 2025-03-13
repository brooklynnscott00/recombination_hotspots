#!/bin/sh
#SBATCH --mail-type=ALL
#SBATCH --mail-type=END
#SBATCH --mail-user=brscott4@asu.edu
#SBATCH --job-name="mask assembly to only include mapped reads"
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --partition=htc
#SBATCH --qos=public
#SBATCH --time=2:00:00
#SBATCH --mem=12G

module load mamba/latest
source activate seqkit_env

hap1_headers='data/TID_1039885.hifiasm.hifi-pacbio.hap1.aligned-dnazoo_HiC.mapped_headers.txt'
hap2_headers='data/TID_1039885.hifiasm.hifi-pacbio.hap2.aligned-dnazoo_HiC.mapped_headers.txt'

assemblyHap1='/scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hifiasm.hifi-pacbio.hap1.p_ctg.fasta'
assemblyHap2='/scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hifiasm.hifi-pacbio.hap2.p_ctg.fasta'

FilteredHap1='/scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hap1.p_ctg.dnazoo-masked.fasta'
FilteredHap2='/scratch/brscott4/gelada/data/long_read_genome_assembly/assemblies/joint_pacbio_ont/TID_1039885.hap2.p_ctg.dnazoo-masked.fasta'

seqkit grep -f ${hap1_headers} ${assemblyHap1} > ${FilteredHap1}
seqkit grep -f ${hap2_headers} ${assemblyHap2} > ${FilteredHap2}

