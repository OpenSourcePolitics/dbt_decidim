select
    id,
    {{ lang('title') }} as title,
    {{ html_cleaning(lang('description')) }} as description,
    decidim_scope_id,
    budget_amount,
    created_at,
    updated_at,
    reference,
    address,
    latitude,
    longitude,
    decidim_budgets_budget_id as budget_id,
    selected_at
from {{ source('decidim', 'decidim_budgets_projects')}}
    