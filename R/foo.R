# foo --------------------------------------------------------------------------
#
#' @title Compose a Message with an Entity Name and Age
#'
#' @description Given \code{name} and \code{age}, when \code{foo} is
#'   called, then a string with that entity details is composed and returned.
#'
#' @param name (`character`) The name of the entity.
#' @param age (`numeric`) The age of the entity.
#'
#' @return (`character`) A string with the entity's details.
#' @export
#'
#' @examples
#' \dontrun{
#' msg <- foo('Earth', 4.543e9)
#' message(msg)
#' }
#'
foo <- function(name, age){
    msg_name <- "`name` should be a non empty string"
    msg_age <- "`age` should be a positive and finite number"
    assertthat::assert_that(isFALSE(missing(name)), isFALSE(is.null(name)), is.character(name), nchar(name) > 0, length(name) == 1, msg = msg_name)
    assertthat::assert_that(isFALSE(missing(age)), is.numeric(age), length(age) == 1, is.finite(age), age > 0, msg = msg_name)

    age <- format(age, scientific = FALSE)
    msg <- paste(name, 'is', age, 'years old')

    return(msg)
}


