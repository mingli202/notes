# Exercise 1: Simulating Probabilities

# (a) Rolling a die!

# (i) Simulate rolling a fair 12-sided die 500 times. Generate a pie chart of the results.

# Set the number of rolls to 500
num_rolls <- 500

# Simulate rolling a fair 12-sided die 500 times
die_rolls <- sample(1:12, num_rolls, replace = TRUE)

# Generate a table of the results
roll_table <- table(die_rolls)

# Generate a pie chart of the results
pie(roll_table, main = "Results of Rolling a 12-Sided Die 500 Times")

# (ii) Simulate rolling an unfair 12-sided die 500 times, where rolling a 1 is three times more likely to occur than
# the rest of the outcomes. Generate a pie chart of the results.

# Set the number of rolls to 500
num_rolls <- 500

# Define the probabilities of each outcome
probs <- rep(1 / 12, 12)
probs[1] <- 3 / 12

# Simulate rolling the unfair die 500 times
die_rolls <- sample(1:12, num_rolls, replace = TRUE, prob = probs)

# Generate a table of the results
roll_table <- table(die_rolls)

# Generate a bar graph of the results
barplot(roll_table, main = "Results of Rolling an Unfair 12-Sided Die 500 Times")

# (iii).

# Set the number of rolls to 10000
num_rolls <- 10000

# Simulate rolling two 12-sided dice 10000 times
die_1 <- sample(1:12, num_rolls, replace = TRUE)
die_2 <- sample(1:12, num_rolls, replace = TRUE)

# Calculate the sum of each roll
roll_sums <- die_1 + die_2

# Estimate the probability of getting a sum of 10
prob_estimate <- sum(roll_sums == 10) / num_rolls

# Print the estimated probability
# paste make everything into a single string
paste("Estimated probability of getting a sum of 10:", prob_estimate, "\n")
# Estimated probability of getting a sum of 10: 0.0623

# Calculate the exact theoretical probability
prob_exact <- sum(table(factor(10 - 1:12, levels = 1:12))) / 12^2

# Print the exact theoretical probability
paste("Exact theoretical probability of getting a sum of 10:", prob_exact, "\n")
# Exact theoretical probability of getting a sum of 10: 0.0625

# (b) Playing the lottery!

# (i) Complete the following code of a function that simulates playing the lotto 6/49 with the same ticket until
# you win the jackpot. You have to insert code where it says HERE.

play_lotto <- function() {
  n <- 0
  ticket <- c(1, 2, 3, 4, 5, 6)
  draw <- c(0, 0, 0, 0, 0, 0)

  while (!all(ticket == draw)) {
    n <- n + 1
    draw <- sort(sample(1:49, 6))
  }

  return(n)
}

# (ii) To test the code, first modify it so that it simulates the lotto 4/49 (sample of 4 numbers instead of 6). It
# should complete faster, and help you debug any problems you may have.

play_lotto_3 <- function() {
  n <- 0
  ticket <- c(1, 2, 3)
  draw <- c(0, 0, 0)

  while (!all(ticket == draw)) {
    n <- n + 1
    draw <- sort(sample(1:49, 3))
  }

  return(n)
}

# (iii) Run your play lotto three function a 100 times, and find the mean.
sum <- 0
for (i in 1:100) {
  sum <- sum + play_lotto_3()
}

mean <- sum / 100
paste("The mean is", mean)
# The mean is 19415.38

# (iv) Run the code for the lotto 6/49 once. The value returned by the function gives the number of times you had to play before winning the jackpot. The code will probably take several minutes to terminate, so be patient.
t <- play_lotto()
paste("The number of times you had to play before winning the lottery is", t)
# The number of times you had to play before winning the lottery is 8 236 946

# (iv) Assuming you play once a week, how many years did it take before winning the jackpot?
paste(8236946 / 52, "years") # 158 402 years

# (v) net income
paste("net profit of", 16000000 - 8236946 * 3)
# net profit of -8 710 838$




# Exercise 2: Coin tossing statistics

# (a) Write a simple function that generates a random sequence of 0’s and 1’s of length k.
generate_flips <- function(k) {
  # make sample of n coin flips
  return(sample(0:1, k, replace = TRUE))
}

