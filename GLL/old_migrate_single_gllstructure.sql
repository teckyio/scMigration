----------------------- Procedure to migrate a single GllStructure record -----------------------
CREATE OR REPLACE PROCEDURE gll.migrate_single_gllstructure (
    p_source_id IN NUMBER
  , p_target_id OUT RAW
) AS
    v_fee_review_id RAW(16);
    v_gll_id        RAW(16);
    v_tmp           RAW(16);

    PROCEDURE add_single_feereview (
        p_userinfo_objectid IN NUMBER
      , p_fee_review_id OUT RAW
    ) AS
        v_rate_type               VARCHAR2(2000);
        v_rate_area               VARCHAR2(2000);
        v_rate_code               VARCHAR2(2000);
        v_ratemetric              NUMBER; -- = f.RATE_FACTOR * f.RATE_VALUE
        v_new_fee_review_id       RAW(16) := sys_guid();
        v_new_fee_review_objectid NUMBER;
        v_old_fee_review_objectid NUMBER;
    BEGIN
        MERGE INTO fee_reviews fre USING (
            SELECT
                null                                                   AS startat
              , null                                                   AS endat
              , 1 AS isactive
              , null                                                   AS structuretype
              , coalesce(sc.rate_type, sg.ratetype)                    AS ratetype
              , coalesce(sc.rate_area, sg.ratearea)                    AS ratearea
              , coalesce(sc.rate_code, sg.ratecode)                    AS ratecode
              , sc.rate_description                                    AS ratedescription
              , sc.rate_nature                                         AS ratenature
              , sc.rate_per_unit                                       AS rateperunit
              , sc.rate_factor                                         AS ratefactor
              , coalesce(sc.rate_value, sg.ratevalue)                  AS ratevalue
              , sc.rate_remarks                                        AS rateremarks
              , sg.objectid                                            AS objectid_d
              , -- use gll_structure.objectid_d AS NEW fee_reviews.objectid_d
                sg.structtype                                          AS structtype
            FROM
                sde.conversion_rates sc
                RIGHT JOIN sde.glluserinfo sg
                ON sc.rate_area = sg.ratearea
                AND sc.rate_type = sg.ratetype
                AND sc.rate_code = sg.ratecode
                AND sc.rate_value = sg.ratevalue
            WHERE
                sg.objectid = p_userinfo_objectid
        ) src ON (fre.objectid_d = src.objectid_d) WHEN MATCHED THEN UPDATE SET fre.updated_at = current_timestamp WHEN NOT MATCHED THEN INSERT ( id, start_at, end_at, is_active, structure_type, rate_type, rate_area, rate_code, rate_description, rate_value, objectid_d,
 -- Fields not present in source data, set to NULL or default values
        rate_nature, rate_per_unit, rate_factor, rate_remarks, is_deleted, created_at, updated_at ) VALUES ( hextoraw(rawtohex(v_new_fee_review_id)), src.startat, src.endat, src.isactive, src.structuretype, src.ratetype, src.ratearea, src.ratecode, src.ratedescription, src.ratevalue, src.objectid_d,
 -- Fields not present in source data, set to NULL or default values
        src.ratenature, -- RATE_NATURE
        src.rateperunit, -- RATE_PER_UNIT
        src.ratefactor, -- RATE_FACTOR
        src.rateremarks, -- RATE_REMARKS
        0, -- IS_DELETED (default to false)
        current_timestamp, -- CREATED_AT
        current_timestamp -- UPDATED_AT
        );
 
        -- Return the FEE_REVIEW_ID
        SELECT
            id INTO p_fee_review_id
        FROM
            fee_reviews fr
        WHERE
            objectid_d = p_source_id;
        gll.log_migration('FEE_REVIEWS (GLLUSERINFO)', p_userinfo_objectid, p_fee_review_id, 'SUCCESS');
    EXCEPTION
        WHEN OTHERS THEN
            log_migration('FEE_REVIEWS (GLLUSERINFO)', p_userinfo_objectid, NULL, 'FAILED', sqlerrm || 'V_NEW_FEE_REVIEW_OBJECTID:' || v_new_fee_review_objectid || ',P_FEE_REVIEW_ID:' || p_fee_review_id);
            raise;
    END add_single_feereview;
