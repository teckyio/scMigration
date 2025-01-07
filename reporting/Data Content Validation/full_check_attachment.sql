TRUNCATE TABLE data_validation_attachment;
DECLARE quantity INT := 481;
BEGIN -- Insert validation results into the table
INSERT INTO data_validation_attachment (objectid, target_objectid, error_msg, is_valid)
SELECT rec.OBJECTID AS objectid,
    att.OBJECT_ID AS target_objectid,
    -- Concatenate error messages for mismatched fields with NVL for null handling
    RTRIM(
        CASE
            WHEN NVL(rec.NAME, 'NULL') = NVL(att.DISPLAYNAME, 'NULL') THEN ''
            ELSE 'NAME;'
        END || CASE
            WHEN NVL(
                rec.CREATED_DATE,
                TO_DATE('1900-01-01', 'YYYY-MM-DD')
            ) = NVL(
                att.CREATED_AT,
                TO_DATE('1900-01-01', 'YYYY-MM-DD')
            ) THEN ''
            ELSE 'CREATED_DATE;'
        END || CASE
            WHEN rec.FILE_TYPE = 'N'
            AND NVL(att_sq."TYPE", 'NULL') = 'RepairRebuildNoti' THEN ''
            WHEN rec.FILE_TYPE = 'V'
            AND NVL(att_sq."TYPE", 'NULL') = 'OccupantsVRNotiLetter' THEN ''
            ELSE 'FILE_TYPE;'
        END || CASE
            WHEN NVL(
                CASE
                    WHEN rec.FILE_TYPE = 'N'
                    AND NVL(att_sq."TYPE", 'NULL') = 'RepairRebuildNoti' THEN ''
                    WHEN rec.FILE_TYPE = 'V'
                    AND NVL(att_sq."TYPE", 'NULL') = 'OccupantsVRNotiLetter' THEN ''
                    ELSE 'NULL;'
                END || '\' || rec.DLO || '\' || rec.SQUATTERID || '\' || rec.NAME, 
            'NULL'
        ) = NVL(att."URL", 'NULL') 
        THEN '' 
        ELSE 'URL;
' 
    END ||
    CASE 
        WHEN NVL(rec.SQUATTERID, -1) = NVL(sq.SQUATTER_ID, -1) 
        THEN '' 
        ELSE 'SQUATTERID;
' 
    END, 
    ';
'
) AS error_msg,
        CASE 
            WHEN RTRIM(
                    CASE 
        WHEN NVL(rec.NAME, 'NULL') = NVL(att.DISPLAYNAME, 'NULL') 
        THEN '' 
        ELSE 'NAME;
' 
    END ||
    CASE 
        WHEN NVL(rec.CREATED_DATE, TO_DATE('1900-01-01', 'YYYY-MM-DD')) = NVL(att.CREATED_AT, TO_DATE('1900-01-01', 'YYYY-MM-DD')) 
        THEN '' 
        ELSE 'CREATED_DATE;
' 
    END ||
    CASE 
        WHEN rec.FILE_TYPE = 'N' AND NVL(att_sq."TYPE", ' NULL ') = ' RepairRebuildNoti ' 
        THEN '' 
        WHEN rec.FILE_TYPE = 'V' AND NVL(att_sq."TYPE", ' NULL ') = ' OccupantsVRNotiLetter ' 
        THEN '' 
        ELSE 'FILE_TYPE;
' 
    END ||
    CASE 
        WHEN NVL(
            CASE 
                WHEN rec.FILE_TYPE = 'N' AND NVL(att_sq."TYPE", 'NULL') = 'RepairRebuildNoti' 
                THEN '' 
                WHEN rec.FILE_TYPE = 'V' AND NVL(att_sq."TYPE", 'NULL') = 'OccupantsVRNotiLetter' 
                THEN '' 
                ELSE 'NULL;
' 
            END || ' \ ' || rec.DLO || ' \ ' || rec.SQUATTERID || ' \ ' || rec.NAME, 
            ' NULL '
        ) = NVL(att."URL", 'NULL') 
        THEN '' 
        ELSE 'URL;
' 
    END ||
    CASE 
        WHEN NVL(rec.SQUATTERID, -1) = NVL(sq.SQUATTER_ID, -1) 
        THEN '' 
        ELSE 'SQUATTERID;
' 
    END
            ) IS NULL THEN 1 
            ELSE 0 
        END AS is_valid
    FROM 
        SDE_SQ.SQUATTER_UPLOAD rec
    LEFT JOIN 
        SQ.ATTACHMENTS att ON rec.OBJECTID = att.OBJECT_ID
    LEFT JOIN 
        SQ.ATTACHMENT_SQ att_sq ON att.ID = att_sq.ATTACHMENT_ID
    LEFT JOIN 
        SQ.SQUATTERS sq ON att_sq.SQUATTER_GUID = SQ.ID
    WHERE 
        quantity = 0 OR ROWNUM <= quantity;

    -- Commit the transaction
    COMMIT;
END;

-- Check the results
SELECT * FROM data_validation_attachment;