select
    id, 
    published_at, 
    title->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as title, 
    subtitle->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as subtitle, 
    slug, 
    'Decidim::ParticipatoryProcess' as type,
    'processes' as space_type_slug,
    decidim_organization_id
from decidim_participatory_processes