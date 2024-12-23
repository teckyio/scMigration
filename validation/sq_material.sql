-- Test Script for Data Validation

-- Test 1: Validate Data Completeness and Accuracy
DECLARE
    v_total_count INTEGER;
    v_inserted_count INTEGER;
BEGIN
    -- Count the potential entries to be inserted
    SELECT COUNT(*) INTO v_total_count FROM SDE_SQ.SQUATTERMATERIAL sm
    LEFT JOIN SQ.MATERIALS m ON sm.MATERIALS = m.NAME 
    LEFT JOIN SQ.SQUATTERS s ON sm.SQUATTERID = s.SQUATTER_ID AND sm.VERSION = s.VERSION;

    -- Count the actual inserted entries
    SELECT COUNT(*) INTO v_inserted_count FROM SQ.SQUATTER_MATERIALS;

    -- Output the results
    DBMS_OUTPUT.PUT_LINE('Total potential entries: ' || v_total_count || ' Actual inserted entries: ' || v_inserted_count);
END;

-- Test 2: Referential Integrity Check
DECLARE
    v_total_count INTEGER;
BEGIN
    -- Example: Verify that MATERIAL_ID references are valid
    SELECT COUNT(*) INTO v_total_count FROM SQ.SQUATTER_MATERIALS sm
    WHERE NOT EXISTS (SELECT 1 FROM SQ.MATERIALS m WHERE sm.MATERIAL_ID = m.ID);
    DBMS_OUTPUT.PUT_LINE('Invalid MATERIAL_ID references: ' || v_total_count);
END;

-- Test 3: Error Handling Verification
DECLARE
    v_total_count INTEGER;
BEGIN
    -- Verify that errors are logged correctly
    SELECT COUNT(*) INTO v_total_count FROM ERROR_LOG
    WHERE TABLE_NAME = 'SQUATTER_MATERIAL';
    DBMS_OUTPUT.PUT_LINE('Logged errors for SQUATTER_MATERIAL: ' || v_total_count);
END;

-- Test 4: Conditional Insert Logic Verification
DECLARE
    v_total_count INTEGER;
BEGIN
    -- Check for records that might have been incorrectly inserted due to conditional logic failure
    SELECT COUNT(*) INTO v_total_count FROM SQ.SQUATTER_MATERIALS sm
    WHERE (sm.SQUATTER_GUID IS NOT NULL AND sm.SQUATTER_PEND_GUID IS NOT NULL) 
        OR (sm.SQUATTER_GUID IS NULL AND sm.SQUATTER_PEND_GUID IS NULL);
    DBMS_OUTPUT.PUT_LINE('Conditional logic errors: ' || v_total_count);
END;
