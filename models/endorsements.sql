with contributions as (
        select decidim_endorsements.*, decidim_component_id
        from decidim_endorsements
            join {{ ref('proposals') }} decidim_proposals_proposals on decidim_endorsements.resource_id = decidim_proposals_proposals.id
                and decidim_proposals_proposals.resource_type = decidim_endorsements.resource_type
    union all
        select decidim_endorsements.*,decidim_component_id
        from decidim_endorsements
            join {{ ref('debates') }} as decidim_debates_debates on decidim_endorsements.resource_id = decidim_debates_debates.id
                and decidim_debates_debates.resource_type = decidim_endorsements.resource_type
    union all
        select decidim_endorsements.*,decidim_component_id
        from decidim_endorsements
            join {{ ref('blog_posts') }} as decidim_blogs_posts on decidim_endorsements.resource_id = decidim_blogs_posts.id
                and decidim_blogs_posts.resource_type = decidim_endorsements.resource_type
) 
select contributions.*
from contributions
    left join decidim_moderations on resource_type = decidim_reportable_type
        and resource_id = decidim_reportable_id 
where hidden_at is null