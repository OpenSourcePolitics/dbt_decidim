select
    id,
    {{ lang('title') }} as title,
    {{ html_cleaning(lang('description')) }} as description,
    {{ lang('instructions') }} as instructions,
    start_time,
    end_time,
    closed_at,
    decidim_component_id,
    decidim_author_id,
    created_at,
    'Decidim::Debates::Debate' as resource_type
from {{ source('decidim', 'decidim_debates_debates') }}
