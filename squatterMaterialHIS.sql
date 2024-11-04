DECLARE
    v_error_message VARCHAR2(4000);
    v_guid VARCHAR2(36);
BEGIN
    FOR rec IN (
        SELECT
            smh.OBJECTID,
            smh.SQUATTERID,
            smh.SQUATTERMATERIALID,
            smh.MATERIALS,
            smh.GlobalID,
            smh.created_user,
            smh.created_date,
            smh.last_edited_user,
            smh.last_edited_date,
            smh.VERSION,
            m.ID AS MATERIAL_ID,
            s.ID AS SQUATTER_GUID
        FROM SDE_SQ.SQUATTERMATERIAL_HIS smh
        LEFT JOIN SQ.MATERIALS m ON m.NAME = smh.MATERIALS
        LEFT JOIN SQ.SQUATTER_HISTORIES s ON s.SQUATTER_ID = smh.SQUATTERID
    ) LOOP
        BEGIN
            generate_Formatted_GUID(v_guid);
            -- Insert into the new SQUATTER_MATERIAL table
            INSERT INTO SQ.SQUATTER_MATERIALS (
                ID,
                SQUATTER_ID, 
                MATERIAL_ID, 
                SQUATTER_GUID, 
                SQUATTER_VERSION
            ) VALUES (
                v_guid,
                rec.SQUATTERID, 
                rec.MATERIAL_ID,
                rec.SQUATTER_GUID,
                rec.VERSION
            );
        EXCEPTION
            WHEN OTHERS THEN
                -- Capture the error and log it
                v_error_message := SQLERRM;
                log_error('SQUATTER_MATERIAL_HIS', v_error_message || ' | ObjectID: ' || TO_CHAR(rec.OBJECTID), rec.OBJECTID);
        END;
    END LOOP;
END;
