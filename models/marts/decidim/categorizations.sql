with participations_categorized as (
    select
        decidim_categories.id as id,
        decidim_categories.name->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as name,
        null as child_id,
        null as child_name,
        categorizable_id,
        categorizable_type
    from decidim_categorizations
        join decidim_categories on decidim_categories.id = decidim_categorizations.decidim_category_id
    where decidim_categories.parent_id is null
union all
    select
        parent_categories.id as id,
        parent_categories.name->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as name,
        decidim_categories.id as child_id,
        decidim_categories.name->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as child_name,
        categorizable_id,
        categorizable_type
    from decidim_categorizations
        join decidim_categories on decidim_categories.id = decidim_categorizations.decidim_category_id
        left join decidim_categories parent_categories on decidim_categories.parent_id = parent_categories.id
    where decidim_categories.parent_id is not null
)
select *
from participations_categorized