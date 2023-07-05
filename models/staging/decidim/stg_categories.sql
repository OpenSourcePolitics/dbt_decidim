select
    id,
    {{ lang('name') }} as name,
    {{ html_cleaning(lang('description')) }} as description,
    decidim_participatory_space_id,
    decidim_participatory_space_type,
    weight,
    parent_id
from {{ source('decidim', 'decidim_categories') }}
