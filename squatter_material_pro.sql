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
            NVL(sm.VERSION, 0) AS VERSION,
            m.ID AS MATERIAL_ID,
            s.ID AS SQUATTER_PEND_GUID
        FROM SDE_SQ.SQUATTERMATERIAL_PRO sm
        LEFT JOIN SQ.MATERIALS m ON sm.MATERIALS = m.NAME 
        LEFT JOIN SQ.SQUATTER_PENDS s ON sm.SQUATTERID = s.SQUATTER_ID AND sm.VERSION = s.VERSION
    ) LOOP
        BEGIN
            generate_Formatted_GUID(v_guid);
            IF rec.SQUATTER_PEND_GUID IS NULL  THEN
                INSERT INTO SQ.SQUATTER_MATERIALS (
                    ID,
                    SQUATTER_ID, 
                    MATERIAL_ID, 
                    SQUATTER_VERSION,
                    CREATED_AT,
                    UPDATED_AT,
                    OBJECT_ID,
                    GLOBAL_ID,
                    D_SQUATTER_MATERIAL_ID,
                    CREATED_BY,
                    UPDATED_BY
                ) VALUES (
                    v_guid,
                    rec.SQUATTERID, 
                    rec.MATERIAL_ID,
                    rec.VERSION,
                    rec.created_date,
                    rec.last_edited_date,
                    rec.OBJECTID,
                    rec.GLOBALID,
                    rec.SQUATTERMATERIALID,
                    rec.created_user,
                    rec.last_edited_user
                );
            ELSE 
                INSERT INTO SQ.SQUATTER_MATERIALS (
                    ID,
                    SQUATTER_ID, 
                    MATERIAL_ID, 
                    SQUATTER_PEND_GUID, 
                    SQUATTER_VERSION,
                    CREATED_AT,
                    UPDATED_AT,
                    OBJECT_ID,
                    GLOBAL_ID,
                    D_SQUATTER_MATERIAL_ID,
                    CREATED_BY,
                    UPDATED_BY
                ) VALUES (
                    v_guid,
                    rec.SQUATTERID, 
                    rec.MATERIAL_ID,
                    rec.SQUATTER_PEND_GUID,
                    rec.VERSION,
                    rec.created_date,
                    rec.last_edited_date,
                    rec.OBJECTID,
                    rec.GLOBALID,
                    rec.SQUATTERMATERIALID,
                    rec.created_user,
                    rec.last_edited_user
                );

            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                -- Capture the error and log it
                v_error_message := SQLERRM;
                log_error('SQUATTER_MATERIAL_PRO', v_error_message, rec.OBJECTID);
        END;
    END LOOP;
END;
