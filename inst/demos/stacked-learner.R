################################################################################
## Tuning a Stacked Learner
## <https://mlr3gallery.mlr-org.com/posts/2020-04-27-tuning-stacking/>
## <https://mlr3pipelines.mlr-org.com/>
################################################################################
# Setup -------------------------------------------------------------------
pkgload::load_all(export_all = TRUE)
library("mlr3")
library("mlr3pipelines")


# Instantiate ML ----------------------------------------------------------
task <- mlr3::TaskRegr$new(id = "mtcars", backend = datasets::mtcars, target = "mpg")


# Level 0 -----------------------------------------------------------------
# Create Learners
# <https://mlr3learners.mlr-org.com/>
requireNamespace("mlr3learners", quietly = TRUE)
learner_rf <- lrn("regr.ranger")
learner_lm <- lrn("regr.lm")
learner_svm <- lrn("regr.svm")


# Create the learner out-of-bag predictions
task_rf <- po("learner_cv", learner_knn, id = "rf")
task_lm <- po("learner_cv", learner_lm, id = "lm")
task_svm <- po("learner_cv", learner_svm, id = "svm")


# Summarise steps into level 0
(
    ensemble <- list(task_lm, task_svm, po("nop", id = "original"))
    %>% gunion()
    %>>% po("featureunion", id = "union1")
    %>>% LearnerRegrAvg$new()
)
ensemble$plot(html = FALSE)


# Train Model
learner_ensemble <- GraphLearner$new(ensemble)
learner_ensemble$train(task)
learner_ensemble$predict_newdata(mtcars)

