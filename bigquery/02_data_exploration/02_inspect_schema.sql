SELECT
    table_name,
    column_name,
    data_type,
    is_nullable

FROM
    `ecommerce-sales-nabin-2026.devflow_raw.INFORMATION_SCHEMA.COLUMNS`

ORDER BY
    table_name,
    ordinal_position;