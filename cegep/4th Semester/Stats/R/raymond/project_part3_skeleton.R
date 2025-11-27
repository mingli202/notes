sir_model <- function(p, S0, I0, R0, num_days) {
  S <- S0 # initial susceptibles
  I <- I0 # initial infected
  R <- R0 # initial recovered
  N <- S + I + R

  for (i in 1:num_days)
  {
    # MODIFY THE NEXT THREE LINES!
    I[i + 1] <- ... # new infected on day i+1
    S[i + 1] <- S[i] - ... # new number of susceptibles on day i+1
    R[i + 1] <- R[i] + ... # new number of recovered on day i+1
  }

  return(list("S" = S, "I" = I, "R" = R))
}

