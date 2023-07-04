select 
    id,
    (case manifest_name 
        when 'blogs' then 'posts' 
        else manifest_name 
    end) as manifest_name,
    name->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as name,
    participatory_space_id,
    participatory_space_type,
    settings,
    weight,
    permissions,
    published_at,
    created_at,
    updated_at
from {{ source('decidim', 'decidim_components') }}
