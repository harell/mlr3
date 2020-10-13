################################################################################
## mlr3 weighted observation
################################################################################
# Creating tasks and learners ---------------------------------------------
ml_task <-  mlr3::TaskRegr$new(id = "mtcars", backend = mtcars, target = "mpg")
ml_task$set_col_role(cols = "wt", new_roles = "weight", exclusive = FALSE)

# Training and predicting -------------------------------------------------
library(mlr3learners)
learner <- mlr3::mlr_learners$get("regr.lm")

learner$train(ml_task, row_ids = 01:30)
print(learner$model)

preds <- learner$predict(ml_task, row_ids = 31:32)
print(preds)

preds <- learner$predict_newdata(mtcars[31:32,] %>% dplyr::select(-wt) %>% tibble::add_column(wt = 1))
print(preds)


