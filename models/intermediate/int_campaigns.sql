
with adwords as (
    select date_date, paid_source, campaign_id, campaign_name, ads_cost, impression, click
    from {{ ref('stg_adwords') }}
),
bing as (
    select date_date, paid_source, campaign_id, campaign_name, ads_cost, impression, click
    from {{ ref('stg_bing') }}
),
criteo as (
    select date_date, paid_source, campaign_id, campaign_name, ads_cost, impression, click
    from {{ ref('stg_criteo') }}
),
facebook as (
    select date_date, paid_source, campaign_id, campaign_name, ads_cost, impression, click
    from {{ ref('stg_facebook') }}
)

select *
from adwords
union all
select * from bing
union all
select * from criteo
union all
select * from facebook
