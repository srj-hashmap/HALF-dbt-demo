USE ROLE SYSADMIN;

CREATE DATABASE IF NOT EXISTS raw;
CREATE DATABASE IF NOT EXISTS analytics;

CREATE SCHEMA IF NOT EXISTS raw.jaffle_shop;
CREATE SCHEMA IF NOT EXISTS raw.stripe;


USE ROLE SECURITYADMIN;

-- WAREHOUSE Permissions
CREATE ROLE IF NOT EXISTS DBTADMINROLE;
GRANT USAGE, OPERATE, MONITOR ON WAREHOUSE COMPUTE_WH TO ROLE DBTADMINROLE;

-- DATABASE Permissions
GRANT USAGE ON DATABASE RAW to ROLE DBTADMINROLE;
GRANT USAGE ON DATABASE ANALYTICS to ROLE DBTADMINROLE;

GRANT ALL PRIVILEGES ON DATABASE RAW TO ROLE DBTADMINROLE;
GRANT ALL PRIVILEGES ON DATABASE ANALYTICS TO ROLE DBTADMINROLE;

-- SCHEMA Permissions
GRANT USAGE ON ALL SCHEMAS IN DATABASE RAW to ROLE DBTADMINROLE;
GRANT USAGE ON ALL SCHEMAS IN DATABASE ANALYTICS to ROLE DBTADMINROLE;

GRANT ALL PRIVILEGES ON ALL SCHEMAS IN DATABASE RAW to ROLE DBTADMINROLE;
GRANT ALL PRIVILEGES ON ALL SCHEMAS IN DATABASE ANALYTICS to ROLE DBTADMINROLE;

GRANT USAGE ON FUTURE SCHEMAS IN DATABASE RAW to ROLE DBTADMINROLE;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE ANALYTICS to ROLE DBTADMINROLE;

GRANT ALL PRIVILEGES ON FUTURE SCHEMAS IN DATABASE RAW to ROLE DBTADMINROLE;
GRANT ALL PRIVILEGES ON FUTURE SCHEMAS IN DATABASE ANALYTICS to ROLE DBTADMINROLE;
GRANT ROLE DBTADMINROLE TO ROLE SYSADMIN;

-- Creating Users and tables
CREATE OR REPLACE USER DBTUSER 
PASSWORD = 'DBT_TO_SF' 
LOGIN_NAME = 'DBTUSER' 
DISPLAY_NAME = 'DBTUSER' 
MUST_CHANGE_PASSWORD = FALSE
DEFAULT_WAREHOUSE = 'COMPUTE_WH' 
DEFAULT_ROLE = 'DBTADMINROLE';

GRANT ROLE DBTADMINROLE TO USER DBTUSER;
GRANT ROLE DBTADMINROLE TO USER SARANHASHMAP;


USE ROLE SYSADMIN;
CREATE OR REPLACE TABLE raw.jaffle_shop.customers 
( id integer,
  first_name varchar,
  last_name varchar
);


COPY INTO raw.jaffle_shop.customers (id, first_name, last_name)
FROM 's3://dbt-tutorial-public/jaffle_shop_customers.csv'
file_format = (
  type = 'CSV'
  field_delimiter = ','
  skip_header = 1
  );


CREATE OR REPLACE TABLE raw.jaffle_shop.orders
( id integer,
  user_id integer,
  order_date date,
  status varchar,
  _etl_loaded_at timestamp default current_timestamp
);


COPY INTO raw.jaffle_shop.orders (id, user_id, order_date, status)
FROM 's3://dbt-tutorial-public/jaffle_shop_orders.csv'
file_format = (
  type = 'CSV'
  field_delimiter = ','
  skip_header = 1
  );


CREATE OR REPLACE TABLE raw.stripe.payment 
( id integer,
  orderid integer,
  paymentmethod varchar,
  status varchar,
  amount integer,
  created date,
  _batched_at timestamp default current_timestamp
);


COPY INTO raw.stripe.payment (id, orderid, paymentmethod, status, amount, created)
FROM 's3://dbt-tutorial-public/stripe_payments.csv'
file_format = (
  type = 'CSV'
  field_delimiter = ','
  skip_header = 1
  );


--TABLE Permissions
GRANT SELECT ON ALL TABLES IN SCHEMA RAW.JAFFLE_SHOP to ROLE DBTADMINROLE;
GRANT SELECT ON ALL TABLES IN SCHEMA RAW.STRIPE to ROLE DBTADMINROLE; 
