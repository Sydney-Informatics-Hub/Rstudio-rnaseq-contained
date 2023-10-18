# Rstudio rnaseq container

Singularity/Docker image to run RStudio (v4.1.0) with packages required for differential expression analysis with RNAseq data. This container provides a reproducible environment in which to perform differential expression and functional enrichment analyses in our [RNA differential expression R notebook](https://github.com/Sydney-Informatics-Hub/rnaseq-differential-expression-Rnotebook). 

This image was used in the Australian BioCommons [Introduction to RNAseq workshop](https://sydney-informatics-hub.github.io/rnaseq-workshop-2023/) ran on 11-12th October 2023.

If you have used this work for a publication, you must acknowledge SIH, e.g: "The authors acknowledge the technical assistance provided by the Sydney Informatics Hub, a Core Research Facility of the University of Sydney."

## Prerequisites

* [Docker](https://docs.docker.com/get-docker/)

Or

* [Singularity](https://docs.sylabs.io/guides/3.7/admin-guide/installation.html)


## Run with Docker

To run this container, mount a directory housing your data (specify which paths you need to mount), and run the RStudio server instance with: 

```bash 
docker run -p 8787:8787 \
    -e PASSWORD=yourpassword \
    -v /path/on/host:/home/rstudio sydneyinformaticshub/rnaseq-rstudio:4.1.0
```

* `-p 8787:8787` maps port 8787 in the container to 8787 on your host
* `-e PASSWORD=yourpassword` sets the password you'll need to use to open this in your browser

### Run RStudio in your browser

- Open up a browser window at http://localhost:8787/ 
- Enter the username: rstudio
- Enter the password you gave it e.g `yourpassword` as seen in the above command


## Build with Docker
If you wish to recreate this docker image you can follow these steps, for example.

Check out this repository with git:

```bash 
git clone https://github.com/Sydney-Informatics-Hub/Rstudio-rnaseq-contained.git

```

Then build with Docker:

```bash
cd Rstudio-rnaseq-contained
sudo docker build . -t sydneyinformaticshub/rnaseq-rstudio:4.1.0
```

Then push the image to dockerhub:

```
sudo docker push sydneyinformaticshub/rnaseq-rstudio:4.1.0
```

## Build with Singularity 

If you are on a machine with no Docker (like a HPC environment), you may wish to use [Singularity](https://docs.sylabs.io/guides/3.7/admin-guide/installation.html) as an alternative.

Pull the image to build it on your host (or locally and copy the resulting image to the HPC). 

```bash 
singularity pull docker://sydneyinformaticshub/rnaseq-rstudio:4.1.0
```
This will create a contained image called `rnaseq-rstudio:4.1.0` you can use to run Rstudio.

Next, make a scratch directory for Rstudio server on your host machine, e.g.

```
mkdir -p /tmp/rstudio-server`
```

Then launch the server similar to the docker command but with additional configuration options required:

``` 
PASSWORD='yourpassword' singularity exec \
	-B $(pwd):/home/rstudio/
    -B /tmp/rstudio-server:/var/lib/rstudio-server \
    -B /tmp/rstudio-server:/var/run/rstudio-server \
    rnaseq-rstudio:4.1.0 \
    rserver --auth-none=0 --auth-pam-helper-path=pam-helper --server-user ubuntu
	
```

* `PASSWORD='yourpassword' singularity exec` sets the password environment variable and then runs the `singularity exec` command.
* `-B $(pwd):/home/rstudio/` will mount a required wrtieable directory in the container. `pwd` is your current working folder. You can substitute any approriate directory for this.
* `-B /tmp/rstudio-server:/var/lib/rstudio-server` and `-B /tmp/rstudio-server:/var/run/rstudio-server` mount additional required writeable directories.
* `rstudio_4.1.0.sif` is the Singularity image file we built in the previous step.
* `rserver --auth-none=0 --auth-pam-helper-path=pam-helper --server-user ubuntu` executes the command in the container, in this case "rserver" with various options. A key option here is the `--server-user ubuntu` which assumes the user on the host machine is called **ubuntu**, this is necessary with most Singularity setups to maintain the security mapping between users of the host and in the container.

Assuming you are running Singularity on a headless remote server, you must ensure you connect to the host with port forwarding enabled if you wish to view the RStudio session on your local machine.

For example to connect to a [Pawsey Nimbus](https://nimbus.pawsey.org.au/) machine add the additional `-L` flag in your `ssh` command to *forward port 8787*:

```bash
ssh -L 8787:localhost:8787 -i "your-ssh-key" ubuntu@123.456.789
````

Once connected, execute the above Singularity command and navigate a local web browser to http://localhost:8787/ 


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


