select
    id,
    title,
    description,
    file,
    content_type,
    attached_to_id,
    attached_to_type,
    created_at,
    updated_at
from {{ source('decidim','decidim_attachments')}}
