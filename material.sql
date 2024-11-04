DECLARE
    v_error_message VARCHAR2(4000);
    v_count INTEGER;
    v_max_sorting_index INTEGER;
    v_guid VARCHAR(36);
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
        FROM SDE_SQ.SQUATTERMATERIAL
    ) LOOP
        BEGIN
            -- Check if the material already exists in the new Material table
            SELECT COUNT(1) INTO v_count FROM SQ.MATERIALS WHERE NAME = rec.MATERIALS;
            
            IF v_count = 0 THEN
                -- Get the current max SORTING_INDEX
                SELECT NVL(MAX(SORTING_INDEX), 0) + 1 INTO v_max_sorting_index FROM SQ.MATERIALS;
                generate_Formatted_GUID(v_guid)
                INSERT INTO SQ.MATERIALS (ID, NAME, DISPLAY_NAME, SORTING_INDEX)
                VALUES (v_guid, rec.MATERIALS, rec.MATERIALS, v_max_sorting_index);
                COMMIT;
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
    v_guid VARCHAR(36);
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
        FROM SDE_SQ.SQUATTERMATERIAL_HIS
    ) LOOP
        BEGIN
            -- Check if the material already exists in the new Material table
            SELECT COUNT(1) INTO v_count FROM SQ.MATERIALS WHERE NAME = rec.MATERIALS;

            IF v_count = 0 THEN
                -- Get the current max SORTING_INDEX
                SELECT NVL(MAX(SORTING_INDEX), 0) + 1 INTO v_max_sorting_index FROM SQ.MATERIALS;

                -- Insert into the MATERIAL table
                INSERT INTO SQ.MATERIALS (ID, NAME, DISPLAY_NAME, SORTING_INDEX)
                VALUES (v_guid, rec.MATERIALS, rec.MATERIALS, v_max_sorting_index);
                COMMIT;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                v_error_message := SQLERRM;
                log_error('USE', v_error_message, rec.OBJECTID)
        END;
    END LOOP;
END;
