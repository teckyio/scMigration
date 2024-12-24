-- helper function to log migration events
CREATE OR REPLACE PROCEDURE log_migration(
  p_entity_name IN VARCHAR2
, p_source_id IN NUMBER
, p_target_id IN RAW
, p_status IN VARCHAR2
, p_error_message IN VARCHAR2 DEFAULT NULL
) AS
  PRAGMA autonomous_transaction;
BEGIN
  INSERT INTO migration_log (
    entity_name
  , source_id
  , target_id
  , status
  , error_message
  ) VALUES (
    p_entity_name
  , p_source_id
  , p_target_id
  , p_status
  , p_error_message
  );
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('Error logging migration: ' || sqlerrm);
    ROLLBACK;
END log_migration;