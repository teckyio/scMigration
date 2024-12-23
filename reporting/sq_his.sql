-- Data Consistency Check for Key Columns
-- Verify that critical columns in the target table match those in the source table for migrated records.
SELECT 
    s.OBJECTID AS "SOURCE_OBJECTID", 
    t.OBJECT_ID AS "TARGET_OBJECTID",
    CASE 
        WHEN s.SQUATTERID = t.SQUATTER_ID THEN 'MATCH' 
        ELSE 'MISMATCH' 
    END AS "SQUATTER_HIS_ID_MATCH"
FROM SDE_SQ.SQUATTER_HIS s
LEFT JOIN SQ.SQUATTER_HISTORIES t 
    ON s.OBJECTID = t.OBJECT_ID
WHERE s.SQUATTERID IS NOT NULL
ORDER BY
    CASE
        WHEN s.SQUATTERID = t.SQUATTER_ID THEN 1
        ELSE 0
    END,
    "SOURCE_OBJECTID",
    "TARGET_OBJECTID";

-- Duplicate Check in Target Table
-- Ensure no duplicate records exist in the target table.
SELECT 
    OBJECT_ID, COUNT(*) 
FROM SQ.SQUATTER_HISTORIES
GROUP BY OBJECT_ID
HAVING COUNT(*) > 1;

-- Field-Specific Comparison
-- Compare specific fields between source and target for migrated records.
SELECT 
    NVL(s.SURVEYNO, '') || NVL(s.SURVEYNOPREFIX, '') AS "SOURCE_SURVEYNO",
    NVL(t.SURVEY_NO, '') || NVL(t.SURVEY_NO_PREFIX, '') AS "TARGET_SURVEYNO",
    s.OBJECTID AS OBJECTID,
    CASE 
        WHEN s.SURVEYNO = t.SURVEY_NO AND s.SURVEYNOPREFIX = t.SURVEY_NO_PREFIX THEN 'MATCH'
        ELSE 'MISMATCH' 
    END AS "SURVEYNO_MATCH"
FROM SDE_SQ.SQUATTER_HIS s
JOIN SQ.SQUATTER_HISTORIES t 
    ON s.OBJECTID = t.OBJECT_ID
ORDER BY
    CASE
        WHEN NVL(s.SURVEYNO, 'null') = NVL(t.SURVEY_NO, 'null')
        AND NVL(s.SURVEYNOPREFIX, '/null') = NVL(t.SURVEY_NO_PREFIX, '/null') THEN 1
        ELSE 0
    END,
    "SOURCE_SURVEYNO",
    "TARGET_SURVEYNO";
