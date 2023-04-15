# install R on ubunto
Sudo apt install r-base-core
# Install R package
Rscript -e 'install.packages("devtools")'
Rscript -e 'library(devtools);install_github("HaMar65/MosaicTX")'
Rscript -e 'library(MosaicTX);example(CalculateAssociationsTable)'
