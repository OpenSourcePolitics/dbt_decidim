select 
    decidim_users.id,
    email,
    sign_in_count,
    last_sign_in_at,
    decidim_users.created_at,
    decidim_users.updated_at,
    invitation_created_at,
    invitation_sent_at,
    invitation_accepted_at,
    invited_by_id,
    invited_by_type,
    decidim_organization_id,
    confirmed_at,
    confirmation_token,
    unconfirmed_email,
    decidim_users.name,
    locale,
    deleted_at,
    admin,
    managed,
    roles,
    email_on_notification,
    nickname,
    accepted_tos_version,
    type,
    following_count,
    followers_count,
    failed_attempts,
    locked_at,
    admin_terms_accepted_at,
    blocked,
    blocked_at,
    (case when confirmed_at is null then false else true end) as "confirmed",
    concat('https://', host, '/profiles/', nickname, '/activity') as url,
    extended_data
from decidim_users
    join {{ ref('organizations') }} as decidim_organizations on decidim_organizations.id = decidim_users.decidim_organization_id
where true
    and deleted_at is null
    and type like 'Decidim::User'