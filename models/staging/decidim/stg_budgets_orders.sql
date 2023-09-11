select
    id,
    decidim_user_id,
    checked_out_at,
    created_at,
    updated_at,
    decidim_budgets_budget_id
from {{ source('decidim', 'decidim_budgets_orders') }}
