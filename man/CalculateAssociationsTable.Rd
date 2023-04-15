\name{CalculateAssociationsTable}
\alias{CalculateAssociationsTable}

\title{
Estimate the associations between a set of mutations (binary outcomes) and CRISPR KO outcomes for a set of genes
}
\description{
The driver function to estimate the associations between the mutations and the CRISPR knock out data using the logistic regression model.
}
\usage{
CalculateAssociationsTable(mutations = NULL,
geneko = NULL, significanceLevel = 0.95,
KeyColName = "Model", seed = 123456)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{mutations}{
  A data frame of form NxM where rows and columns represent the gene mutations and cell lines respectively. See the examples for an instance of this data.
}
  \item{geneko}{
  A data frame of form MxP where rows and columns represent cell lines and CRISPER KO outcomes for genes respectively. See the examples for an instance of this data.
}
  \item{significanceLevel}{
  A value between 0 and 1. The significant level for testing the effects (coefficients) in the logistic regression. The default is 0.95
}
  \item{KeyColName}{
  The mutations columns must match the row in geneKo data frames based on this name. Used to merge the datasets.
}
  \item{seed}{
  Seed to ensure the reproducability of the results. Default 123456
}
}

\value{
The output is a matrix of associations between mutation lines and KO genes.
}
\references{
Dobson, A. J. (1990) An Introduction to Generalized Linear Models. London: Chapman and Hall.
}
\author{
Hamed Haseli Mashhadi <hamedhaseli@gmail.com>
}

\seealso{
\code{\link{glm}}
}
\examples{
# Loading data
# Mutations
mutations = read.delim(fileCon <-
                         system.file("extdata", "Mutations.tsv", package = "MosaicTX"),
                       sep = '\t')
# CRISPR KOs
geneko = read.delim(fileCon <-
                      system.file("extdata", "Gene_KOs.tsv", package = "MosaicTX"),
                    sep = '\t')

# See a glance of mutation data
head(mutations, 5)

# See a glance of CRISPER KO data
head(geneko, 5)

# Run the driver function to find the associations between mutations and the CRISPR KOs
MosaicTX::CalculateAssociationsTable(mutations = mutations, geneko = geneko)

}
