{{
    config(
        materialized = 'table'
    )
}}
select
    foli.*,
    prod.product_category_name,
    prod.product_name_lenght,
    prod.product_description_lenght,
    prod.product_photos_qty,
    prod.product_weight_g,
    prod.product_length_cm,
    prod.product_height_cm,
    prod.product_width_cm
from {{ ref("fact_orders_line_items_valid") }} as foli
left join {{ ref("dim_products") }} as prod
    on foli.product_id = prod.product_id
