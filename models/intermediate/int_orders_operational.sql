-- models/intermediate/int_orders_operational.sql

with orders_margin as (
    select *
    from {{ ref('int_orders_margin') }}
),

shipping as (
    select
        cast(order_id as string) as orders_id,  -- rename to match orders_margin
        cast(shipping_fee as float64) as shipping_fee,
        cast(log_cost as float64) as log_cost,
        cast(ship_cost as float64) as ship_cost
    from {{ ref('stg_ship') }}
),

joined as (
    select
        o.orders_id,
        o.date_date,
        o.margin,
        s.shipping_fee,
        s.log_cost,
        s.ship_cost
    from orders_margin o
    left join shipping s
        on o.orders_id = s.orders_id
),

calculated as (
    select
        orders_id,
        date_date,
        round(
            cast(
                (margin + shipping_fee - log_cost - ship_cost) as float64
            ),
            2
        ) as operational_margin
    from joined
)

select *
from calculated
