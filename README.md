# Indian Census SQL Data Analysis

This repository contains the code and documentation for Exploratory Data Analysis (EDA) of Indian Census data using SQL queries in python via mysql-connector module. The data is stored in a MySQL database named `indiancensus`, consisting of two tables: data1 and data2.

## Dataset

The dataset comprises two tables in the `indiancensus` database:

### Table: data1

- **District**: Name of the district.
- **State**: State to which the district belongs.
- **Growth**: Population growth rate.
- **Sex_Ratio**: Sex ratio.
- **Literacy**: Literacy rate.

### Table: data2

- **District**: Name of the district.
- **State**: State to which the district belongs.
- **Area_km2**: Area of the district in square kilometers.
- **Population**: Population of the district.

## EDA File

[IndianCensus.ipynb](IndianCensus.ipynb): Jupyter Notebook containing the Python code for the exploratory data analysis of the Indian Census data using SQL queries.

## Usage

```bash
git clone https://github.com/HloHarshit/Indian-Census-SQL-EDA.git
cd Indian-Census-SQL-EDA
jupyter notebook IndianCensus.ipynb
```