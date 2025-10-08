select *
from {{ source('gz_raw_data', 'raw_gz_sales') }}
