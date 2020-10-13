################################################################################
## mlr3 weighted observation
################################################################################
# Imports -----------------------------------------------------------------
MachineLearningTask <- mlr3::TaskRegr
mlr_learners <- mlr3::mlr_learners

# Setup -------------------------------------------------------------------
pkgload::load_all()

# Creating tasks and learners ---------------------------------------------
ml_task <- MachineLearningTask$new(id = "mtcars", backend = datasets::mtcars, target = "mpg")
learner <- mlr_learners$get("regr.lm")

# Training and predicting -------------------------------------------------
#' Now the usual ML operations: Train on some observations, predict on others.
learner$train(ml_task, row_ids = 01:30)
print(learner$model)

preds <- learner$predict(ml_task, row_ids = 31:32)
print(preds)

preds <- learner$predict_newdata(mtcars[31:32,])
print(preds)
