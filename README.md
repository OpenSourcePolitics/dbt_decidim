# dbt_decidim
This project aims to do the analystics engineering work around the Open Source Politics' [decidim-app](https://github.com/OpenSourcePolitics/decidim-app)

## Requirements
- Poetry
- Credentials of your Postgres database available

## Getting started
- Clone repository
- `poetry install`
- `export DBT_LANGUAGE_CODE=fr`
- `export DBT_DECIDIM=your_organization_url`
- `poetry run dbt run --vars '{"POSTGRES_HOST": "0.0.0.0","POSTGRES_USER":"postgres","POSTGRES_PASSWORD":"postgres","POSTGRES_PORT":5432,"POSTGRES_DB":"demo"}'`