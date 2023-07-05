{% macro html_cleaning(column) %}
    regexp_replace({{ column }}, E'(<[^>]+>)|(&[a-z]+;)', '', 'gi')
{% endmacro %}