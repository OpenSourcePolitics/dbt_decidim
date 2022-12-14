-- Warning: are not taken by default into account Conferences, Consultations, Elections, Initiatives, Votations. Uncomment corresponding line to do so
-- This request needs a meta request giving targeted Decidim organizations
with participatory_spaces as (
        select
            id as ps_id,
            published_at as ps_published_at,
            title->>'{{ var('DBT_LANGUAGE_CODE') }}' as ps_title,
            subtitle->>'{{ var('DBT_LANGUAGE_CODE') }}' as ps_subtitle,
            slug as ps_slug,
            decidim_organization_id,
            'Decidim::Assembly' as ps_type,
            'assemblies' as ps_space_type_slug
        from decidim_assemblies
    union all
        select
            id as ps_id, 
            published_at as ps_published_at, 
            title->>'{{ var('DBT_LANGUAGE_CODE') }}' as ps_title, 
            subtitle->>'{{ var('DBT_LANGUAGE_CODE') }}' as ps_subtitle, 
            slug as ps_slug, 
            decidim_organization_id, 
            'Decidim::ParticipatoryProcess' as ps_type,
            'processes' as ps_space_type_slug
        from decidim_participatory_processes
    -- union all
    -- select id, published_at, title, '{}'::jsonb as subtitle, slug, decidim_organization_id, 'Decidim::Conferences' as participatory_space_type
    -- from decidim_conferences
    -- union all
    -- select id, published_at, title, subtitle, slug, decidim_organization_id, 'Decidim::Consultations' as participatory_space_type
    -- from decidim_consultations
    -- union all
    -- select id, published_at, title, subtitle, slug, decidim_organization_id, 'Decidim::Elections' as participatory_space_type
    -- from decidim_elections
    -- union all
    -- select id, published_at, title, '{}'::jsonb as subtitle, slug, decidim_organization_id, 'Decidim::Initiatives' as participatory_space_type
    -- from decidim_initiatives
)
select 
    decidim_components.id,
    manifest_name,
    (case manifest_name when 'blogs' then 'posts' else manifest_name end) as manifest_name_for_url,
    published_at,
    decidim_components.created_at,
    participatory_spaces.*,
    decidim_organizations.host as organization_host,
    concat('https://',decidim_organizations.host,'/', ps_space_type_slug, '/',ps_slug,'/f/',decidim_components.id) as "component_url",
    concat('https://',decidim_organizations.host,'/', ps_space_type_slug, '/',ps_slug,'/') as "ps_url"
from decidim_components
    join participatory_spaces on participatory_spaces.ps_type = decidim_components.participatory_space_type and decidim_components.participatory_space_id = participatory_spaces.ps_id 
    join {{ref('organizations')}} as decidim_organizations on decidim_organizations.id = participatory_spaces.decidim_organization_id
where array_position(array[decidim_components.published_at, participatory_spaces.ps_published_at], null) is null

