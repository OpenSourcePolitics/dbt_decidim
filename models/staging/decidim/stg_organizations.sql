select id,
    name,
    host,
    default_locale,
    available_locales,
    created_at,
    updated_at,
    description->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as description,
    logo,
    twitter_handler,
    favicon,
    instagram_handler,
    facebook_handler,
    youtube_handler,
    github_handler,
    official_img_header,
    official_url,
    reference_prefix,
    secondary_hosts,
    available_authorizations,
    header_snippets,
    cta_button_text,
    cta_button_path,
    enable_omnipresent_banner,
    omnipresent_banner_title->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as omnipresent_banner_title,
    omnipresent_banner_url,
    highlighted_content_banner_enabled,
    highlighted_content_banner_title->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as highlighted_content_banner_title,
    highlighted_content_banner_short_description->>'{{ env_var('DBT_LANGUAGE_CODE') }}',
    tos_version,
    badges_enabled,
    send_welcome_notification,
    users_registration_mode,
    time_zone
from decidim_organizations
where host = '{{ env_var('DBT_DECIDIM') }}'
