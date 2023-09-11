select
    id,
    decidim_order_id,
    decidim_project_id
from {{ source('decidim', 'decidim_budgets_line_items') }}
