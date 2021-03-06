################################################################################
## mlr3 weighted observation
################################################################################
# Creating tasks and learners ---------------------------------------------
ml_task <-  mlr3::TaskRegr$new(id = "mtcars", backend = mtcars, target = "mpg")
ml_task$set_col_roles("wt", "weight")

# Training and predicting -------------------------------------------------
library(mlr3learners)
learner <- mlr3::mlr_learners$get("regr.lm")

learner$train(ml_task, row_ids = 01:30)
print(learner$model)

preds <- learner$predict(ml_task, row_ids = 31:32)
print(preds)

# DOESN'T WORK
# Error: Cannot rbind data to task 'mtcars', missing the following mandatory columns: wt
preds <- learner$predict_newdata(mtcars[31:32,], ml_task)

## WORKS
ml_task$set_col_role(ml_task$col_roles$weight, character(0))
preds <- learner$predict_newdata(mtcars[31:32,], ml_task)
preds <- learner$predict_newdata(mtcars[31:32,] %>% dplyr::select(-wt), ml_task)
