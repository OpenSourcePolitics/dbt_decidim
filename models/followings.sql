with complete_followings as (
    with followings as (
            select decidim_follows.*,
                decidim_proposals_proposals.decidim_component_id,
                url as followable_url,
                title as followable_title
            from decidim_follows
                join {{ ref('proposals') }} decidim_proposals_proposals on decidim_proposals_proposals.id = decidim_followable_id
                    and resource_type = decidim_followable_type
        union all
            select distinct decidim_follows.*,
                -1 as "decidim_components.id",
                ps_url as followable_url,
                ps_title as followable_title
            from decidim_follows
                join {{ ref('components') }} decidim_components on decidim_components.ps_id = decidim_followable_id
                    and ps_type = decidim_followable_type
        union all
            select decidim_follows.*, decidim_debates_debates.decidim_component_id, debate_url as followable_url, title as followable_title
            from decidim_follows
                join {{ ref('debates') }} decidim_debates_debates on decidim_debates_debates.id = decidim_followable_id
                    and resource_type =  decidim_followable_type
        union all
            select decidim_follows.*, decidim_blogs_posts.decidim_component_id, post_url as followable_url, title as followable_title
            from decidim_follows
                join {{ ref('blog_posts') }} decidim_blogs_posts on decidim_blogs_posts.id = decidim_followable_id
                    and resource_type = decidim_followable_type
        union all
            select decidim_follows.*, -1 as decidim_component_id, '' as followable_url, '' as followable_title
            from decidim_follows
                join {{ ref('users') }} decidim_users on decidim_users.id = decidim_followable_id
            where decidim_followable_type = 'Decidim::UserBaseEntity'
        union all
            select decidim_follows.*, decidim_component_id, meeting_url as followable_url, title as followable_title
            from decidim_follows
                join {{ ref('meetings') }} decidim_meetings on decidim_meetings.id = decidim_followable_id
                    and resource_type = decidim_followable_type
        union all
            select decidim_follows.*, decidim_component_id, project_url as followable_url, title as followable_title
            from decidim_follows
                join {{ ref('budgets_projects') }} decidim_budgets_projects on decidim_budgets_projects.id = decidim_followable_id
                    and resource_type = decidim_followable_type
        union all
            select decidim_follows.*, -1 as decidim_component_id, url as followable_url, title as followable_title
            from decidim_follows
                join {{ref('initiatives')}} decidim_initiatives on decidim_initiatives.id = decidim_followable_id
                    and resource_type = decidim_followable_type
    )
        select 
            followings.*,
            'real_follow' as "following_way",
            decidim_followable_id as "root_decidim_followable_id",
            decidim_followable_type as "root_decidim_followable_type",
            followable_url as "root_following_url",
            followable_title as "root_followable_title"
        from followings,
            lateral (select (case array_length(array_remove(string_to_array(decidim_followable_type, ':', ''),null),1) when 2 then 'Ancestor' else 'Child' end) as followable_meta_type) p_is_ps
        where followable_meta_type != 'Ancestor'
    union all
        select
            distinct
            followings.*,
            'ancestor_follow' as "following_way",
            children_followings.decidim_followable_id as "root_decidim_followable_id",
            children_followings.decidim_followable_type as "root_decidim_followable_type",
            children_followings.followable_url as "root_following_url",
            children_followings.followable_title as "root_followable_title"
        from (
            select 
            followings.*,
                'real_follow' as "following_way",
                decidim_followable_id as "root_decidim_followable_id",
                decidim_followable_type as "root_decidim_followable_type",
                followable_url as "root_following_url"
            from followings,
                lateral (select (case array_length(array_remove(string_to_array(decidim_followable_type, ':', ''),null),1) when 2 then 'Ancestor' else 'Child' end) as followable_meta_type) p_is_ps
            where followable_meta_type != 'Ancestor'
        ) as children_followings
            join {{ ref('components') }} as components on components.id = children_followings.decidim_component_id
            join followings on followings.decidim_followable_id = components.ps_id and followings.decidim_followable_type = components.ps_type
)
select id,
    decidim_user_id,
    root_decidim_followable_id,
    root_decidim_followable_type,
    root_followable_title,
    created_at,
    updated_at,
    root_following_url,
    decidim_followable_id,
    decidim_followable_type,
    followable_url,
    following_way
from complete_followings
order by root_decidim_followable_id