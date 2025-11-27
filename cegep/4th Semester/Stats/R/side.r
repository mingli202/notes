simulate <- function(n, replace = TRUE) {
  gen <- 0
  s <- sum(1:n)

  # initialize empty list of all 0 because we need a value for each element
  # otherwise we get an error
  empty_list <- c()

  # initialize the current generation
  current <- 1:n

  # populate both lists
  for (i in 1:n) {
    empty_list[[i]] <- vector()
  }

  # the previous generation is the generation of parents
  previous <- empty_list

  pop <- 1:n

  repeat {
    gen <- gen + 1

    # for each individual, we sample 2 parents
    for (i in pop) {
      # sample 2 parents
      parents <- unique(sample(pop, 2, replace = replace))

      # for each parents, we add the individual to the new generation
      for (p in parents) {
        # new is an array of descendants
        new <- union(previous[[p]], current[[i]])

        # check if the parent has all the individuals from the first generation
        # if so then immediately return the generation count
        if (sum(new) == s) {
          return(gen)
        }

        # update the parent generation
        previous[[p]] <- new
      }
    }

    # after choosing 2 parents for each individual,
    # the previous generation becomes the current generation
    # and the sampling begins again until a parent has all individuals as descendants
    current <- previous
    previous <- empty_list
  }
}

system.time(simulate(5000))


diff <- function() {
  d <- list()
  ns <- c(2000, 200)

  for (n in ns) {
    runs_true <- c()
    runs_false <- c()

    for (i in 1:50) {
      print(paste(n, i))

      runs_true <- append(runs_true, simulate(n, replace = TRUE))
      runs_false <- append(runs_false, simulate(n, replace = FALSE))
    }

    d[[paste("replace_true", n, sep = "_")]] <- runs_true
    d[[paste("replace_false", n, sep = "_")]] <- runs_false
  }

  write.csv(d, "./diff.csv")
}
