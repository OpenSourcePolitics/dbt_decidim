select
    id,
    decidim_user_id,
    decidim_followable_id,
    decidim_followable_type,
    created_at,
    updated_at
from {{ source('decidim', 'decidim_follows')}}
