with source as (
      select * from {{ source('decidim', 'decidim_conferences') }}
),
select
    id,
    {{ lang('title') }} as title,
    {{ lang('slogan') }} as slogan,
    slug,
    hashtag,
    {{ lang('description') }} as description
from source
    select
        -- {{ adapter.quote("id") }},
        -- {{ adapter.quote("title") }},
        -- {{ adapter.quote("slogan") }},
        -- {{ adapter.quote("slug") }},
        -- {{ adapter.quote("hashtag") }},
        -- {{ adapter.quote("reference") }},
        -- {{ adapter.quote("location") }},
        -- {{ adapter.quote("decidim_organization_id") }},
        -- {{ adapter.quote("short_description") }},
        -- {{ adapter.quote("description") }},
        -- {{ adapter.quote("hero_image") }},
        -- {{ adapter.quote("banner_image") }},
        -- {{ adapter.quote("promoted") }},
        -- {{ adapter.quote("published_at") }},
        -- {{ adapter.quote("objectives") }},
        -- {{ adapter.quote("show_statistics") }},
        -- {{ adapter.quote("start_date") }},
        -- {{ adapter.quote("end_date") }},
        -- {{ adapter.quote("scopes_enabled") }},
        -- {{ adapter.quote("decidim_scope_id") }},
        -- {{ adapter.quote("registrations_enabled") }},
        -- {{ adapter.quote("available_slots") }},
        -- {{ adapter.quote("registration_terms") }},
        -- {{ adapter.quote("created_at") }},
        -- {{ adapter.quote("updated_at") }},
        -- {{ adapter.quote("signature_name") }},
        -- {{ adapter.quote("signature") }},
        -- {{ adapter.quote("main_logo") }},
        -- {{ adapter.quote("sign_date") }},
        -- {{ adapter.quote("diploma_sent_at") }},
        -- {{ adapter.quote("follows_count") }}
)
select * from renamed
  