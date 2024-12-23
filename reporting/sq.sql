-- Data Consistency Check for Key Columns
-- Verify that critical columns in the target table match those in the source table for migrated records.
SELECT 
    s.OBJECTID AS "SOURCE_OBJECTID", 
    t.OBJECT_ID AS "TARGET_OBJECTID",
    CASE 
        WHEN s.SQUATTERID = t.SQUATTER_ID THEN 'MATCH' 
        ELSE 'MISMATCH' 
    END AS "SQUATTER_ID_MATCH"
FROM SDE_SQ.SQUATTER s
LEFT JOIN SQ.SQUATTERS t 
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
FROM SQ.SQUATTERS
GROUP BY OBJECT_ID
HAVING COUNT(*) > 1;

-- Field-Specific Comparison
-- Compare specific fields between source and target for migrated records.
SELECT
    NVL(s.SURVEYNO, 'null') || NVL(s.SURVEY_NOPREFIX, '/null') AS "SOURCE_SURVEYNO",
    NVL(t.SURVEY_NO, 'null') || NVL(t.SURVEY_NO_PREFIX, '/null') AS "TARGET_SURVEYNO",
    CASE
        WHEN NVL(s.SURVEYNO, 'null') = NVL(t.SURVEY_NO, 'null')
        AND NVL(s.SURVEYNOPREFIX, '/null') = NVL(t.SURVEY_NO_PREFIX, '/null') THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS "SURVEYNO_MATCH"
FROM SDE_SQ.SQUATTER s
JOIN SQ.SQUATTERS t
    ON s.OBJECTID = t.OBJECT_ID
ORDER BY
    CASE
        WHEN NVL(s.SURVEYNO, 'null') = NVL(t.SURVEY_NO, 'null')
        AND NVL(s.SURVEYNOPREFIX, '/null') = NVL(t.SURVEY_NO_PREFIX, '/null') THEN 1
        ELSE 0
    END,
    "SOURCE_SURVEYNO",
    "TARGET_SURVEYNO";


