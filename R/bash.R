
#' A registry contains a list of all currently defined environment variables,
#' with utilities for evaluating references to other variables.  Not meant
#' for external usage.
#'
#' @field vars A named list of environment variables.
#' @field export_pattern Regular expression for finding export statements in bash files.
#' @field var_pattern Regular expression for identifying variable references.

registry <- setRefClass("registry",
	fields = list(
		vars = "list",
		export_pattern = "character",
		var_pattern = "character"
	),
	methods = list(
		initialize = function() {
			"Create a new registry and initialize vars to all variables from current session."
			vars <<- lapply(Sys.getenv(), identity)

			export_pattern <<- "^export " # line starts with `export `.  ignores commented lines.
			var_pattern <<- "(\\$[A-z0-9]{1,})" # alphanumeric name, with leading dollar
		},
		set = function(k, v) {
			"Add a new variable to the registry, and evaluate for references to other variables."
			vars[[k]] <<- .self$evaluate(v)

			# find candidates for reevaluation
			reevaluate <- stringr::str_which(vars, k)
			lapply(names(vars)[reevaluate], function(key){
					vars[[key]] <<- .self$evaluate(vars[[key]])
			})
		},
		get = function(k) {
			"Retrieve the value of a variable."
			return(vars[[k]])
		},
		evaluate = function(v) {
			"Evaluate the value of the variable."
			matches <- stringr::str_extract_all(v, var_pattern) %>% unlist()
			for(match in matches) {
				raw.match <- stringr::str_replace(match, "\\$", "")
				replacement <- ifelse(!is.null(.self$get(raw.match)), .self$get(raw.match), match)
				v <- stringr::str_replace_all(v, paste0("\\", match), replacement) # escape the dollar
			}
			return(stringr::str_replace(v, ";$", "")) # strip trailing semicolons
		},
		load = function(bash_file) {
			"Load a bash file and set all exported variables."
			raw.vars <- readLines(bash_file) %>%
				stringr::str_subset(export_pattern) %>% # filter out non-environment variables
				stringr::str_replace_all(export_pattern, "") %>% # replace the export pattern
				stringr::str_replace_all("\"", "") %>% # replace any quotes in the value
				stringr::str_split("=", 2) %>% # split on the first equals
				lapply(function(kv) {
					if(length(kv) == 2) {
						.self$set(kv[1], kv[2]) # add the variable to the registry
					}
				})
			return(NULL)
		}
	)
)

#' Load environment variables into the current R session
#'
#' \code{load_vars} reads the contents of a bash file, loads,
#' evaluates and sets environment variables in the current R session.
#'
#' @param bash_file A connection object or character string to pass to \code{readLines}.
#' @export
load_vars <- function(bash_file) {
	r <- registry$new()
	r$load(bash_file)

	# set the environment variables
	lapply(names(r$vars), function(k){
		.Internal(Sys.setenv(k, r$get(k)))
	})

	invisible(r)
}
