select
    id,
    published_at,
    {{ lang('title') }} as title,
    {{ lang('subtitle') }} as subtitle,
    slug,
    'Decidim::Assembly' as type,
    'assemblies' as space_type_slug,
    decidim_organization_id
from {{ source('decidim', 'decidim_assemblies') }}
