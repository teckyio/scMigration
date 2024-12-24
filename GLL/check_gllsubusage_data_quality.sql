----------------------- Procedure to perform data quality checks on GLLSUBUSAGE -----------------------
CREATE OR REPLACE PROCEDURE gll.check_gllsubusage_data_quality AS
    v_invalid_count NUMBER;
BEGIN
 
    -- Check for required fields in SOURCE_GLL_SUBUSAGE
    SELECT
        count(*) INTO v_invalid_count
    FROM
        sde_gll.gll_sub_purposes
    WHERE
        sub_purpose_code IS NULL
        OR description IS NULL
        OR purpose_code IS NULL
        OR objectid IS NULL;
    IF v_invalid_count > 0 THEN
        raise_application_error ( -20015, 'Data quality check failed: ' || v_invalid_count || ' records in SOURCE_GLL_SUBUSAGE have missing required fields.' );
    END IF;
 

    -- Check for duplicate subusage codes within the same usage
    SELECT
        count(*) INTO v_invalid_count
    FROM
        (
            SELECT
                objectid
              , sub_purpose_code
            FROM
                sde_gll.gll_sub_purposes
            GROUP BY
                objectid
              , sub_purpose_code
            HAVING
                count(*) > 1
        );
    IF v_invalid_count > 0 THEN
        raise_application_error ( -20016, 'Data quality check failed: ' || v_invalid_count || ' duplicate SUBUSAGECODE found within the same USAGE_ID in SOURCE_GLL_SUBUSAGE.' );
    END IF;
 

    -- Check for orphaned subusages (no corresponding usage)
    SELECT
        count(*) INTO v_invalid_count
    FROM
        sde_gll.gll_sub_purposes sgs
    WHERE
        NOT EXISTS (
            SELECT
                1
            FROM
                sde_gll.gll_purposes     sgu
            WHERE
                sgu.purpose_code = sgs.purpose_code
        );
    IF v_invalid_count > 0 THEN
        raise_application_error ( -20017, 'Data quality check failed: ' || v_invalid_count || ' orphaned records found in SOURCE_GLL_SUBUSAGE.' );
    END IF;

    dbms_output.put_line ( 'GLLSUBUSAGE data quality check passed successfully.' );
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line ( 'Error in GLLSUBUSAGE data quality check: ' || sqlerrm );
        raise;
END check_gllsubusage_data_quality;