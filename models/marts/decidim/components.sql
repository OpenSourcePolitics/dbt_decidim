-- Warning: are not taken by default into account Conferences, Consultations, Elections, Initiatives, Votations. Uncomment corresponding line to do so
-- This request needs a meta request giving targeted Decidim organizations
with participatory_spaces as (
        select * from {{ ref('stg_assemblies' )}}
    union all
        select * from {{ ref('stg_participatory_processes' )}}
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
),

components as (
    select
        id,
        manifest_name,
        created_at,
        published_at,
        participatory_space_type,
        participatory_space_id
    from {{ ref('stg_components') }}
)
select 
    components.id,
    components.manifest_name,
    components.published_at,
    components.created_at,
    participatory_spaces.id as participatory_space_id,
    participatory_spaces.type as participatory_space_type, 
    decidim_organizations.host as organization_host,
    concat('https://', decidim_organizations.host, '/', space_type_slug, '/', participatory_spaces.slug, '/f/', components.id) as "component_url",
    concat('https://', decidim_organizations.host, '/', space_type_slug, '/', participatory_spaces.slug, '/') as "ps_url"
from components
    join participatory_spaces 
        on components.participatory_space_type = participatory_spaces.type
        and components.participatory_space_id = participatory_spaces.id 
    join {{ ref('organizations') }} as decidim_organizations on decidim_organizations.id = participatory_spaces.decidim_organization_id
where array_position(array[components.published_at, participatory_spaces.published_at], null) is null
