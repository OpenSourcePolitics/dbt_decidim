select
    id,
    {{ lang('title') }} as title,
    {{ html_cleaning(lang('description')) }} as description,
    {{ lang('tos') }} as tos,
    questionnaire_for_id,
    questionnaire_for_type,
    published_at,
    created_at,
    updated_at,
    salt
from {{ source('decidim', 'decidim_forms_questionnaires') }}
