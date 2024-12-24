-- Main Attachments migration procedure
CREATE OR REPLACE PROCEDURE migrate_attachments AS
    v_source_id       NUMBER;
    v_target_id       RAW(16);
    v_batch_size      NUMBER := 5000;
    v_total_processed NUMBER := 0;
    v_batch_count     NUMBER := 0;
    v_max_id          NUMBER;
    v_min_id          NUMBER;
BEGIN
 
    -- Get the range of IDs to process
    SELECT
        min(objectid)
      , max(objectid) INTO v_min_id
      , v_max_id
    FROM
        sde_gll.governmentlandlicence;
    WHILE v_min_id <= v_max_id LOOP
        v_batch_count := v_batch_count + 1;
        FOR src IN (
            SELECT
                g.objectid                             AS gll_objectid
              , coalesce(g.filepath, n'null')           AS scanned_gll_url
              , coalesce(g.scpath, n'null')             AS scanned_sc_url
              , coalesce(g.sirpath, n'null')            AS scanned_sir_url
              , coalesce(g.rlpath, n'null')             AS scanned_rl_url
              , coalesce(g.licencefeefilepath, n'null') AS scanned_gllfeeaccess_url
              , 0 AS file_size
              , g.creationdate                         AS created_at
              , g.lastamendmentdate                    AS updated_at
            FROM
                sde_gll.governmentlandlicence g
            WHERE
                g.objectid BETWEEN v_min_id AND v_min_id + v_batch_size - 1
        ) LOOP
            BEGIN
                v_source_id := src.gll_objectid;
 
                -- CHECK_ATTACHMENT_DATA_QUALITY(SRC.URL, SRC.FULL_FILENAME, SRC.DISPLAYNAME, SRC.FILE_SIZE, SRC.CREATED_AT, SRC.UPDATED_AT);
                IF src.scanned_gll_url != 'null' OR src.scanned_sc_url != 'null' OR src.scanned_sir_url != 'null' OR src.scanned_rl_url != 'null' OR src.scanned_gllfeeaccess_url != 'null' THEN
                    migrate_single_attachment( src.gll_objectid, src.scanned_gll_url, src.scanned_sc_url, src.scanned_sir_url, src.scanned_rl_url, src.scanned_gllfeeaccess_url, src.file_size, src.created_at, src.updated_at, v_target_id );
                    log_migration( 'ATTACHMENTS', v_source_id, v_target_id, 'SUCCESS' );
                    v_total_processed := v_total_processed + 1;
                END IF;
            EXCEPTION
                WHEN OTHERS THEN
                    dbms_output.put_line('Error processing record with ID: ' || src.gll_objectid || ', scanned_gll_url: ' || src.scanned_gll_url || ', FullFilename: ' || src.scanned_gll_url ||src.scanned_sc_url ||src.scanned_sir_url||src.scanned_rl_url|| '. Error: ' || sqlerrm);
                    log_migration('ATTACHMENTS', v_source_id, NULL, 'ERROR', 'ID: ' || src.gll_objectid || ', scanned_gll_url: ' || src.scanned_gll_url || ', Error: ' || sqlerrm);
            END;
        END LOOP;

        COMMIT;
        dbms_output.put_line('ATTACHMENTS' || ' batch processed. Current ID: ' || v_min_id);
        v_min_id := v_min_id + v_batch_size;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error in attachment migration: ' || sqlerrm);
END migrate_attachments;