BEGIN
    EXECUTE IMMEDIATE '
        CREATE TABLE MIGRATION_LOG (
        ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
        , ENTITY_NAME VARCHAR2(100)
        , SOURCE_ID NUMBER
        , TARGET_ID RAW(16)
        , STATUS VARCHAR2(20)
        , ERROR_MESSAGE VARCHAR2(4000)
        , CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )';
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -955 THEN
            dbms_output.put_line ('Table MIGRATION_LOG already exists');
        ELSE
            raise;
        END IF;
END;

BEGIN
    EXECUTE IMMEDIATE '
        CREATE TABLE MIGRATION_SUMMARY (
        ID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
        , START_TIME TIMESTAMP
        , END_TIME TIMESTAMP
        , ORIGINAL_ENTITY VARCHAR2(500)
        , NEW_ENTITY VARCHAR2(500)
        , TOTAL_RECORDS NUMBER
        , MIGRATED_RECORDS NUMBER
        , FAILED_RECORDS NUMBER
        , CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )';
EXCEPTION
    WHEN OTHERS THEN
        IF sqlcode = -955 THEN
            dbms_output.put_line ('Table MIGRATION_SUMMARY already exists');
        ELSE
            raise;
        END IF;
END;