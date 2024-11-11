DECLARE
    v_error_message VARCHAR2(4000);
    v_guid VARCHAR2(36);
BEGIN
    FOR rec IN (
        SELECT
            sm.OBJECTID,
            sm.SQUATTERID,
            sm.SQUATTERMATERIALID,
            sm.MATERIALS,
            sm.GlobalID,
            sm.created_user,
            sm.created_date,
            sm.last_edited_user,
            sm.last_edited_date,
            sm.VERSION,
            m.ID AS MATERIAL_ID,
            s.ID AS SQUATTER_HIS_GUID
        FROM SDE_SQ.SQUATTERMATERIAL_HIS sm
        LEFT JOIN SQ.MATERIALS m ON sm.MATERIALS = m.NAME 
        LEFT JOIN SQ.SQUATTER_HISTORIES s ON sm.SQUATTERID = s.SQUATTER_ID AND sm.VERSION = s.VERSION
        -- WHERE sm.OBJECTID NOT IN (SELECT new_sm.OBJECT_ID FROM SQ.SQUATTER_MATERIAL_HIS new_sm WHERE new_sm.OBJECT_ID IS NOT NULL)
    ) LOOP
        BEGIN
            generate_Formatted_GUID(v_guid);
            IF rec.SQUATTER_HIS_GUID IS NULL  THEN
                v_error_message := 'Missing mandatory join data: SQUATTER_HIS_GUID is NULL!!';
                log_error('SQUATTER_MATERIAL_HIS', v_error_message, rec.OBJECTID);
            ELSE 
                INSERT INTO SQ.SQUATTER_MATERIAL_HIS (
                    ID,
                    SQUATTER_ID, 
                    MATERIAL_ID, 
                    SQUATTER_GUID, 
                    SQUATTER_VERSION,
                    CREATED_AT,
                    UPDATED_AT,
                    OBJECT_ID
                ) VALUES (
                    v_guid,
                    rec.SQUATTERID, 
                    rec.MATERIAL_ID,
                    rec.SQUATTER_HIS_GUID,
                    rec.VERSION,
                    rec.created_date,
                    rec.last_edited_date,
                    rec.OBJECT_ID
                );

            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                -- Capture the error and log it
                v_error_message := SQLERRM;
                log_error('SQUATTER_MATERIAL-HIS', v_error_message, rec.OBJECTID);
        END;
    END LOOP;
END;
