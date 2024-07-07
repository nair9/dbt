{% macro convert_timezone(date_column, source_timezone='UTC', target_timezone='America/New_York') -%}
    
    convert_timezone('{{ source_timezone }}', '{{ target_timezone }}', {{ date_column }})

{%- endmacro %}