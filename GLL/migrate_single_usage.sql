-- Procedure to migrate a single usage record
CREATE OR REPLACE PROCEDURE migrate_single_usage (
    p_objectid IN NUMBER
) AS
    v_count NUMBER;
BEGIN
 
    -- Check if the usage code exists
    SELECT
        count(*) INTO v_count
    FROM
        sde_gll.gll_purposes
    WHERE
        objectid = p_objectid;
    IF v_count = 0 THEN
        raise_application_error ( -20005, 'Usage code ' || p_objectid || ' not found' );
    END IF;
 

    -- Merge the usage record into the new table
    MERGE INTO gll_usages t USING (
        SELECT
            s."PURPOSE_CODE" AS usage_code
          , s.objectid       AS objectid_d
          , s."DESCRIPTION"  AS description
        FROM
            sde_gll.gll_purposes s
        WHERE
            s.objectid = p_objectid
    ) s ON (t.usage_code = s.usage_code) WHEN MATCHED THEN UPDATE SET t.objectid_d = s.objectid_d, t.description = s.description, t.updated_at = current_date WHEN NOT MATCHED THEN INSERT (id, usage_code, objectid_d, description, created_at, updated_at) VALUES ( sys_guid(), s.usage_code, s.objectid_d, s.description, current_date, current_date );
 
    -- update sub-usage foreign key
    UPDATE gll_sub_usage gsu
    SET
        gll_usage_id = (
            SELECT
                id
            FROM
                gll_usages           gu
            WHERE
                gu.usage_code = gsu.usage_code_d
        )
    WHERE
        gsu.usage_code_d = (
            SELECT
                gu2.usage_code
            FROM
                gll_usages gu2
            WHERE
                gu2.objectid_d = p_objectid
        );
 
    -- Log the successful migration
    log_migration ('GLL_USAGES', p_objectid, NULL, 'SUCCESS');
EXCEPTION
    WHEN OTHERS THEN
        log_migration ( 'GLL_USAGES', p_objectid, NULL, 'ERROR', 'Error migrating OBJECTID ' || p_objectid || ': ' || sqlerrm );
        raise;
END migrate_single_usage;