{{
    config(
        materialized = 'view',
        tags = 'ecom'
    )
}}

select
    *
from {{ source("public", "olist_customers_dataset") }}
