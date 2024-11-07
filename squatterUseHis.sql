DECLARE
    v_error_message VARCHAR2(4000);
    v_guid VARCHAR2(36);
BEGIN
    FOR rec IN (
        SELECT
            suh.OBJECTID,
            suh.SQUATTERID,
            suh.SQUATTERUSEID,
            suh.MATERIALS,
            suh.GlobalID,
            suh.created_user,
            suh.created_date,
            suh.last_edited_user,
            suh.last_edited_date,
            suh.VERSION,
            m.ID AS USE_ID,
            s.ID AS SQUATTER_HIS_GUID,
        FROM SDE_SQ.SQUATTERUSE_HIS su
        LEFT JOIN SQ.USES m ON suh.USE = m.NAME 
        LEFT JOIN SQ.SQUATTER_HISTORIES s ON suh.SQUATTERID = s.SQUATTER_ID AND suh.VERSION = s.VERSION
        -- WHERE suh.OBJECTID NOT IN (SELECT new_suh.OBJECT_ID FROM SQ.SQUATTER_MATERIAL_HIS new_sm WHERE new_suh.OBJECT_ID IS NOT NULL)
    ) LOOP
        BEGIN
            generate_Formatted_GUID(v_guid);
            IF rec.SQUATTER_HIS_GUID IS NULL  THEN
                v_error_message := 'Missing mandatory join data: SQUATTER_HIS_GUID is NULL!!';
                log_error('SQUATTER_USE_HIS', v_error_message, rec.OBJECTID);
            ELSE 
                INSERT INTO SQ.SQUATTER_USE_HIS (
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
                    rec.SQUATTER_HIS_GUID,
                    rec.VERSION,
                    rec.created_date,
                    rec.last_edited_date
                );

            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                -- Capture the error and log it
                v_error_message := SQLERRM;
                log_error('SQUATTER_USE_HIS', v_error_message, rec.OBJECTID);
        END;
    END LOOP;
END;
