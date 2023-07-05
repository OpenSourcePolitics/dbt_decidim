select
    id,
    decidim_category_id,
    categorizable_id,
    categorizable_type,
    created_at,
    updated_at
from {{ source('decidim', 'decidim_categorizations')}}
    