DECLARE
    v_error_message VARCHAR2(4000);
BEGIN
    FOR rec IN (
        SELECT
            OBJECTID,
            SQUATTERID,
            SQUATTERMATERIALID,
            MATERIALS,
            GlobalID,
            created_user,
            created_date,
            last_edited_user,
            last_edited_date,
            VERSION
        FROM OLDDB.SQUATTERMATERIAL
    ) LOOP
        BEGIN
            -- Check if the material already exists in the new Material table
            IF NOT EXISTS (SELECT 1 FROM NEWDB.MATERIALS WHERE NAME = rec.MATERIALS) THEN
                -- Insert into the MATERIAL table
                INSERT INTO NEWDB.MATERIAL (NAME, DISPLAY_NAME, SORTING_INDEX)
                VALUES (rec.MATERIALS, rec.MATERIALS, 1);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                -- Capture the error and log it
                v_error_message := SQLERRM;
                log_error('SQUATTER_MATERIAL', v_error_message);
        END;
    END LOOP;
END;

DECLARE
    v_error_message VARCHAR2(4000);
BEGIN
    FOR rec IN (
        SELECT
            OBJECTID,
            SQUATTERID,
            SQUATTERMATERIALID,
            MATERIALS,
            GlobalID,
            created_user,
            created_date,
            last_edited_user,
            last_edited_date,
            VERSION
        FROM OLDDB.SQUATTERMATERIAL_HIS
    ) LOOP
        BEGIN
            -- Check if the material already exists in the new Material table
            IF NOT EXISTS (SELECT 1 FROM NEWDB.MATERIALS WHERE NAME = rec.MATERIALS) THEN
                -- Insert into the MATERIAL table
                INSERT INTO NEWDB.MATERIALS (NAME, DISPLAY_NAME, SORTING_INDEX)
                VALUES (rec.MATERIALS, rec.MATERIALS, 1);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                -- Capture the error and log it
                v_error_message := SQLERRM;
                log_error('SQUATTER_MATERIAL', v_error_message);
        END;
    END LOOP;
END;

