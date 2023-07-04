with components as (
    select * from {{ ref("stg_components") }}
),

participatory_spaces as (
    select * from {{ ref("int_participatory_spaces") }}
),

organizations as (
    select host
    from {{ ref("stg_organizations") }}
    limit 1
)

select
    components.id,
    components.manifest_name,
    components.created_at,
    components.published_at,
    concat('https://', (select host from organizations), '/', space_type_slug, '/', slug, '/f/', components.id) as url,
    participatory_spaces.id as participatory_space_id,
    participatory_spaces.type as participatory_space_type
from components
    join participatory_spaces
        on participatory_space_id = participatory_spaces.id
        and participatory_space_type = participatory_spaces.type
