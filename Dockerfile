FROM rocker/r-ver:3.6.0

# ARG WHEN
WORKDIR /TechnicalTest

# Dependancies
RUN apt-get update
RUN apt-get -y install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev
RUN apt-get update && apt-get -y install libssl-dev libxml2 libxml2-dev libgsl-dev zlib1g-dev imagemagick libpq-dev  

# prepare the environment
RUN R -e 'install.packages("devtools",repos="https://cloud.r-project.org");devtools::install_github("HaMar65/MosaicTX")'

# Run the analysis
RUN R -e 'library(MosaicTX);example(CalculateAssociationsTable)'

# Make the home directory
WORKDIR /MosaicTX/TechnicalTest