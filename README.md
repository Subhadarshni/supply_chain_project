**📦 Supply Chain Analytics Project (dbt + Snowflake)**

**📌 Overview**

This project is an end-to-end data transformation and analytics pipeline built using dbt (Data Build Tool) on Snowflake. It models an e-commerce supply chain system including orders, shipments, returns, and inventory.
Raw data is generated using Python and stored in AWS S3 before being loaded into Snowflake for transformation.

It covers:

Data ingestion (CSV → Snowflake)

Data transformation (staging → dimensions → fact tables)

Data quality testing

Snapshot (SCD Type 2)

Business analytics using SQL


**🏗️ Architecture**

Data Flow

    Data Ingestion (Python + AWS S3) → Staging → Dimensions → Fact → Data Testing → Analytics / BI

**📁 Project Structure**
```
dbt_ecommerce_project/
│
├── 📁 python/
│   ├── 📁 supply_chain_data/              # Raw CSV files (source data)
│   │   ├── inventory.csv
│   │   ├── orders.csv
│   │   ├── products.csv
│   │   ├── returns.csv
│   │   ├── shipments.csv
│   │
│   └── generate_data.py                  # Python script to generate data
│
├── 📁 dbt_project/                       # Main dbt project
│   │
│   ├── 📁 models/
│   │   │
│   │   ├── 📁 staging/                   # Raw → cleaned layer
│   │   │   ├── src_supply_chain.yml
│   │   │   ├── stg_inventory.sql
│   │   │   ├── stg_orders.sql
│   │   │   ├── stg_products.sql
│   │   │   ├── stg_returns.sql
│   │   │   ├── stg_shipments.sql
│   │   │
│   │   ├── 📁 dimensions/                # Dimension tables
│   │   │   ├── dim_date.sql
│   │   │   ├── dim_products.sql
│   │   │   ├── dim_warehouse.sql
│   │   │
│   │   ├── 📁 marts/                     # Final business (fact) tables
│   │   │   ├── fact_inventory.sql
│   │   │   ├── fact_orders.sql
│   │   │   ├── fact_returns.sql
│   │   │   ├── fact_shipments.sql
│   │   │
│   │   └── schema.yml                    # Tests + documentation
│   │
│   ├── 📁 snapshots/                     # Slowly Changing Dimensions (SCD Type 2)
│   │   ├── snap_inventory.sql
│   │   ├── snap_orders.sql
│   │   ├── snap_products.sql
│   │
│   ├── 📁 seeds/                         # Static data (optional)
│   │
│   ├── 📁 macros/                        # Reusable SQL logic
│   │   └── generate_schema_name.sql
│   │
│   ├── 📁 analyses/                      # Business queries (window functions)
│   │   └── business_analytics.sql
│   │
│   ├── 📁 tests/                         # Custom tests
│   │
│   ├── 📁 logs/
│   ├── 📁 dbt_packages/
│   │
│   └── dbt_project.yml                  # Main dbt config file
│
├── 📁 logs/                              # External logs
├── 📁 venv/                              # Virtual environment
│
├── requirements.txt                      # Python dependencies
└── README.md                             # Project documentation
```

**📊 Data Models**

 👉 Staging Layer:  Cleans raw data from source tables
 
    stg_orders
    stg_shipments
    stg_inventory
    stg_products
    stg_returns



👉 Dimension Tables:  Provides descriptive attributes for analysis

      dim_date
      dim_products
      dim_warehouse



👉 Fact Tables: Core business tables for analytics

        fact_orders
        fact_shipments
        fact_inventory
        fact_returns
        
** 🔹Custom Macro: generate_schema_name**

      {% macro generate_schema_name(custom_schema_name, node) %}
      
          {%- if custom_schema_name is none -%}
      
              {{ target.schema }}
      
          {%- else -%}
      
              {{ custom_schema_name }}
      
          {%- endif -%}
      
      {% endmacro %}
**🔄 Snapshots (SCD Type 2)**

    snap_inventory (stock changes tracking)
    snap_orders (status/history tracking)
    snap_products (attribute changes tracking)

    
**✅ Data Quality Tests**

Defined in schema.yml:

    not_null
    unique
    accepted_values
    relationships
    

**📈 Business Analytics (Window Functions)**

Location: analyses/business_analytics.sql

