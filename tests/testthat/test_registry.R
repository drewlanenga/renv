context("Storing and retrieving environment variables")

test_that("variable registry loads default variables.", {
  r <- registry$new()
  expect_gt(length(r$vars), 0)
})

test_that("variable registry gets and sets new variables.", {
  r <- registry$new()

  nvars <- length(r$vars)
  r$set("foo", "bar")
  expect_equal(r$get("foo"), "bar")
  expect_equal(length(r$vars), nvars + 1)
})

test_that("variable registry evaluates variable references.", {
  r <- registry$new()

  r$set("foo", "$bar")
  r$set("bar", "foo")

  # the reference to bar in the foo definition should be evaluated
  # after the value of bar is defined
  expect_equal(r$get("foo"), "foo")
})

test_that("variable registry does not get stuck.", {
  r <- registry$new()

  r$set("foo", "$bar")
  r$set("bar", "$foo")

  # the circular definition of foo and bar should not cause
  # the evaluation to spiral
  expect_equal(r$get("foo"), "$bar")
})

test_that("undefined variables remain unevaluated.", {
  r <- registry$new()

  r$set("wat", "$wat")
  expect_equal(r$get("wat"), "$wat")
})
