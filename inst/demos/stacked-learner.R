################################################################################
## Tuning a Stacked Learner
## <https://mlr3gallery.mlr-org.com/posts/2020-04-27-tuning-stacking/>
## <https://mlr3pipelines.mlr-org.com/>
################################################################################
# Setup -------------------------------------------------------------------
pkgload::load_all(export_all = TRUE)
library("mlr3")
library("mlr3pipelines")
task <- mlr3::TaskRegr$new(id = "mtcars", backend = datasets::mtcars, target = "mpg")


# Level 0 -----------------------------------------------------------------
# Create Learners
# <https://mlr3learners.mlr-org.com/>
requireNamespace("mlr3learners", quietly = TRUE)
learner_rf <- lrn("regr.ranger")
learner_lm <- lrn("regr.lm")
learner_svm <- lrn("regr.svm")


# Summarise steps into level 0
(
    ensemble <- list(
        PipeOpLearnerCV$new(learner_lm, id = "cv_lm"),
        PipeOpLearnerCV$new(learner_svm, id = "cv_svm"),
        PipeOpNOP$new(id = "original")
    )
    %>% gunion()
    %>>% PipeOpFeatureUnion$new(id = "union1")
    %>>% LearnerRegrAvg$new()
)
ensemble$plot(html = FALSE)


# Train Model
set.seed(2059)
learner_ensemble <- GraphLearner$new(ensemble)
learner_ensemble$train(task)
learner_ensemble$predict_newdata(mtcars)

