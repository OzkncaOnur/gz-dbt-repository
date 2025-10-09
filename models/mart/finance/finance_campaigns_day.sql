-- Günlük finansal ve reklam performansını birleştirir.
-- Bağlantılar:
--   - int_campaigns_day (kampanya verileri)
--   - finance_days (finansal veriler)
-- Hesaplama: ads_margin = operational_margin - ads_cost

with campaigns as (
    select
        date_date,
        total_ads_cost as ads_cost,
        total_impressions as ads_impression,
        total_clicks as ads_clicks
    from {{ ref('int_campaigns_day') }}
),

finance as (
    select
        date_date,
        average_basket,
        cast(total_operational_margin as float64) as operational_margin,
        cast(total_revenue as float64) as revenue,
        cast(total_purchase_cost as float64) as purchase_cost,
        cast(total_shipping_fee as float64) as shipping_fee,
        cast(total_log_cost as float64) as log_cost,
        cast(total_ship_cost as float64) as shipping_cost,
        cast(total_quantity as float64) as quantity,
        cast(total_operational_margin as float64) as margin
    from {{ ref('finance_days') }}
)

select
    f.date_date as date_date,
    round(f.operational_margin - c.ads_cost, 2) as ads_margin,
    f.average_basket,
    round(f.operational_margin, 2) as operational_margin,
    round(c.ads_cost, 2) as ads_cost,
    c.ads_impression,
    c.ads_clicks,
    round(f.quantity, 2) as quantity,
    round(f.revenue, 2) as revenue,
    round(f.purchase_cost, 2) as purchase_cost,
    round(f.margin, 2) as margin,
    round(f.shipping_fee, 2) as shipping_fee,
    round(f.log_cost, 2) as log_cost,
    round(f.shipping_cost, 2) as shipping_cost
from finance f
left join campaigns c
    on f.date_date = c.date_date
order by date_date
