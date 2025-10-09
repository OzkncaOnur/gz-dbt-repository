--{{ config(materialized='view') }}

-- Günlük kampanya performans verilerini özetler.
-- int_campaigns modelinden veriyi alır ve günlük bazda toplar.

with aggregated as (
    select
        date_date,
        count(distinct campaign_id) as campaign_count,     -- Günlük kampanya sayısı
        sum(ads_cost) as total_ads_cost,                   -- Toplam reklam maliyeti
        sum(impression) as total_impressions,              -- Toplam gösterim sayısı
        sum(click) as total_clicks,                        -- Toplam tıklama sayısı
        round(safe_divide(sum(click), sum(impression)), 2) as ctr,   -- CTR (Click Through Rate, 2 decimal)
        round(safe_divide(sum(ads_cost), sum(click)), 2) as cpc      -- CPC (Cost Per Click, 2 decimal)
    from {{ ref('int_campaigns') }}
    group by date_date
)

select *
from aggregated
order by date_date desc
