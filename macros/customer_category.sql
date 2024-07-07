{% macro customer_category(revenue) %}

    {% set spend_category_sql %}
    case
        when {{ revenue }} > 1000 then 'best'
        when {{ revenue }} > 500 then 'top'
        when {{ revenue }} > 100 then 'medium'
        else 'small'
    end
    {% endset %}

    {{ return(spend_category_sql) }}

{% endmacro %}
