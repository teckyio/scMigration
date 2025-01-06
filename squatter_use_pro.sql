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
            suh.GLOBALID,
            suh.created_user,
            suh.created_date,
            suh.last_edited_user,
            suh.last_edited_date,
            NVL(suh.VERSION, 0) AS VERSION,
            m.ID AS USE_ID,
            s.ID AS SQUATTER_PEND_GUID
        FROM SDE_SQ.SQUATTERUSE_PRO suh
        LEFT JOIN SQ.USES m ON suh.SQUATTERUSE = m.NAME 
        LEFT JOIN SQ.SQUATTER_PENDS s ON suh.SQUATTERID = s.SQUATTER_ID AND suh.VERSION = s.VERSION
    ) LOOP
        BEGIN
            generate_Formatted_GUID(v_guid);
            IF rec.SQUATTER_PEND_GUID IS NULL THEN
                INSERT INTO SQ.SQUATTER_USES (
                    ID,
                    SQUATTER_ID, 
                    USE_ID, 
                    SQUATTER_VERSION,
                    CREATED_AT,
                    UPDATED_AT,
                    OBJECT_ID,
                    GLOBAL_ID,
                    D_SQUATTER_USE_ID,
                    CREATED_BY,
                    UPDATED_BY
                ) VALUES (
                    v_guid,
                    rec.SQUATTERID, 
                    rec.USE_ID,
                    rec.VERSION,
                    rec.created_date,
                    rec.last_edited_date,
                    rec.OBJECTID,
                    rec.GLOBALID,
                    rec.SQUATTERUSEID,
                    rec.created_user,
                    rec.last_edited_user
                );
            ELSE 
                INSERT INTO SQ.SQUATTER_USES (
                    ID,
                    SQUATTER_ID, 
                    USE_ID, 
                    SQUATTER_PEND_GUID, 
                    SQUATTER_VERSION,
                    CREATED_AT,
                    UPDATED_AT,
                    OBJECT_ID,
                    GLOBAL_ID,
                    D_SQUATTER_USE_ID,
                    CREATED_BY,
                    UPDATED_BY
                ) VALUES (
                    v_guid,
                    rec.SQUATTERID, 
                    rec.USE_ID,
                    rec.SQUATTER_PEND_GUID,
                    rec.VERSION,
                    rec.created_date,
                    rec.last_edited_date,
                    rec.OBJECTID,
                    rec.GLOBALID,
                    rec.SQUATTERUSEID,
                    rec.created_user,
                    rec.last_edited_user
                );

            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                -- Capture the error and log it
                v_error_message := SQLERRM;
                log_error('SQUATTER_USE_PRO', v_error_message, rec.OBJECTID);
        END;
    END LOOP;
END;
