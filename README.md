# Rstudio rnaseq container

Singularity/Docker image to run RStudio (v4.1.0) with packages required for differential expression analysis with RNAseq data. This container provides a reproducible environment in which to perform differential expression and functional enrichment analyses in our [RNA differential expression R notebook](https://github.com/Sydney-Informatics-Hub/rnaseq-differential-expression-Rnotebook). 

This image was used in the Australian BioCommons [Introduction to RNAseq workshop](https://sydney-informatics-hub.github.io/rnaseq-workshop-2023/) ran on 11-12th October 2023.

If you have used this work for a publication, you must acknowledge SIH, e.g: "The authors acknowledge the technical assistance provided by the Sydney Informatics Hub, a Core Research Facility of the University of Sydney."

# Build the container

## Build with Docker

Check out this repository with git and then build with Docker

```bash 
git clone https://github.com/Sydney-Informatics-Hub/Rstudio-rnaseq-contained.git
```

```bash
sudo docker build . -t sydneyinformaticshub/rnaseq-rstudio:4.1.0
```

## Run with Docker

To run this container, mount a directory housing your data (specify which paths you need to mount), and run the RStudio server instance with: 

```bash 
docker run -d -p 8787:8787 \
    -e PASSWORD=yourpassword \
    -v /path/on/host:/home/rstudio sydneyinformaticshub/rnaseq-rstudio:4.1.0
```

* `-d` runs in a detached mode 
* `-p 8787:8787` maps port 8787 in he container to 8787 on your host
* `-e PASSWORD=yourpassword` sets the password you'll need to use to open this in your browser

## Push to Dockerhub

```
sudo docker push sydneyinformaticshub/rnaseq-rstudio:4.1.0
```

## Build with Singularity 

```bash 
singularity pull docker://sydneyinformaticshub/rnaseq-rstudio:4.1.0
```
## Run with Singularity 

```
mkdir -p /tmp/rstudio-server`
```
``` 
PASSWORD='yourpassword' singularity exec \
    -B /tmp/rstudio-server:/var/lib/rstudio-server \
    -B /tmp/rstudio-server:/var/run/rstudio-server \
    -B /home/ubuntu/working_directory/Day-2:/home \
    rstudio_4.1.0.sif \
    rserver --auth-none=0 --auth-pam-helper-path=pam-helper --server-user ubuntu
```

## Run RStudio in your browser
- Open up a browser window with http://localhost:8787/ 
- Enter the username: rstudio
- Enter the password you gave it e.g `yourpassword` as seen in the above command


## R packages 

The following R packages are installed in this image: 

```default
annotables
biobroom
biomaRt
clusterProfiler
DESeq2
devtools
dplyr
edgeR
ggnewscale
ggplot2
gplots
factoextra
limma
org.Mm.eg.db
pheatmap
RColorBrewer
rstudioapi
tibble
tidyverse
```


