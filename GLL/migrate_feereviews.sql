CREATE OR REPLACE PROCEDURE migrate_feereviews 
AS
    v_max_id      NUMBER;
    v_min_id      NUMBER;
    v_batch_size  NUMBER := 1000;
    v_batch_count NUMBER := 0;
    v_source_id   NUMBER;
    v_target_id   RAW(16);

    PROCEDURE migrate_single_feereview(
        p_objectid IN NUMBER
      , p_targetid IN RAW
    ) IS
    BEGIN
        MERGE INTO fee_reviews f USING(
            SELECT
                null                                         AS start_at
              , null                                         AS end_at
              , 0 											 AS is_deleted
              , 1 											 AS is_active
              , null                                         AS structure_type
              , SQ.rate_type                                 AS rate_type
              , SQ.rate_area                                 AS rate_area
              , SQ.rate_code                                 AS rate_code
              , SQ.rate_description                          AS rate_description
              , SQ.rate_nature                               AS rate_nature
              , SQ.rate_per_unit                             AS rate_per_unit
              , SQ.rate_factor                               AS rate_factor
              , SQ.rate_value                                AS rate_value
              , SQ.rate_remarks                              AS rate_remarks
              , SQ.id                                        AS objectid
              , current_timestamp                            AS created_at
              , current_timestamp                            AS updated_at
            FROM
                sde_gll.conversion_rates sc
            WHERE
                SQ.id = p_objectid
        ) src ON ( src.objectid = f.objectid_d ) WHEN MATCHED THEN UPDATE SET 
	       	f.rate_type = src.rate_type
	       	, f.rate_area = src.rate_area
	       	, f.rate_code = src.rate_code
	       	, f.rate_description = src.rate_description
	       	, f.rate_nature = src.rate_nature
	       	, f.rate_per_unit = src.rate_per_unit
	       	, f.rate_factor = src.rate_factor
	       	, f.rate_value = src.rate_value
	       	, f.rate_remarks = src.rate_remarks
	       	, f.start_at = src.start_at
	       	, f.end_at = src.end_at
	       	, f.is_deleted = src.is_deleted
	       	, f.is_active = src.is_active
	       	, f.created_at = src.created_at
	       	, f.updated_at = src.updated_at
	       	, f.structure_type = src.structure_type
      WHEN NOT MATCHED THEN INSERT ( id, rate_type, rate_area, rate_code, rate_description, rate_nature, rate_per_unit, rate_factor, rate_value, rate_remarks, start_at, end_at, is_deleted, is_active, created_at, updated_at, structure_type, objectid_d) VALUES ( p_targetid, src.rate_type, src.rate_area, src.rate_code, src.rate_description, src.rate_nature, src.rate_per_unit, src.rate_factor, src.rate_value, src.rate_remarks, src.start_at, src.end_at, src.is_deleted, src.is_active, src.created_at, src.updated_at, src.structure_type, src.objectid);
        dbms_output.put_line('single_feereview');
    END migrate_single_feereview;
BEGIN
    dbms_output.put_line('migrate feereview');
    MERGE INTO fee_reviews f USING(
        SELECT
            -1 AS objectid_d
          , 'Unable to map from the original system'     AS rate_description
          , hextoraw('00000000000000000000000000000000') AS id
          , current_timestamp                            AS created_at
          , current_timestamp                            AS updated_at
        FROM
            dual
    ) src ON (src.objectid_d = f.objectid_d) WHEN MATCHED THEN UPDATE SET f.updated_at = src.updated_at WHEN NOT MATCHED THEN INSERT (id, rate_description, objectid_d, created_at, updated_at) VALUES (src.id, src.rate_description, src.objectid_d, src.created_at, src.updated_at);
    SELECT
        min(id)
      , max(id) INTO v_min_id
      , v_max_id
    FROM
        sde_gll.conversion_rates;
    WHILE v_min_id <= v_max_id LOOP
        v_batch_count := v_batch_count + 1;
        FOR src IN (
            SELECT
                id
            FROM
                sde_gll.conversion_rates s
            WHERE
                s.id BETWEEN v_min_id AND v_min_id + v_batch_size - 1
        ) LOOP
            BEGIN
                v_source_id := src.id;
                IF v_source_id IS NOT NULL THEN
                    v_target_id := sys_guid();
                    migrate_single_feereview(v_source_id, v_target_id);
                    log_migration('FEE_REVIEWS', v_source_id, v_target_id, 'SUCCESS');
                END IF;
            EXCEPTION
                WHEN OTHERS THEN
                    log_migration('FEE_REVIEWS (SINGLE)', v_source_id, NULL, 'FAILED', sqlerrm);
            END;

            v_min_id := v_min_id + v_batch_size;
        END LOOP;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error on conversion rate migration: ' || sqlerrm);
        log_migration('FEE_REVIEWS', v_source_id, NULL, 'FAILED', sqlerrm);
END migrate_feereviews;