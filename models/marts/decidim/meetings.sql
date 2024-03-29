select
    decidim_meetings_meetings.id,
    decidim_meetings_meetings.title->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as title,
    regexp_replace(description->>'{{ env_var('DBT_LANGUAGE_CODE') }}', E'(<[^>]+>)|(&[a-z]+;)', '', 'gi') as description,
    (case length(address) when 0 then 'Pas d''adresse' else address end) as address,
    (case when attendees_count is null is false then attendees_count else 0 end) as attendees_count,
    decidim_meetings_meetings.created_at,
    decidim_scope_id,
    decidim_component_id,
    start_time,
    end_time,
    registration_url,
    'https://' || organization_host || '/' || ps_space_type_slug || '/' || ps_slug || '/f/' || decidim_component_id || '/meetings/' || decidim_meetings_meetings.id as meeting_url,
    private_meeting,
    decidim_author_id,
    'Decidim::Meetings::Meeting' as resource_type,
    categories,
    coalesce(categories[1], 'Sans catégorie') as first_category,
    sub_categories,
    coalesce(sub_categories[1], 'Sans sous-catégorie') as first_sub_category
from decidim_meetings_meetings
    join {{ ref('components') }} as decidim_components on decidim_meetings_meetings.decidim_component_id = decidim_components.id
    left join (
      select array_agg(name) as categories, 
          array_agg(child_name) as sub_categories,
          categorizable_id
      from {{ ref('categorizations') }} categorizations
      where categorizations.categorizable_type = 'Decidim::Meetings::Meeting'
      group by categorizable_id
    ) as categorizations on categorizations.categorizable_id = decidim_meetings_meetings.id 
where manifest_name like 'meetings'