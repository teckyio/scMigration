CREATE TABLE ERROR_LOG (
    ID           NUMBER GENERATED BY DEFAULT AS IDENTITY,
    TABLE_NAME   VARCHAR2(100),
    ERROR_MESSAGE VARCHAR2(4000),
    LOG_DATE     DATE
);

CREATE OR REPLACE PROCEDURE log_error (
    p_table_name VARCHAR2,
    p_error_msg  VARCHAR2
) IS
BEGIN
    INSERT INTO ERROR_LOG (TABLE_NAME, ERROR_MESSAGE, LOG_DATE)
    VALUES (p_table_name, p_error_msg, SYSDATE);
    COMMIT;
END;