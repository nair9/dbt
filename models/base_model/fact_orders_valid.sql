{{ config(materialized="table") }}
with
    first_order_date as (
        select fo.customer_id, min(fo.order_purchase_timestamp) as first_order_date
        from {{ ref("fact_orders") }} fo
        where fo.order_status = 'delivered'
        group by fo.customer_id
    ),
    first_order as (
        select
            fo.customer_id,
            fo.order_id,
            fo.order_purchase_timestamp,
            f.first_order_date,
            case
                when f.first_order_date = fo.order_purchase_timestamp then 1 else 0
            end as is_first_order
        from {{ ref("fact_orders") }} fo
        join
            first_order_date f
            on fo.customer_id = f.customer_id
            and fo.order_purchase_timestamp = f.first_order_date
    )
select fo.*, f.first_order_date, f.is_first_order
from {{ ref("fact_orders") }} fo
left join first_order f on fo.order_id = f.order_id
where fo.order_status = 'delivered'