BEGIN
 
    -- SELECT newly added ID from FREE_REVIEWS for GLL_STRUCTURES
    add_single_feereview(p_source_id, v_fee_review_id);
    MERGE INTO gll_structures gse USING (
        SELECT
            objectid                                               AS objectid_d
          , v_gll_id                                               AS gll_id
          , structureid                                            AS structure_id
          , glluser                                                AS description
          , glllength                                              AS length
          , gllwidth                                               AS width
          , gllheight                                              AS height
          , gllarea                                                AS area
          , ratemetric                                             AS ratemetric
          , calcfee                                                AS calcfee
          , modifiedby                                             AS modifiedby_d
          , glluserinfoid                                          AS glluserinfoid_d
          , governmentlandlicenceid                                AS governmentlandlicenceid_d
          , null_convertor(tsunit)                                 AS tsunit_d
          , null_convertor(lengthunit)                             AS lengthunit
          , null_convertor(heightunit)                             AS heightunit_d
          , null_convertor(widthunit)                              AS widthunit
          , null_convertor(areaunit)                               AS areaunit
          , areametric                                             AS areametric
          , percarea                                               AS percentarea
          , purposecode                                            AS purposecode_d
          , subpurposecode                                         AS subpurposecode_d
          , structtype                                             AS structtype
          , ratearea                                               AS ratearea_d
          , ratetype                                               AS ratetype_d
          , ratevalue                                              AS ratevalue_d
          , ratecode                                               AS ratecode_d
          , ratemetric                                             AS ratemetric_d
          , calcfee                                                AS calcfee_d
          , hextoraw(regexp_replace(globalid, '[^A-Fa-f0-9]', '')) AS globalid_d
          , nvl(creationdate, current_timestamp)                   AS created_at --not nullable
          , nvl(lastamendmentdate, current_timestamp)              AS updated_at --not nullable
        FROM
            sde.glluserinfo
        WHERE
            objectid = p_source_id
    ) src ON (gse.objectid_d = src.objectid_d) WHEN MATCHED THEN UPDATE SET gse.updated_at = src.updated_at WHEN NOT MATCHED THEN INSERT ( id, gll_id, objectid_d, structure_id, description, length, width, height, area, rate_metric, calc_fee, modifiedby_d, glluserinfoid_d, governmentlandlicenceid_d, tsunit_d, length_unit, height_unit_d, width_unit, area_unit, area_metric, percent_area, purposecode_d, subpurposecode_d, struct_type, ratevalue_d, ratemetric_d, calcfee_d, globalid_d,
 -- Foreign keys set to NULL with comments
    fee_review_id, gll_sub_usage_id, gll_usage_id
 -- , CREATOR_ID, UPDATETOR_ID
    , created_at, updated_at ) VALUES ( sys_guid(), (
        SELECT
            g.id
        FROM
            glls g
        WHERE
            g.governmentlandlicenceid_d = src.governmentlandlicenceid_d
    ), -- GLL_ID: Will be updated after GLLS merged, not nullable
    src.objectid_d, src.structure_id, src.description, src.length, src.width, src.height, src.area, src.ratemetric, src.calcfee, src.modifiedby_d, src.glluserinfoid_d, src.governmentlandlicenceid_d, src.tsunit_d, src.lengthunit, src.heightunit_d, src.widthunit, src.areaunit, src.areametric, src.percentarea, src.purposecode_d, src.subpurposecode_d, src.structtype, src.ratevalue_d, src.ratemetric_d, src.calcfee_d, src.globalid_d,
 -- Foreign keys set to NULL with comments
    v_fee_review_id, -- FEE_REVIEW_ID, not nullable
        CASE
            WHEN src.subpurposecode_d IS NULL
            THEN
                NULL
            ELSE
                (
                    SELECT
                        id
                    FROM
                        gll_sub_usage
                    WHERE
                        objectid_d = src.subpurposecode_d
                )
        END, -- GLL_SUB_USAGE_ID: Should be mapped from GllSubUsageEntity
        CASE
            WHEN src.purposecode_d IS NULL
            THEN
                NULL
            ELSE
                (
                    SELECT
                        id
                    FROM
                        gll_usages
                    WHERE
                        objectid_d = src.purposecode_d
                )
        END, -- GLL_USAGE_ID: Should be mapped from GllUsageEntity
    -- NULL, -- CREATOR_ID: Should be mapped from PostEntity
    -- NULL, -- UPDATETOR_ID: Should be mapped from PostEntity
    src.created_at, src.updated_at );
    SELECT
        id INTO p_target_id
    FROM
        gll_structures
    WHERE
        objectid_d = p_source_id;
    log_migration('GLL_STRUCTURES', p_source_id, p_target_id, 'SUCCESS');
EXCEPTION
    WHEN OTHERS THEN
        log_migration('GLL_STRUCTURES', p_source_id, NULL, 'FAILED', 'V_FEE_REVIEW_ID: ' || v_fee_review_id || ', ' ||sqlerrm);
        raise;
END migrate_single_gllstructure;