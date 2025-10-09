

-- Aylık bazda finansal ve reklam performansını özetler.


with monthly as (
    select
        format_date('%Y-%m', date) as datemonth,
        round(sum(ads_margin), 2) as ads_margin,
        -- convert average_basket from string to numeric before averaging
        round(avg(cast(average_basket as float64)), 2) as average_basket,
        round(sum(operational_margin), 2) as operational_margin,
        round(sum(ads_cost), 2) as ads_cost,
        sum(ads_impression) as ads_impression,
        sum(ads_clicks) as ads_clicks,
        sum(quantity) as quantity,
        round(sum(revenue), 2) as revenue,
        round(sum(purchase_cost), 2) as purchase_cost,
        round(sum(margin), 2) as margin,
        round(sum(shipping_fee), 2) as shipping_fee,
        round(sum(log_cost), 2) as log_cost,
        round(sum(ship_cost), 2) as ship_cost
    from {{ ref('finance_campaigns_day') }}
    group by datemonth
)

select *
from monthly
order by datemonth desc
