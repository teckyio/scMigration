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
            s.ID AS SQUATTER_GUID
        FROM SDE_SQ.SQUATTERMATERIAL sm
        LEFT JOIN SQ.MATERIALS m ON m.NAME = sm.MATERIALS
        LEFT JOIN SQ.SQUATTERS s ON s.SQUATTER_ID = sm.SQUATTERID
    ) LOOP
        BEGIN
            generate_Formatted_GUID(v_guid);
            -- Insert into the new SQUATTER_MATERIAL table
            INSERT INTO SQ.SQUATTER_MATERIALS (
                ID,
                SQUATTER_ID, 
                MATERIAL_ID, 
                SQUATTER_GUID, 
                SQUATTER_VERSION,
                CREATED_AT,
                UPDATED_AT
            ) VALUES (
                v_guid,
                rec.SQUATTERID, 
                rec.MATERIAL_ID,
                rec.SQUATTER_GUID,
                rec.VERSION,
                rec.created_date,
                rec.last_edited_date
            );
        EXCEPTION
            WHEN OTHERS THEN
                -- Capture the error and log it
                v_error_message := SQLERRM;
                log_error('SQUATTER_MATERIAL', v_error_message || ' | ObjectID: ' || TO_CHAR(rec.OBJECTID), rec.OBJECTID);
        END;
    END LOOP;
END;
