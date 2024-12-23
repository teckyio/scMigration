--  File Path Construction Validation
-- Validate that the filepath is constructed correctly in the ATTACHMENTS table.
SELECT
    a."URL" AS "TARGET_FILEPATH",
    s.FILE_TYPE,
    s.DLO,
    s.SQUATTERID,
    s.NAME,
    CASE
        WHEN s.FILE_TYPE = 'N' THEN 'RepairRebuildNoti'
        WHEN s.FILE_TYPE = 'V' THEN 'OccupantsVRNotiLetter'
    END || '\' || s.DLO || '\' || s.SQUATTERID || '\' || s.NAME AS "EXPECTED_FILEPATH"
FROM SDE_SQ.SQUATTER_UPLOAD s
JOIN SQ.ATTACHMENTS a
    ON s.OBJECTID = a.OBJECT_ID
WHERE a."URL" NOT LIKE '%' || s.DLO || '%'
  OR a."URL" NOT LIKE '%' || s.SQUATTERID || '%'
  OR a."URL" NOT LIKE '%' || s.NAME || '%';


-- Validate One-to-Many Relationship
-- Ensure a squatter can have multiple attachments, but no attachment is assigned to more than one squatter.
SELECT 
    atsq.ATTACHMENT_ID,
    COUNT(DISTINCT atsq.SQUATTER_GUID) AS "SQUATTER_COUNT"
FROM SQ.ATTACHMENT_SQ atsq
GROUP BY atsq.ATTACHMENT_ID
HAVING COUNT(DISTINCT atsq.SQUATTER_GUID) > 1;
