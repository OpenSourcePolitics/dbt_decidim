{%- set source_relation = adapter.get_relation(
      database=source('decidim', 'decidim_initiatives').database,
      schema=source('decidim', 'decidim_initiatives').schema,
      identifier=source('decidim', 'decidim_initiatives').name) -%}

{% set table_exists=source_relation is not none %}

{% if table_exists %}

{{ log("Table exists", info=True) }}

select
    id,
    created_at
    published_at,
    {{ lang('title') }} as title,
    {{ lang('description') }} as description,
    decidim_author_id,
    decidim_organization_id,
    state,
    signature_type,
    signature_start_date,
    answer
from {{ source('decidim', 'decidim_initiatives') }}

{% else %}

{{ log("Table does not exist", info=True) }}

select 
    null as id,
    null as created_at,
    null as published_at,
    null as title,
    null as description,
    null as decidim_author_id,
    null as decidim_organization_id,
    null as state,
    null as signature_type,
    null as signature_start_date,
    null as answer
where false

{% endif %}