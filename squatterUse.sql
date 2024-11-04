DECLARE
    v_error_message VARCHAR2(4000);
    v_guid VARCHAR2(36);
BEGIN
    FOR rec IN (
        SELECT
            su.OBJECTID,
            su.SQUATTERID,
            su.SQUATTERUSEID,
            su.SQUATTERUSE,
            su.GlobalID,
            su.created_user,
            su.created_date,
            su.last_edited_user,
            su.last_edited_date,
            su.VERSION,
            u.ID AS USE_ID,
            s.ID AS SQUATTER_GUID
        FROM SDE_SQ.SQUATTERUSE su
        LEFT JOIN SQ.USES u ON u.NAME = su.SQUATTERUSE
        LEFT JOIN SQ.SQUATTERS s ON s.SQUATTER_ID = su.SQUATTERID
    ) LOOP
        BEGIN
            generate_Formatted_GUID(v_guid);
            -- Insert into the new SQUATTER_MATERIAL table
            INSERT INTO SQ.SQUATTER_USES (
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
                log_error('SQUATTER_USES', v_error_message || ' | ObjectID: ' || TO_CHAR(rec.OBJECTID), rec.OBJECTID);
        END;
    END LOOP;
END;
