test_that("wastdr_msg_abort works", {
  expect_error(wastdr_msg_abort("This is an error!"))
})

test_that("wastdr_msg_warn works", {
  expect_warning(wastdr_msg_warn("This is a warning!", verbose = TRUE))

  expect_null(wastdr_msg_warn("This is a warning!", verbose = FALSE))
})

test_that("wastdr_msg_noop works", {
  expect_message(wastdr_msg_noop("This is a noop message!", verbose = TRUE))
  expect_null(wastdr_msg_noop("This is a noop message!", verbose = FALSE))
})

test_that("wastdr_msg_info works", {
  expect_message(wastdr_msg_info("This is an info!", verbose = TRUE))
  expect_null(wastdr_msg_info("This is an info!", verbose = FALSE))
})

test_that("wastdr_msg_successworks", {
  expect_message(wastdr_msg_success("This is a success message!", verbose = TRUE))
  expect_null(wastdr_msg_success("This is a success message!", verbose = FALSE))
})
