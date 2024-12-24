-- Procedure to perform data quality checks
CREATE OR REPLACE PROCEDURE gll.check_attachment_data_quality(
    p_url IN VARCHAR2
  , p_full_filename IN VARCHAR2
  , p_displayname IN VARCHAR2
  , p_file_size IN NUMBER
  , p_created_at IN TIMESTAMP
  , p_updated_at IN TIMESTAMP
) AS
BEGIN
    IF p_full_filename IS NULL OR length(trim(p_full_filename)) = 0 THEN
        raise_application_error(-20001, 'FullFilename cannot be null or empty');
    END IF;

    IF p_displayname IS NULL OR length(trim(p_displayname)) = 0 THEN
        raise_application_error(-20002, 'Displayname cannot be null or empty');
    END IF;

    IF p_file_size IS NOT NULL AND p_file_size < 0 THEN
        raise_application_error(-20003, 'FileSize must be positive');
    END IF;

    IF p_url IS NOT NULL AND NOT regexp_like(p_url, '\\.*$') THEN
        raise_application_error(-20004, 'Invalid URL format: ' || p_url);
    END IF;

    IF length(p_full_filename) > 255 THEN
        raise_application_error(-20005, 'FullFilename exceeds maximum length of 255 characters');
    END IF;

    IF length(p_displayname) > 255 THEN
        raise_application_error(-20006, 'Displayname exceeds maximum length of 255 characters');
    END IF;

    IF p_created_at > systimestamp THEN
        raise_application_error(-20007, 'Created date cannot be in the future');
    END IF;

    IF p_updated_at > systimestamp THEN
        raise_application_error(-20008, 'Updated date cannot be in the future');
    END IF;
 

    -- Add more checks as needed
END check_attachment_data_quality;