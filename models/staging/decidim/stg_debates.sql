select
    id,
    title->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as title,
    regexp_replace(
        description->>'{{ env_var('DBT_LANGUAGE_CODE') }}',
        E'(<[^>]+>)|(&[a-z]+;)', '', 'gi'
    ) as description,
    instructions->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as instructions,
    start_time,
    end_time,
    closed_at,
    decidim_component_id,
    decidim_author_id,
    created_at,
    'Decidim::Debates::Debate' as resource_type
from {{ source('decidim', 'decidim_debates_debates') }}
