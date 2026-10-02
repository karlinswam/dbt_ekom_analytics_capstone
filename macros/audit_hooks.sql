{% macro create_audit_schema() %}
  create schema if not exists {{ target.catalog }}.audit
{% endmacro %}

{% macro create_audit_table() %}
  create table if not exists {{ target.catalog }}.audit.audit_log (
    invocation_id string,
    job_name string,
    status string,
    start_time timestamp,
    end_time timestamp,
    row_count bigint
  ) using delta
{% endmacro %}

{% macro audit_start() %}
  insert into {{ target.catalog }}.audit.audit_log
  values ('{{ invocation_id }}', '{{ this }}', 'STARTED', current_timestamp(), cast(null as timestamp), cast(null as bigint))
{% endmacro %}

{% macro audit_end() %}
  update {{ target.catalog }}.audit.audit_log
  set status = 'SUCCESS', end_time = current_timestamp(), row_count = (select count(*) from {{ this }})
  where invocation_id = '{{ invocation_id }}' and job_name = '{{ this }}' and status = 'STARTED'
{% endmacro %}
