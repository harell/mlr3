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


# Sample the data: Predefined Folds Re-sampling ---------------------------
set.seed(1)
n <- nrow(BreastCancer)

# Define folds externally
folds <- sample(1:5, size = n, replace = TRUE)
table(folds)

# Add folds to the data set and use it as grouping factor
# Instantiate a classification task
bc_task <- mlr3::TaskClassif$new(
    id = "BreastCancer",
    backend = BreastCancer %>% tibble::add_column(folds_id = folds, .before = 0),
    target = "Class",
    positive = "malignant"
)
bc_task$col_roles$group <- "folds_id"
# Remove "folds_id" from features
bc_task$col_roles$feature <- setdiff(bc_task$col_roles$feature, "folds_id")

# Instantiate a re-sampling task
rsample <- mlr3::rsmp("cv", folds = 5)
set.seed(123)
rsample$instantiate(bc_task)
rsample$instance

rsample$train_set(1)
rsample$test_set(1)
