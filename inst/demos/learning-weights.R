################################################################################
## mlr3 weighted observation
################################################################################
# Imports -----------------------------------------------------------------
TaskClassif <- mlr3::TaskClassif
Learner <- mlr3::Learner
mlr_learners <- mlr3::mlr_learners
mlr_measures <- mlr3::mlr_measures
as.data.table <- mlr3::as.data.table
lrn <- mlr3::lrn
rsmp <- mlr3::rsmp

# Setup -------------------------------------------------------------------
pkgload::load_all(export_all = TRUE)
# tasks, train, predict, resample, benchmark
library("mlr3")
# about a dozen reasonable learners
library("mlr3learners")

# Creating tasks and learners ---------------------------------------------
#' Let’s work on the canonical, simple iris data set, and try out some ML
#' algorithms. We will start by using a decision tree with default settings.
task <- TaskClassif$new(id = "iris", backend = datasets::iris, target = "Species")
print(task)
learner1 <- mlr_learners$get("classif.rpart")
print(learner1)

# Training and predicting -------------------------------------------------
#' Now the usual ML operations: Train on some observations, predict on others.
learner1$train(task, row_ids = 1:120)
print(learner1$model)

preds <- learner1$predict(task, row_ids = 121:150)
print(preds)

preds <- learner1$predict_newdata(newdata = iris[121:150, ])
print(preds)

# Evaluation --------------------------------------------------------------
(
    mlr_measures
    %>% as.data.table()
    %>% dplyr::filter(task_type %in% "classif", task_properties %not_in% "twoclass")
    %>% head(Inf)
)

"classif.acc" %>% mlr_measures$get() %>% preds$score() %>% print()
c("classif.acc", "classif.ce") %>% mlr_measures$mget() %>% preds$score() %>% print()
preds$confusion %>% print()

# Changing hyperpars ------------------------------------------------------
#' The learner contains information about all parameters that can be configured,
#' including data type, constraints, defaults, etc. We can change the
#' hyperparameters either during construction of later through an active
#' binding.
print(learner1$param_set)
learner2 <- lrn("classif.rpart", predict_type = "prob", minsplit = 50)
learner2$param_set$values$minsplit <- 50

# Resampling / Cross-validation -------------------------------------------
#' Resampling simply repeats the train-predict-score loop and collects all
#' results in a nice data.table.
cv10 <- rsmp("cv", folds = 10)
predict_cv <- resample(task, learner1, cv10)
print(predict_cv)

# Installing more learners from mlr3’s GitHub learner org -----------------
c("classif.acc", "classif.ce") %>% mlr_measures$mget() %>% predict_cv$score() %>% print()
predict_cv$data %>% print()
predict_cv$prediction() %>% as.data.table() %>% dplyr::arrange(row_id) %>% head() %>% print()

# Populating the learner dictionary ---------------------------------------
# browseURL("https://github.com/mlr3learners/")
# remotes::install_github("mlr3learners/mlr3learners.randomforest")
library(mlr3learners.randomforest)

# Benchmarking, to compare multiple learners ------------------------------
#' The benchmark() function can conveniently compare learners on the same
#' dataset(s).
learners <- list(learner1, learner2, lrn("classif.randomForest"))
bm_grid <- mlr3::benchmark_grid(task, learners, cv10)
bm <- mlr3::benchmark(bm_grid)
c("classif.acc", "classif.ce") %>% mlr_measures$mget() %>% bm$aggregate() %>% print()
