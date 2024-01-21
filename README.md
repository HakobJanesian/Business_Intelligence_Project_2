# Database Setup and Data Loading for Analysis

This project involves setting up databases for a relational and dimensional data model and loading data for analysis purposes. The focus is on an internet service provider's data, structured to facilitate both transactional operations and analytical queries.

## Contents

- [Project Overview](#project-overview)
- [Database Creation](#database-creation)
  - [Relational Database](#relational-database)
  - [Dimensional Database](#dimensional-database)
- [Data Loading](#data-loading)
  - [Source Data](#source-data)
  - [Data Loading Procedure](#data-loading-procedure)
- [Dimensional Data ETL](#dimensional-data-etl)
  - [SCD Type 1](#scd-type-1)
  - [SCD Type 2](#scd-type-2)

## Project Overview

This project sets up a SQL Server environment for handling and analyzing data from an internet service provider. The setup involves creating two databases: a relational database for transactional data and a dimensional database for analytical purposes.

## Database Creation

### Relational Database

The relational database, `Orders_RELATION_DB`, is structured to store detailed transactional data, including orders, customers, employees, and products. The database schema is designed to support normal transactional operations.

#### Setup Instructions

1. **Create Database**: Execute the SQL commands to create the `Orders_RELATION_DB` database and its tables, such as `Orders`, `OrderDetails`, `Products`, etc.
2. **Define Relationships**: Establish foreign key relationships between tables to ensure data integrity.

### Dimensional Database

The dimensional database, `Orders_DIMENSIONAL_DW`, is structured for analytical querying with dimensions and fact tables, facilitating efficient data analysis and reporting.

#### Setup Instructions

1. **Create Database**: Execute the SQL commands to create the `Orders_DIMENSIONAL_DW` database and its dimensional and fact tables, like `DimProducts`, `DimCustomers`, `FactOrders`, etc.
2. **SCD Implementation**: Slowly Changing Dimensions (SCD) Type 1 and Type 2 are implemented for handling dimensional data changes over time.

## Data Loading

### Source Data

Data is sourced from an Excel file `data_source.xlsx`, containing multiple sheets representing different entities such as orders and products.

### Data Loading Procedure

1. **Read Excel Data**: Utilize `pandas` to read data from the Excel file.
2. **Establish Database Connection**: Connect to the SQL Server using `pyodbc` and SQLAlchemy's `create_engine`.
3. **Load Data to SQL Server**: Transfer data from Excel to the corresponding tables in the `Orders_RELATION_DB` using pandas' `to_sql` method.

## Dimensional Data ETL

ETL processes are implemented for populating dimensional tables from the relational database, handling both SCD Type 1 and Type 2.

### SCD Type 1

SCD Type 1 procedures update dimension tables with the latest data while overwriting the old data, not keeping any history of changes.

### SCD Type 2

SCD Type 2 procedures add new records to dimension tables for changes, keeping history with `ValidFrom`, `ValidTo`, and `IsCurrent` fields to track the duration of each record's validity.

## Execution

Execute the provided Python scripts to load data into the relational database and run stored procedures for populating the dimensional database for analytical purposes.

---

This README provides a comprehensive guide for setting up and populating databases for transactional and analytical purposes, focusing on a practical example involving an internet service provider's data.
