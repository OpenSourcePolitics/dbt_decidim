select
    decidim_proposals_proposals.id,
    ps_id as decidim_participatory_space_id,
    ps_slug as decidim_participatory_space_slug,
    coalesce(nullif(decidim_scopes.name->>'{{ env_var('DBT_LANGUAGE_CODE') }}', ''), 'Sans secteur') as decidim_scope_name,
    regexp_replace(decidim_proposals_proposals.title->>'{{ env_var('DBT_LANGUAGE_CODE') }}', E'(<[^>]+>)|(&[a-z]+;)', '', 'gi') as title,
    regexp_replace(decidim_proposals_proposals.body->>'{{ env_var('DBT_LANGUAGE_CODE') }}', E'(<[^>]+>)|(&[a-z]+;)', '', 'gi') as content,
    'Decidim::Proposals::Proposal' as resource_type,
    concat('https://',organization_host,'/',ps_space_type_slug,'/',ps_slug,'/f/',decidim_proposals_proposals.decidim_component_id,'/proposals/',decidim_proposals_proposals.id) as url,
    decidim_proposals_proposals.decidim_component_id,
    decidim_proposals_proposals.created_at,
    decidim_proposals_proposals.published_at,
    state,
    authors_ids,
    coalesce(authors_ids[1], -1) as first_author_id,
    coalesce(nullif(decidim_proposals_proposals.address,''),'Pas d''adresse') as address,
    categories,
    coalesce(categories[1], 'Sans catégorie') as first_category,
    sub_categories,
    coalesce(sub_categories[1], 'Sans sous-catégorie') as first_sub_category
from decidim_proposals_proposals
    join {{ref('components')}} as decidim_components on decidim_components.id = decidim_component_id
    left join (
        select array_agg(decidim_users.id) as authors_ids, decidim_coauthorships.coauthorable_id 
        from {{ref('users')}} as decidim_users 
            join decidim_coauthorships on decidim_users.id = decidim_coauthorships.decidim_author_id
        where coauthorable_type = 'Decidim::Proposals::Proposal'
        group by coauthorable_id
    ) as coauthorships on decidim_proposals_proposals.id = coauthorable_id
    left join decidim_moderations on decidim_reportable_id = decidim_proposals_proposals.id
    left join decidim_scopes on decidim_scopes.id = decidim_proposals_proposals.decidim_scope_id
    left join (
      select array_agg(name) as categories, 
          array_agg(child_name) as sub_categories,
          categorizable_id
      from {{ref('categorizations')}} categorizations
      where categorizations.categorizable_type = 'Decidim::Proposals::Proposal'
      group by categorizable_id
    ) as categorizations on categorizations.categorizable_id = decidim_proposals_proposals.id 
where true
    and not(hidden_at is not null and decidim_reportable_type = 'Decidim::Proposals::Proposal')
    and decidim_proposals_proposals.published_at is not null
group by decidim_proposals_proposals.id,
    ps_id,
    ps_slug,
    decidim_scope_name,
    organization_host,
    ps_space_type_slug,
    authors_ids,
    categories,
    sub_categories