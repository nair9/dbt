{% macro redshift_unload_table(
    schema,
    table,
    s3_path,
    iam_role=None,
    aws_key=None,
    aws_secret=None,
    aws_region=None,
    aws_token=None,
    manifest=False,
    header=False,
    format=None,
    delimiter=",",
    null_as="",
    max_file_size="6 GB",
    escape=True,
    compression=None,
    add_quotes=False,
    encrypted=False,
    overwrite=False,
    cleanpath=False,
    parallel=False,
    partition_by=None,
    sql_command=None
) %}

    {% if sql_command %} 
    {% set sql = sql_command %}
    {% else %}
        {% set sql %} 'select * from "{{ schema }}"."{{ table }}"' {% endset %}
    {% endif %}

    {% set unload_command %}
        -- compile UNLOAD statement
        UNLOAD ('{{ sql }}')
        TO '{{ s3_path }}'
        {% if iam_role %}
            IAM_ROLE '{{ iam_role }}'
        {% elif aws_key and aws_secret %}
            ACCESS_KEY_ID '{{ aws_key }}'
            SECRET_ACCESS_KEY '{{ aws_secret }}'
            {% if aws_token %}
                SESSION_TOKEN '{{ aws_token }}'
            {% endif %}
        {% else %}
            -- Raise an error if authorization args are not present
            {{ exceptions.raise_compiler_error("You must provide AWS authorization parameters via 'iam_role' or 'aws_key' and 'aws_secret'.") }}
        {% endif %}
        {% if manifest %}
        MANIFEST VERBOSE
        {% endif %}
        {% if header %}
        HEADER
        {% endif %}
        {% if format %}
        FORMAT AS {{format|upper}}
        {% endif %}
        {% if not format %}
        DELIMITER AS '{{ delimiter }}'
        {% endif %}
        NULL AS '{{ null_as }}'
        MAXFILESIZE AS {{ max_file_size }}
        {% if escape %}
        ESCAPE
        {% endif %}
        {% if compression %}
        {{ compression|upper }}
        {% endif %}
        {% if add_quotes %}
        ADDQUOTES
        {% endif %}
        {% if encrypted %}
        ENCRYPTED
        {% endif %}
        {% if overwrite %}
        ALLOWOVERWRITE
        {% endif %}
        {% if cleanpath %}
        CLEANPATH
        {% endif %}
        {% if not parallel %}
        PARALLEL OFF
        {% endif %}
        {% if aws_region %}
        REGION '{{ aws_region }}'
        {% endif %}
        {% if partition_by %}
        PARTITION BY ( {{ partition_by | join(', ') }} )
        {% endif %}
    {% endset %}

    {% if not execute %}
    {# /* no-op */ #}
    {% else %} {% do run_query(unload_command) %}
    {% endif %}

{% endmacro %}
