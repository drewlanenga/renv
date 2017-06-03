context("Setting environment variables")


test_that("variables are loaded into the session.", {
  # keep names of pre-existing variables so we can
  # remove the others afterward
  existing <- names(Sys.getenv())

  vars <- load_vars("test.sh")
  expect_equal(Sys.getenv("RULES"), "RULES")
  expect_equal(Sys.getenv("DATADIR"), "~/RULES/data")
  expect_equal(vars$trailing, "comment")
  expect_equal(Sys.getenv("hidden"), "")
  expect_equal(vars$thing1, "thing2")
  expect_equal(Sys.getenv("odoyle"), "ODOYLE")

  # reset new variables to give other tests a new slate
  for(name in names(vars)[!(names(vars) %in% existing)]) {
    .Internal(Sys.setenv(name, ""))
  }
})
