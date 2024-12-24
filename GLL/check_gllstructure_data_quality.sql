----------------------- Procedure to perform data quality checks on GLLSTRUCTURE -----------------------
CREATE OR REPLACE PROCEDURE gll.check_gllstructure_data_quality AS
    v_invalid_count NUMBER;
BEGIN -- Check for required fields in SDE_GLL.GLLUSERINFO
    SELECT
        count(*) INTO v_invalid_count
    FROM
        sde.glluserinfo
    WHERE
        structureid IS NULL
        OR governmentlandlicenceid IS NULL;
    IF v_invalid_count > 0 THEN
        raise_application_error ( -20004, 'Data quality check failed: ' || v_invalid_count || ' records in SDE_GLL.GLLUSERINFO have missing required fields.' );
    END IF;

    dbms_output.put_line ( 'GLLSTRUCTURE data quality check passed successfully.' );
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line ( 'Error in GLLSTRUCTURE data quality check: ' || sqlerrm );
        raise;
END check_gllstructure_data_quality;