DECLARE
    v_error_message VARCHAR2(4000);
    v_guid VARCHAR2(36);
    v_attachment_sq_guid VARCHAR2(36);
    converted_filetype VARCHAR2(50);
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
            -- Determine the converted file type
            IF rec.FILE_TYPE = 'N' THEN
                converted_filetype := 'Repair_Rebuild';
            ELSIF rec.FILE_TYPE = 'V' THEN
                converted_filetype := 'VRS';
            ELSE
                RAISE_APPLICATION_ERROR(-20001, 'Invalid FILE_TYPE: ' || rec.FILE_TYPE);
            END IF;

            -- Construct the file path
            filepath := converted_filetype || '\' || rec.DLO || '\' || rec.SQUATTERID || '\' || rec.NAME;

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
                "OBJECT_ID"
            ) VALUES (
                v_guid,
                rec.NAME,
                rec.NAME,
                0,
                filepath,
                rec.OBJECTID
            );

            -- Insert into ATTACHMENT_SQ based on FILE_TYPE
            IF rec.FILE_TYPE = 'V' THEN
                INSERT INTO SQ.ATTACHMENT_SQ (ID, Attachment_Id, Occupants_VR_Noti_Letter_Sq_Guid)
                VALUES (
                    v_attachment_sq_guid,
                    v_guid,
                    (SELECT ID FROM SQ.SQUATTERS WHERE SQUATTER_ID = rec.SQUATTERID)
                );
            ELSIF rec.FILE_TYPE = 'N' THEN
                INSERT INTO SQ.ATTACHMENT_SQ (ID, Attachment_Id, Repair_Rebuild_Noti_Sq_Guid)
                VALUES (
                    v_attachment_sq_guid,
                    v_guid,
                    (SELECT ID FROM SQ.SQUATTERS WHERE SQUATTER_ID = rec.SQUATTERID)
                );
            END IF;

        EXCEPTION
            WHEN OTHERS THEN
                v_error_message := SQLERRM;
                log_error('ATTACHMENT', v_error_message, rec.OBJECTID);
        END;
    END LOOP;
END;
