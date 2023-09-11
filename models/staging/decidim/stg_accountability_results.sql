
select
    id,
    {{ lang('title') }} as title,
    {{ html_cleaning(lang('description')) }} as description,
    reference,
    start_date,
    end_date,
    progress,
    parent_id,
    decidim_accountability_status_id,
    decidim_component_id,
    decidim_scope_id,
    created_at,
    updated_at,
    children_count,
    weight,
    external_id,
    comments_count
from {{ source('decidim', 'decidim_accountability_results') }}
