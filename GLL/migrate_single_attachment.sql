-- Procedure to migrate a single attachment record
CREATE OR REPLACE PROCEDURE migrate_single_attachment (
    p_gll_objectid IN NUMBER
  , scanned_gll_url IN VARCHAR2
  , scanned_sc_url IN VARCHAR2
  , scanned_sir_url IN VARCHAR2
  , scanned_rl_url IN VARCHAR2
  , scanned_gllfeeaccessment_url IN VARCHAR2
  , p_file_size IN NUMBER
  , p_created_at IN TIMESTAMP
  , p_updated_at IN TIMESTAMP
  , p_target_id OUT RAW
) AS
    p_id          RAW(16);
    p_relation_id RAW(16);
    p_url         VARCHAR2(4000);

    PROCEDURE process_attachment(
        p_full_filename IN VARCHAR2
      , p_relation_column IN VARCHAR2
    ) IS
        v_sql VARCHAR2(4000);
    BEGIN
        p_id := sys_guid();
        p_relation_id := sys_guid();
        MERGE INTO attachments a USING (
            SELECT
                p_id                                                                                     AS id
                , regexp_replace(p_full_filename, '\\L_Drive\\DMS\\', '\\\\npgonassvmcifs\\rms_gll_stg\\data\\') AS full_filename
                , p_full_filename                                                                        AS full_filename_original
                , regexp_substr(p_full_filename, '[^\\]*$')                                              AS displayname
                , p_file_size                                                                            AS file_size
                , p_created_at                                                                           AS created_at
                , p_updated_at                                                                           AS updated_at
            FROM
                dual
        ) src ON (a.url = src.full_filename_original) WHEN MATCHED THEN UPDATE SET a.full_filename = src.full_filename, a.displayname = src.displayname, a.file_size = src.file_size, a.created_at = src.created_at, a.updated_at = src.updated_at WHEN NOT MATCHED THEN INSERT (id, full_filename, displayname, file_size, url, created_at, updated_at) VALUES (src.id, src.full_filename, src.displayname, src.file_size, src.full_filename_original, src.created_at, src.updated_at);
        SELECT
            id INTO p_target_id
        FROM
            attachments a
        WHERE
            a.url = p_full_filename;
        v_sql := '
            MERGE INTO ATTACHMENT_GLL AG USING (
                SELECT
                    :1 AS GLL_OBJECTID,
                    (SELECT ID FROM GLLS G WHERE G.OBJECTID_D = :2) AS GLL_ID,
                    :3 AS ATTACHMENT_ID
                FROM DUAL
            ) SRC ON (SRC.ATTACHMENT_ID = AG.ATTACHMENT_ID AND SRC.GLL_ID = AG.' || p_relation_column || ')
            WHEN MATCHED THEN
                UPDATE SET AG.UPDATED_AT = CURRENT_TIMESTAMP
            WHEN NOT MATCHED THEN
                INSERT (ID, ATTACHMENT_ID, ' || p_relation_column || ', CREATED_AT, UPDATED_AT)
                VALUES (:4, SRC.ATTACHMENT_ID, SRC.GLL_ID, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)';
        EXECUTE IMMEDIATE v_sql USING p_gll_objectid, p_gll_objectid, p_target_id, p_relation_id;
    END process_attachment;
BEGIN
    IF scanned_gll_url != 'null' THEN
        process_attachment(scanned_gll_url, 'SCANNED_LICENSES_GLL_ID');
    END IF;

    IF scanned_sc_url != 'null' THEN
        process_attachment(scanned_sc_url, 'SCANNED_SQUATTER_CONTROL_INFORMATIONS_GLL_ID');
    END IF;

    IF scanned_sir_url != 'null' THEN
        process_attachment(scanned_sir_url, 'SITE_INSPECTION_REPORTS_GLL_ID');
    END IF;

    IF scanned_rl_url != 'null' THEN
        process_attachment(scanned_rl_url, 'SQUATTER_OCCUPANTS_LETTERS_GLL_ID');
    END IF;

    IF scanned_gllfeeaccessment_url != 'null' THEN
        process_attachment(scanned_gllfeeaccessment_url, 'SCANNED_GLL_FEE_ASSESSMENT_SHEETS_GLL_ID');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error in MIGRATE_SINGLE_ATTACHMENT: ' || 'ID: ' || p_id || ', FULL_FILENAME: ' || coalesce(scanned_gll_url, scanned_sc_url, scanned_sir_url, scanned_rl_url, scanned_gllfeeaccessment_url) || ', Error: ' || sqlerrm);
        log_migration('ATTACHMENTS', p_gll_objectid, NULL, 'ERROR', 'GLL_OBJECTID: ' || p_gll_objectid || ', ATTACHMENT_ID: ' || p_id || ', P_RELATION_ID: ' || p_relation_id || ', Error: ' || sqlerrm);
END migrate_single_attachment;