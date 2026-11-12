{{
    config(
        materialized='incremental',
        unique_key='order_id',
        incremental_strategy='merge'
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
{%if is_incremental()%}
where shipped_date > (select max(shipped_date) from {{this}})      --jijna template. or can use source
{%endif%}