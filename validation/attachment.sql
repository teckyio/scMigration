-- Test Script for Data Validation

-- Test 1: Validate Data Completeness and Accuracy
DECLARE
    v_source_count INTEGER;
    v_destination_count INTEGER;
    v_attachment_sq_count INTEGER;
BEGIN
    -- Count the total entries in the source
    SELECT COUNT(*) INTO v_source_count FROM SDE_SQ.SQUATTER_UPLOAD;

    -- Count the entries inserted into the attachments table
    SELECT COUNT(*) INTO v_destination_count FROM SQ.ATTACHMENTS;

    -- Count the entries inserted into the attachment_squatter table
    SELECT COUNT(*) INTO v_attachment_sq_count FROM SQ.ATTACHMENT_SQ;

    -- Output the results
    DBMS_OUTPUT.PUT_LINE('Source count: ' || v_source_count);
    DBMS_OUTPUT.PUT_LINE('Attachments inserted: ' || v_destination_count);
    DBMS_OUTPUT.PUT_LINE('Attachment Squatter links inserted: ' || v_attachment_sq_count);
END;

-- Test 2: Referential Integrity Check
DECLARE
    v_source_count INTEGER;
BEGIN
    -- Verify that all SQUATTER_GUID references are valid
    SELECT COUNT(*) INTO v_source_count FROM SQ.ATTACHMENT_SQ aq
    WHERE NOT EXISTS (SELECT 1 FROM SQ.SQUATTERS s WHERE aq.SQUATTER_GUID = s.ID);
    DBMS_OUTPUT.PUT_LINE('Invalid SQUATTER_GUID references in SQ.ATTACHMENT_SQ: ' || v_source_count);
END;

-- Test 3: Error Handling Verification
DECLARE
    v_source_count INTEGER;
BEGIN
    -- Verify that errors are logged correctly
    SELECT COUNT(*) INTO v_source_count FROM ERROR_LOG
    WHERE TABLE_NAME = 'ATTACHMENT';
    DBMS_OUTPUT.PUT_LINE('Logged errors for ATTACHMENTS: ' || v_source_count);
END;

-- Test 4: Validation of File Path Construction
DECLARE
    v_source_count INTEGER;
BEGIN
    -- Check for any incorrect file paths
    SELECT COUNT(*) INTO v_source_count FROM SQ.ATTACHMENTS
    WHERE NOT (URL LIKE '%\%' AND URL LIKE '%\%'); -- Adjust pattern check based on expected format
    DBMS_OUTPUT.PUT_LINE('Incorrect file paths: ' || v_source_count);
END;
