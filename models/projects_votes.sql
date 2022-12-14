-- /!\ Warning : counts unfinished votes !
select
    decidim_budgets_orders.id,
    decidim_user_id,
    decidim_budgets_projects.id as "project_id",
    decidim_budgets_projects.title as "project_title",
    decidim_budgets_projects.decidim_component_id,
    created_at,
    checked_out_at,
    project_url
from {{ ref('budgets_projects') }} as decidim_budgets_projects
    join decidim_budgets_line_items on decidim_budgets_line_items.decidim_project_id = decidim_budgets_projects.id
    join decidim_budgets_orders on decidim_budgets_orders.id = decidim_budgets_line_items.decidim_order_id