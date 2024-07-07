select
    order_purchase_timestamp as order_purchase_timestamp_utc,
    {{ convert_timezone("order_purchase_timestamp") }} as order_purchase_timestamp_est
from {{ ref("fact_orders_valid") }}
