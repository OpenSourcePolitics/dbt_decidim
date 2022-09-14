select 
    decidim_initiatives.id,
    decidim_initiatives.id::text as id_as_text,
    title->>'fr' as title,
    regexp_replace(decidim_initiatives.description->>'fr', E'(<[^>]+>)|(&[a-z]+;)', '', 'gi') as description,
    decidim_author_id,
    published_at,
    (case state
      when 0 then 'Created'
      when 1 then 'Validated'
      when 2 then 'Discarded'
      when 3 then 'Published'
      when 4 then 'Rejected'
      when 5 then 'Accepted'
    end) as parsed_state,
    state,
    signature_type,
    signature_start_date,
    signature_end_date,
    regexp_replace(answer->>'fr', E'(<[^>]+>)|(&[a-z]+;)', '', 'gi') as answer,
    answered_at,
    answer_url,
    decidim_initiatives.created_at,
    decidim_initiatives.updated_at,
    decidim_user_group_id,
    hashtag,
    scoped_type_id,
    decidim_author_type,
    parsed_online_votes,
    parsed_offline_votes,
    parsed_online_votes + parsed_offline_votes as sum_votes,
    comments_count,
    follows_count,
    concat('https://', (select host from {{ ref('organizations') }} org), '/initiatives/i-',decidim_initiatives.id) as url,
    supports_required,
    decidim_areas.id as area_id,
    (case when decidim_areas.name ? 'fr' then decidim_areas.name->>'fr' else 'No sub category' end) as area_name,
    (case when decidim_area_types.name ? 'fr' then decidim_area_types.name->>'fr' else 'No category' end) as area_type_name,
    'Decidim::Initiative' as resource_type
from decidim_initiatives
    join {{ ref('organizations') }} decidim_organizations on decidim_organizations.id = decidim_initiatives.decidim_organization_id
    join decidim_initiatives_type_scopes on scoped_type_id = decidim_initiatives_type_scopes.id
    left join decidim_areas on decidim_areas.id = decidim_initiatives.decidim_area_id
    left join decidim_area_types on decidim_area_types.id = area_type_id,
    lateral (select (case when online_votes ? 'total' then online_votes->>'total' else '0' end)::int as parsed_online_votes) t_online,
    lateral (select (case when offline_votes ? 'total' then offline_votes->>'total' else '0' end)::int as parsed_offline_votes) t_offline