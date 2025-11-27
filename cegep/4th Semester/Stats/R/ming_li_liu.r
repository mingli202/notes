# Ming Li Liu
# 2242250

# Exercise 1 -----------------------------------

# a
# i
die <- 1:12 # possibe values of a die
s1 <- sample(die, 500, replace = TRUE) # take a sample of 500 rolls
# table gets the frequency of unique entries
t <- table(s1)
pie(t) # make a pie chart

# ii
die <- 1:12 # possibe values of a die
p <- c(3 / 14, rep(1 / 14, 11)) # probability vector

s2 <- sample(die, 500, replace = TRUE, prob = p) # take sample of unfair die
barplot(table(s2)) # make a bar plot

# iii
# two independent samples to add them up
die <- 1:12 # possibe values of a die
d1_sample <- sample(die, 10000, replace = TRUE)
d2_sample <- sample(die, 10000, replace = TRUE)

# add respective rolls to get sum of roll
pairs <- sample(d1_sample + d2_sample, 10000, replace = TRUE)
t <- table(pairs)

# 9th element is 'sum equal 10' entry
t[[9]] / 10000 # 0.0658

# theoretical probability
9 / 144 # 0.0625


# b
# i
play_lotto <- function() {
  n <- 0 # n times
  draw <- rep(0, 6) # initialize it
  ticket <- c(1, 3, 4, 5, 6, 8) # your ticket

  # randomize draw and loop until you get your ticket
  while (!all(ticket == draw)) {
    n <- n + 1 # increase the number of times played

    # sort the draw because order doesn't matter
    draw <- sort(sample(1:49, 6))
  }

  return(n) # returns number of times played
}

# ii
# changed draw length to 3 instead of 6
play_lotto_three <- function() {
  n <- 0
  draw <- rep(0, 3)
  ticket <- c(1, 3, 4)

  while (!all(ticket == draw)) {
    n <- n + 1
    draw <- sort(sample(1:49, 3))
  }

  return(n)
}

# iii
# play 3/49 100 times
sum <- 0
for (i in 1:100) {
  sum <- sum + play_lotto_three()
}
sum / 100 # average is 17425.18

# iv
# play 6/49 1 times
# took 117.93 seconds
# played 6 582 983 times
play_lotto()

# v
6582983 / 52 # 126 596 years

# vi
16000000 - 6582983 * 3 # -3 748 949$



# Exercise 2 -----------------------------------
# a
generate_flips <- function(n) {
  # make sample of n coin flips
  return(sample(0:1, n, replace = TRUE))
}

# b
run_all <- function(v) {
  # get sequence flips v
  # append -1 to ensure last sequence is properly counted
  # instead of checking for the condition once more after the loop
  flips <- append(v, -1)

  last <- -1
  heads <- c()
  tails <- c()
  counter <- 0

  for (flip in flips) {
    # check if the current is part of the sequence behind
    if (flip != last) {
      # append the sequence's length to its corresponding flip
      if (last == 0) {
        heads <- append(heads, counter)
      } else if (last == 1) {
        tails <- append(tails, counter)
      }
      # reset counter
      counter <- 1
      # update sequence
      last <- flip
    } else {
      counter <- counter + 1
    }
  }

  return(list(heads = heads, tails = tails))
}

# c
longest_runs <- c()
for (i in 1:10000) {
  # get sequence of heads and tails and store it into a variable
  s <- run_all(generate_flips(200))

  # get the max between the heads and tails vector
  longest_runs <- append(longest_runs, max(s$heads, s$tails))
}

# d
# freq = false makes the frequencies relative
# seq() ensures that the increment is 1 no matter what
hist(longest_runs, freq = FALSE, breaks = seq(1, 30, 1))


# e
generate_flips <- function(n) {
  # make sample of n coin flips
  return(sample(0:1, n, replace = TRUE, prob = c(1 / 3, 2 / 3)))
}

longest_heads_runs <- c()
longest_tails_runs <- c()
for (i in 1:10000) {
  s <- run_all(generate_flips(200))
  longest_heads_runs <- append(longest_heads_runs, max(s$heads))
  longest_tails_runs <- append(longest_tails_runs, max(s$tails))
}

# f
hist(longest_heads_runs, freq = FALSE, breaks = seq(1, 30, 1))
hist(longest_tails_runs, freq = FALSE, breaks = seq(1, 30, 1))



# Exercise 3 -----------------------------------
# a
simulate_moran <- function(n) {
  generations <- 0

  # vector where [1] is num of standards and [2] is num of mutants
  population <- c(n - 1, 1)

  # run until one side dominates the other
  while (population[1] != 0 && population[2] != 0) {
    dead_person <- sample(
      # vector representing the index of the dead person
      c(1, 2), 1,

      # taking a random person in the population is the same as
      # choosing between 2 values with corresponding probabillities
      prob = c(population[1] / n, population[2] / n)
    )
    # decrement the right side
    population[dead_person] <- population[dead_person] - 1

    # same thing as above but for the person to replace
    replace_person <- sample(
      c(1, 2), 1,
      # since one person died, it's over n - 1 instead of n
      prob = c(population[1] / (n - 1), population[2] / (n - 1))
    )
    population[replace_person] <- population[replace_person] + 1

    generations <- generations + 1
  }

  return(list(
    generations = generations,
    take_over = if (population[2] == 0) "standards" else "mutants"
  ))
}

# b
data <- list(gen = 0, standards = 0, mutants = 0)

times <- 10000 # run the simulation 10 000 times
for (i in 1:times) {
  res <- simulate_moran(100)
  # update the sum of generations
  data$gen <- data$gen + res$generations
  # update the amount of times a sides has taken over
  data[[res$take_over]] <- data[[res$take_over]] + 1
}

# percentage of mutants
print(100 * data$mutants / times) # 0.95%
# mean of generations
print(data$gen / times) # 524.0682


# Exercise 4 -----------------------------------

# a
m <- 33357600 # total participants
n <- 5559600 # winning participants
k <- 8000 # sample size
x <- 1299 # number of winners drawn

# probability that less than 1300 won
phyper(x, n, m - n, k) # 0.1549954
sum(dhyper(1:x, n, m - n, k)) # 0.1549954


# b
x <- 2400
lambda <- 29 * 82

# probability that at least 2400 shots are made
1 - ppois(x, lambda) # 0.3212928
1 - sum(dpois(1:x, lambda)) # 0.3212928


# bonus
# permutation function
permute <- function(n) {
  # probability that everyone has different birthdays
  p <- 1

  # instead of using the formula with factorials,
  # I use the derivation instead since factorial of big numbers gives NaN
  # first person has 365 possible choices
  # second has 364, third has 363, etc
  # the product is then divided by 365 ^ n to get the probability
  # thus: p = (365 * 364 * 363 ... * 365 - (n - 1)) / 365 ^ n
  for (i in 365:(365 - n + 1)) {
    p <- p * (i / 365)
  }

  # the complement of 'everyone different birthday'
  # is 'at least 2 people have the same birthday'
  return(1 - p)
}

x <- 1:100 # p(x) for x > 100 is very close to 1 (according to R)
plot(x, lapply(x, permute),
  main = "Probability that at least 2 people have the
  same birthday in a group of N people",
  ylab = "P(X >= 2)",
  xlab = "N people in the group"
)
