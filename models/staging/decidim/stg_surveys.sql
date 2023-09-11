select
    id,
    decidim_component_id,
    created_at,
    updated_at
from {{ source('decidim', 'decidim_surveys_surveys') }}
