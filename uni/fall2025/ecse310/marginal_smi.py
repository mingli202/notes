import pandas as pd
import numpy as np


df: pd.DataFrame = pd.read_csv("./data set homework 3 Fall 2025.csv")
n_rows = len(df)


def marginal_smi():
    print("============ marginal SMI ============")
    for col in ["age", "education years", "gender", "hours-per-week", "income"]:
        d = df[[col]].value_counts(normalize=True)
        smi = -sum(d * np.log2(d))
        print(f"{col} marginal smi: {smi}")


def joint_smi():
    print("============ joint SMI ============")
    prob = df.value_counts(normalize=True)
    smi = -sum(prob * np.log2(prob))
    print(f"joint smi: {smi}")


def mutual_smis():
    print("============ mutual SMI ============")
    income = df[["income"]].value_counts(normalize=True)
    income_smi = -sum(income * np.log2(income))

    for col in ["education years", "gender", "hours-per-week"]:
        income = df[["income", col]].value_counts(normalize=True)

        col_df = df[[col]].value_counts(normalize=True)
        col_smi = -sum(col_df * np.log2(col_df))

        joint_smi = -sum(income * np.log2(income))
        mutual_smi = income_smi + col_smi - joint_smi
        print(f"{col} mutual smi: {mutual_smi}")


def hours_smi_given_gender_is_female():
    print("============ SMI given gender is female ============")
    female = df[df["gender"] == "Female"]
    prob = female[["hours-per-week"]].value_counts(normalize=True)
    smi = -sum(prob * np.log2(prob))
    print(f"hours-per-week smi given gender is female: {smi}")


def main():
    marginal_smi()
    joint_smi()
    mutual_smis()
    hours_smi_given_gender_is_female()


if __name__ == "__main__":
    main()