Example Insights:

    Top Selling Products
    Order Growth Trend (Running Total)
    Shipment Carrier Performance
    Inventory Ranking by Warehouse
    Latest Shipment Status Per Order
    Moving Average Sales

**🚀 Tools & Technologies**


    Cloud Data Warehouse: Snowflake
    Transformation Layer: dbt (Data Build Tool)
    Cloud Storage: AWS S3 (used for storing raw CSV data)
    Version Control: Git
    Python: 3.12+
    Text Editor: VS Code



**⚙️ Setup Instructions**

Prerequisites:

    Snowflake Account (will create one if doesn't exist)
    Python Environment
    Python 3.12 or higher
    pip or uv package manager
    **AWS Account (will create one if doesn't exist) ** (for S3 storage)

Installation:

      1. Clone Repository
          git clone <your-repo>
          cd dbt_ecommerce_project
      2. Create Virtual Environment
          python -m venv venv
          venv\Scripts\activate   # Windows
      3. Install Dependencies
          pip install dbt-core dbt-snowflake
      4. Configure profiles.yml
      ~/.dbt/profiles.yml
          supply_chain_project:
            outputs:
              dev:
                account:<your-account-identifier>
                database: ECOMMERCE_DB
                password: <your-password>
                role: ACCOUNTADMIN
                schema: RAW
                threads: 6
                type: snowflake
                user: <your-username>
                warehouse: COMPUTE_WH
            target: dev
         
      5. Set Up Snowflake Database
      
      Run the DDL scripts to create tables:
      
            CREATE DATABASE ECOMMERCE_DB;
            USE DATABASE ECOMMERCE_DB;
            CREATE SCHEMA RAW;
            USE SCHEMA RAW;
      
            CREATE SCHEMA IF NOT EXISTS STAGING;
            CREATE SCHEMA IF NOT EXISTS MARTS;
            
            CREATE TABLE ORDERS (
            ORDER_ID INT,
            PRODUCT_ID INT,
            CUSTOMER_ID INT,
            ORDER_DATE DATE,
            QUANTITY INT,
            ORDER_STATUS STRING
            );
            
            
            CREATE TABLE RETURNS (
            RETURN_ID INT,
            ORDER_ID INT,
            RETURN_DATE DATE,
            REASON STRING
            );
            
            CREATE TABLE SHIPMENTS (
            SHIPMENT_ID INT,
            ORDER_ID INT,
            SHIPMENT_DATE DATE,
            CARRIER STRING,
            DELIVERY_STATUS STRING
            );
            
            CREATE TABLE PRODUCTS (
            PRODUCT_ID INT,
            PRODUCT_NAME STRING,
            CATEGORY STRING,
            PRICE NUMBER
            );
            
            CREATE TABLE INVENTORY (
            INVENTORY_ID INT,
            PRODUCT_ID INT,
            WAREHOUSE STRING,
            STOCK_QTY INT,
            UPDATED_AT DATE
            );
      6. Run python/generate_data.py  to generate data
         
      7.Load Source Data
      
      Load CSV files from python/supply_chain_data/ to Snowflake :
      
           inventory.csv -> inventory
           orders.csv -> orders
           products.csv -> products
           returns.csv -> returns
           shipments.csv -> shipments


**🚀 dbt Commands**

      Command              Description
      dbt debug	           Check connection
      dbt run	           Run all models
      dbt test         	   Run tests
      dbt snapshot	       Run snapshots
      dbt docs generate	   Generate docs
      dbt docs serve	   View docs
      dbt build	           Run everything

**🐛 Troubleshooting**

      Common Issues:
      
      Connection Error
      Verify Snowflake credentials in profiles.yml
      Check network connectivity
      Ensure warehouse is running
      
      Compilation Error
      Run dbt debug to check configuration
      Verify model dependencies
      Check Jinja syntax
      
      Incremental Load Issues
      Run dbt run --full-refresh to rebuild from scratch
      Verify source data timestamps

**📊 Future Enhancements**


    Add Airflow for orchestration
    CI/CD integration (GitHub Actions)
    Dashboarding (Power BI / Tableau)

**⭐ Conclusion**

This project demonstrates an end-to-end data pipeline using dbt, including data modeling, testing, and analytics-ready transformations, making it suitable for real-world data engineering use cases.
