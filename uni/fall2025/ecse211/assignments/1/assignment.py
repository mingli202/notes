"""Replace the word 'pass' with your solution!"""

import math
from statistics import mean, median

STUDENT_NAME = "Ming Li Liu"
STUDENT_ID = "261226740"


def q1(x: int, y: int) -> int:
    """Write a function that returns the sum of x and y"""
    return x + y


def q2(x: int, y: int) -> int:
    """Write a function that returns the product of x and y"""
    return x * y


def q3(x: int, y: int) -> int:
    """Write a function that returns the value of x to the y power"""
    return x**y


def q4(x: int) -> tuple[int, int, int]:
    """Write a function that returns the 3 computed values
    in a tuple or list form:

    x times 2, x minus 3, and x divided by 10 (integer-division, not floating point)
    """
    return x * 2, x - 3, x // 10


def q5(x: int, y: int):
    """Write a function to represent the summation from the assignment doc"""
    return sum(n for n in range(x, y + 1))


def q6(x: int) -> int:
    """Write a function to represent the following summation, while being given x as input:

    Hint: You do not need to use the answer in q5 for this question.
    """
    return sum(sum(2 * i + k for k in range(0, 6)) for i in range(0, x + 1))


def q7(x: int) -> list[int]:
    """Create and return a list of integers (length x) where:

    * The absolute value of each element is three times the index.
    For example, the absolute value of the element at index 5 should be 15.

    * Values at even indices must be positive, and values at odd indices must be negative.

    The output should resemble this format:

    If x=5, then output = [0, -3, 6, -9, 12]

    Hint: Nothing should be printed in this question, as we ask you to return the list of values.

    """
    return [i * 3 * (-1) ** (i % 2) for i in range(x)]


def q8(lst: list[int]) -> list[int]:
    """Create a function to find the index of every number 10
    within the given input list, 'lst'.

    Return these indices as a new list.

    (hint: use 'enumerate')

    Examples:
    lst: [10, 9, 8, 7, 6, 10, 4, 3, 10, 1]
    answer: [0, 5, 8]

    lst: [10]
    answer: [0]

    lst: [3, 2, 1]
    answer: []

    lst: []
    answer: []
    """
    return [i for i in range(len(lst)) if lst[i] == 10]


def q9(dct: dict[str, float]) -> tuple[list[str], float]:
    """Determine the GPA of the given student, using the given dict 'dct'.
    The keys of the dict are course names, while the values are the GPA obtained in each course.

    Return two things as a tuple: a list of the courses taken, and the semester GPA. You can
    assume that all courses pull the same weight in the GPA calculation, i.e., it is sufficient
    to compute the average of the GPAs to determine the semester GPA.

    (hint: 2.6 is very similar to 2.59999996 so either answer should be fine. We use math.isclose)
    (hint 2: use dict.items)

    Examples:
    input: {'Calc 2' : 2.3, 'Physics' : 3.4, 'Algorithms' : 2.1}
    answer: (['Calc 2', 'Physics', 'Algorithms'], 2.6)

    input: {'English' : 1.5, 'History' : 4.0, 'French' : 3.8}
    answer: (['English', 'History', 'French'], 3.1)
    """
    return list(dct.keys()), sum(dct.values()) / len(dct)


def q10(x: int):
    """Create a function that performs the following operations on the given input x:
    if x less than 5 or greater than 255, return 0
    if x is between 5 and 255 (inclusive), return x divided by 1.25 (floating-point division)
    """
    return 0 if x < 5 or x > 255 else x / 1.25


def q11(x: int, y: int, z: int) -> tuple[float, float, float]:
    """Create a function that performs vector normalization on the 3D vector <x, y, z>

    Return a list or tuple of the 3 normalized x, y, z values.

    The formula for vector normalization is in the assignment doc.

    (hint: use the math python module)

    Examples:
    input: [4, 5, 6]
    answer (not exact): [0.4558423058385518, 0.5698028822981898, 0.6837634587578276]

    input: [3, 4, 0]
    answer: [0.6, 0.8, 0.0]

    input: [0, 100, 0]
    answer: [0, 1, 0]
    """
    return (lambda n: (0.0, 0.0, 0.0) if n == 0 else (x / n, y / n, z / n))(
        math.sqrt(x**2 + y**2 + z**2)
    )


def q12(radius: int, degrees: int) -> tuple[float, float]:
    """Write a funciton to convert the given Polar Coordinates into Cartesian Coordinates.
    These formulas are in the assignment doc.

    (hint 1: The input is in DEGREES but you need RADIANS)

    (hint 2: both math.cos and math.sin USE RADIANS)

    input: [10, 60]
    answer (not exact): (5.000000000000001, 8.660254037844386)

    input: [10, 30]
    answer: (8.660254037844387, 4.999999999999999)

    input: [1, 180]
    answer: (-1.0, 1.2246467991473532e-16)

    input: [13, 22.6]
    answer: (12.001732822468751, 4.9958391945774485)

    """
    return radius * math.cos(math.radians(degrees)), radius * math.sin(
        math.radians(degrees)
    )


def q13(data: list[list[int]]):
    """From a list of lists of numbers, give the Minimum, Maximum, Mean, and Median for each list in the given data.

    The format of these lists is as follows:
    [
        [1,2,3,4,5],
        [3,4,5],
        [45,83,65,52,47]
    ]
    The number of give lists is variable, and the length of each list is variable.
    Your code will not be tested for speed performance.

    Output your data as a string. Each list's stats are in one row, which is separated by a newline character.
    Each number is separated by a comma, such as this:
    1,2,3,4
    6,7,8,9
    1,2,3,4
    3,6,8,9

    Do not use print(). Create and build the string in a variable and return the string.
    No extra spaces. You may end each row with a newline.(Your testing program will expect this)
    """

    return "".join(f"{min(row)},{max(row)},{mean(row)},{median(row)}\n" for row in data)


def q14(text: str) -> list[list[int]]:
    """Take the following string input and convert it into a 2-dimensional list. Such as:

    Input:
    1,2,3
    4,5,6,7,8
    9,102,5,25,3

    Output:
    [
        [1,2,3],
        [4,5,6,7,8],
        [9,102,5,25,3]
    ]

    Requirement:
    * The numbers within the 2D list output must be of the int type, not the str type.

    Rules for Input Data:
    * The input string will not have any spaces in it.
    * Each row is separated by a newline character.
    * There is no newline character at the end of the Input String.
    * Each number is separated by a comma.
    * The numbers will all be integers within -2147483648 to 2147483647.
    """
    return [[int(n) for n in row.split(",")] for row in text.split("\n")]
