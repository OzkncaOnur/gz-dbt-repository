-- models/mart/finance_days.sql

with orders_margin as (
    select
        cast(date_date as date) as date_date,
        orders_id,
        revenue,
        quantity,
        purchase_cost,
        margin
    from {{ ref('int_orders_margin') }}
),

orders_operational as (
    select
        cast(date_date as date) as date_date,
        orders_id,
        operational_margin
    from {{ ref('int_orders_operational') }}
),

shipping as (
    select
        cast(order_id as string) as orders_id,
        cast(shipping_fee as float64) as shipping_fee,
        cast(log_cost as float64) as log_cost
    from {{ ref('stg_ship') }}
),

joined as (
    select
        o.date_date,
        o.orders_id,
        o.revenue,
        o.quantity,
        o.purchase_cost,
        o.margin,
        op.operational_margin,
        s.shipping_fee,
        s.log_cost
    from orders_margin o
    left join orders_operational op on o.orders_id = op.orders_id
    left join shipping s on o.orders_id = s.orders_id
),

daily_agg as (
    select
        date_date,
        count(distinct orders_id) as total_transactions,
        FORMAT('%.2f', sum(revenue)) as total_revenue,
        FORMAT('%.2f', CAST(sum(quantity) AS FLOAT64)) as total_quantity,
        FORMAT('%.2f', sum(purchase_cost)) as total_purchase_cost,
        FORMAT('%.2f', sum(shipping_fee)) as total_shipping_fee,
        FORMAT('%.2f', sum(log_cost)) as total_log_cost,
        FORMAT('%.2f', sum(operational_margin)) as total_operational_margin,
        FORMAT('%.2f', sum(revenue) / count(distinct orders_id)) as average_basket
    from joined
    group by date_date
)

{{ config(materialized='table') }}
select *
from daily_agg
order by date_date

