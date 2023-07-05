{% macro lang(column) %}
    {{ column }}->>'{{ env_var('DBT_LANGUAGE_CODE') }}'
{% endmacro %}