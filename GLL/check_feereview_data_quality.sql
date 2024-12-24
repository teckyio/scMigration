----------------------- Procedure to perform data quality checks on FEEREVIEW -----------------------
CREATE OR REPLACE PROCEDURE gll.check_feereview_data_quality AS
    v_invalid_count NUMBER;
BEGIN -- Check for required fields in SDE_GLL.CONVERSION_RATES
    SELECT
        count(*) INTO v_invalid_count
    FROM
        sde.conversion_rates
    WHERE
        rate_type IS NULL
        OR rate_area IS NULL
        OR rate_code IS NULL
        OR rate_description IS NULL
        OR rate_value IS NULL;
 
    --        [NOTE]: 4 rows of data missing RATE_CODE and RATE_VALUE
    IF v_invalid_count > 0 THEN
        raise_application_error ( -20007, 'Data quality check failed: ' || v_invalid_count || ' records in SDE_GLL.CONVERSION_RATES have missing required fields.' );
    END IF;
 

    -- Check for negative rate values
    SELECT
        count(*) INTO v_invalid_count
    FROM
        sde.conversion_rates
    WHERE
        rate_value < 0;
    IF v_invalid_count > 0 THEN
        raise_application_error ( -20009, 'Data quality check failed: ' || v_invalid_count || ' records in SDE_GLL.CONVERSION_RATES have negative rate values.' );
    END IF;

    dbms_output.put_line ( 'FEE_REVIEWS data quality check passed successfully.' );
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line ( 'Error in FEEREVIEW data quality check: ' || sqlerrm );
        raise;
END check_feereview_data_quality;