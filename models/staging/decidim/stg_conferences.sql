{%- set source_relation = adapter.get_relation(
      database=source('decidim', 'decidim_conferences').database,
      schema=source('decidim', 'decidim_conferences').schema,
      identifier=source('decidim', 'decidim_conferences').name) -%}

{% set table_exists=source_relation is not none %}

{% if table_exists %}

{{ log("Table exists", info=True) }}

select
    id,
    {{ lang('title') }} as title,
    {{ lang('slogan') }} as slogan,
    slug,
    hashtag,
    reference,
    location,
    decidim_organization_id,
    {{ html_cleaning(lang('short_description')) }} as short_description,
    {{ html_cleaning(lang('description')) }} as description,
    hero_image,
    banner_image,
    promoted,
    published_at,
    {{ html_cleaning(lang('objectives')) }} as objectives,
    show_statistics,
    start_date,
    end_date,
    scopes_enabled,
    decidim_scope_id,
    registrations_enabled,
    available_slots,
    {{ html_cleaning(lang('registration_terms')) }} as registration_terms,
    created_at,
    updated_at,
    signature_name,
    signature,
    main_logo,
    sign_date,
    diploma_sent_at,
    follows_count
from {{ source('decidim', 'decidim_conferences') }}

{% else %}

{{ log("Table does not exist", info=True) }}

select
    null as id,
    null as title,
    null as slogan,
    null as slug,
    null as hashtag,
    null as reference,
    null as location,
    null as decidim_organization_id,
    null as short_description,
    null as description,
    null as hero_image,
    null as banner_image,
    null as promoted,
    null as published_at,
    null as objectives,
    null as show_statistics,
    null as start_date,
    null as end_date,
    null as scopes_enabled,
    null as decidim_scope_id,
    null as registrations_enabled,
    null as available_slots,
    null as registration_terms,
    null as created_at,
    null as updated_at,
    null as signature_name,
    null as signature,
    null as main_logo,
    null as sign_date,
    null as diploma_sent_at,
    null as follows_count
where false

{% endif %}
