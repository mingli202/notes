compute <- function(N) {
  n <- 0
  prev_gen <- 1:N
  empty_list <- c()
  for (i in 1:N) {
    empty_list[[i]] <- vector()
  }


  while (TRUE) {
    n <- n + 1

    new_gen <- empty_list

    parent_list <- c()

    # (n)
    for (i in 1:N) {
      parent_list[[i]] <- sample(1:N, 2, replace = FALSE)
      for (k in 1:2) {
        parent_index <- parent_list[[i]][k]
        new_gen[[parent_index]] <- union(new_gen[[parent_index]], prev_gen[[i]])
        if (length(new_gen[[i]]) == N) {
          return(n)
        }
      }
    }

    prev_gen <- new_gen
  }
}

system.time(compute(4000))
