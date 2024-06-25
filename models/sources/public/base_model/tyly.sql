{{
    config(
        materialized = 'table'
    )
}}
with
    order_revenue as (
        select
            date_trunc('day', fo.order_purchase_timestamp)::date as order_date,
            round(sum(dp.payment_value)::numeric, 2) as revenue,
            count(*) as no_orders
        from {{ ref("fact_orders_valid") }} fo
        join {{ ref("dim_payments") }} dp on fo.order_id = dp.order_id
        group by 1
    ),
    ty as (
            select
                order_date,
                revenue as ty_revenue
            from order_revenue
            -- group by 1
        ),
    ly as (select * from ty)
select
    ty.order_date as ty_date,
    ty.ty_revenue,
    ly.order_date as ly_date,
    ly.ty_revenue as ly_revenue
from ty
left join ly on ly.order_date = dateadd(day, -364, ty.order_date)