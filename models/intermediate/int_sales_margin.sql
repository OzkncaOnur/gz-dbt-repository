-- models/intermediate/int_sales_margin.sql

with
sales as (
    select *
    from {{ ref('stg_sales') }}
),

products as (
    select *
    from {{ ref('stg_product') }}
),

joined as (
    select
        s.orders_id,
        s.date_date,
        s.product_id,
        s.quantity,
        s.revenue,
        p.purchase_price
    from sales s
    left join products p
        on s.product_id = p.product_id
),

calculated as (
    select
        orders_id,
        product_id,
        date_date,
        quantity,
        revenue,
        purchase_price,
        quantity * purchase_price as purchase_cost,
        revenue - (quantity * purchase_price) as margin
    from joined
)
select
    orders_id,
    product_id,
    quantity,
    revenue,
    purchase_price,
    purchase_cost,
    margin
from calculated
