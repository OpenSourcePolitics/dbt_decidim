select decidim_initiatives_votes.id,
    decidim_initiative_id,
    decidim_initiatives_votes.decidim_author_id,
    decidim_initiatives_votes.created_at,
    decidim_initiatives_votes.updated_at,
    hash_id, 
    decidim_scope_id,
    decidim_initiatives.url as initiative_url
from decidim_initiatives_votes
    join {{ ref('initiatives') }} as decidim_initiatives on decidim_initiatives.id = decidim_initiative_id