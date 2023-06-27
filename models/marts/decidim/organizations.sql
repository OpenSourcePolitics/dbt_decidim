with stg_organizations as (
    select * from {{ ref('stg_organizations' )}}
    
)
select id,
    name,
    host,
    default_locale,
    available_locales,
    created_at,
    updated_at,
    description,
    secondary_hosts,
    available_authorizations,
    header_snippets,
    tos_version,
    badges_enabled,
    send_welcome_notification,
    users_registration_mode,
    time_zone
from stg_organizations
where host = '{{ env_var('DBT_DECIDIM') }}'
