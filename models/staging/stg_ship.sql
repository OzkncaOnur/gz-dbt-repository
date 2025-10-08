-- Prepare shipment data
select
    cast(orders_id as string) as order_id,
    cast(shipping_fee as float64) as shipping_fee,
    cast(logCost as float64) as log_cost,
    cast(ship_cost as numeric) as ship_cost 
from {{ source('gz_raw_data', 'raw_gz_ship') }}
