# Rstudio rnaseq container
RStudio singularity container for 2023 RNAseq workshop.   
This is a short tutorial about how to create a RStudio singularity container on [Pawsey Nimbus](https://pawsey.org.au/systems/nimbus-cloud-service/) instance and execute it by running a RStudio server.  
If you have used this work for a publication, you must acknowledge SIH, e.g: "The authors acknowledge the technical assistance provided by the Sydney Informatics Hub, a Core Research Facility of the University of Sydney."


# Quickstart for Pawswey-Nimbus VM instance

**Base link**: [Run RStudio Interactively](https://support.pawsey.org.au/documentation/display/US/Run+RStudio+Interactively)

### Build a Docker container image
- A user on Nimbus instance does not have root privileges. Hence they cannot deploy a docker container directly. Instead they need to create a docker image and then convert the docker image into a singularity image to deploy it.  
- The command to build a docker image is as follows:  
`sudo docker build -f BioCommons_Dockerfile_4.1.0_V4.0 -t rstudio:4.1.0 .` The above command requires a RStudio `Dockerfile`. Here the name of our Dockerfile is `BioCommons_Dockerfile_4.1.0_V4.0` and the name of the output Docker container image is `rstudio:4.1.0`.  
- Additional details about contents of a RStudio Dockerfile for bioinformatics can be found [here](https://support.pawsey.org.au/documentation/pages/viewpage.action?pageId=59476382#RunRStudioInteractively-2.2.1.BuildRStudiocontainer(R=4.1.0))  
- Click on the Dockerfile name [BioCommons_Dockerfile_4.1.0_V4.0](BioCommons_Dockerfile_4.1.0_V4.0) to view contents of the file used to create the Docker image for this workshop.

### Pull and convert the Docker image into a Singularity container
- The next step is to convert the docker container image into a singulairty container image.  
- The required command is: `sudo singularity pull docker-daemon:rstudio:4.1.0`  
- The output of the above command is a singularity container image file called `rstudio:4.1.0.sif`


### Run with Docker  
NA

### Push to Dockerhub
- Login to dockerhub  
  - Use command `docker login`
  - Use credentials
- List all Docker container images on your system  
   `docker images`

- Make sure you have tagged your image correctly with the full repository name and tag  
  `docker tag sydneyinformaticshub/rstudio:4.1.0 sydneyinformaticshub/rstudio:4.1.0`

- Push the docker image to the docker registry:  
  `docker push sydneyinformaticshub/rstudio:4.1.0`
  
See the repo at [https://hub.docker.com/repository/docker/sydneyinformaticshub/rstudio/general](https://hub.docker.com/repository/docker/sydneyinformaticshub/rstudio/general)

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




