context("Setting environment variables")

test_that("variables are loaded into the session.", {
  load_vars("test.sh")
  expect_equal(Sys.getenv("FOO"), "FOO")
  expect_equal(Sys.getenv("DATADIR"), "~/FOO/data")
})
