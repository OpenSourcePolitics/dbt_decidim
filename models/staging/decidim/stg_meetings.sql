select
    id,
    {{ lang('title') }} as title,
    {{ html_cleaning(lang('description')) }} as description,
    start_time,
    end_time,
    address,
    {{ lang('location') }} as location,
    {{ lang('location_hints') }} as location_hints,
    decidim_component_id,
    decidim_author_id,
    decidim_scope_id,
    created_at,
    updated_at,
    {{ lang('closing_report') }} as closing_report,
    attendees_count,
    contributions_count,
    attending_organizations,
    closed_at,
    latitude,
    longitude,
    reference,
    registrations_enabled,
    available_slots,
    {{ lang('registration_terms') }} as registration_terms,
    reserved_slots,
    private_meeting,
    transparent,
    registration_form_enabled,
    decidim_author_type,
    decidim_user_group_id,
    comments_count,
    salt,
    online_meeting_url,
    type_of_meeting,
    registration_type,
    registration_url,
    follows_count
from {{ source('decidim', 'decidim_meetings_meetings') }}
