

select
    cast(date_date as date) as date_date,                     -- Kampanya verisinin kayıt tarihi
    cast(paid_source as STRING) as paid_source,              -- Pazarlama kanalı (örneğin 'google_ads')
    cast(campaign_key as STRING) as campaign_id,              -- Kampanya kimliği
    cast(camPGN_name as STRING) as campaign_name,            -- Kampanya adı (camPGN_name'den değiştirildi)
    cast(ads_cost as float64) as ads_cost,                       -- Reklam maliyeti, string'den float'a dönüştürüldü
    cast(impression as numeric) as impression,                 -- Gösterim sayısı
    cast(click as numeric) as click                            -- Reklam tıklama sayısı
from {{ source('gz_raw_data', 'raw_gz_bing') }}


--dbt run-operation codegen.generate_base_model --args '{"source_name": "raw_gz_bing", "table_name": "raw_gz_bing"} > staging'
--dbt run-operation codegen.generate_base_models
