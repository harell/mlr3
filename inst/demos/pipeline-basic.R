################################################################################
## mlr3pipelines Tutorial - German Credit
## <https://mlr3gallery.mlr-org.com/posts/2020-03-11-mlr3pipelines-tutorial-german-credit/>
## <https://cheatsheets.mlr-org.com/mlr3pipelines.pdf>
################################################################################

# Setup -------------------------------------------------------------------
library(mlr3)
library(mlr3pipelines)
library(mlr3learners)
# future::plan("multiprocess", .cleanup = FALSE)

# Instantiate Task --------------------------------------------------------
## Load example
task = tsk("german_credit")

## Use only factors
credit_full = task$data()
credit = credit_full[, sapply(credit_full, FUN = is.factor), with = FALSE]

## Introduce NA values
set.seed(20191101)
credit = credit[, lapply(.SD, function(x) {
    x[sample(c(TRUE, NA), length(x), replace = TRUE, prob = c(.9, .1))]
})]
credit$credit_risk = credit_full$credit_risk

## Create task
task = TaskClassif$new(id = "GermanCredit", backend = credit, target = "credit_risk")


# Instantiate Resampling --------------------------------------------------
set.seed(20191101)
cv10_instance = rsmp("cv", folds = 10)$instantiate(task)


# Missing Value Imputation ------------------------------------------------
ranger = lrn("classif.ranger")
ranger$train(task)

#' We can perform imputation of missing values using a PipeOp. To find out which
#' imputation PipeOps are available, we do the following:
mlr_pipeops$keys("^impute")

#' We choose to impute factorial features using a new level (via
#' PipeOpImputeOOR)
imputer = po("imputeoor")
task_imputed = imputer$train(list(task))[[1]]
task_imputed$missings()
head(task_imputed$data())


