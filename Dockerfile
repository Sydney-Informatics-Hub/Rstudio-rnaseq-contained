FROM rocker/rstudio:4.1.0

# Set one or more individual labels
LABEL com.example.version="0.0.1"
LABEL org.opencontainers.image.authors="Sydney Informatics Hub"
LABEL com.example.release-date="2023-10-20"
LABEL com.example.version.is-production=""


# Install system-level packages or dependencies required by other softwares or packages 
 
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  libxml2-dev \
  libcairo2-dev \
  libsqlite-dev \
  libmagick++-dev \
  libmariadbd-dev \
  libmariadbclient-dev \
  libpq-dev \
  libssh2-1-dev \
  unixodbc-dev \
  libsasl2-dev \
  libglpk-dev \
  default-jre \
  default-jdk
  

# Install R packages related to data - manipulation, visualisation
# Add additional package(s) one per line by using a the backlash (`\`) separater, as seen below   

RUN install2.r --error --skipinstalled --ncpus -4 \
    --deps TRUE \
    caTools \
    devtools \
    dplyr \
    factoextra \
    formatR \
    ggplot2 \
    gplots \
    RColorBrewer \
    remotes \
    rstudioapi \
    selectr \
    tibble \
    tidyverse



RUN R -e 'devtools::install_github("stephenturner/annotables")'

RUN R -e 'remotes::install_github("HenrikBengtsson/matrixStats", ref="develop")'


# Install Bioconductor related packages

RUN R -e 'install.packages("BiocManager")'

RUN R -e 'BiocManager::install(version = "3.14"); library(BiocManager); \
          BiocManager::install(c("AnnotationDbi", "MatrixGenerics", "biobroom", "biomaRt", "DESeq2", "edgeR", "limma", "org.Mm.eg.db", "org.Hs.eg.db", "KEGGgraph", "KEGGREST", "EnhancedVolcano"))'

RUN R -e 'install.packages("pathfindR")'

RUN R -e 'devtools::install_github("YuLab-SMU/yulab.utils")'

RUN R -e 'BiocManager::install(version = "3.14"); library(BiocManager); \
          BiocManager::install("clusterProfiler")'

RUN chown -R root:root /var/lib/rstudio-server && chmod -R g=u /var/lib/rstudio-server

