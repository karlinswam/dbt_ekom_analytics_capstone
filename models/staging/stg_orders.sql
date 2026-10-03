{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='order_id'
) }}

select
    order_id,
    customer_id,
    order_date
from {{ source('landing', 'orders') }}

{% if is_incremental() %}

where order_id >
(
    select coalesce(max(order_id),0)
    from {{ this }}
)

{% endif %}