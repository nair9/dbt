select *
from {{ ref("fact_orders_valid") }} m
where m.first_order_date > m.order_purchase_timestamp
