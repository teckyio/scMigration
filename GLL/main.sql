-- Main migration procedure
CREATE OR REPLACE PROCEDURE perform_migration
AS
    v_start_time       timestamp;
    v_end_time         timestamp;
    v_total_records    NUMBER := 0;
    v_migrated_records NUMBER := 0;
    v_failed_records   NUMBER := 0;
    v_batch_size       NUMBER := 1000;
    v_id               NUMBER := 0;
    v_table_exists     NUMBER := 0;

    PROCEDURE migrate_entity (
        p_entity_name IN VARCHAR2
      , p_source_table IN VARCHAR2
      , p_migrate_procedure IN VARCHAR2
    ) AS
        v_sql             VARCHAR2(4000);
        v_entity_total    NUMBER := 0;
        v_entity_migrated NUMBER := 0;
        v_entity_failed   NUMBER := 0;
        v_min_id          NUMBER;
        v_max_id          NUMBER;
        v_current_id      NUMBER;
        v_target_id       RAW(16);
    BEGIN
 
        -- Checking if OBJECTID table exists...
        SELECT
            count(*) INTO v_table_exists
        FROM
            all_tab_columns
        WHERE
            table_name = p_source_table
            AND owner = 'SDE_GLL'
            AND column_name = 'OBJECTID';
        IF v_table_exists = 1 THEN
 
            -- Get the range of OBJECTIDs to process
            EXECUTE IMMEDIATE 'SELECT MIN(OBJECTID), MAX(OBJECTID) FROM SDE_GLL.' || p_source_table INTO v_min_id, v_max_id;
            v_current_id := v_min_id;
            WHILE v_current_id <= v_max_id LOOP
                v_sql := 'BEGIN
                            FOR REC IN (SELECT OBJECTID FROM SDE_GLL.' || p_source_table || ' WHERE OBJECTID BETWEEN :start_id AND :end_id)
                            LOOP
                                BEGIN
                                    ' || p_migrate_procedure || '(REC.OBJECTID, :target_id);
                                EXCEPTION
                                    WHEN OTHERS THEN
                                        LOG_MIGRATION(''' || p_entity_name || ''', REC.OBJECTID, NULL, ''ERROR'', SQLERRM);
                                END;
                            END LOOP;
                          END;';
                EXECUTE IMMEDIATE v_sql USING v_current_id, v_current_id + v_batch_size - 1, OUT v_target_id;
                v_current_id := v_current_id + v_batch_size;
                COMMIT; -- Commit after each batch
                dbms_output.put_line(p_entity_name || ' batch processed. Current ID: ' || v_current_id);
            END LOOP;
        ELSE
 
            -- Get the range of IDs to process
            EXECUTE IMMEDIATE 'SELECT MIN(ID), MAX(ID) FROM SDE_GLL.' || p_source_table INTO v_min_id, v_max_id;
            v_current_id := v_min_id;
            WHILE v_current_id <= v_max_id LOOP
                v_sql := 'BEGIN
                            FOR REC IN (SELECT ID FROM SDE_GLL.' || p_source_table || ' WHERE ID BETWEEN :start_id AND :end_id)
                            LOOP
                                BEGIN
                                    ' || p_migrate_procedure || '(REC.ID, :target_id);
                                EXCEPTION
                                    WHEN OTHERS THEN
                                        LOG_MIGRATION(''' || p_entity_name || ''', REC.ID, NULL, ''ERROR'', SQLERRM);
                                END;
                            END LOOP;
                          END;';
                EXECUTE IMMEDIATE v_sql USING v_current_id, v_current_id + v_batch_size - 1, OUT v_target_id;
                v_current_id := v_current_id + v_batch_size;
                COMMIT; -- Commit after each batch
                dbms_output.put_line(p_entity_name || ' batch processed. Current ID: ' || v_current_id);
            END LOOP;
        END IF;
    END migrate_entity;
BEGIN
    dbms_output.put_line('Starting migration process');
    v_start_time := current_timestamp;
 
    -- Perform data quality checks
    -- CHECK_GLL_DATA_QUALITY();
    -- CHECK_GLLSTRUCTURE_DATA_QUALITY();
    -- CHECK_FEEREVIEW_DATA_QUALITY();
    -- Migrate GLL records and related entities
   ---
    migrate_feereviews();
    migrate_usages();
    migrate_entity('GLLS', 'GOVERNMENTLANDLICENCE', 'MIGRATE_SINGLE_GLL');
    migrate_entity('GLL_STRUCTURES', 'GLLUSERINFO', 'MIGRATE_SINGLE_GLLSTRUCTURE');
    migrate_attachments();
    COMMIT;
    v_end_time := current_timestamp;
    generate_report(v_start_time, v_end_time);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error during migration: ' || sqlerrm);
        raise;
END perform_migration;