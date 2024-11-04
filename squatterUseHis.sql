DECLARE
    v_error_message VARCHAR2(4000);
    v_guid VARCHAR2(36);
BEGIN
    FOR rec IN (
        SELECT
            suh.OBJECTID,
            suh.SQUATTERID,
            suh.SQUATTERUSEID,
            suh.SQUATTERUSE,
            suh.GlobalID,
            suh.created_user,
            suh.created_date,
            suh.last_edited_user,
            suh.last_edited_date,
            suh.VERSION,
            u.ID AS USE_ID,
            s.ID AS SQUATTER_GUID
        FROM SDE_SQ.SQUATTERUSE_HIS suh
        LEFT JOIN SC.USES u ON u.NAME = suh.SQUATTERUSE
        LEFT JOIN SC.SQUATTER_HISTORIES s ON s.SQUATTER_ID = suh.SQUATTERID
    ) LOOP
        BEGIN
            generate_Formatted_GUID(v_guid);
            -- Insert into the new SQUATTER_MATERIAL table
            INSERT INTO SC.SQUATTER_USES (
                ID,
                SQUATTER_ID, 
                USE_ID, 
                SQUATTER_GUID, 
                SQUATTER_VERSION
            ) VALUES (
                v_guid,
                rec.SQUATTERID, 
                rec.USE_ID,
                rec.SQUATTER_GUID,
                rec.VERSION
            );
        EXCEPTION
            WHEN OTHERS THEN
                -- Capture the error and log it
                v_error_message := SQLERRM;
                log_error('SQUATTER_USES_HIS', v_error_message || ' | ObjectID: ' || TO_CHAR(rec.OBJECTID), rec.OBJECTID);
        END;
    END LOOP;
END;
