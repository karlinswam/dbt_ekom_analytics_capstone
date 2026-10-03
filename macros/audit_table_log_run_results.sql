
{% macro audit_table_log_run_results(results) %}
    {{ log("LOG_RUN_RESULTS EXECUTED", info=True) }}
    {{ log("RESULT COUNT=" ~ (results | length), info=True) }}

    {% if execute %}

        {% for result in results %}
            {{ log("MODEL=" ~ result.node.name, info=True) }}

            {% if result.node.resource_type == 'model'%}

                {% set rows_affected =
                    result.adapter_response.get('rows_affected', -1)
                %}

                {% set insert_sql %}

                    insert into
                        {{ target.database }}.audit.dbt_model_audit
                    (
                        invocation_id,
                        model_name,
                        model_status,
                        rows_affected,
                        execution_seconds,
                        target_name,
                        invocation_started_at
                    )
                    values
                    (
                        '{{ invocation_id }}',
                        '{{ result.node.name }}',
                        '{{ result.status }}',
                        {{ rows_affected }},
                        {{ result.execution_time }},
                        '{{ target.name }}',
                        '{{ run_started_at }}'
                    );

                {% endset %}

                {% do run_query(insert_sql) %}

            {% endif %}

        {% endfor %}

    {% endif %}

{% endmacro %}