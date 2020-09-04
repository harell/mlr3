################################################################################
## Block & Predefined Folds Re-sampling
## <https://mlr3gallery.mlr-org.com/posts/2020-03-30-stratification-blocking/>
################################################################################
# Setup -------------------------------------------------------------------
pkgload::load_all(export_all = TRUE)
# tasks, train, predict, resample, benchmark
library("mlr3")


# Get the data ------------------------------------------------------------
data(BreastCancer, package = "mlbench")
skimr::skim(BreastCancer)
#' Let's count how many observation actually have the same Id more than once
sum(table(BreastCancer$Id) > 1)
#' There are 46 Id’s with more than one observation (row).

# Sample the data: Block Re-sampling --------------------------------------
# Instantiate a classification task
bc_task <- mlr3::TaskClassif$new(
    id = "BreastCancer",
    backend = BreastCancer,
    target = "Class",
    positive = "malignant"
)
# Use Id column as block factor
bc_task$col_roles$group <- "Id"
# Remove Id from feature
bc_task$col_roles$feature <- setdiff(bc_task$col_roles$feature, "Id")
# Instantiate a re-sampling task
rsample <- mlr3::rsmp("cv", folds = 5)
# Sample the data
set.seed(123)
bc_task %>% rsample$instantiate()
rsample$instance


# Sample the data: Predifined Folds Re-sampling ---------------------------


