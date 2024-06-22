{{
    config(
        materialized = 'view',
        tags = 'ecom'
    )
}}

select *
from {{ source("public", "olist_geolocation_dataset") }}
