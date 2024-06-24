{{ config(materialized="table") }}

select *
from {{ ref("fact_order_line_items") }} fo
where fo.order_id in (select order_id from {{ ref("fact_orders_valid") }})
