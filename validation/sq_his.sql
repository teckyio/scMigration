-- Test Script for Data Validation

-- Test 1: Validate Data Completeness
DECLARE
    v_source_count INTEGER;
    v_destination_count INTEGER;
BEGIN
    -- Count source entries
    SELECT COUNT(*) INTO v_source_count FROM SDE_SQ.SQUATTER_HIS sh
    WHERE OBJECTID NOT IN (SELECT OBJECT_ID FROM SQ.SQUATTER_HISTORIES WHERE OBJECT_ID IS NOT NULL);

    -- Count destination entries
    SELECT COUNT(*) INTO v_destination_count FROM SQ.SQUATTER_HISTORIES;

    -- Output the results
    DBMS_OUTPUT.PUT_LINE('Source Count: ' || v_source_count || ' Destination Count: ' || v_destination_count);
    -- Add additional logic if needed to verify that these counts should match or meet certain criteria
END;

-- Test 2: Referential Integrity Check
DECLARE
    v_source_count INTEGER;
BEGIN
    -- Assuming DLO_ID should reference a valid entry in a DLO table
    SELECT COUNT(*) INTO v_source_count FROM SQ.SQUATTER_HISTORIES h
    WHERE NOT EXISTS (SELECT 1 FROM DLOS d WHERE h.DLO_ID = d.ID);
    DBMS_OUTPUT.PUT_LINE('Invalid DLO_ID references: ' || v_source_count);
END;

-- Test 3: Check Data Transformations
DECLARE
    v_source_count INTEGER;
BEGIN
    -- Check for incorrect HAS_REMARK conversions
    SELECT COUNT(*) INTO v_source_count FROM SQ.SQUATTER_HISTORIES sh
    JOIN SDE_SQ.SQUATTER os ON sh.OBJECT_ID = os.OBJECTID
    WHERE (sh.HAS_REMARK = 1 AND os.HASREMARK = 'N')
       OR (sh.HAS_REMARK = 0 AND os.HASREMARK = 'Y');
    DBMS_OUTPUT.PUT_LINE('Incorrect HAS_REMARK Transformations: ' || v_source_count);
END;

-- Test 4: Error Logging Verification
DECLARE
    v_source_count INTEGER;
BEGIN
    -- Verify that errors are logged correctly
    SELECT COUNT(*) INTO v_source_count FROM ERROR_LOG
    WHERE TABLE_NAME = 'SQUATTERS_HIS';
    DBMS_OUTPUT.PUT_LINE('Logged errors for SQUATTERS_HIS: ' || v_source_count);
END;

-- Test 5: Date Field Formatting
DECLARE
    v_source_count INTEGER;
BEGIN
    -- Example: Check for any incorrect date formatting
    SELECT COUNT(*) INTO v_source_count FROM SQ.SQUATTER_HISTORIES
    WHERE LENGTH(CREATED_DATE) <> 10;
    DBMS_OUTPUT.PUT_LINE('Date formatting errors in CREATED_DATE: ' || v_source_count);
END;
