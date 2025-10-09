
-- Enhanced operational margin per order
-- Include revenue, quantity, purchase_cost for finance aggregation

with orders_base as (
    select
        cast(orders_id as string) as orders_id,
        cast(date_date as date) as date_date,
        cast(revenue as float64) as revenue,
        cast(quantity as float64) as quantity,
        cast(purchase_cost as float64) as purchase_cost,
        cast(margin as float64) as margin
    from {{ ref('int_orders_margin') }}  -- source for base financials
),

shipping as (
    select
        cast(orders_id as string) as orders_id,
        cast(shipping_fee as float64) as shipping_fee,
        cast(logCost as float64) as log_cost,
        cast(ship_cost as float64) as ship_cost
    from {{ source('gz_raw_data', 'raw_gz_ship') }}
),

calculated as (
    select
        o.orders_id,
        o.date_date,
        o.revenue,
        o.quantity,
        o.purchase_cost,
        s.shipping_fee,
        s.log_cost,
        s.ship_cost,
        round(
            (o.margin + coalesce(s.shipping_fee,0) - coalesce(s.log_cost,0) - coalesce(s.ship_cost,0)),
            2
        ) as operasyonel_marj
    from orders_base o
    left join shipping s
        on o.orders_id = s.orders_id
)

select *
from calculated
order by date_date
