{% set unload_s3_path = 's3://s3unloaddata/unload_to_s3.csv' %}

{{
    config(
        materialized = 'table',
        post_hook = [
            redshift_unload_table(
                s3_path = unload_s3_path,
                aws_key = env_var('DBT_ENV_AWS_ACCESS_KEY', ''),
                aws_secret = env_var('DBT_ENV_AWS_SECRET_KEY', ''),
                header = True,
                delimiter = '|',
                overwrite = True,
                sql_command = '
                    select *
                    from ' ~ this
            )
        ]
    )
}}

select
    *
from {{ ref('monthly_new_orders') }}
