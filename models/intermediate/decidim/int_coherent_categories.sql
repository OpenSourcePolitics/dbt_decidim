-- All categories
with all_categories as (
    select *
    from {{ ref('stg_categories')}} 
),

-- Parent categories
parent_categories as (
    select *,
        '' as parent_name,
        '' as parent_description 
    from all_categories
    where parent_id is null
),

-- Child categories without informations about parents'
child_categories_without_parent_infos as (
    select *
    from all_categories
    where parent_id is not null
),

child_categories as (
    select 
        child_categories_without_parent_infos.*,
        all_categories.name as parent_name,
        all_categories.name as parent_description
    from child_categories_without_parent_infos
        join all_categories
            on child_categories_without_parent_infos.parent_id = all_categories.id
),

final as (
    select *
    from parent_categories
        union all
    select *
    from child_categories
)

select * from final
