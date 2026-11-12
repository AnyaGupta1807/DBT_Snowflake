{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='order_id'
    )
}}

with cte as (
    select * from {{source('raw','ORDERS')}}
)

select 
order_id,
customer_id,
status,
shipped_date
from cte
{% if is_incremental() %}
where shipped_date > (select max(shipped_date) from {{this}})
{% endif %}