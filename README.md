# Rstudio rnaseq container

Singularity/Docker image to run RStudio with packages required for differential expression analysis with RNAseq data. This container provides a reproducible environment in which to perform differential expression and functional enrichment analyses in our [RNA differential expression R notebook](https://github.com/Sydney-Informatics-Hub/rnaseq-differential-expression-Rnotebook). 

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
docker run -d -p 8787:8787 -e PASSWORD=yourpassword -v /path/on/host:/home/rstudio rocker/rstudio
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



### Pull a singularity container from the docker image
`sudo singularity pull docker-daemon:rstudio:4.1.0`


### Run the singularity container to start the Rstudio Server (on pawsey-Nimbus)
- **Step I**  
`mkdir -p /tmp/rstudio-server`
 
- **Step II**   
``` 
PASSWORD='abc' singularity exec \
    -B /tmp/rstudio-server:/var/lib/rstudio-server \
    -B /tmp/rstudio-server:/var/run/rstudio-server \
    -B /home/ubuntu/working_directory/Day-2:/home \
    rstudio_4.1.0.sif \
    rserver --auth-none=0 --auth-pam-helper-path=pam-helper --server-user ubuntu
```

**Note**
singularity exec invokes the container to run the rserver command.  
- `-B` is a flag used to for bind-mounting.  
- `/home/ubuntu/base_directory/working_directory` is a directory on your instance.   
- `/home` is the container's directory `/home/ubuntu/working_directory/Day-2` is bind-mounted to.  
- Do not replace `/home`. You can replace `/home/ubuntu/working_directory/Day-2`  with a directory of your choice, as long as it has user ownership.  
- A folder called `rstudio` is automatically created inside the folder `/home/ubuntu/rnaseq23/day2_RStudio/working_dir`
    - **All input files** to be viewed from RStudio need to be placed in this folder `rstudio`.  
    - **All outputs** from your R session are saved to the `rstudio` folder.


### Open RStudio from a browser
- Open up a browser window 
- Go to your instance IP address with the 8787 port, e.g. 146.118.XX.XX:8787
- Enter the username you created, e.g. rstudio (or if using a container, ubuntu)
- Enter the password you gave it e.g `abc` as seen in the above command
- Run your R commands as you normally would


### End your RStudio session and server
If you ran RStudio from a container, stop the running command with ctrl+c:

Or kill the process on the port:
`lsof -ti:8787 | xargs kill -9`  
`lsof -ti:8787`

### Other useful commands
1) List all Docker containers (including stopped ones): `docker ps -a`  
2) Remove containers you no longer need: `docker container rm CONTAINER_ID`  
3) Clean the Singularity cache: `sudo singularity cache clean`  
The above command
- Is used to clean the Singularity cache.
- Singularity caches container images to speed up subsequent container operations by storing images locally.
- It will remove all cached container images from the cache directory.
- **Note**: Running this command will delete all cached images, and you may need to re-download or rebuild the containers if they are required again in the future.


4) **Update a Docker container image (over-write)**
- If you need to modify/update an existing docker image, you can use the same name for a Docker image without deleting the existing one. Docker will take advantage of caching to build the new image efficiently.  
- When you build an image with the same name as an existing image, Docker will only update the layers that have changed in your Dockerfile, and reuse the layers that haven't changed.  
- This helps save disk space because it doesn't create entirely new images.

5) **Rename a Docker image** using the docker tag command to give it a new name and optionally a new tag.
- In your case, you want to rename your image from rstudio:4.1.0 to sydneyinformaticshub/rstudio:4.1.0.wCP. Use the command `sudo docker tag rstudio:4.1.0 sydneyinformaticshub/rstudio:4.1.0`.
- This command creates a new image tag with the desired name and tag while keeping the original image intact.
- After running this command, you'll have two tags pointing to the same image: rstudio:4.1.0.wCP and sydneyinformaticshub/rstudio:4.1.0.wCP. You can then push this newly tagged image to a Docker registry if needed.

## Packages 

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


