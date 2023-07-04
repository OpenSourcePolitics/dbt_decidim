select
    id,
    name->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as name,
    regexp_replace(
        description->>'{{ env_var('DBT_LANGUAGE_CODE') }}',
        E'(<[^>]+>)|(&[a-z]+;)', '', 'gi'
    ) as description,
    decidim_participatory_space_id,
    decidim_participatory_space_type,
    weight,
    parent_id
from {{ source('decidim', 'decidim_categories') }}
