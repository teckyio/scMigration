DECLARE
    v_error_message VARCHAR2(4000);
    v_guid VARCHAR2(36);
BEGIN
    FOR rec IN (
        SELECT
            sm.OBJECTID,
            sm.SQUATTERID,
            sm.SQUATTERUSEID,
            sm.SQUATTERUSE,
            sm.GlobalID,
            sm.created_user,
            sm.created_date,
            sm.last_edited_user,
            sm.last_edited_date,
            sm.VERSION,
            m.ID AS USE_ID,
            s.ID AS SQUATTER_GUID,
            sp.ID AS SQUATTER_PEND_GUID
        FROM SDE_SQ.SQUATTERUSE sm
        LEFT JOIN SQ.USES m ON sm.SQUATTERUSE = m.NAME 
        LEFT JOIN SQ.SQUATTERS s ON sm.SQUATTERID = s.SQUATTER_ID AND sm.VERSION = s.VERSION
        LEFT JOIN SQ.SQUATTER_PENDS sp ON sm.SQUATTERID = sp.SQUATTER_ID AND sm.VERSION = sp.VERSION
        -- WHERE sm.OBJECTID NOT IN (SELECT new_sm.OBJECT_ID FROM SQ.SQUATTER_MATERIALS new_sm WHERE new_sm.OBJECT_ID IS NOT NULL)
    ) LOOP
        BEGIN
            generate_Formatted_GUID(v_guid);
            IF rec.SQUATTER_GUID IS NULL AND rec.SQUATTER_PEND_GUID IS NULL THEN
                v_error_message := 'Missing mandatory join data: SQUATTER_PEND_GUID AND SQUATTER_GUID is NULL!!';
                log_error('SQUATTER_USE', v_error_message, rec.OBJECTID);
            ELSIF rec.SQUATTER_GUID IS NOT NULL AND rec.SQUATTER_PEND_GUID IS NULL THEN
                INSERT INTO SQ.SQUATTER_USES (
                    ID,
                    SQUATTER_ID, 
                    USE_ID, 
                    SQUATTER_GUID, 
                    SQUATTER_VERSION,
                    CREATED_AT,
                    UPDATED_AT
                ) VALUES (
                    v_guid,
                    rec.SQUATTERID, 
                    rec.USE_ID,
                    rec.SQUATTER_GUID,
                    rec.VERSION,
                    rec.created_date,
                    rec.last_edited_date
                );
            ELSIF  rec.SQUATTER_PEND_GUID IS NOT NULL AND rec.SQUATTER_GUID IS NULL THEN
                INSERT INTO SQ.SQUATTER_USES (
                    ID,
                    SQUATTER_ID, 
                    USE_ID, 
                    SQUATTER_PEND_GUID, 
                    SQUATTER_VERSION,
                    CREATED_AT,
                    UPDATED_AT
                ) VALUES (
                    v_guid,
                    rec.SQUATTERID, 
                    rec.USE_ID,
                    rec.SQUATTER_PEND_GUID,
                    rec.VERSION,
                    rec.created_date,
                    rec.last_edited_date
                );
            ELSE
                v_error_message := 'Missing mandatory join data: SQUATTER_PEND_GUID AND SQUATTER_GUID MATCH WITH A SQUATTERMATIRAL!!';
                log_error('SQUATTER_USE', v_error_message, rec.OBJECTID);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                -- Capture the error and log it
                v_error_message := SQLERRM;
                log_error('SQUATTER_USE', v_error_message, rec.OBJECTID);
        END;
    END LOOP;
END;
