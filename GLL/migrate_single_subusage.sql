-- Procedure to migrate a single sub-usage record
CREATE OR REPLACE PROCEDURE migrate_single_subusage (
    p_objectid IN NUMBER
) AS
    v_count    NUMBER;
    v_new_guid RAW(16) := sys_guid();
BEGIN
 
    -- Check if the subusage code exists
    SELECT
        count(*) INTO v_count
    FROM
        sde_gll.gll_sub_purposes
    WHERE
        objectid = p_objectid;
    IF v_count = 0 THEN
        raise_application_error ( -20004, 'Subusage code ' || p_objectid || ' not found' );
    END IF;
 

    -- Merge the sub-usage record into the new table
    MERGE INTO gll_sub_usage t USING (
        SELECT
            gsp."PURPOSE_CODE"     AS usage_code
          , gsp."SUB_PURPOSE_CODE" AS sub_usage_code
          , gsp."DESCRIPTION"      AS description
          , objectid
        FROM
            sde_gll.gll_sub_purposes gsp
        WHERE
            objectid = p_objectid
    ) s ON (t.objectid_d = s.objectid) WHEN MATCHED THEN UPDATE SET t.usage_code_d = s.usage_code, t.description = s.description, t.sub_usage_code = s.sub_usage_code, t.created_at = current_date, t.updated_at = current_date WHEN NOT MATCHED THEN INSERT ( id, usage_code_d, sub_usage_code, description, objectid_d, created_at, updated_at ) VALUES ( v_new_guid, s.usage_code, s.sub_usage_code, s.description, s.objectid, current_date, current_date );
 
    -- Log the successful migration
    log_migration ( 'GLL_SUB_USAGE', p_objectid, v_new_guid, 'SUCCESS' );
EXCEPTION
    WHEN OTHERS THEN
        log_migration ( 'GLL_SUB_USAGE', p_objectid, NULL, 'ERROR', 'Error migrating subusage code ' || p_objectid || ': ' || sqlerrm );
        raise;
END migrate_single_subusage;