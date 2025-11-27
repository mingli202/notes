mrca <- function(n, replace) {
  generation <- 0

  # initialize the current generation
  current <- 1:n

  # initialize the empty list
  empty_list <- c()
  for (i in 1:n) {
    empty_list[[i]] <- vector()
  }

  while (TRUE) {
    generation <- generation + 1

    # initialize the parent generation
    # they all start with no descendants
    parent_generation <- empty_list

    # for each individual, we sample 2 parents
    for (i in 1:n) {
      # sample 2 parents of the current child
      parents_list <- unique(sample(1:n, 2, replace = replace))

      # for each parents, we add the individual to the new generation
      for (parent_index in parents_list) {
        # update the parent's descendants to include that of the child
        parent_generation[[parent_index]] <- union(parent_generation[[parent_index]], current[[i]])

        # if the parent has all individuals as descendants, we return the generation
        if (length(parent_generation[[parent_index]]) == n) {
          return(generation)
        }
      }
    }

    # after choosing 2 parents for each individual,
    # the previous next generation becomes the current generation
    # and the sampling begins again until a parent has all individuals as descendants
    current <- parent_generation
  }
}

# function that runs the simulation 25 times,
# and stores the results in a list and prints it
sim_25_times <- function() {
  ns <- c(200, 700, 1500, 4000, 8000)
  replace_false <- list()
  replace_true <- list()

  for (n in ns) {
    runs_false <- c()
    runs_true <- c()

    for (i in 1:25) {
      runs_false <- append(runs_false, mrca(n, replace = FALSE))
      runs_true <- append(runs_true, mrca(n, replace = TRUE))
    }

    replace_false[[paste("false_n", n, sep = "_")]] <- runs_false
    replace_true[[paste("true_n", n, sep = "_")]] <- runs_true
  }

  print(replace_false)
  print(replace_true)
}

# 2.6
# comparing replace true and replace false for high and low population size
difference <- function() {
  data <- list()
  ns <- c(3000, 300)

  # collec the data for large and small population
  for (n in ns) {
    runs_true <- c()
    runs_false <- c()

    for (i in 1:50) {
      print(paste(n, i))

      runs_true <- append(runs_true, mrca(n, replace = TRUE))
      runs_false <- append(runs_false, mrca(n, replace = FALSE))
    }

    data[[paste("replace_true", n, sep = "_")]] <- runs_true
    data[[paste("replace_false", n, sep = "_")]] <- runs_false
  }




  # H_o: u1 = u2
  # H_a: u1 != u2

  # for large population
  var1 <- var(data$replace_true_3000)
  var2 <- var(data$replace_false_3000)
  x_bar <- mean(data$replace_true_3000)
  y_bar <- mean(data$replace_false_3000)
  print(paste("x_bar:", x_bar, "y_bar:", y_bar, "var1:", var1, "var2:", var2))
  n <- 50

  # assuming H_o is true
  z <- (x_bar - y_bar) / sqrt(var1 / n + var2 / n)
  p_value <- 2 * pnorm(-abs(z))
  print(paste("z:", z, "p_value:", p_value))


  # for small population
  var1 <- var(data$replace_true_300)
  var2 <- var(data$replace_false_300)
  x_bar <- mean(data$replace_true_300)
  y_bar <- mean(data$replace_false_300)
  print(paste("x_bar:", x_bar, "y_bar:", y_bar, "var1:", var1, "var2:", var2))
  n <- 50

  # assuming H_o is true
  z <- (x_bar - y_bar) / sqrt(var1 / n + var2 / n)
  p_value <- 2 * pnorm(-abs(z))
  print(paste("z:", z, "p_value:", p_value))
}

possible_exploration <- function() {
  # Possible exploration
  # for a significance level of 0.05:
  p <- 1

  # run the simulation for different population sizes
  # until p < 0.05
  while (TRUE) {
    # run the simulation with decreasing population size
    # until p < 0.05
    for (n in 200:1) {
      replace_true <- c()
      replace_false <- c()

      for (i in 1:50) {
        replace_true <- append(replace_true, mrca(n, replace = TRUE))
        replace_false <- append(replace_false, mrca(n, replace = FALSE))
      }

      x_bar <- mean(replace_true)
      y_bar <- mean(replace_false)
      var1 <- var(replace_true)
      var2 <- var(replace_false)

      z <- (x_bar - y_bar) / sqrt(var1 / 50 + var2 / 50)
      p <- 2 * pnorm(-abs(z))
      print(paste(n, p))

      if (p < 0.05) {
        return(paste(n, p))
      }
    }
  }
}

system.time(mrca(4000, TRUE))
