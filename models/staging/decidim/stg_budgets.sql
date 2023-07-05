select 
    id,
    {{ lang('title') }} as title,
    {{ html_cleaning(lang('description')) }} as description,
    weight,
    total_budget,
    decidim_component_id,
    created_at,
    updated_at,
    decidim_scope_id
from {{ source('decidim', 'decidim_budgets_budgets')}}