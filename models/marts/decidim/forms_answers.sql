with answers as (
        select 
            decidim_user_id, 
            session_token,
            question_type,
            position,
            (case when decidim_forms_answers.body = '' then 'Pas de réponse' else decidim_forms_answers.body end) as "answer",
            '' as sub_matrix_question,
            '' as custom_body,
            -1 as sorting_position,
            decidim_forms_questions.decidim_questionnaire_id,
            decidim_forms_questions.body,
            decidim_forms_answers.created_at
        from decidim_forms_answers
            join decidim_forms_questions on decidim_forms_questions.id = decidim_forms_answers.decidim_question_id
        where true
            and decidim_forms_answers.body is not null
            and question_type = ANY('{short_answer,long_answer}'::text[])
    union all
        select distinct 
            decidim_user_id,
            session_token,
            question_type,
            decidim_forms_questions.position as "position",
            decidim_forms_answer_choices.body::text as "answer",
            '' as sub_matrix_question,
            decidim_forms_answer_choices.custom_body as custom_body,
            (case question_type when 'sorting' then decidim_forms_answer_choices.position else -1 end) as sorting_position,
            decidim_forms_questions.decidim_questionnaire_id,
            decidim_forms_questions.body,
            decidim_forms_answers.created_at
        from decidim_forms_answers
            join decidim_forms_questions on decidim_forms_questions.id = decidim_forms_answers.decidim_question_id
            join decidim_forms_answer_choices on decidim_forms_answer_choices.decidim_answer_id = decidim_forms_answers.id
        where true
            and question_type = ANY('{single_option, multiple_option, sorting}'::text[])
    union all
        select distinct 
            decidim_user_id, 
            session_token,
            question_type,
            decidim_forms_questions.position as "position",
            decidim_forms_answer_choices.body::text as "answer",
            decidim_forms_question_matrix_rows.body->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as "sub_matrix_question",
            '' as custom_body,
            -1 as sorting_position,
            decidim_forms_questions.decidim_questionnaire_id,
            decidim_forms_questions.body,
            decidim_forms_answers.created_at
        from decidim_forms_answers
            join decidim_forms_questions on decidim_forms_questions.id = decidim_forms_answers.decidim_question_id
            join decidim_forms_answer_choices on decidim_forms_answer_choices.decidim_answer_id = decidim_forms_answers.id
            join decidim_forms_question_matrix_rows on decidim_forms_question_matrix_rows.decidim_question_id = decidim_forms_answers.decidim_question_id
        where true
            and question_type = ANY('{matrix_single, matrix_multiple}'::text[])
    union all
        select distinct
            decidim_user_id,
            session_token,
            question_type,
            decidim_forms_questions.position as "position",
            file as "answer",
            '' as "sub_matrix_question",
            'https://' || (select host from {{ ref('organizations') }} decidim_organizations) || '/uploads/decidim/attachment/file/' || decidim_attachments.id || '/' || decidim_attachments.file as custom_body,
            -1 as sorting_position,
            decidim_forms_questions.decidim_questionnaire_id,
            decidim_forms_questions.body,
            decidim_forms_answers.created_at
        from decidim_forms_answers
            join decidim_forms_questions on decidim_forms_questions.id = decidim_forms_answers.decidim_question_id
            join decidim_attachments on decidim_attachments.attached_to_id = decidim_forms_answers.id
        where attached_to_type = 'Decidim::Forms::Answer'
)
select 
    decidim_user_id,
    session_token,
    question_type,
    body->>'{{ env_var('DBT_LANGUAGE_CODE') }}' as question_title,
    btrim(answer, '"') as answer,
    sub_matrix_question,
    custom_body,
    sorting_position,
    decidim_questionnaire_id,
    decidim_component_id,
    (case sorting_position
        when 0 then 10
        when 1 then 9
        when 2 then 8
        when 3 then 7
        when 4 then 6
        when 5 then 5
        when 6 then 4
        when 7 then 3
        when 8 then 2
        when 9 then 1
        else -1
    end) as sorting_points,
    position,
    created_at
from answers
    join {{ ref('forms') }} as decidim_forms_questionnaires on decidim_forms_questionnaires.id = decidim_questionnaire_id
order by session_token, position