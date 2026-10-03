{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='order_item_id'
) }}

select
    {{ dbt_utils.generate_surrogate_key([
        'order_id',
        'product_id'
    ]) }} as order_item_id,

    order_id,
    product_id,
    quantity,
    price

from {{ source('landing','order_items') }}

{% if is_incremental() %}

where order_id >
(
    select coalesce(max(order_id),0)
    from {{ this }}
)

{% endif %}