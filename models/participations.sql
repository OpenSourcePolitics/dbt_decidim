with participations as (
        select decidim_users.id,
            decidim_proposals_proposals.decidim_component_id,
            'Decidim::Proposals::Proposal' as "participation_type",
            decidim_proposals_proposals.id::text as "participation_id", 
            decidim_proposals_proposals.created_at as participation_date
        from {{ ref('proposals') }} as decidim_proposals_proposals
            join decidim_coauthorships on decidim_coauthorships.coauthorable_id = decidim_proposals_proposals.id
            join decidim_users on decidim_users.id = decidim_coauthorships.decidim_author_id
        where coauthorable_type = 'Decidim::Proposals::Proposal'
    union all
        select decidim_users.id,
            decidim_endorsements.decidim_component_id,
            'Decidim::Endorsements::Endorsement' as "participation_type",
            decidim_endorsements.id::text as "participation_id", 
            decidim_endorsements.created_at as participation_date
        from {{ ref('endorsements') }} as decidim_endorsements
            join decidim_users on decidim_users.id = decidim_endorsements.decidim_author_id
    union all
        select decidim_users.id,
            decidim_component_id,
            'Decidim::Comments::Comment' as "participation_type",
            decidim_comments_comments.id::text as "participation_id",
            decidim_comments_comments.created_at as contribution_date
        from {{ ref('comments') }} decidim_comments_comments
            join decidim_users on decidim_users.id = decidim_comments_comments.decidim_author_id
    union all
        select decidim_users.id,
            decidim_proposals_proposals.decidim_component_id,
            'Decidim::Proposals::ProposalVote' as "participation_type",
            decidim_proposals_proposal_votes.id::text as "participation_id",
            decidim_proposals_proposal_votes.created_at as participation_date
        from decidim_proposals_proposal_votes
            join decidim_users on decidim_users.id = decidim_author_id
            join {{ ref('proposals') }} as decidim_proposals_proposals on decidim_proposals_proposal_votes.decidim_proposal_id = decidim_proposals_proposals.id 
    union all
        select distinct
            decidim_user_id,
            decidim_component_id,
            'Decidim::Forms::Answer' as "participation_type",
          decidim_forms_answers.session_token as "participation_id",
          decidim_forms_answers.created_at::date as participation_date
        from {{ ref('forms_answers') }} as decidim_forms_answers
    union all
        select decidim_author_id as decidim_user_id,
            decidim_component_id,
            'Decidim::Debates::Debate' as "participation_type",
            id::text as participation_id,
            created_at as participation_date
        from {{ ref('debates') }} decidim_debates_debates
    union all
        select 
            decidim_user_id,
            decidim_component_id,
            'Decidim::Budgets::Project::Vote' as participation_type,
            id::text as participation_id,
            created_at as participation_date
        from {{ ref('projects_votes') }} decidim_bugdets_projects_votes
    union all
        select 
            decidim_user_id,
            decidim_component_id,
            'Decidim::Meetings::Registration' as participation_type,
            decidim_meetings_meetings.id::text as participation_id,
            decidim_meetings_registrations.created_at as participation_date
        from {{ ref('meetings') }} decidim_meetings_meetings
            join decidim_meetings_registrations on decidim_meetings_registrations.decidim_meeting_id = decidim_meetings_meetings.id
)
select 
    distinct participations.id as "user_id",
    substr(participation_id,1,10)::bigint as participation_id,
    decidim_component_id,
    participation_type,
    participation_date
from participations