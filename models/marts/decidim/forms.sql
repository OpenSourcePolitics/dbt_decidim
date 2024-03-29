with questionnaires as (
    select decidim_forms_questionnaires.id as questionnaire_id,
        decidim_forms_questionnaires.title,
        decidim_meetings_meetings.decidim_component_id
    from decidim_forms_questionnaires
        join decidim_meetings_meetings on decidim_meetings_meetings.id = questionnaire_for_id
    where questionnaire_for_type = 'Decidim::Meetings::Meetings'
union all
    select decidim_forms_questionnaires.id as questionnaire_id,
        decidim_forms_questionnaires.title,
        decidim_surveys_surveys.decidim_component_id
    from decidim_forms_questionnaires
        join decidim_surveys_surveys on decidim_surveys_surveys.id = questionnaire_for_id
    where questionnaire_for_type = 'Decidim::Surveys::Survey'
)
select
    questionnaires.questionnaire_id as id,
    title->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as title,
    decidim_components.id as decidim_component_id,
    concat ('https://',organization_host, '/', ps_space_type_slug,'/', ps_slug, '/f/', decidim_component_id) as "questionnaire_url"
from questionnaires
    join {{ ref('components') }} decidim_components on decidim_components.id = decidim_component_id 