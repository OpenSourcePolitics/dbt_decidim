select
    decidim_budgets_projects.id, 
    decidim_budgets_projects.title->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as title,
    regexp_replace(decidim_budgets_projects.description->>'{{ env_var('DBT_LANGUAGE_CODE') }}', E'(<[^>]+>)|(&[a-z]+;)', '', 'gi') as description,
    decidim_budgets_projects.decidim_scope_id, 
    decidim_budgets_projects.budget_amount as project_amount, 
    decidim_budgets_budgets.id as budget_id,
    decidim_budgets_budgets.title as budget_title,
    decidim_component_id,
    project_url,
    'Decidim::Budgets::Project' as resource_type,
    categories,
    coalesce(nullif(categories[1], ''), 'Without category') as first_category,
    sub_categories,
    coalesce(sub_categories[1], 'Sans sous-catégorie') as first_sub_category
from decidim_budgets_projects
    join {{ ref('budgets') }} as decidim_budgets_budgets on decidim_budgets_budgets.id = decidim_budgets_projects.decidim_budgets_budget_id
    join {{ ref('components') }} as decidim_components on decidim_components.id = decidim_component_id
    left join (
        select array_agg(name) as categories, 
            array_agg(child_name) as sub_categories,
            categorizable_id
        from {{ ref('categorizations') }} categorizations
        where categorizations.categorizable_type = 'Decidim::Budgets::Project'
        group by categorizable_id
    ) categorizations on categorizations.categorizable_id = decidim_budgets_projects.id,
    lateral (select concat(component_url,'/', manifest_name_for_url,'/', decidim_budgets_budgets.id, '/projects/', decidim_budgets_projects.id) as project_url) t_project_url