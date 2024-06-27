{{
    config(
        materialized = 'table'
    )
}}
with
    new_order_revenue as (
        select
            date_trunc('month', fo.order_purchase_timestamp)::date as order_month,
            round(sum(dp.payment_value)::numeric, 2) as revenue,
            count(*) as no_orders
        from {{ ref("fact_orders_valid") }} fo
        join {{ ref("dim_payments") }} dp on fo.order_id = dp.order_id
        group by 1
    ),
    -- new_aov as (
    --     select 
    --         *,
    --         round((revenue / no_orders)::numeric, 2) as aov
    --     from new_order_revenue
    -- ),
    no_trans as (
        select
            order_id,
            count(*) as no_items
        from {{ ref("fact_orders_line_items_valid") }}
        group by 1
    ),
    trans_by_month as (
        select
            date_trunc('month', fo.order_purchase_timestamp)::date as order_month,
            sum(foli.no_items) as tot_units
        from {{ ref("fact_orders_valid") }} fo
        join no_trans foli
        on fo.order_id = foli.order_id
        group by 1
    )
select
    n.*,
    t.tot_units,
    round((n.revenue::numeric / n.no_orders::numeric), 2) as aov,
    round((t.tot_units::numeric/n.no_orders::numeric),2) as upt,
    round((n.revenue/t.tot_units) ,2) as aur
from trans_by_month t
join new_order_revenue n
on t.order_month = n.order_month
