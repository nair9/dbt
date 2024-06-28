{{
    config(
        materialized = 'table'
    )
}}
select
    *
from {{ref("dim_customers")}} cust
left join {{ref("dim_geolocation")}} geo
on cust.customer_city = geo.geolocation_city
limit 10