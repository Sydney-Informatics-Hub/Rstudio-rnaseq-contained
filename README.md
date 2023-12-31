# Rstudio rnaseq container

Singularity/Docker image to run RStudio (v4.1.0) with packages required for differential expression analysis with RNAseq data. This container provides a reproducible environment in which to perform differential expression and functional enrichment analyses in our [RNA differential expression R notebook](https://github.com/Sydney-Informatics-Hub/rnaseq-differential-expression-Rnotebook). 

This image was used in the Australian BioCommons [Introduction to RNAseq workshop](https://sydney-informatics-hub.github.io/rnaseq-workshop-2023/) we ran on 11-12th October 2023.

If you have used this work for a publication, you must acknowledge SIH, e.g: "The authors acknowledge the technical assistance provided by the Sydney Informatics Hub, a Core Research Facility of the University of Sydney."

## Prerequisites

* [Docker](https://docs.docker.com/get-docker/)

Or

* [Singularity](https://docs.sylabs.io/guides/3.7/admin-guide/installation.html)


## Run with Docker

We have tested this container using Docker on local Mac machines and also on the Pawsey Nimbus Cloud using the[`Pawsey Bio - Ubuntu 22.04 - 2023-06`](https://support.pawsey.org.au/documentation/display/US/Nimbus+for+Bioinformatics) instance image. 

If you are on your local machine, we recommend that you run this container using Docker. 
  
### On a local machine

#### MacOS 

- Please open a terminal window on your machine by clicking on the `Terminal` app in the `Applications` menu.

#### Windows

- Please use a linux terminal emulator like [MobaXterm](https://mobaxterm.mobatek.net/) on windows. MobaXterm is not available on windows as a native application and needs to be installed.

Once you are working in a unix/linux terminal window on your local machine, please follow the instructions below.

To run this container:  

Start docker by double-clicking on the `Docker` app icon in the `Applications` menu. 

Run the RStudio server instance using the following command: 

```bash 
docker run \
	-p 8787:8787 \
	-e PASSWORD='yourpassword' \
	-v /path/on/host:/home/rstudio \
	sydneyinformaticshub/rnaseq-rstudio:4.1.0
```
* `-p 8787:8787` maps port 8787 in the container to 8787 on your host machine.
* `-e PASSWORD='yourpassword'` sets the password you will need to use to open rstudio in your browser
* `-v /path/on/host:/home/rstudio` sets up a directory mount, which allows you to share data between your host machine and the Docker container.
* `sydneyinformaticshub/rnaseq-rstudio:4.1.0` is the [Docker image name](https://hub.docker.com/r/sydneyinformaticshub/rnaseq-rstudio). With no other arguments passed this will run the container using its default configuration.

**Run RStudio in your browser**  

Open a web browser and enter http://localhost:8787/  in the address bar

* Enter the username: `rstudio`
* Enter the password you gave it e.g `yourpassword` as seen in the above command

### On Pawsey Nimbus cloud

Assuming you are running Docker on a remote server without a graphical user interface (GUI), you must ensure you connect to the host with port forwarding enabled in order to view the RStudio session on your local machine.

For example to connect to a [Pawsey Nimbus](https://nimbus.pawsey.org.au/) machine add the additional `-L` flag in your `ssh` command to *forward port 8787*:

```bash
ssh -L 8787:localhost:8787 -i "your-ssh-key" ubuntu@146.118.XX.XXX
```

Once connected, execute the above Docker command then on a local web browser navigate to http://localhost:8787/ 

* Enter the username: `rstudio`
* Enter the password you gave it e.g `yourpassword` as seen in the above command

## Run with Singularity

### On Pawsey Nimbus cloud

Pull the image to build it on your host (or build locally and copy the resulting image to the host). 

```bash 
singularity pull docker://sydneyinformaticshub/rnaseq-rstudio:4.1.0
```

This will create a contained image called `rnaseq-rstudio:4.1.0.sif` you can use to run RStudio with Singularity.

Next, on your host machine make a scratch directory for RStudio Server:

```bash
mkdir -p /tmp/rstudio-server
```

Run the RStudio server instance using the following command: 

```bash
PASSWORD='yourpassword' singularity exec \
    -B $(pwd):/home/rstudio/ \
    -B /tmp/rstudio-server:/var/lib/rstudio-server \
    -B /tmp/rstudio-server:/var/run/rstudio-server \
    rnaseq-rstudio_4.1.0.sif \
    rserver --auth-none=0 --auth-pam-helper-path=pam-helper --server-user ubuntu
```

* `PASSWORD='yourpassword' singularity exec` sets the password environment variable and then runs the `singularity exec` command.
* `-B $(pwd):/home/rstudio/` will mount a required wrtieable directory in the container. `pwd` is your current working folder. You can substitute any approriate directory for this.
* `-B /tmp/rstudio-server:/var/lib/rstudio-server` and `-B /tmp/rstudio-server:/var/run/rstudio-server` mount additional required writeable directories.
* `rnaseq-rstudio:4.1.0.sif` is the Singularity image file we built in the previous step.
* `rserver --auth-none=0 --auth-pam-helper-path=pam-helper --server-user ubuntu` executes the command in the container, in this case "rserver" with various options.
* `--server-user ubuntu` assumes the user on the host machine is called **ubuntu**, this is necessary with most Singularity setups to maintain the security mapping between users of the host and in the container.

Assuming you are running Singularity on a remote server without a graphical user interface (GUI), you must ensure you connect to the host with port forwarding enabled in order to view the RStudio session on your local machine.

For example to connect to a [Pawsey Nimbus](https://nimbus.pawsey.org.au/) machine add the additional `-L` flag in your `ssh` command to *forward port 8787*:

```bash
ssh -L 8787:localhost:8787 -i "your-ssh-key" ubuntu@146.118.XX.XXX
```

Once connected, execute the above Singularity command and open a web browser on your local machine and navigate to http://localhost:8787/ in the address bar.   

- Enter the username: `ubuntu`  
- Enter the password you gave it e.g `yourpassword`


## Build with Docker (SIH staff only)

If you wish to make modifications to the container or recreate this Dockerfile from scratch, follow these steps, for example.

Clone this repository with git:

```bash 
git clone https://github.com/Sydney-Informatics-Hub/Rstudio-rnaseq-contained.git

```

Edit the `Dockerfile` as required, then build with Docker:

```bash
cd Rstudio-rnaseq-contained
sudo docker build . -t sydneyinformaticshub/rnaseq-rstudio:4.1.0
```

Push the image to Dockerhub:

```bash
sudo docker push sydneyinformaticshub/rnaseq-rstudio:4.1.0
```

## R packages 

The following R packages are installed in this image: 

```default
DESeq2:1.32.0
edgeR:3.34.1
limma:3.48.3
RColorBrewer:1.1.3
gplots:3.1.3
ggplot2:3.4.3
factoextra:1.0.7
devtools:2.4.5
rstudioapi:0.15.0
dplyr:1.1.2
tibble:3.2.1
tidyverse:2.0.0
pheatmap:1.0.12
biomaRt:2.48.3
annotables:0.1.91
org.Mm.eg.db:3.13.0
biobroom:1.24.0
clusterProfiler:4.0.5
ggnewscale:0.4.9
```


