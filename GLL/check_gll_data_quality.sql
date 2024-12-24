----------------------- Procedure to perform data quality checks ----------------------- 
CREATE OR REPLACE PROCEDURE gll.check_gll_data_quality AS
    v_invalid_count NUMBER;
BEGIN
 
    -- Check for required fields in GLL.GLLS
    SELECT
        count(*) INTO v_invalid_count
    FROM
        sde.governmentlandlicence
    WHERE
        governmentlandlicenceid IS NULL
        OR objectid IS NULL
        OR creationdate IS NULL;
    IF v_invalid_count > 0 THEN
        raise_application_error(-20001, 'Data quality check failed: ' || v_invalid_count || ' records in GLL.GLLS have missing required fields.');
    END IF;
 

    -- Check for duplicate GLL_NO
    SELECT
        count(*) INTO v_invalid_count
    FROM
        (
            SELECT
                objectid
            FROM
                sde.governmentlandlicence
            GROUP BY
                objectid
            HAVING
                count(*) > 1
        );
    IF v_invalid_count > 0 THEN
        raise_application_error(-20002, 'Data quality check failed: ' || v_invalid_count || ' duplicate GLL_NO found in GLL.GLLS.');
    END IF;
 

    -- Check for invalid dates
    SELECT
        count(*) INTO v_invalid_count
    FROM
        sde.governmentlandlicence
    WHERE
        commencementdate > current_date;
    IF v_invalid_count > 0 THEN
        raise_application_error(-20003, 'Data quality check failed: ' || v_invalid_count || ' records in GLL.GLLS have invalid dates.');
    END IF;
 

    -- Add more data quality checks for other source tables as needed
    dbms_output.put_line('Data quality check passed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error in data quality check: ' || sqlerrm);
        raise;
END check_gll_data_quality;