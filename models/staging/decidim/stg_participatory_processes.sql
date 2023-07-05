select
    id, 
    published_at, 
    {{ lang('title') }} as title,
    {{ lang('subtitle') }} as subtitle, 
    slug, 
    'Decidim::ParticipatoryProcess' as type,
    'processes' as space_type_slug,
    decidim_organization_id
from {{ source('decidim', 'decidim_participatory_processes') }}