DECLARE
    v_error_message VARCHAR2(4000);
    v_max_sorting_index NUMBER;
BEGIN
    FOR rec IN (
        SELECT
            OBJECTID,
            SQUATTERID,
            SQUATTERUSEID,
            SQUATTERUSE,
            GlobalID,
            created_user,
            created_date,
            last_edited_user,
            last_edited_date,
            VERSION
        FROM OLDDB.SQUATTERUSE
    ) LOOP
        BEGIN
            -- Check if the use already exists in the new Use table
            IF NOT EXISTS (SELECT 1 FROM NEWDB.USE WHERE NAME = rec.SQUATTERUSE) THEN
                -- Get the current maximum sorting index
                SELECT NVL(MAX(SORTING_INDEX), 0) INTO v_max_sorting_index FROM NEWDB.USE;

                -- Insert the new use with the next sorting index
                INSERT INTO NEWDB.USE (NAME, DISPLAY_NAME, SORTING_INDEX)
                VALUES (rec.SQUATTERUSE, rec.SQUATTERUSE, v_max_sorting_index + 1);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                -- Capture the error and log it
                v_error_message := SQLERRM;
                log_error('SQUATTER_USE', v_error_message);
        END;
    END LOOP;
END;

DECLARE
    v_error_message VARCHAR2(4000);
    v_max_sorting_index NUMBER;
BEGIN
    FOR rec IN (
        SELECT
            OBJECTID,
            SQUATTERID,
            SQUATTERUSEID,
            SQUATTERUSE,
            GlobalID,
            created_user,
            created_date,
            last_edited_user,
            last_edited_date,
            VERSION
        FROM OLDDB.SQUATTERUSE_HIS
    ) LOOP
        BEGIN
            -- Check if the use already exists in the new Use table
            IF NOT EXISTS (SELECT 1 FROM NEWDB.USES WHERE NAME = rec.SQUATTERUSE) THEN
                -- Get the current maximum sorting index
                SELECT NVL(MAX(SORTING_INDEX), 0) INTO v_max_sorting_index FROM NEWDB.USE;

                -- Insert the new use with the next sorting index
                INSERT INTO NEWDB.USES (NAME, DISPLAY_NAME, SORTING_INDEX)
                VALUES (rec.SQUATTERUSE, rec.SQUATTERUSE, v_max_sorting_index + 1);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                -- Capture the error and log it
                v_error_message := SQLERRM;
                log_error('SQUATTER_USE', v_error_message);
        END;
    END LOOP;
END;
/