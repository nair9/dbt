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
    no_trans as (
        select
            order_id,
            count(*) as no_items
        from {{ ref("fact_orders_line_items_valid") }}
        group by 1
    ),
    trans_by_day as (
        select
            date_trunc('day', fo.order_purchase_timestamp)::date as order_date,
            sum(foli.no_items) as tot_units
        from {{ ref("fact_orders_valid") }} fo
        join no_trans foli
        on fo.order_id = foli.order_id
        group by 1
    ),
    ty as (
        select
            order_date,
            revenue as ty_revenue
        from order_revenue
    ),
    ly as (select * from ty),
    tyly as (
        select
            ty.order_date as ty_date,
            ty.ty_revenue,
            ly.order_date as ly_date,
            ly.ty_revenue as ly_revenue
        from ty
        left join ly on ly.order_date = dateadd(day, -364, ty.order_date)
    )
select
    n.order_date,
    n.revenue as ty_revenue,
    n.no_orders,
    t.tot_units,
    tyly.ly_date,
    tyly.ly_revenue,
    round((n.revenue / n.no_orders)::numeric, 2) as aov,
    round((t.tot_units::numeric/n.no_orders::numeric),2) as upt,
    round((n.revenue/t.tot_units) ,2) as aur
from trans_by_day t
join order_revenue n
on t.order_date = n.order_date
join tyly tyly
on t.order_date = tyly.ty_date
