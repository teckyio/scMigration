CREATE OR UPDATE TABLE log_error (
    ID           NUMBER GENERATED BY DEFAULT AS IDENTITY,
    TABLE_NAME   VARCHAR2(100),
    ERROR_MESSAGE VARCHAR2(4000),
    LOG_DATE     DATE,
    OBJECTID VARCHAR2(100) 
);

CREATE OR REPLACE PROCEDURE generate_Formatted_GUID(p_guid OUT VARCHAR2)
IS
    l_raw_guid RAW(16);
BEGIN
    l_raw_guid := sys_guid();
    p_guid := SUBSTR(rawtohex(l_raw_guid), 1, 8) || '-' ||
              SUBSTR(rawtohex(l_raw_guid), 9, 4) || '-' ||
              SUBSTR(rawtohex(l_raw_guid), 13, 4) || '-' ||
              SUBSTR(rawtohex(l_raw_guid), 17, 4) || '-' ||
              SUBSTR(rawtohex(l_raw_guid), 21, 12);
END;

CREATE OR REPLACE PROCEDURE log_error (
    p_table_name VARCHAR2,
    p_error_msg  VARCHAR2,
    p_object_id VARCHAR2 DEFAULT NULL
) IS
BEGIN
    INSERT INTO ERROR_LOG (TABLE_NAME, ERROR_MESSAGE, LOG_DATE, OBJECTID)
    VALUES (p_table_name, p_error_msg, SYSDATE, p_object_id);
    COMMIT;
END;

CREATE OR REPLACE PROCEDURE find_dlo_id(
    p_dlooffice IN VARCHAR2,
    p_dlo_id OUT VARCHAR2
) IS
    v_dlo_ids VARCHAR2(4000);
BEGIN
    BEGIN
        -- Attempt to find a single ID based on the DLO_NAME
        SELECT ID
        INTO p_dlo_id
        FROM SQ.DLOS dlos
        WHERE DLO_NAME LIKE '%' || '/' || p_dlooffice || '%'
            OR (p_dlooffice = 'ND' AND DLO_NAME LIKE '%/N%')
            OR (p_dlooffice = 'HKWS' AND DLO_NAME LIKE '%/HKW&S%')
            OR (p_dlooffice = 'KT' AND DLO_NAME LIKE '%/TW&KT%');

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_dlo_id := NULL;
            log_error('DLO', 'NO FOUND DLOOFFICE: ' || p_dlooffice, NULL);

        WHEN TOO_MANY_ROWS THEN
            p_dlo_id := NULL;
            
            -- Collect all IDs that match the condition to log them
            SELECT LISTAGG(ID, ', ') WITHIN GROUP (ORDER BY ID)
            INTO v_dlo_ids
            FROM SQ.DLOS
            WHERE DLO_NAME LIKE '%' || p_dlooffice || '%';
            
            -- Log an error with the concatenated list of IDs for debugging
            log_error('DLO', 'Multiple records found for DLOOFFICE: ' || p_dlooffice || 
                             '. Found IDs: ' || v_dlo_ids,NULL);
    END;
END;
