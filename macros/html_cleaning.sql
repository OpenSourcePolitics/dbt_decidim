{% macro html_cleaning(column, key) %}
    regexp_replace({{ column }}->>'{{ key }}', E'(<[^>]+>)|(&[a-z]+;)', '', 'gi')
{% endmacro %}