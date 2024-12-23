-- Test Script for Data Validation

-- Test 1: Validate Data Completeness and Accuracy
DECLARE
    v_source_count INTEGER;
    v_destination_count INTEGER;
BEGIN
    -- Count the potential entries to be inserted from the source
    SELECT COUNT(*) INTO v_source_count FROM SDE_SQ.SQUATTERMATERIAL_HIS sm
    LEFT JOIN SQ.MATERIALS m ON sm.MATERIALS = m.NAME 
    LEFT JOIN SQ.SQUATTER_HISTORIES s ON sm.SQUATTERID = s.SQUATTER_ID AND sm.VERSION = s.VERSION;

    -- Count the actual inserted entries in the destination
    SELECT COUNT(*) INTO v_destination_count FROM SQ.SQUATTER_MATERIAL_HIS;

    -- Output the results
    DBMS_OUTPUT.PUT_LINE('Total potential entries: ' || v_source_count || ' Actual inserted entries: ' || v_destination_count);
END;

-- Test 2: Referential Integrity Check
DECLARE
    v_source_count INTEGER;
BEGIN
    -- Verify that MATERIAL_ID references are valid
    SELECT COUNT(*) INTO v_source_count FROM SQ.SQUATTER_MATERIAL_HIS sm
    WHERE NOT EXISTS (SELECT 1 FROM SQ.MATERIALS m WHERE sm.MATERIAL_ID = m.ID);
    DBMS_OUTPUT.PUT_LINE('Invalid MATERIAL_ID references: ' || v_source_count);

    -- Verify that SQUATTER_HISTORY_ID references are valid
    SELECT COUNT(*) INTO v_source_count FROM SQ.SQUATTER_MATERIAL_HIS sm
    WHERE sm.SQUATTER_HISTORY_ID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM SQ.SQUATTER_HISTORIES s WHERE sm.SQUATTER_HISTORY_ID = s.ID);
    DBMS_OUTPUT.PUT_LINE('Invalid SQUATTER_HISTORY_ID references: ' || v_source_count);
END;

-- Test 3: Error Handling Verification
DECLARE
    v_source_count INTEGER;
BEGIN
    -- Verify that errors are logged correctly
    SELECT COUNT(*) INTO v_source_count FROM ERROR_LOG
    WHERE TABLE_NAME = 'SQUATTER_MATERIAL_HIS';
    DBMS_OUTPUT.PUT_LINE('Logged errors for SQUATTER_MATERIAL_HIS: ' || v_source_count);
END;

-- Test 4: Data Accuracy for Default Version
DECLARE
    v_source_count INTEGER;
BEGIN
    -- Check for records with incorrect default version setting
    SELECT COUNT(*) INTO v_source_count FROM SQ.SQUATTER_MATERIAL_HIS
    WHERE VERSION = 0 AND EXISTS (SELECT 1 FROM SDE_SQ.SQUATTERMATERIAL_HIS WHERE OBJECTID = OBJECT_ID AND VERSION IS NOT NULL);
    DBMS_OUTPUT.PUT_LINE('Incorrect default VERSION setting: ' || v_source_count);
END;
