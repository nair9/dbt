{% macro customer_category(revenue) %}

    {% set spend_category_sql %}
    case
        when {{ revenue }} > 1000 then '4 - best'
        when {{ revenue }} > 500 then '3 - top'
        when {{ revenue }} > 100 then '2 - medium'
        else '1 - small'
    end
    {% endset %}

    {{ return(spend_category_sql) }}

{% endmacro %}
