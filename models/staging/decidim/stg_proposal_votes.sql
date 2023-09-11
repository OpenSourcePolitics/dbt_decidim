select
    id,
    decidim_proposal_id,
    decidim_author_id,
    created_at,
    updated_at,
    weight,
    temporary
from {{ source('decidim', 'decidim_proposals_proposal_votes') }}
