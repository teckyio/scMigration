SELECT 'MATERIAL' AS "TABLE_NAME",
       (SELECT COUNT(DISTINCT MATERIALS)
        FROM (SELECT sm.MATERIALS
              FROM SDE_SQ.SQUATTERMATERIAL sm
              UNION ALL
              SELECT smh.MATERIALS
              FROM SDE_SQ.SQUATTERMATERIAL_HIS smh)) AS "TOTAL TYPE OF MATERIAL",
       (SELECT COUNT(DISTINCT MATERIAL_ID)
        FROM (SELECT sm.MATERIAL_ID
              FROM SQ.SQUATTER_MATERIALS sm
              UNION ALL
              SELECT smh.MATERIAL_ID
              FROM SQ.SQUATTER_MATERIAL_HIS smh)) AS "SUCCESS"
FROM DUAL
UNION ALL
SELECT 'USE' AS "TABLE_NAME",
       (SELECT COUNT(DISTINCT SQUATTERUSE)
        FROM (SELECT su.SQUATTERUSE
              FROM SDE_SQ.SQUATTERUSE su
              UNION ALL
              SELECT suh.SQUATTERUSE
              FROM SDE_SQ.SQUATTERUSE_HIS suh)) AS "TOTAL TYPE OF USE",
       (SELECT COUNT(DISTINCT USE_ID)
        FROM (SELECT su.USE_ID
              FROM SQ.SQUATTER_USES su
              UNION ALL
              SELECT suh.USE_ID
              FROM SQ.SQUATTER_USE_HIS suh)) AS "SUCCESS"
FROM DUAL;
