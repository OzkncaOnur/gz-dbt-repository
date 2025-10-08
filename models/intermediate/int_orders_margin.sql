-- models/intermediate/int_orders_margin.sql

with sales_margin as (
    select *
    from {{ ref('int_sales_margin_internal') }}
),

orders_agg as (
    select
        cast(orders_id as string) as orders_id,
        min(date_date) as date_date,  -- Aynı sipariş için birden çok tarih varsa en erkenini alıyoruz
        sum(revenue) as revenue,
        sum(quantity) as quantity,
        round(cast(sum(purchase_cost) as float64), 2) as purchase_cost,
        round(cast(sum(margin) as float64), 2) as margin
    from sales_margin
    group by orders_id
)

select *
from orders_agg
