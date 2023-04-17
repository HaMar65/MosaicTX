FROM rocker/r-ver:3.6.0

# ARG WHEN
WORKDIR /TechnicalTest

# Dependancies
RUN apt-get update && apt-get -y install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev
RUN apt-get update && apt-get -y install libssl-dev libxml2 libxml2-dev libgsl-dev zlib1g-dev imagemagick libpq-dev  
RUN apt-get update && apt-get -y install libzmq3-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev build-essential libcurl4-openssl-dev libxml2-dev libssl-dev libfontconfig1-dev

# prepare the environment
RUN R -e 'install.packages("ragg",repos="https://cloud.r-project.org")'
RUN R -e 'install.packages("pkgdown",repos="https://cloud.r-project.org")'
RUN R -e 'install.packages("devtools",repos="https://cloud.r-project.org");devtools::install_github("HaMar65/MosaicTX")'

# Run the analysis
RUN R -e 'library(MosaicTX);print(example(CalculateAssociationsTable))'

# Make the home directory
WORKDIR MosaicTX/TechnicalTest

# Print the results in the console
ENTRYPOINT R -e 'library(MosaicTX);print(example(CalculateAssociationsTable))'


