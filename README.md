# dbt_decidim
This project aims to do the analystics engineering work around the Open Source Politics' [decidim-app](https://github.com/OpenSourcePolitics/decidim-app)

## Requirements
- Poetry
- Credentials of your Postgres database available

## Getting started
- Clone repository
- Install dependencies : `poetry install`
- Fill env file with relevant variables taking example on `.env.example`
- `source .env`
- `poetry run dbt run`