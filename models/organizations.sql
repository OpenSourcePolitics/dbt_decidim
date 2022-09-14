select id,
    name,
    host,
    default_locale,
    available_locales,
    created_at,
    updated_at,
    description->>'{{ var('DBT_LANGUAGE_CODE') }}' as description,
    secondary_hosts,
    available_authorizations,
    header_snippets,
    tos_version,
    badges_enabled,
    send_welcome_notification,
    users_registration_mode,
    time_zone
from decidim_organizations
where host = '{{ var('DBT_DECIDIM') }}'
