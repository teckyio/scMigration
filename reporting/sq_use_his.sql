-- Data Integrity Check
-- Verify that critical fields in the target tables match the source tables for migrated records.
SELECT 
    sm.OBJECTID AS "SOURCE_OBJECTID",
    NVL(sm.MATERIALS, '') AS "SOURCE_MATERIAL",
    NVL(m.NAME, '') AS "TARGET_MATERIAL",
    CASE 
        WHEN NVL(sm.MATERIALS, '') = NVL(m.NAME, '') THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS "MATERIALS_MATCH"
FROM SDE_SQ.SQUATTERMATERIAL sm
LEFT JOIN SC.SQUATTER_MATERIALS t 
    ON sm.OBJECTID = t.OBJECT_ID
LEFT JOIN SQ.MATERIALS m 
    ON t.MATERIAL_ID = m.ID
ORDER BY 
    CASE 
        WHEN NVL(sm.MATERIALS, '') = NVL(m.NAME, '') THEN 1
        ELSE 0
    END, 
    sm.OBJECTID, sm.MATERIALS, m.NAME;


-- Duplicate Records
-- Ensure there are no duplicate records in the target tables.
SELECT 
    OBJECT_ID, COUNT(*) 
FROM SQ.SQUATTER_MATERIALS
GROUP BY OBJECT_ID
HAVING COUNT(*) > 1;

-- Referential Integrity Validation
-- Ensure relationships between foreign key fields (e.g., SQUATTER_GUID, MATERIAL_ID) are maintained.
SELECT 
    sm.SQUATTERID AS "SOURCE_SQUATTER_ID",
    t.SQUATTER_ID AS "TARGET_SQUATTER_ID",
    CASE 
        WHEN sm.SQUATTERID = t.SQUATTER_ID THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS "RELATION_MATCH"
FROM SDE_SQ.SQUATTERMATERIAL sm
LEFT JOIN SQ.SQUATTER_MATERIALS t 
    ON sm.OBJECTID = t.OBJECT_ID;
