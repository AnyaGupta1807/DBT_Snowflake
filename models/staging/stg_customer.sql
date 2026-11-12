{{
    config(
        materialized ='table'
    )
}}

with cte as (
    select * from {{source('raw','CUSTOMERS')}} 
)

select city, 
       country ,
       created_at, 
       first_name as f_name,
       last_name as l_name,
       Email,
       phone 
       from cte