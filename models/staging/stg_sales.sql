-- models/staging/stg_sales.sql
select
    cast(date_date as Date) as date_date,
    orders_id,
    cast(pdt_id as string) as product_id,   -- rename + ensure consistent type
    cast(revenue as numeric) as revenue,    -- keep one revenue column
    cast(quantity as int64) as quantity
from {{ source('gz_raw_data', 'raw_gz_sales') }}
