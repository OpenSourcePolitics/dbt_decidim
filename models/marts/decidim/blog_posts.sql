select
    decidim_blogs_posts.id,
    title->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as title,
    regexp_replace(body->>'{{ env_var('DBT_LANGUAGE_CODE') }}', E'(<[^>]+>)|(&[a-z]+;)', '', 'gi') as body,
    decidim_component_id,
    decidim_blogs_posts.created_at,
    decidim_blogs_posts.updated_at,
    decidim_author_id,
    concat('https://', organization_host, '/', ps_space_type_slug, '/', ps_slug, '/f/', decidim_components.id, '/posts/', decidim_blogs_posts.id) as post_url,
    'Decidim::Blogs::Post' as resource_type
from decidim_blogs_posts
    join {{ ref('components') }} decidim_components on decidim_components.id = decidim_component_id