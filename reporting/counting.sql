-- This SQL query provides a comprehensive comparison of record counts between source tables in the SDE_SQ schema and their corresponding target tables in the SC schema. It helps verify the success of data migration processes by listing the total number of records in the source tables (TOTAL) alongside the successfully migrated records in the target tables (SUCCESS). This query is especially useful for auditing, reporting, and ensuring data consistency post-migration.

SELECT 'SQUATTER' AS "TABLE_NAME",
       (SELECT COUNT(*) FROM SDE_SQ.SQUATTER) AS "TOTAL",
       (SELECT COUNT(*) FROM SQ.SQUATTERS) AS "SUCCESS"
FROM dual
UNION ALL
SELECT 'SQUATTER_HIS' AS "TABLE_NAME",
       (SELECT COUNT(*) FROM SDE_SQ.SQUATTER_HIS) AS "TOTAL",
       (SELECT COUNT(*) FROM SQ.SQUATTER_HISTORIES) AS "SUCCESS"
FROM dual
UNION ALL
SELECT 'SQUATTER_USE' AS "TABLE_NAME",
       (SELECT COUNT(*) FROM SDE_SQ.SQUATTERUSE) AS "TOTAL",
       (SELECT COUNT(*) FROM SQ.SQUATTER_USES) AS "SUCCESS"
FROM dual
UNION ALL
SELECT 'SQUATTER_MATERIAL' AS "TABLE_NAME",
       (SELECT COUNT(*) FROM SDE_SQ.SQUATTERMATERIAL) AS "TOTAL",
       (SELECT COUNT(*) FROM SQ.SQUATTER_MATERIALS) AS "SUCCESS"
FROM dual
UNION ALL
SELECT 'SQUATTER_USE_HIS' AS "TABLE_NAME",
       (SELECT COUNT(*) FROM SDE_SQ.SQUATTERUSE_HIS) AS "TOTAL",
       (SELECT COUNT(*) FROM SQ.SQUATTER_USE_HIS) AS "SUCCESS"
FROM dual
UNION ALL
SELECT 'SQUATTER_MATERIAL_HIS' AS "TABLE_NAME",
       (SELECT COUNT(*) FROM SDE_SQ.SQUATTERMATERIAL_HIS) AS "TOTAL",
       (SELECT COUNT(*) FROM SQ.SQUATTER_MATERIAL_HIS) AS "SUCCESS"
FROM dual
UNION ALL
SELECT 'ATTACHMENT' AS "TABLE_NAME",
       (SELECT COUNT(*) FROM SDE_SQ.SQUATTER_UPLOAD) AS "TOTAL",
       (SELECT COUNT(*) FROM SQ.ATTACHMENTS) AS "SUCCESS"
FROM dual;
