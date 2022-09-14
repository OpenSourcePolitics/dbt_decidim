select
    decidim_budgets_budgets.id,
    decidim_budgets_budgets.title->>'fr' as title,
    decidim_components.id as decidim_component_id
from decidim_budgets_budgets
    join {{ ref('organizations') }} as decidim_components on decidim_components.id = decidim_budgets_budgets.decidim_component_id