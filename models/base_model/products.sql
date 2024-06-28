{{
    config(
        materialized = 'table'
    )
}}
select
    *
from {{ref("fact_orders_line_items_valid")}} foli
left join {{ref("dim_products")}} prod
on foli.product_id = prod.product_id