DECLARE
    v_error_message VARCHAR2(4000);
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
            -- Find the SquatterGuid from the new DB based on the SquatterId
            DECLARE
                v_squatter_guid VARCHAR2(100);
            BEGIN
                SELECT ID INTO v_squatter_guid FROM NEWDB.SQUATTER_HIS WHERE SQUATTER_ID = rec.SQUATTERID AND VERSION = res.VERSION;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_squatter_guid := NULL;
            END;
            INSERT INTO NEWDB.SQUATTER_USE_HIS (
                SQUATTER_ID, USE_ID, SQUATTER_GUID VERSION
            ) VALUES (
                rec.SQUATTERID, 
                (SELECT ID FROM NEWDB.USES WHERE NAME = rec.SQUATTERUSE), 
                v_squatter_guid, rec.VERSION
            );
        EXCEPTION
            WHEN OTHERS THEN
                -- Capture the error and log it
                v_error_message := SQLERRM;
                log_error('SQUATTER_USE', v_error_message);
        END;
    END LOOP;
END;
/
