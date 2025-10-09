-- Standardize product data
select
    cast(products_id as string) as product_id,
    cast(purchSE_PRICE as float64) as purchase_price
from {{ source('gz_raw_data', 'raw_gz_product') }}
