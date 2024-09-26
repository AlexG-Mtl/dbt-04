{% macro drop_schema_str(schema) %}
    {% set relation = api.Relation.create(database=target.database, schema=schema) %}
    {% do adapter.drop_schema(relation) %}
{% endmacro %}
