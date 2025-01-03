
DECLARE
    v_error_message VARCHAR2(4000);
    v_guid VARCHAR2(36);
    v_dlo_id VARCHAR2(36);
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
        FROM SDE_SQ.SQUATTER
    ) LOOP
        BEGIN
            generate_Formatted_GUID(v_guid);
            find_dlo_id(rec.DLOOFFICE, v_dlo_id);
            -- Insert into new table
            INSERT INTO SQ.SQUATTERS (
                ID, 
                OBJECT_ID, SQUATTER_ID, DIMENSIONS_L, DIMENSIONS_B, DIMENSIONS_H, 
                SURVEY_LOCATION, DLO_ID, 
                FILE_NAME, STATUS, CREATED_DATE, DISTRICT, 
                SC_PLAN_NO, 
                CREATED_USER, LAST_EDITED_USER, LAST_EDITED_DATE, 
                CIS_SQUATTER_ID, 
                BOOK_NO, SERIAL_NO, SURVEY_NO, CASE_REFERENCE, DATA_PROBLEM, 
                SC_OFFICE, SURVEY_NO_PREFIX, 
                HAS_REMARK, HOUSE_NO, DISPLAY_NAME,
                Certainty_Of_Digitized_Polygon, 
                UNITS, 
                SERIAL_NO_EDIT, HD161FORM_RECORD_DATE, 
                DELETE_REASON,
                DELETE_DATE, 
                RE_INSTATE_DATE, 
                VERSION, 
                SURVEY_RECORD1982, APPROVED_CREATION_DATE, APPROVED_DELETE_DATE, 
                APPROVED_REINSTATE_DATE, APPROVED_AMENDMENT_DATE,
                JOB_NO,
                CLEARANCE_NO,
                AMEND_DATE,
                CASE_FILE,
                RECORD_DATE,
                CREATED_AT,
                UPDATED_AT
            ) VALUES (
                v_guid,
                rec.OBJECTID, rec.SQUATTERID, rec.DIMENSION_L, rec.DIMENSION_B, rec.DIMENSION_H, 
                rec.LOCATION, v_dlo_id, 
                rec.FILENAME, rec.STATUS, rec.CREATION_DATE, rec.SQUATTERDISTRICT, 
                rec.PLANFILENAME, 
                rec.CREATED_USER, rec.LAST_EDITED_USER, rec.LAST_EDITED_DATE, 
                rec.CISSQUATTERID, 
                rec.BOOKNO, rec.SERIALNO, rec.SURVEYNO, rec.FILEREF, rec.ISSUE, 
                rec.SCOFFICE, rec.SURVEYNOPREFIX, 
                rec.HASREMARK,
                rec.HOUSENO, rec.DISPLAYNAME, 
                rec.BOUNDARYSTATUS, 
                rec.DIMENSIONUNIT, 
                rec.SERIALNO_EDIT, rec.RECORDDATE_EDIT, 
                rec.DELETE_REASON, 
                rec.DELETE_DATE, 
                rec.REINSTATE_DATE, 
                rec.VERSION, 
                rec.SURVEYRECORD_1982, rec.APPROVED_CREATION_DATE, rec.APPROVED_DELETE_DATE, 
                rec.APPROVED_REINSTATE_DATE, rec.APPROVED_AMEND_DATE,
                rec.JOBNO,
                rec.CLEARANCE_NO,
                rec.AMEND_DATE,
                rec.CASEFILE,
                rec.RECORDDATE,
                rec.CREATED_DATE,
                rec.LAST_EDITED_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                v_error_message := SQLERRM;
                log_error('SQUATTERS', v_error_message, rec.OBJECT_ID);
                CONTINUE;
        END;
    END LOOP;
END;

