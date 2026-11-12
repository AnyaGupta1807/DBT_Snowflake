{{
    config(
        materialized='incremental',
        incremental_strategy='insert_overwrite',
        partition_by={
            "field": "shipped_date",
            "data_type":"date"

        }
    )
}}

with cte as (
    select * from {{source('raw','ORDERS')}}
)

select 
order_id,
customer_id,
status,
shipped_date,
current_timestamp() as DS
from cte
{%if is_incremental()%}
where shipped_date > (select max(shipped_date) from {{this}})      --jijna template. or can use source
{%endif%}