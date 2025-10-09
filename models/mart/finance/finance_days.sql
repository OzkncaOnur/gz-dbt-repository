

-- Daily finance aggregation using only enhanced int_orders_operational

with daily_agg as (
    select
        date_date as date_date,
        count(distinct orders_id) as total_transactions,
        round(sum(revenue), 2) as total_revenue,
        round(sum(revenue) / count(distinct orders_id), 2) as average_basket,
        round(sum(operasyonel_marj), 2) as total_operational_margin,
        round(sum(purchase_cost), 2) as total_purchase_cost,
        round(sum(shipping_fee) / count(distinct orders_id), 2) as total_shipping_fee,
        round(sum(log_cost), 2) as total_log_cost,
        round(sum(ship_cost), 2) as total_ship_cost,
        sum(quantity) as total_quantity
    from {{ ref('int_orders_operational') }}
    group by date_date
)

select *
from daily_agg
order by date_date
