-- Test Script for Data Validation

-- Test 1: Validate Data Completeness and Accuracy
DECLARE
    v_total_count INTEGER;
    v_inserted_count INTEGER;
BEGIN
    -- Count the potential entries to be inserted
    SELECT COUNT(*) INTO v_total_count FROM SDE_SQ.SQUATTERUSE sm
    LEFT JOIN SQ.USES m ON sm.SQUATTERUSE = m.NAME 
    LEFT JOIN SQ.SQUATTERS s ON sm.SQUATTERID = s.SQUATTER_ID AND sm.VERSION = s.VERSION;

    -- Count the actual inserted entries
    SELECT COUNT(*) INTO v_inserted_count FROM SQ.SQUATTER_USES;

    -- Output the results
    DBMS_OUTPUT.PUT_LINE('Total potential entries: ' || v_total_count || ' Actual inserted entries: ' || v_inserted_count);
END;

-- Test 2: Referential Integrity Check
DECLARE
    v_total_count INTEGER;
BEGIN
    -- Example: Verify that MATERIAL_ID references are valid
    SELECT COUNT(*) INTO v_total_count FROM SQ.SQUATTER_USES su
    WHERE NOT EXISTS (SELECT 1 FROM SQ.USES u WHERE su.USE_ID = u.ID);
    DBMS_OUTPUT.PUT_LINE('Invalid USE_ID references: ' || v_total_count);

    -- Verify that SQUATTER_HISTORY_ID references are valid
    SELECT COUNT(*) INTO v_source_count FROM SQ.SQUATTER_MATERIAL_HIS sm
    WHERE sm.SQUATTER_HISTORY_ID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM SQ.SQUATTER_HISTORIES s WHERE sm.SQUATTER_HISTORY_ID = s.ID);
    DBMS_OUTPUT.PUT_LINE('Invalid SQUATTER_HISTORY_ID references: ' || v_source_count);
END;

-- Test 3: Error Handling Verification
DECLARE
    v_total_count INTEGER;
BEGIN
    -- Verify that errors are logged correctly
    SELECT COUNT(*) INTO v_total_count FROM ERROR_LOG
    WHERE TABLE_NAME = 'SQUATTER_USE';
    DBMS_OUTPUT.PUT_LINE('Logged errors for SQUATTER_USE: ' || v_total_count);
END;

-- Test 4: Conditional Insert Logic Verification
DECLARE
    v_total_count INTEGER;
BEGIN
    -- Check for records that might have been incorrectly inserted due to conditional logic failure
    SELECT COUNT(*) INTO v_total_count FROM SQ.SQUATTER_USES su
    WHERE (su.SQUATTER_GUID IS NOT NULL AND su.SQUATTER_PEND_GUID IS NOT NULL) 
        OR (su.SQUATTER_GUID IS NULL AND su.SQUATTER_PEND_GUID IS NULL);
    DBMS_OUTPUT.PUT_LINE('Conditional logic errors: ' || v_total_count);
END;
