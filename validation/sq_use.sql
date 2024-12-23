-- Test Script for Data Validation

-- Test 1: Validate Data Completeness and Accuracy
DECLARE
    v_source_count INTEGER;
    v_destination_count INTEGER;
BEGIN
    -- Count the potential entries to be inserted from the source
    SELECT COUNT(*) INTO v_source_count FROM SDE_SQ.SQUATTERUSE sm
    LEFT JOIN SQ.USES m ON sm.SQUATTERUSE = m.NAME 
    LEFT JOIN SQ.SQUATTERS s ON sm.SQUATTERID = s.SQUATTER_ID AND sm.VERSION = s.VERSION
    LEFT JOIN SQ.SQUATTER_PENDS sp ON sm.SQUATTERID = sp.SQUATTER_ID AND sm.VERSION = sp.VERSION;

    -- Count the actual inserted entries in the destination
    SELECT COUNT(*) INTO v_destination_count FROM SQ.SQUATTER_USES;

    -- Output the results
    DBMS_OUTPUT.PUT_LINE('Total potential entries: ' || v_source_count || ' Actual inserted entries: ' || v_destination_count);
END;

-- Test 2: Referential Integrity Check
BEGIN
    -- Verify that USE_ID references are valid
    SELECT COUNT(*) INTO v_source_count FROM SQ.SQUATTER_USES su
    WHERE NOT EXISTS (SELECT 1 FROM SQ.USES u WHERE su.USE_ID = u.ID);
    DBMS_OUTPUT.PUT_LINE('Invalid USE_ID references: ' || v_source_count);

    -- Verify that SQUATTER_GUID references are valid
    SELECT COUNT(*) INTO v_source_count FROM SQ.SQUATTER_USES su
    WHERE su.SQUATTER_GUID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM SQ.SQUATTERS s WHERE su.SQUATTER_GUID = s.ID);
    DBMS_OUTPUT.PUT_LINE('Invalid SQUATTER_GUID references: ' || v_source_count);

    -- Verify that SQUATTER_PEND_GUID references are valid
    SELECT COUNT(*) INTO v_source_count FROM SQ.SQUATTER_USES su
    WHERE su.SQUATTER_PEND_GUID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM SQ.SQUATTER_PENDS sp WHERE su.SQUATTER_PEND_GUID = sp.ID);
    DBMS_OUTPUT.PUT_LINE('Invalid SQUATTER_PEND_GUID references: ' || v_source_count);
END;

-- Test 3: Error Handling Verification
BEGIN
    -- Verify that errors are logged correctly
    SELECT COUNT(*) INTO v_source_count FROM ERROR_LOG
    WHERE TABLE_NAME = 'SQUATTER_USE';
    DBMS_OUTPUT.PUT_LINE('Logged errors for SQUATTER_USE: ' || v_source_count);
END;

-- Test 4: Conditional Insert Logic Verification
BEGIN
    -- Check for records that might have been incorrectly inserted due to conditional logic failure
    SELECT COUNT(*) INTO v_source_count FROM SQ.SQUATTER_USES su
    WHERE (su.SQUATTER_GUID IS NOT NULL AND su.SQUATTER_PEND_GUID IS NOT NULL) 
        OR (su.SQUATTER_GUID IS NULL AND su.SQUATTER_PEND_GUID IS NULL);
    DBMS_OUTPUT.PUT_LINE('Conditional logic errors: ' || v_source_count);
END;
