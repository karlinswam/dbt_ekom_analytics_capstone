select
  cast(product_id as bigint) as product_id,
  trim(product_name) as product_name,
  coalesce(initcap(trim(category)), 'Uncategorized') as category,
  cast(list_price as decimal(18,2)) as list_price
from {{ source('landing', 'products') }}
