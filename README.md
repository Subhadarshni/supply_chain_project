**📦 Supply Chain Analytics Project (dbt + Snowflake)**

📌 Overview
This project is an end-to-end data transformation and analytics pipeline built using dbt (Data Build Tool) on Snowflake. It models an e-commerce supply chain system including orders, shipments, returns, and inventory.


🏗️ Project Architecture

Layers used:

Source Layer → Raw data from Snowflake (RAW schema)

Staging Layer → Cleaned & standardized data (STAGING)

Marts Layer → Business-ready fact tables (MARTS)

📁 Project Structure
dbt_ecommerce_project/
│
├── .venv/                     # Virtual environment
├── logs/                     # dbt logs
├── python/                   # Python scripts (data generation, preprocessing)
│
├── supply_chain_data/        # Raw CSV data
│   ├── inventory.csv
│   ├── orders.csv
│   ├── products.csv
│   ├── returns.csv
│   ├── shipments.csv
│   └── generate_data.py
│
├── supply_chain_project/     # MAIN DBT PROJECT
│
│   ├── dbt_project.yml       # Project configuration (schemas, materialization)
│   ├── profiles.yml         # DB connection config (outside sometimes)
│
│   ├── models/               # TRANSFORMATION LAYER ⭐
│   │
│   │   ├── staging/          # Raw → Clean
│   │   │   ├── stg_orders.sql
│   │   │   ├── stg_products.sql
│   │   │   └── stg_inventory.sql
│   │
│   │   ├── dimensions/       # Dimension tables
│   │   │   ├── dim_date.sql
│   │   │   ├── dim_products.sql
│   │   │   └── dim_warehouse.sql
│   │
│   │   ├── marts/            # Business-ready tables
│   │   │   ├── fact_inventory.sql
│   │   │   └── fact_sales.sql
│   │
│   │   └── schema.yml        # Tests + documentation
│
│   ├── analyses/             # Ad-hoc queries
│   │   └── business_analytics.sql
│
│   ├── macros/               # Reusable SQL functions
│   │   └── generate_schema_name.sql
│
│   ├── tests/                # Custom tests
│   └── snapshots/            # Slowly changing data
│
├── dbt_packages/             # Installed dbt packages
└── README.md


📊 Data Models
Fact Tables:
fact_orders → Order-level data

fact_shipments → Shipment tracking

fact_returns → Return information

fact_inventory → Warehouse stock

Dimension Tables:
dim_products → Product details


✅ Data Quality Tests
Implemented using dbt tests:

not_null

unique

accepted_values

relationships

Example:

- name: order_status
  tests:
    - accepted_values:
        values: ['placed','shipped','delivered']

🚀 Tools & Technologies
dbt Core (v1.11)
Snowflake
SQL
VS Code

Key Learnings
Data modeling (Star Schema)

Incremental loading

Data testing & validation

Snapshots (historical tracking)

Analytics using window functions

📌 Future Improvements
Add Airflow for orchestration

CI/CD integration (GitHub Actions)

Dashboarding (Power BI / Tableau)

Semantic Layer (dbt metrics)
