select
    id,
    {{ lang('title') }} as title,
    {{ html_cleaning(lang('body')) }} as body,
    decidim_component_id,
    created_at,
    updated_at,
    decidim_author_id,
    'Decidim::Blogs::Post' as resource_type
from {{ source('decidim', 'decidim_blogs_posts') }}
