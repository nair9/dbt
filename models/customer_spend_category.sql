with
    cust_rev as (
        select
            fo.customer_id,
            cast(round(sum(foli.price), 2) as decimal(10, 2)) as tot_rev
        from {{ ref("fact_orders_valid") }} fo
        left join
            {{ ref("fact_orders_line_items_valid") }} foli
            on fo.order_id = foli.order_id
        group by 1
    )

select
    *,
    {{ customer_category('tot_rev') }} as customer_category
from cust_rev
