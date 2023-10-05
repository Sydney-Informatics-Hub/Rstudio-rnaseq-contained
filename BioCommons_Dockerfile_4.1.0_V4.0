FROM rocker/rstudio:4.1.0
 
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
    tidyverse \
    pheatmap \
    ggnewscale

RUN R -e 'devtools::install_github("stephenturner/annotables")'

RUN R -e 'remotes::install_github("HenrikBengtsson/matrixStats", ref="develop")'

RUN R -e 'install.packages("BiocManager")'

RUN R -e 'BiocManager::install(version = "3.14"); library(BiocManager); \
          BiocManager::install(c("AnnotationDbi", "MatrixGenerics", "biobroom", "biomaRt", "DESeq2", "edgeR", "limma", "org.Mm.eg.db", "org.Hs.eg.db", "KEGGgraph", "KEGGREST", "EnhancedVolcano"))'

RUN R -e 'install.packages("pathfindR")'

RUN R -e 'devtools::install_github("YuLab-SMU/yulab.utils")'

RUN R -e 'BiocManager::install(version = "3.14"); library(BiocManager); \
          BiocManager::install("clusterProfiler")'

RUN chown -R root:root /var/lib/rstudio-server && chmod -R g=u /var/lib/rstudio-server

