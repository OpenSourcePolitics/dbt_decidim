-- WARNING: based on the definition of the decidim_app here : https://github.com/OpenSourcePolitics/decidim-app
with commentaries as (
        select decidim_comments_comments.*, decidim_accountability_results.decidim_component_id as "decidim_component_id"
        from decidim_accountability_results join decidim_comments_comments on decidim_root_commentable_id = decidim_accountability_results.id
        where decidim_root_commentable_type = 'Decidim::Accountability::Result'
    union all
        select decidim_comments_comments.*, decidim_blogs_posts.decidim_component_id as "decidim_component_id"
        from {{ ref('blog_posts') }} decidim_blogs_posts
            join decidim_comments_comments on decidim_root_commentable_id = decidim_blogs_posts.id
                and decidim_root_commentable_type = decidim_blogs_posts.resource_type
    union all
        select decidim_comments_comments.*, decidim_budgets_projects.decidim_component_id as "decidim_component_id"
        from {{ ref('budgets_projects') }} decidim_budgets_projects
            join decidim_comments_comments on decidim_root_commentable_id = decidim_budgets_projects.id
                and decidim_root_commentable_type = decidim_budgets_projects.resource_type
    union all
        select decidim_comments_comments.*, decidim_debates_debates.decidim_component_id as "decidim_component_id"
        from {{ ref('debates') }} decidim_debates_debates
            join decidim_comments_comments on decidim_root_commentable_id = decidim_debates_debates.id
                and decidim_root_commentable_type = decidim_debates_debates.resource_type
    union all
        select decidim_comments_comments.*, decidim_meetings_meetings.decidim_component_id as "decidim_component_id"
        from {{ ref('meetings') }} as decidim_meetings_meetings
            join decidim_comments_comments on decidim_comments_comments.decidim_root_commentable_id = decidim_meetings_meetings.id
                and decidim_root_commentable_type = decidim_meetings_meetings.resource_type
    union all
        select decidim_comments_comments.*, decidim_proposals_proposals.decidim_component_id as "decidim_component_id"
        from {{ ref('proposals') }} as decidim_proposals_proposals
            join decidim_comments_comments on decidim_root_commentable_id = decidim_proposals_proposals.id
                and decidim_root_commentable_type = decidim_proposals_proposals.resource_type
    union all
            select decidim_comments_comments.*, decidim_proposals_collaborative_drafts.decidim_component_id as "decidim_component_id"
        from decidim_proposals_collaborative_drafts
            join decidim_comments_comments on decidim_comments_comments.decidim_root_commentable_id = decidim_proposals_collaborative_drafts.id
            left join decidim_moderations on decidim_proposals_collaborative_drafts.id = decidim_moderations.decidim_reportable_id
        where decidim_root_commentable_type = 'Decidim::Proposals::CollaborativeDraft'
            and decidim_proposals_collaborative_drafts.published_at is not null
            and decidim_moderations.hidden_at is null
)
select
    commentaries.id,
    commentaries.decidim_commentable_id,
    commentaries.decidim_commentable_type,
    commentaries.decidim_author_id,
    commentaries.created_at,
    commentaries.depth,
    commentaries.alignment,
    decidim_root_commentable_id,
    decidim_root_commentable_type,
    decidim_author_type,
    body->>'fr' as body,
    commentaries.decidim_component_id,
    decidim_components.ps_slug,
    concat('https://', organization_host, '/', ps_space_type_slug, '/', ps_slug, '/f/', decidim_components.id, '/', manifest_name_for_url,'/', commentaries.decidim_root_commentable_id, '?commentId=', commentaries.id, '#comment_', commentaries.id) as comment_url
from commentaries
    join {{ ref('components') }} as decidim_components on decidim_components.id = commentaries.decidim_component_id
    left join decidim_moderations on decidim_moderations.decidim_reportable_id = commentaries.id
where (decidim_moderations.hidden_at is null or (decidim_moderations.hidden_at is not null and decidim_moderations.decidim_reportable_type not like 'Decidim::Comments::Comment'))