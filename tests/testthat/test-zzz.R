context("unit test for package hooks")

# onAttach ----------------------------------------------------------------
test_that("Global options are defined", {
    err_msg <- "onAttach did not load config-r.yml"
    expect_true(identical(is.null(.Options$path_inst), FALSE), info = err_msg)
})

# hook for test coverage --------------------------------------------------
if(Sys.getenv("R_COVR") == "true")
    test_that("component-tests", {
        path <- file.path(dirname(getwd()), "component-tests")
        testthat::test_dir(path)
    })
