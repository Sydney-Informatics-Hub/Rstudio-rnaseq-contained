# Rstudio-rnaseq-container
RStudio container for 2023 RNAseq workshop

# Quickstart
This is a short tutorial about how to create a RStudio singularity container on Nimbus Pawsey instance and execute it by running a RServer on the instance  

## How to create/modify a RStudio Singularity container
**Base link**: https://support.pawsey.org.au/documentation/display/US/Run+RStudio+Interactively 

### Build with Docker container image
- The command to build a docker image:  
`sudo docker build -f BioCommons_Dockerfile_4.1.0_V4.0 -t rstudio:4.1.0.wCP .`


- The above command requires a RStudio `Dockerfile`. Here the name of our Dockerfile is `BioCommons_Dockerfile_4.1.0_V4.0`.  
- Additional details about a RStudio Dockerfile for bioinformatics can be found [here](https://support.pawsey.org.au/documentation/pages/viewpage.action?pageId=59476382#RunRStudioInteractively-2.2.1.BuildRStudiocontainer(R=4.1.0))


### Update a Docker container image (over-write)
- You can use the same name for a Docker image without deleting the existing one and Docker will take advantage of caching to build the new image efficiently.  
- When you build an image with the same name as an existing image, Docker will only update the layers that have changed in your Dockerfile, and reuse the layers that haven't changed. This helps save disk space because it doesn't create entirely new images.


### Pull and convert the Docker image into a Singularity container
A user on Nimbus instance does not have root privileges. Hence they cannot deploy a docker container. Instead they need convert the docker image into a singularity image and deploy it.

The command to convert the docker image into a singularity image is:  
`sudo singularity pull docker-daemon:rstudio:4.1.0.wCP`


### Run with Docker  
NA

### Push to Dockerhub
To be done



### Build with Singularity
Not tested


### Run the singulairty container to start the Rstudio Server
- **Step I**  
`mkdir -p /home/ubuntu/rnaseq23/day2_RStudio/working_dir/rstudio-server`
 
- **Step II**   
``` 
PASSWORD='abc' singularity exec \
    -B /home/ubuntu/rnaseq23/day2_RStudio/working_dir/rstudio-server:/var/lib/rstudio-server \
    -B /home/ubuntu/rnaseq23/day2_RStudio/working_dir/rstudio-server:/var/run/rstudio-server \
    -B /home/ubuntu/rnaseq23/day2_RStudio/working_dir:/home \
    rstudio_4.1.0.wCP.sif \
    rserver --auth-none=0 --auth-pam-helper-path=pam-helper --server-user ubuntu
```

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

