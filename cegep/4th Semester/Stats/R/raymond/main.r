sir_model <- function(p, s_0, i_0, r_0, num_days) {
  s <- s_0 # initial susceptibles
  i <- i_0 # initial infected
  r <- r_0 # initial recovered
  days <- 0

  n <- s + i + r

  for (k in 1:num_days) {
    # MODIFY THE NEXT THREE LINES!
    i[k + 1] <- sum(rbinom(1, s[k], 1 - (1 - p)^i[k]))
    s[k + 1] <- s[k] - i[k + 1]
    r[k + 1] <- r[k] + (n - s[k + 1] - i[k + 1])

    if (i[k + 1] != 0) {
      days <- days + 1
    }
  }

  return(list("S" = s, "I" = i, "R" = r, "days" = days))
}

plot_graphs <- function(sample) {
  for (i in 1:5) {
    data <- sir_model(sample$p, sample$s, sample$i, sample$r, sample$days)
    days <- sample$days
    max_infected <- max(data$I, na.rm = TRUE)
    print(max_infected)

    plot(
      0:days,
      data$I,
      type = "l",
      col = "red",
      ylab = "Number of People",
      xlab = "Day",
      lty = 1,
      main = paste("SIR Model, p =", sample$p, ", max infected =", max_infected),
      ylim = c(0, sample$s + sample$i + sample$r)
    )
    lines(0:days, data$S, col = "blue")
    lines(0:days, data$R, col = "green")

    legend(
      "topright",
      c("Infected", "Susceptible", "Recovered"),
      lty = c(1, 1, 1),
      col = c("red", "blue", "green")
    )
  }
  browseURL("./Rplots.pdf")
}

sample_a <- list(p = 0.001, s = 2000, i = 2, r = 0, days = 50)
sample_b <- list(p = 0.004, s = 400, i = 3, r = 0, days = 20)
sample_c <- list(p = 0.13, s = 2000, i = 50, r = 0, days = 10)

# c)
test_case_a <- function() {
  plot_graphs(sample_a)
}

# d)
test_case_b <- function() {
  plot_graphs(sample_b)
}

# e)
test_case_c <- function() {
  plot_graphs(sample_c)
}

# f)
plot_running_avg <- function(sample) {
  avg_s <- c()
  sum_s <- c()

  avg_i <- c()
  sum_i <- c()

  avg_r <- c()
  sum_r <- c()

  days <- c()

  x <- 1:500

  for (i in x) {
    data <- sir_model(sample$p, sample$s, sample$i, sample$r, sample$days)

    sum_s <- append(sum_s, max(data$S, na.rm = TRUE))
    avg_s[i] <- mean(sum_s)

    sum_i <- append(sum_i, max(data$I, na.rm = TRUE))
    avg_i[i] <- mean(sum_i)

    sum_r <- append(sum_r, max(data$R, na.rm = TRUE))
    avg_r[i] <- mean(sum_r)

    days[i] <- data$days
  }

  plot(
    x,
    avg_i,
    main = paste(
      "Average Max Infected over 500 Simulations;",
      "p =", sample$p, "s =", sample$s, "i =", sample$i
    ),
    xlab = "Simulations",
    ylab = "Average Max Infected",
    type = "l",
    col = "red",
    ylim = c(0, max(avg_i, avg_s, avg_r))
  )

  lines(x, avg_s, col = "blue")
  lines(x, avg_r, col = "green")

  legend(
    "topright",
    c("Infected", "Susceptible", "Recovered"),
    lty = c(1, 1, 1),
    col = c("red", "blue", "green")
  )

  hist(
    days,
    main = paste(
      "Histogram of number of days it took until extinction",
      "p =",
      sample$p,
      "s =",
      sample$s,
      "i =",
      sample$i
    ),
    xlab = "Number of days",
    ylab = "Frequency",
    freq = FALSE
  )
}

for_each_of_the_three_cases <- function() {
  plot_running_avg(sample_a)
  plot_running_avg(sample_b)
  plot_running_avg(sample_c)

  browseURL("./Rplots.pdf")
}

test_case_a()
test_case_b()
test_case_c()
for_each_of_the_three_cases()

test_for_p_and_i <- function() {
  for (a in seq(2, 50, 1)) {
    x <- seq(0, 0.1, 0.0001)
    y <- c()
    n <- 10

    # do it for k = 2:1000
    for (k in x) {
      # get average max infected for a given initial infected number
      s <- 0
      for (l in 1:n) {
        sam <- list(p = k, s = 2000, i = a, r = 0, days = 30)
        sample <- sir_model(sam$p, sam$s, sam$i, sam$r, sam$days)
        s <- s + max(sample$I, na.rm = TRUE)
      }
      y <- append(y, s / n)
    }

    plot(
      x,
      y,
      ylim = c(0, 2000),
      main = paste("Average Max Infected vs. p, i =", a),
      xlab = "p",
      ylab = "Average Max Infected"
    )
  }
  browseURL("./Rplots.pdf")
}

# test_for_p_and_i()
