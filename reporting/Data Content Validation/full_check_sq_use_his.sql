TRUNCATE TABLE data_validation_squatter_use_his;
DECLARE quantity INT := 0;
BEGIN -- Insert data into the table with validation checks
INSERT INTO data_validation_squatter_use_his (
    objectid,
    target_ObjectId,
    error_msg,
    is_valid,
    dlo
  )
SELECT rec.objectid AS objectid,
  s.OBJECT_ID AS target_ObjectId,
  -- Concatenate error messages for all mismatched fields
  RTRIM(
    CASE
      WHEN rec.OBJECTID = s.OBJECT_ID THEN ''
      ELSE 'OBJECTID;'
    END || CASE
      WHEN NVL(rec.SQUATTERID, -1) = NVL(s.SQUATTER_ID, -1) THEN ''
      ELSE 'SQUATTERID;'
    END || CASE
      WHEN NVL(rec.VERSION, 0) = NVL(s.SQUATTER_VERSION, -1) THEN ''
      ELSE 'VERSION;'
    END || CASE
      WHEN NVL(rec.GLOBALID, 'NULL') = NVL(s.GLOBAL_ID, 'NULL') THEN ''
      ELSE 'GLOBALID;'
    END || CASE
      WHEN NVL(rec.SQUATTERUSE, 'NULL') = NVL(u.NAME, 'NULL') THEN ''
      ELSE 'SQUATTERUSE;'
    END || CASE
      WHEN NVL(
        rec.CREATED_DATE,
        TO_DATE('1900-01-01', 'YYYY-MM-DD')
      ) = NVL(s.CREATED_AT, TO_DATE('1900-01-01', 'YYYY-MM-DD')) THEN ''
      ELSE 'CREATAED_DATE;'
    END || CASE
      WHEN NVL(
        rec.LAST_EDITED_DATE,
        TO_DATE('1900-01-01', 'YYYY-MM-DD')
      ) = NVL(s.UPDATED_AT, TO_DATE('1900-01-01', 'YYYY-MM-DD')) THEN ''
      ELSE 'LAST_EDITED_DATE;'
    END || CASE
      WHEN NVL(rec.CREATED_USER, 'NULL') = NVL(s.CREATED_BY, 'NULL') THEN ''
      ELSE 'CREATED_USER;'
    END || CASE
      WHEN NVL(rec.LAST_EDITED_USER, 'NULL') = NVL(s.UPDATED_BY, 'NULL') THEN ''
      ELSE 'LAST_EDITED_USER;'
    END || CASE
      WHEN NVL(rec.SQUATTERUSEID, -1) = NVL(s.D_SQUATTER_USE_ID, -1) THEN '' 
      ELSE 'SQUATTERUSEID'
    END,
    '; '
  ),
  CASE
    WHEN (
      CASE
        WHEN rec.OBJECTID = s.OBJECT_ID THEN ''
        ELSE 'OBJECTID;'
      END || CASE
        WHEN NVL(rec.SQUATTERID, -1) = NVL(s.SQUATTER_ID, -1) THEN ''
        ELSE 'SQUATTERID;'
      END || CASE
        WHEN NVL(rec.VERSION, 0) = NVL(s.SQUATTER_VERSION, -1) THEN ''
        ELSE 'VERSION;'
      END || CASE
        WHEN NVL(rec.GLOBALID, 'NULL') = NVL(s.GLOBAL_ID, 'NULL') THEN ''
        ELSE 'GLOBALID;'
      END || CASE
        WHEN NVL(rec.SQUATTERUSE, 'NULL') = NVL(u.NAME, 'NULL') THEN ''
        ELSE 'SQUATTERUSE;'
      END || CASE
        WHEN NVL(
          rec.CREATED_DATE,
          TO_DATE('1900-01-01', 'YYYY-MM-DD')
        ) = NVL(s.CREATED_AT, TO_DATE('1900-01-01', 'YYYY-MM-DD')) THEN ''
        ELSE 'CREATAED_DATE;'
      END || CASE
        WHEN NVL(
          rec.LAST_EDITED_DATE,
          TO_DATE('1900-01-01', 'YYYY-MM-DD')
        ) = NVL(s.UPDATED_AT, TO_DATE('1900-01-01', 'YYYY-MM-DD')) THEN ''
        ELSE 'LAST_EDITED_DATE;'
      END || CASE
        WHEN NVL(rec.CREATED_USER, 'NULL') = NVL(s.CREATED_BY, 'NULL') THEN ''
        ELSE 'CREATED_USER;'
      END || CASE
        WHEN NVL(rec.LAST_EDITED_USER, 'NULL') = NVL(s.UPDATED_BY, 'NULL') THEN ''
        ELSE 'LAST_EDITED_USER;'
      END || CASE
        WHEN NVL(rec.SQUATTERUSEID, -1) = NVL(s.D_SQUATTER_USE_ID, -1) THEN '' 
      ELSE 'SQUATTERUSEID'
      END
    ) IS NULL THEN 1
    ELSE 0
  END AS is_valid,
  sq.dlo_id as dlo
FROM SDE_SQ.SQUATTERUSE_HIS rec
  LEFT JOIN SQ.SQUATTER_USE_HIS s ON rec.OBJECTID = s.object_id
  LEFT JOIN SQ.SQUATTER_HISTORIES sq ON s.Squatter_History_Id = sq.id
  LEFT JOIN SQ.USES u ON s.USE_ID = u.id
WHERE quantity = 0
  OR ROWNUM <= quantity;
-- Commit transaction
COMMIT;
END;
SELECT *
FROM data_validation_squatter_use_his;