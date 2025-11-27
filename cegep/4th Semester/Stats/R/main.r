# simulate Time for Most Recent Common Ancestor (TMCRA)
# n: population size
simulate <- function(n, replace = TRUE) {
  gen <- 0

  # initialize the current generation
  current <- 1:n

  # initialize empty list of all 0 because we need a value for each element
  # otherwise we get an error
  empty_list <- c()

  # initialize the empty list
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
        if (length(new) == n) {
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


# function that runs the simulation 25 times,
# and stores the results in a list and prints it
sim <- function() {
  ns <- c(500, 1000, 2000, 4000, 7000, 10000)
  replace_false <- list()
  replace_true <- list()

  for (n in ns) {
    runs_false <- c()
    runs_true <- c()

    for (i in 1:25) {
      runs_false <- append(runs_false, simulate(n, replace = FALSE))
      runs_true <- append(runs_true, simulate(n, replace = TRUE))
    }

    replace_false[[paste("n", n, sep = "_")]] <- runs_false
    replace_true[[paste("n", n, sep = "_")]] <- runs_true
  }

  write.csv(replace_false, "./replaceFalse.csv")
  write.csv(replace_true, "./replaceTrue.csv")
}

# comparing replace true and replace false for high and low population size
diff <- function() {
  data <- list()
  ns <- c(2000, 200)

  for (n in ns) {
    runs_true <- c()
    runs_false <- c()

    for (i in 1:50) {
      print(paste(n, i))

      runs_true <- append(runs_true, simulate(n, replace = TRUE))
      runs_false <- append(runs_false, simulate(n, replace = FALSE))
    }

    data[[paste("replace_true", n, sep = "_")]] <- runs_true
    data[[paste("replace_false", n, sep = "_")]] <- runs_false
  }


  write.csv(data, "./diff.csv")
}

hypothesis <- function() {
  data <- read.csv("./diff.csv")

  # H_o: u1 = u2
  # H_a: u1 != u2

  # for large population
  x_bar <- mean(data$replace_true_2000)
  y_bar <- mean(data$replace_false_2000)
  var1 <- var(data$replace_true_2000)
  var2 <- var(data$replace_false_2000)
  print(paste("x_bar:", x_bar, "; y_bar:", y_bar, "; var_1:", var1, "; var_2:", var2))
  n <- 50

  # assuming H_o is true
  z <- (x_bar - y_bar) / sqrt(var1 / n + var2 / n)
  p_value <- 2 * pnorm(-abs(z))
  print(paste("z:", z, "; p_value:", p_value))


  # for small population
  x_bar <- mean(data$replace_true_200)
  y_bar <- mean(data$replace_false_200)
  var1 <- var(data$replace_true_200)
  var2 <- var(data$replace_false_200)
  print(paste("x_bar:", x_bar, "; y_bar:", y_bar, "; var_1:", var1, "; var_2:", var2))
  n <- 50

  # assuming H_o is true
  z <- (x_bar - y_bar) / sqrt(var1 / n + var2 / n)
  p_value <- 2 * pnorm(-abs(z))
  print(paste("z:", z, "; p_value:", p_value))
}

possible_exploration <- function() {
  # Possible exploration
  # for a significance level of 0.05:
  p <- 1

  repeat {
    # run the simulation with decreasing population size
    # until p < 0.05
    for (n in 200:1) {
      replace_true <- c()
      replace_false <- c()

      for (i in 1:50) {
        replace_true <- append(replace_true, simulate(n, replace = TRUE))
        replace_false <- append(replace_false, simulate(n, replace = FALSE))
      }

      x_bar <- mean(replace_true)
      y_bar <- mean(replace_false)
      var1 <- var(replace_true)
      var2 <- var(replace_false)

      z <- (x_bar - y_bar) / sqrt(var1 / 50 + var2 / 50)
      p <- 2 * pnorm(-abs(z))
      print(paste(n, p))

      # stop when p < 0.05
      if (p < 0.05) {
        return(n)
      }
    }
  }
}

system.time(simulate(4000))
