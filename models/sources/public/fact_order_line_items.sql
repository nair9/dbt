{{
    config(
        materialized = 'view',
        tags = 'ecom'
    )
}}

select *
from {{ source("public", "olist_order_items_dataset") }}
