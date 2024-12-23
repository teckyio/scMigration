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
FROM SDE_SQ.SQUATTERMATERIAL_HIS sm
LEFT JOIN SQ.SQUATTER_MATERIAL_HIS t 
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
FROM SQ.SQUATTER_MATERIAL_HIS
GROUP BY OBJECT_ID
HAVING COUNT(*) > 1;

-- Referential Integrity Validation
-- Ensure relationships between foreign key fields (e.g., SQUATTER_GUID, MATERIAL_ID) are maintained.
SELECT 
	sm.OBJECTID AS "OBJECTID",
    sm.SQUATTERID AS "SOURCE_SQUATTER_ID",
    t.SQUATTER_ID AS "TARGET_SQUATTER_ID",
    CASE 
        WHEN NVL(sm.SQUATTERID, '0') = NVL(t.SQUATTER_ID, '0') THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS "RELATION_MATCH"
FROM SDE_SQ.SQUATTERMATERIAL_HIS sm
LEFT JOIN SQ.SQUATTER_MATERIAL_HIS t 
    ON sm.OBJECTID = t.OBJECT_ID
ORDER BY 
    CASE 
        WHEN NVL(sm.SQUATTERID, '0') = NVL(t.SQUATTER_ID, '0') THEN 1
        ELSE 0
    END, 
	"OBJECTID", "SOURCE_SQUATTER_ID", "TARGET_SQUATTER_ID";

