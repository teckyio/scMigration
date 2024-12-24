-- Main migration procedure
CREATE OR REPLACE PROCEDURE migrate_usages AS
    CURSOR c_sub_objectid IS
    SELECT
        objectid
    FROM
        sde_gll.gll_sub_purposes;
    CURSOR c_objectid IS
    SELECT
        objectid
    FROM
        sde_gll.gll_purposes;
    v_error_count NUMBER := 0;
BEGIN
 
    -- Start transaction
    SAVEPOINT start_migration;
 
    -- Perform data quality checks
    --    CHECK_GLLUSAGE_DATA_QUALITY ();
    --    CHECK_GLLSUBUSAGE_DATA_QUALITY ();
    -- Migrate sub-usage records
    FOR subusage_rec IN c_sub_objectid LOOP
        BEGIN
            migrate_single_subusage (subusage_rec.objectid);
        EXCEPTION
            WHEN OTHERS THEN
                v_error_count := v_error_count + 1;
                dbms_output.put_line ( 'Error migrating subusage OBJECTID ' || subusage_rec.objectid || ': ' || sqlerrm );
        END;
    END LOOP;
 

    -- Migrate usage records
    FOR usage_rec IN c_objectid LOOP
        BEGIN
            migrate_single_usage (usage_rec.objectid);
        EXCEPTION
            WHEN OTHERS THEN
                v_error_count := v_error_count + 1;
                dbms_output.put_line ( 'Error migrating usage OBJECTID ' || usage_rec.objectid || ': ' || sqlerrm );
        END;
    END LOOP;

    COMMIT;
    IF v_error_count = 0 THEN
        dbms_output.put_line ('Migration completed successfully.');
    ELSE
        dbms_output.put_line ( 'Migration completed with ' || v_error_count || ' errors.' );
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO start_migration;
        dbms_output.put_line ('Critical error during migration: ' || sqlerrm);
        raise;
END migrate_usages;