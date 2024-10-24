
DECLARE
    v_error_message VARCHAR2(4000);
BEGIN
    FOR rec IN (
        SELECT
            OBJECTID,
            SQUATTERID,
            DIMENSION_L,
            DIMENSION_B,
            DIMENSION_H,
            LOCATION,
            DLOOFFICE,
            FILENAME,
            STATUS,
            RECORDDATE,
            SQUATTERDISTRICT,
            PLANFILENAME,
            CREATED_USER,
            CREATED_DATE,
            LAST_EDITED_USER,
            LAST_EDITED_DATE,
            CISSQUATTERID,
            BOOKNO,
            SERIALNO,
            SURVEYNO,
            FILEREF,
            ISSUE,
            SCOFFICE,
            SURVEYNOPREFIX,
            HASREMARK,
            HOUSENO,
            DISPLAYNAME,
            BOUNDARYSTATUS,
            DIMENSIONUNIT,
            SERIALNO_EDIT,
            RECORDDATE_EDIT,
            JOBNO,
            CREATION_DATE,
            CASEFILE,
            AMEND_DATE,
            DELETE_REASON,
            CLEARANCE_NO,
            DELETE_DATE,
            REINSTATE_DATE,
            APPROVE_STATUS,
            VERSION,
            SURVEYRECORD_1982,
            APPROVED_CREATION_DATE,
            APPROVED_DELETE_DATE,
            APPROVED_REINSTATE_DATE,
            APPROVED_AMEND_DATE
        FROM OLDDB.SQUATTER
    ) LOOP
        BEGIN
            -- Insert into new table
            INSERT INTO NEWDB.SQUATTER_PENDS (
                OBJECT_ID, SQUATTER_ID, DIMENSIONS_L, DIMENSIONS_B, DIMENSIONS_H, 
                SURVEY_LOCATION, DLO_ID, FILE_NAME, STATUS, CREATED_DATE, SQUATTER_DISTRICT, 
                PLAN_FILE_NAME, CREATED_USER, LAST_EDITED_USER, LAST_EDITED_DATE, CIS_SQUATTER_ID, 
                BOOK_NO, SERIAL_NO, SURVEY_NO, FILE_REF, ISSUE, SC_OFFICE, SURVEY_NO_PREFIX, 
                HAS_REMARK, HOUSE_NO, DISPLAY_NAME, BOUNDARY_STATUS, DIMENSION_UNIT, 
                SERIAL_NO_EDIT, RECORD_DATE_EDIT, JOB_NO, CASE_REFERENCE, AMEND_DATE, 
                DELETE_REASON, CLEARANCE_NO, DELETE_DATE, REINSTATE_DATE, APPROVE_STATUS, VERSION, 
                SURVEY_RECORD_1982, APPROVED_CREATION_DATE, APPROVED_DELETE_DATE, 
                APPROVED_REINSTATE_DATE, APPROVED_AMEND_DATE
            ) VALUES (
                rec.OBJECTID, rec.SQUATTERID, rec.DIMENSION_L, rec.DIMENSION_B, rec.DIMENSION_H, 
                rec.LOCATION, (SELECT ID FROM NEWDB.DLOS WHERE DLO_NAME = rec.DLOOFFICE), 
                rec.FILENAME, rec.STATUS, rec.RECORDDATE, rec.SQUATTERDISTRICT, rec.PLANFILENAME, 
                rec.CREATED_USER, rec.CREATED_DATE, rec.LAST_EDITED_USER, rec.LAST_EDITED_DATE, 
                rec.CISSQUATTERID, rec.BOOKNO, rec.SERIALNO, rec.SURVEYNO, rec.FILEREF, rec.ISSUE, 
                rec.SCOFFICE, rec.SURVEYNOPREFIX, rec.HASREMARK, rec.HOUSENO, rec.DISPLAYNAME, 
                rec.BOUNDARYSTATUS, rec.DIMENSIONUNIT, rec.SERIALNO_EDIT, rec.RECORDDATE_EDIT, 
                rec.JOBNO, rec.CASEFILE, rec.AMEND_DATE, rec.DELETE_REASON, rec.CLEARANCE_NO, 
                rec.DELETE_DATE, rec.REINSTATE_DATE, rec.APPROVE_STATUS, rec.VERSION, 
                rec.SURVEYRECORD_1982, rec.APPROVED_CREATION_DATE, rec.APPROVED_DELETE_DATE, 
                rec.APPROVED_REINSTATE_DATE, rec.APPROVED_AMEND_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                v_error_message := SQLERRM;
                log_error('SQUATTER_PEND', v_error_message);
        END;
    END LOOP;
END;

