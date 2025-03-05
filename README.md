## Gelada PRDM9 binding motif analysis

#### Download human PRDM9 binding motifs

From the terminal, in the location where you want to download the datset, run the command:

```wget https://raw.githubusercontent.com/AndreaGuarracino/readcombination/refs/heads/master/prdm9_binding_motifs/PRDM9_motifs.human.txt```

The position weigh matrices (PWMs) representing these motifs are obtained from [Altemose et a.2017](https://elifesciences.org/articles/28383)


#### Install required software
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