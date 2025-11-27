import random
from matplotlib import pyplot as plt


def simulate(balance=10_000, target=20_000) -> tuple:
    bet = 5

    while True:
        isWin = random.randint(0, 1)

        if (isWin == 1):
            balance += bet
            bet = 5

        else:
            balance -= bet
            bet *= 2

        if balance <= 0:
            break

        if balance >= target:
            return 1, balance

    return 0, balance


def main():
    target = 20_000
    initialBalance = 10_000

    times = 1000
    wins = 0

    x = []
    y = []

    for i in range(times):
        didWin, finalBalance = simulate(initialBalance, target)
        wins += didWin

        x.append(i)
        y.append(finalBalance)
        print(i)

    plt.plot(x, y)
    plt.title(f"{wins} wins out of {times}")
    plt.show()


if __name__ == "__main__":
    main()
