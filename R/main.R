swapRowsAndColumnsInaDF = function (x, ModelsColName = 'Model') {
  x = data.frame(t(x))
  names(x) = x[1,]
  x = x[-1,]
  x[, ModelsColName] = rownames(x)
  rownames(x) = NULL
  return(x)
}

makeFolds = function(x, y, nfold = 5) {
  fold0 <- sample.int(sum(y == 0)) %% nfold
  fold1 <- sample.int(sum(y == 1)) %% nfold
  foldid <- numeric(length(y))
  foldid[y == 0] <- fold0
  foldid[y == 1] <- fold1
  foldid <- foldid + 1
  return(foldid)
}

unittest = function(iteration = 1000,
                    ngene = 15,
                    nmut = 10,
                    high=30,
                    low=3,
                    seed = 123456) {
  set.seed(seed)
  testresult = c()

  # Run the function under 100 different scenarios
  # There must  be less than 5% change of making any error
  for (i in 1:1000) {
    message('Test ', i, ' from ', iteration)
    # Create random mutation data with 20 genes and 10 cell lines
    mutations = as.data.frame(matrix(sample(
      0:1, size = nmut ^ 2, replace = TRUE
    ), ncol = nmut))
    colnames(mutations) = paste0('Model', 1:nmut)
    mutations = cbind('Mutation' = paste0('Gene_', 1:nmut, '_mut'), mutations)

    # create random matrix for the Gene KOs
    geneko = as.data.frame(matrix(runif(
      ngene * nmut, runif(1, -high, -low), runif(1, low, high)
    ), nrow = nmut))
    colnames(geneko) = paste0('Gene_', LETTERS[1:ngene], '_mut')
    geneko = cbind('Model' = paste0('Model', 1:nmut), geneko)

    # The output must show no associations at all
    testout = CalculateAssociationsTable(mutations = mutations, geneko = geneko)

    testresult = c(testresult, unique(as.vector(testout)))

  }

  table(testresult)
}

CalculateAssociationsTable = function(mutations = NULL,
                                      geneko = NULL,
                                      significanceLevel = .95,
                                      KeyColName = 'Model',
                                      seed = 123456) {
  set.seed(123456)

  # Prepare the data
  mutations = swapRowsAndColumnsInaDF(mutations, ModelsColName = KeyColName)

  # Check for mismatches in the data sets
  if (any(!is.null(setdiff(mutations$Model, geneko$Model)), !is.null(setdiff(geneko$Model, mutations$Model)))) {
    message(
      '--> Attention! Two datasets differe in the number of models, ',
      setdiff(mutations$Model, geneko$Model),
      ',',
      setdiff(geneko$Model, mutations$Model)
    )
  }

  # Merge two data sets and create the driver dataset
  driverData = merge(
    mutations,
    geneko,
    by = KeyColName,
    all = FALSE,
    suffixes = c('Mutations', 'CRISPR')
  )

  # Create X and Y matrices
  X = driverData[, names(driverData) %in% names(geneko) &
                   !names(driverData) %in% KeyColName]
  Y = driverData[, names(driverData) %in% names(mutations) &
                   !names(driverData) %in% KeyColName]

  # Loop though the mutations and perform logistic regression
  message('--> Processing mutation lines ...')
  for (i in 1:ncol(Y)) {
    message('\t--> Processing ', names(Y)[i])

    data = cbind(Y = as.numeric(Y[, i]), X)
    # Apply logistic model
    suppressWarnings({
      logiR =  glm(Y ~ ., family = binomial(link = "logit"), data = data)
    })

    # Store the results
    if (i <= 1) {
      OutputMatrix = summary(logiR)$coefficients[, 4]

    } else{
      OutputMatrix = cbind(OutputMatrix, summary(logiR)$coefficients[, 4])
    }
  }

  #Postprocess the results
  OutputMatrix = as.data.frame(OutputMatrix)
  names(OutputMatrix) = names(Y)
  OutputMatrix = OutputMatrix[-1, ]
  OutputMatrix = apply(OutputMatrix, 2, function(x) {
    x[x < (1 - significanceLevel)] = 'Associated found'
    x[x >= (1 - significanceLevel)] = 'No Asscociation found'
    return(x)
  })


  return(OutputMatrix)
}
