DECLARE
    v_error_message VARCHAR2(4000);
BEGIN
    FOR rec IN (
        SELECT
            OBJECTID,
            SQUATTERID,
            created_user,
            created_date,
            last_edited_user,
            last_edited_date,
            SHAPE,
            GDB_GEOMATTR_DATA
        FROM OLDDB.SQUATTER_POLY
    ) LOOP
        BEGIN
            INSERT INTO NEWDB.SQUATTER_POLYS (
                OBJECT_ID, SQUATTER_ID, CREATED_USER, CREATED_DATE, LAST_EDITED_USER, 
                LAST_EDITED_DATE, SHAPE, VERSION, DELETED
            ) VALUES (
                rec.OBJECTID, rec.SQUATTERID, rec.created_user, rec.created_date, rec.last_edited_user, 
                rec.last_edited_date, rec.SHAPE, 1, 0
            );
        EXCEPTION
            WHEN OTHERS THEN
                v_error_message := SQLERRM;
                log_error('SQUATTER_POLYS', v_error_message);
        END;
    END LOOP;
END;
/
