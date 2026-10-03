{% macro audit_table_create() %}

    {% do run_query(
        "create schema if not exists dbt_ekom_analytics.audit"
    ) %}

    {% do run_query(
        "
        create table if not exists
        dbt_ekom_analytics.audit.dbt_model_audit
        (
            invocation_id string,
            model_name string,
            model_status string,
            rows_affected bigint,
            execution_seconds double,
            target_name string,
            invocation_started_at timestamp,
            audit_created_at timestamp
        )
        "
    ) %}

{% endmacro %}