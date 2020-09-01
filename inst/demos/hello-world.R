################################################################################
## mlr3 basics on “iris” - Hello World!
## <https://mlr3gallery.mlr-org.com/posts/2020-03-18-iris-mlr3-basics/>
################################################################################
# Imports -----------------------------------------------------------------
TaskClassif <- mlr3::TaskClassif
mlr_learners <- mlr3::mlr_learners
mlr_measures <- mlr3::mlr_measures
as.data.table <- mlr3::as.data.table


# Setup -------------------------------------------------------------------
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


# Resampling / Cross-validation -------------------------------------------


# Installing more learners from mlr3’s GitHub learner org -----------------



# Benchmarking, to compare multiple learners ------------------------------


