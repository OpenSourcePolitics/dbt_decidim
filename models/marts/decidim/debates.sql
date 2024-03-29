select
    decidim_debates_debates.id,
    title->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as title,
    regexp_replace(description->>'{{ env_var('DBT_LANGUAGE_CODE') }}', E'(<[^>]+>)|(&[a-z]+;)', '', 'gi') as description,
    start_time,
    end_time,
    decidim_component_id,
    decidim_author_id,
    decidim_debates_debates.created_at,
    closed_at,
    ps_slug,
    concat('https://', organization_host, '/', ps_space_type_slug, '/', ps_slug, '/f/', decidim_components.id, '/debates/', decidim_debates_debates.id) as debate_url,
    'Decidim::Debates::Debate' as resource_type,
    categories,
    coalesce(categories[1], 'Sans catégorie') as first_category,
    sub_categories,
    coalesce(sub_categories[1], 'Sans sous-catégorie') as first_sub_category
from decidim_debates_debates
    join {{ ref('components')}} decidim_components on decidim_components.id = decidim_component_id
    left join (
      select array_agg(name) as categories, 
          array_agg(child_name) as sub_categories,
          categorizable_id
      from {{ ref('categorizations') }} categorizations
      where categorizations.categorizable_type = 'Decidim::Debates::Debate'
      group by categorizable_id
    ) as categorizations on categorizations.categorizable_id = decidim_debates_debates.id 