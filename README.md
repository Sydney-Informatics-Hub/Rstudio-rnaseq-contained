# Rstudio-rnaseq-container
RStudio container for 2023 RNAseq workshop

# Quickstart
This is a short tutorial about how to create a RStudio singularity container on Nimbus Pawsey instance and execute it by running a RServer on the instance  

## How to create/modify a RStudio Singularity container
**Base link**: [Run RStudio Interactively](https://support.pawsey.org.au/documentation/display/US/Run+RStudio+Interactively)

### Build a Docker container image
- A user on Nimbus instance does not have root privileges. Hence they cannot deploy a docker container directly. Instead they need to create a docker image and then convert the docker image into a singularity image to deploy it.  
- The command to build a docker image is as follows:  
`sudo docker build -f BioCommons_Dockerfile_4.1.0_V4.0 -t rstudio:4.1.0.wCP .` The above command requires a RStudio `Dockerfile`. Here the name of our Dockerfile is `BioCommons_Dockerfile_4.1.0_V4.0` and the name of the Docker container image is `rstudio:4.1.0.wCP`.  
- Additional details about contents of a RStudio Dockerfile for bioinformatics can be found [here](https://support.pawsey.org.au/documentation/pages/viewpage.action?pageId=59476382#RunRStudioInteractively-2.2.1.BuildRStudiocontainer(R=4.1.0))  
-  Click on the Dockerfile name [BioCommons_Dockerfile_4.1.0_V4.0](BioCommons_Dockerfile_4.1.0_V4.0) to view contents of the file used to create the Docker image for this workshop.


### Update a Docker container image (over-write)
- If you need to modify/update an existing docker image, you can use the same name for a Docker image without deleting the existing one. Docker will take advantage of caching to build the new image efficiently.  
- When you build an image with the same name as an existing image, Docker will only update the layers that have changed in your Dockerfile, and reuse the layers that haven't changed.  
- This helps save disk space because it doesn't create entirely new images.


### Pull and convert the Docker image into a Singularity container
- The next step is to convert the docker container image into a singulairty container image.  
- The required command is:  
`sudo singularity pull docker-daemon:rstudio:4.1.0.wCP`  
- The output of the above command is a singularity container image file called `rstudio:4.1.0.wCP.sif`


### Run with Docker  
NA

### Push to Dockerhub
To be done



### Build with Singularity
Not tested


### Run the singularity container to start the Rstudio Server
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

**Note**
singularity exec invokes the container to run the rserver command.  
- `-B` is a flag used to for bind-mounting.  
- `/home/ubuntu/base_directory/working_directory` is a directory on your instance.   
- `/home` is the container's directory `/home/ubuntu/base_directory/working_directory` is bind-mounted to.  
- Do not replace `/home`. You can replace `/home/ubuntu/base_directory/working_directory`  with a directory of your choice, as long as it has user ownership.  
- A folder called `rstudio` is automatically created inside the folder `/home/ubuntu/rnaseq23/day2_RStudio/working_dir`
    - All input files to be viewed from RStudio need to be placed in this folder `rstudio`.  
    - All outputs from your R session are saved to the `rstudio` folder.


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

