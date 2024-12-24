----------------------- Procedure to migrate a single GllStructure record -----------------------
CREATE OR REPLACE PROCEDURE migrate_single_gllstructure 
(
    p_source_id IN NUMBER
  , p_target_id OUT RAW
) AS
    v_fee_review_id RAW(16);
    v_gll_id        RAW(16);
    v_tmp           RAW(16);
BEGIN
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
          , globalid                                               AS globalid_d
          , nvl(creationdate, current_timestamp)                   AS created_at --not nullable
          , nvl(lastamendmentdate, current_timestamp)              AS updated_at --not nullable
        FROM
            sde_gll.glluserinfo
        WHERE
            objectid = p_source_id
    ) src ON (gse.objectid_d = src.objectid_d) WHEN MATCHED THEN UPDATE SET 
    
	    gse.gll_id = src.gll_id
	    , gse.structure_id = src.structure_id
	    , gse.description = src.description
	    , gse.LENGTH = src.length
	    , gse.width = src.width
	    , gse.height = src.height
	    , gse.area = src.area
	    , gse.rate_metric = src.ratemetric
	    , gse.calc_fee = src.calcfee
	    , gse.modifiedby_d = src.modifiedby_d
	    , gse.glluserinfoid_d = src.glluserinfoid_d
	    , gse.governmentlandlicenceid_d = src.governmentlandlicenceid_d
	    , gse.tsunit_d = src.tsunit_d
	    , gse.length_unit = src.lengthunit
	    , gse.height_unit_d = src.heightunit_d
	    , gse.width_unit = src.widthunit
	    , gse.area_unit = src.areaunit
	    , gse.area_metric = src.areametric
	    , gse.percent_area = src.percentarea
	    , gse.purposecode_d = src.purposecode_d
	    , gse.subpurposecode_d = src.subpurposecode_d
	    , gse.struct_type = src.structtype
	    , gse.ratevalue_d = src.ratevalue_d
	    , gse.ratemetric_d = src.ratemetric_d
	    , gse.calcfee_d = src.calcfee_d
	    , gse.globalid_d = src.globalid_d
	 -- Foreign keys set to NULL with comments
	    , gse.fee_review_id = coalesce ((
						        SELECT
						            f.id                                                   AS id
						        FROM
						            fee_reviews         f
						        WHERE
						            f.rate_type = src.ratetype_d
						            AND f.rate_area = src.ratearea_d
						            AND f.rate_code = src.ratecode_d
						    ), hextoraw('00000000000000000000000000000000')) -- FEE_REVIEW_ID, not nullable
	    , gse.gll_sub_usage_id = CASE
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
						        END -- GLL_SUB_USAGE_ID: Should be mapped from GllSubUsageEntity
	    , gse.gll_usage_id = CASE
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
					                        objectid_d = src.subpurposecode_d
					                )
					        END -- GLL_SUB_USAGE_ID: Should be mapped from GllSubUsageEntity
	 -- , CREATOR_ID, UPDATETOR_ID
	    , gse.created_at = src.created_at
	    , gse.updated_at = src.updated_at
    
    WHEN NOT MATCHED THEN INSERT ( id, gll_id, objectid_d, structure_id, description, length, width, height, area, rate_metric, calc_fee, modifiedby_d, glluserinfoid_d, governmentlandlicenceid_d, tsunit_d, length_unit, height_unit_d, width_unit, area_unit, area_metric, percent_area, purposecode_d, subpurposecode_d, struct_type, ratevalue_d, ratemetric_d, calcfee_d, globalid_d,
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
    coalesce ((
        SELECT
            f.id                                                   AS id
        FROM
            fee_reviews         f
        WHERE
            f.rate_type = src.ratetype_d
            AND f.rate_area = src.ratearea_d
            AND f.rate_code = src.ratecode_d
    ), hextoraw('00000000000000000000000000000000')), -- FEE_REVIEW_ID, not nullable
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