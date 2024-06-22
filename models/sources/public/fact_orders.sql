{{
    config(
        materialized = 'view',
        tags = 'ecom'
    )
}}

select
    *
from {{ source("public", "olist_orders_dataset") }}
