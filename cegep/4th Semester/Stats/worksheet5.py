import math
import typing
from matplotlib import pyplot as plt
import numpy as np


class Bernoulli:
    def __init__(self, p: float | int):
        self.p = p  # probability of success

    def pmf(self, x: int) -> float:
        match x:
            case 0:
                return 1 - self.p
            case 1:
                return self.p
            case _:
                raise ValueError("x must be 0 or 1")

    def expectedValue(self) -> float:
        return self.p

    def variance(self) -> float:
        return self.p * (1 - self.p)


class Binomial:
    def __init__(self, N: int, p: float | int):
        self.N = N
        self.p = p

    def pmf(self, x: int) -> float:
        return math.comb(self.N, x) * self.p**x * (1 - self.p) ** (self.N - x)

    def cdf(self, x: int, start=0) -> float:
        return sum(self.pmf(i) for i in range(start, x + 1))

    def expectedValue(self) -> float:
        return self.N * self.p

    def variance(self) -> float:
        return self.N * self.p * (1 - self.p)


class Hypergeometric:
    def __init__(self, nOptions: int, mGood: int, nChoose: int):
        self.N = nOptions
        self.M = mGood
        self.n = nChoose

    def pmf(self, x: int) -> float:
        return (
            math.comb(self.M, x)
            * math.comb(self.N - self.M, self.n - x)
            / math.comb(self.N, self.n)
        )

    def cdf(self, x: int, start=0) -> float:
        return sum(self.pmf(i) for i in range(start, x + 1))

    def expectedValue(self) -> float:
        return self.n * self.M / self.N

    def variance(self) -> float:
        return (
            ((self.N - self.n) / (self.N - 1))
            * (self.n * self.M / self.N)
            * (1 - self.M / self.N)
        )


class Poisson:
    def __init__(self, lam: float | int):
        self.lam = lam

    def pmf(self, x: int) -> float:
        return math.exp(-self.lam) * self.lam**x / math.factorial(x)

    def cdf(self, x: int, start=0) -> float:
        return sum(self.pmf(i) for i in range(start, x + 1))

    def expectedValue(self) -> float:
        return self.lam

    def variance(self) -> float:
        return self.lam


def pInRange(start: int, end: int, p: typing.Callable[[int], float]):
    return sum(p(x) for x in range(start, end + 1))


def main():
    X = Poisson(29 * 82)
    print(1 - pInRange(0, 2400, X.pmf))


if __name__ == "__main__":
    main()