# (b) A run of heads or run of tails is a subsequence of consecutive heads or tails, respectively.
run_all <- function(coin_tossing_seq) {
  current <- coin_tossing_seq[1]
  heads <- c()
  tails <- c()
  counter <- 0

  for (flip in coin_tossing_seq) {
    # check if the current is part of the sequence behind
    if (flip == current) {
      counter <- counter + 1
    } else {
      # append the sequence's length to its corresponding flip
      if (current == 0) {
        heads <- append(heads, counter)
      } else if (current == 1) {
        tails <- append(tails, counter)
      }
      # reset counter
      counter <- 1
      # update sequence
      current <- flip
    }
  }

  # properly add in the last sequence
  if (current == 0) {
    heads <- append(heads, counter)
  } else if (current == 1) {
    tails <- append(tails, counter)
  }

  return(list(heads = heads, tails = tails))
}

# (c) Simulate an experiment of generating n = 10000 coin tossing sequences of length 200 by using a for loop.
longest_runs <- c()
for (i in 1:10000) {
  # get the sequence of heads and tails and store it into a variable
  s <- run_all(generate_flips(200))

  # get the max between the heads and tails vector
  longest_runs <- append(longest_runs, max(s$heads, s$tails))
}

# (d) Create a histogram and calculate relative frequencies from the array longest runs. Compare the relative frequencies obtained with the probabilities listed in the table at the end of this document.

# freq = false makes the frequencies relative
hist(longest_runs, freq = FALSE, breaks = 1:30)

# (e) Simulate an experiment of generating n = 10000 coin tossing sequences of length 200 with a biased coin that gives heads 1/3 of the time and tails 2/3 of the time. Collect the longest heads runs and longest tails runs in the arrays longest heads runs and longest tails runs respectively.

# update the generate_flips function to produce an unfair coin
generate_flips <- function(k) {
  return(sample(0:1, k, replace = TRUE, prob = c(1 / 3, 2 / 3)))
}

longest_heads_runs <- c()
longest_tails_runs <- c()

for (i in 1:10000) {
  s <- run_all(generate_flips(200))
  longest_heads_runs <- append(longest_heads_runs, max(s$heads))
  longest_tails_runs <- append(longest_tails_runs, max(s$tails))
}

# (f) Create histograms and calculate relative frequencies for the arrays longest heads runs, longest tails runs respectively. Compare the two results.
hist(longest_heads_runs, freq = FALSE, breaks = 1:30)
hist(longest_tails_runs, freq = FALSE, breaks = 1:30)




# Exercise 3: Moran Process

# (a) Write a function in R called simulate moran.
simulate_moran <- function(n) {
  # Create population
  population <- c(rep(0, n - 1), 1)

  # Set generation counter
  generations <- 0

  # Loop until the population is taken over by one type
  while (sum(population) != 0 && sum(population) != n) {
    # choose 2 person: 1 that dies and 1 that replaces the dead one
    dead_and_replace <- sample(1:n, 2)

    # make the change
    population[dead_and_replace[1]] <- population[dead_and_replace[2]]

    # update the generations
    generations <- generations + 1
  }

  # Determine the winning type and return the number of generations
  if (sum(population) == 0) {
    return(c(generations, 0))
  } else {
    return(c(generations, 1))
  }
}

# (b) Run the function at least 1000 times with n = 100, and collect the data. What percentage of the time was the population taken over by the mutants? On average, how many generations did each simulation last?

n_simulations <- 1000
n <- 100
mutant_counts <- numeric(n_simulations)
generation_counts <- numeric(n_simulations)

for (i in 1:n_simulations) {
  result <- simulate_moran(n)
  mutant_counts[i] <- result[2]
  generation_counts[i] <- result[1]
}

mutant_percentage <- mean(mutant_counts)
avg_generations <- mean(generation_counts)

paste("Percentage of times the population was taken over by the mutants:", mutant_percentage, "\n")
# Percentage of times the population was taken over by the mutants: 0.014 (1.4%)
paste("Average number of generations per simulation:", avg_generations, "\n")
# Average number of generations per simulation: 532.079




# Exercise 4: Probability distributions

# (a) Calculate the exact probability that less than 1,300 of these cups were winning a coffee or food prize using the hypergeometric distribution

m <- 33357600 # total participants
n <- m / 6 # winning participants
k <- 8000 # sample size
x <- 1299 # number of winners drawn

# probability that less than 1300 won
phyper(x, n, m - n, k) # 0.1549954

# (b) Considering a full season of 82 games, calculate the probability that the total number of shots on goal made by the Canadiens will exceed 2400 shots?

x <- 2400
lambda <- 29 * 82

# probability that at least 2400 shots are made
1 - ppois(x, lambda) # 0.3212928
