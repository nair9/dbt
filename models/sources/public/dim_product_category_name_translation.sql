{{
    config(
        materialized = 'view',
        tags = 'ecom'
    )
}}

select
    *
from {{ source("public", "product_category_name_translation") }}
