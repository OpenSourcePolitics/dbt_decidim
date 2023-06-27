{% macro table_exists() -%}
    {{ 
    return (
        adapter.get_relation(
            database=source('public', 'decidim_initiatives').database,
            schema=source('public', 'decidim_initiatives').schema,
            identifier=source('public', 'decidim_initiatives').name
        )
    )
    }}
{%- endmacro %}