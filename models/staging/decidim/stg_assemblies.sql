select
    id,
    published_at,
    title->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as title,
    subtitle->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as subtitle,
    slug,
    'Decidim::Assembly' as type,
    'assemblies' as space_type_slug,
    decidim_organization_id
from decidim_assemblies
