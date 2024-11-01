DECLARE
    v_error_message VARCHAR2(4000);
    v_count INTEGER;
    v_max_sorting_index INTEGER;
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
        FROM SDE_SQ.SQUATTERUSE
    ) LOOP
        BEGIN
            -- Check if the use already exists in the new Material table
            SELECT COUNT(1) INTO v_count FROM SQ.USES WHERE NAME = rec.SQUATTERUSE;

            IF v_count = 0 THEN
                -- Get the current max SORTING_INDEX
                SELECT NVL(MAX(SORTING_INDEX), 0) + 1 INTO v_max_sorting_index FROM SQ.USES;
                
                INSERT INTO SQ.MATERIALS (NAME, DISPLAY_NAME, SORTING_INDEX)
                VALUES (rec.SQUATTERUSE, rec.SQUATTERUSE, v_max_sorting_index);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                v_error_message := SQLERRM;
                log_error('USE', v_error_message, rec.OBJECTID)
        END;
    END LOOP;
END;

-- Second block for SQUATTERMATERIAL_HIS

DECLARE
    v_error_message VARCHAR2(4000);
    v_count INTEGER;
    v_max_sorting_index INTEGER;
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
        FROM SDE_SQ.SQUATTERUSE_HIS
    ) LOOP
        BEGIN
            -- Check if the material already exists in the new Material table
            SELECT COUNT(1) INTO v_count FROM SQ.USES WHERE NAME = rec.SQUATTERUSE;

            IF v_count = 0 THEN
                -- Get the current max SORTING_INDEX
                SELECT NVL(MAX(SORTING_INDEX), 0) + 1 INTO v_max_sorting_index FROM SQ.USES;

                -- Insert into the MATERIAL table
                INSERT INTO SQ.USES (NAME, DISPLAY_NAME, SORTING_INDEX)
                VALUES (rec.SQUATTERUSE, rec.SQUATTERUSE, v_max_sorting_index);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                v_error_message := SQLERRM;
                log_error('USE', v_error_message, rec.OBJECTID)
        END;
    END LOOP;
END;
