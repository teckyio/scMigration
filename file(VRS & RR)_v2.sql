DECLARE
    v_error_message VARCHAR2(4000);
    v_guid VARCHAR2(36);
    v_attachment_sq_guid VARCHAR2(36);
    converted_filetype VARCHAR2(50);
    folder_name VARCHAR2(50);
    filepath VARCHAR2(4000);
BEGIN
    FOR rec IN (
        SELECT
            OBJECTID,
            NAME,
            CREATED_DATE,
            FILE_TYPE,
            DLO,
            SQUATTERID
        FROM SDE_SQ.SQUATTER_UPLOAD old
    ) LOOP
        BEGIN

            IF rec.FILE_TYPE = 'N' THEN
                folder_name := 'RepairRebuildNoti';
            ELSIF rec.FILE_TYPE = 'V' THEN
                folder_name := 'OccupantsVRNotiLetter';
            ELSE
                RAISE_APPLICATION_ERROR(-20001, 'Invalid folder_name: ' || rec.FILE_TYPE);
            END IF;

            IF rec.FILE_TYPE = 'N' THEN
                converted_filetype := 'RepairRebuildNoti';
            ELSIF rec.FILE_TYPE = 'V' THEN
                converted_filetype := 'OccupantsVRNotiLetter';
            ELSE
                RAISE_APPLICATION_ERROR(-20001, 'Invalid FILE_TYPE: ' || rec.FILE_TYPE);
            END IF;

            -- Construct the file path
            filepath := folder_name || '\' || rec.DLO || '\' || rec.SQUATTERID || '\' || rec.NAME;

            -- Generate GUID
            generate_Formatted_GUID(v_guid);
            generate_Formatted_GUID(v_attachment_sq_guid);

            -- Insert into attachments table
            INSERT INTO SQ.ATTACHMENTS (
                ID,
                FULL_FILENAME,
                DISPLAYNAME,
                FILESIZE,
                "URL",
                "OBJECT_ID",
                CREATED_AT,
                UPDATED_AT
            ) VALUES (
                v_guid,
                rec.NAME,
                rec.NAME,
                0,
                filepath,
                rec.OBJECTID,
                rec.CREATED_DATE,
                rec.CREATED_DATE
            );

            INSERT INTO SQ.ATTACHMENT_SQ (ID, ATTACHMENT_ID, SQUATTER_GUID, "TYPE")
            VALUES (
                v_attachment_sq_guid,
                v_guid,
                (SELECT ID FROM SQ.SQUATTERS WHERE SQUATTER_ID = rec.SQUATTERID),
                converted_filetype
            );
        EXCEPTION
            WHEN OTHERS THEN
                v_error_message := SQLERRM;
                log_error('ATTACHMENT', v_error_message, rec.OBJECTID);
        END;
    END LOOP;
END;
