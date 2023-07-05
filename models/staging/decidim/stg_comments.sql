select
    id,
    {{ lang('body') }} as body,
    decidim_author_id,
    decidim_author_type,
    decidim_user_group_id,
    decidim_commentable_id,
    decidim_commentable_type,
    decidim_root_commentable_id,
    decidim_root_commentable_type,
    depth,
    alignment,
    created_at,
    updated_at
from {{ source('decidim', 'decidim_comments_comments') }}
