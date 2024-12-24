----------------------- Procedure to perform data quality checks on GLLUSAGE -----------------------
CREATE OR REPLACE PROCEDURE gll.check_gllusage_data_quality AS
    v_error_count NUMBER := 0;
BEGIN
 
    -- Check for duplicate SUB_USAGE_CODE in SOURCE_SUB_USAGE
    SELECT
        count(*) INTO v_error_count
    FROM
        (
            SELECT
                gsp.objectid
            FROM
                sde_gll.gll_sub_purposes gsp
            GROUP BY
                gsp.objectid
              , gsp."PURPOSE_CODE" || gsp."SUB_PURPOSE_CODE" || gsp."DESCRIPTION"
            HAVING
                count(1) > 1
        );
    IF v_error_count > 0 THEN
        raise_application_error ( -20001, 'Data quality check failed: ' || v_error_count || 'Duplicate SUB_USAGE_CODE found in SOURCE_SUB_USAGE' );
    END IF;
 

    -- Check for duplicate USAGE_CODE in SOURCE_USAGE
    SELECT
        count(*) INTO v_error_count
    FROM
        (
            SELECT
                gp.objectid
            FROM
                sde_gll.gll_purposes gp
            GROUP BY
                gp."PURPOSE_CODE" || gp."DESCRIPTION"
              , gp.objectid
            HAVING
                count(1) > 1
        );
    IF v_error_count > 0 THEN
        raise_application_error ( -20002, 'Data quality check failed: ' || v_error_count || 'Duplicate USAGE_CODE found in SOURCE_USAGE' );
    END IF;
 

    -- Check for orphaned SUB_USAGE records
    SELECT
        count(1) INTO v_error_count
    FROM
        sde_gll.gll_sub_purposes gsp
        LEFT JOIN sde_gll.gll_purposes gp
        ON gsp."PURPOSE_CODE" = gp."PURPOSE_CODE"
    WHERE
        gp."PURPOSE_CODE" IS NULL;
    IF v_error_count > 0 THEN
        raise_application_error (-20003, 'Data quality check failed: ' || v_error_count || 'Orphaned SUB_USAGE records found');
    END IF;
 

    -- Check for required fields in SOURCE_GLL_USAGE
    SELECT
        count(*) INTO v_error_count
    FROM
        sde_gll.gll_purposes
    WHERE
        purpose_code IS NULL
        OR description IS NULL;
    IF v_error_count > 0 THEN
        raise_application_error ( -20004, 'Data quality check failed: ' || v_error_count || ' records in SOURCE_GLL_USAGE have missing required fields.' );
    END IF;
END check_gllusage_data_quality;