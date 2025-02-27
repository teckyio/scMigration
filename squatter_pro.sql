DECLARE v_error_message VARCHAR2(4000);
v_guid VARCHAR2(36);
v_dlo_id VARCHAR2(36);
BEGIN FOR rec IN (
    SELECT sh.OBJECTID,
        sh.SQUATTERID,
        sh.DIMENSION_L,
        sh.DIMENSION_B,
        sh.DIMENSION_H,
        sh.LOCATION,
        sh.DLOOFFICE,
        sh.FILENAME,
        sh.STATUS,
        sh.RECORDDATE,
        sh.SQUATTERDISTRICT,
        sh.PLANFILENAME,
        sh.CREATED_USER,
        sh.CREATED_DATE,
        sh.LAST_EDITED_USER,
        sh.LAST_EDITED_DATE,
        sh.CISSQUATTERID,
        sh.BOOKNO,
        sh.SERIALNO,
        sh.SURVEYNO,
        sh.FILEREF,
        sh.ISSUE,
        sh.SCOFFICE,
        sh.SURVEYNOPREFIX,
        sh.HASREMARK,
        sh.HOUSENO,
        sh.DISPLAYNAME,
        sh.BOUNDARYSTATUS,
        sh.DIMENSIONUNIT,
        sh.SERIALNO_EDIT,
        sh.RECORDDATE_EDIT,
        sh.JOBNO,
        sh.CREATION_DATE,
        sh.CASEFILE,
        sh.AMEND_DATE,
        sh.DELETE_REASON,
        sh.CLEARANCE_NO,
        sh.DELETE_DATE,
        sh.REINSTATE_DATE,
        sh.APPROVE_STATUS,
        sh.VERSION,
        sh.SURVEYRECORD_1982,
        sh.APPROVED_CREATION_DATE,
        sh.APPROVED_DELETE_DATE,
        sh.APPROVED_REINSTATE_DATE,
        sh.APPROVED_AMEND_DATE,
        s.ID AS SQUATTER_GUID
    FROM SDE_SQ.SQUATTER_PRO sh
        LEFT JOIN SQ.SQUATTERS s ON sh.SQUATTERID = s.SQUATTER_ID
) LOOP BEGIN 
generate_Formatted_GUID(v_guid);
find_dlo_id(rec.DLOOFFICE, v_dlo_id);
IF NVL(rec.APPROVE_STATUS, 'NULL') != 'UPDATE_PENDING'
AND NVL(rec.APPROVE_STATUS, 'NOT_APPROERRORVED') != 'DELETE_PENDING' THEN log_error(
    'SQUATTER_HIS',
    'Skipped due to invalid APPROVE_STATUS',
    rec.OBJECTID
);
ELSE -- Insert into new table
INSERT INTO SQ.SQUATTER_PENDS (
        SQUATTER_GUID,
        ID,
        OBJECT_ID,
        SQUATTER_ID,
        DIMENSIONS_L,
        DIMENSIONS_B,
        DIMENSIONS_H,
        SQUATTER_LOCATION,
        DLO_ID,
        FILE_NAME,
        STATUS,
        DISTRICT,
        SC_PLAN_NO,
        CREATED_USER,
        LAST_EDITED_USER,
        LAST_EDITED_DATE,
        CIS_SQUATTER_ID,
        BOOK_NO,
        SERIAL_NO,
        SURVEY_NO,
        FILEREF,
        DATA_PROBLEM,
        SC_OFFICE,
        SURVEY_NO_PREFIX,
        HAS_REMARK,
        HOUSE_NO,
        DISPLAY_NAME,
        CERTAINTY_OF_DIGITIZED_POLYGON,
        UNITS,
        SERIAL_NO_EDIT,
        HD161FORM_RECORD_DATE,
        DELETE_REASON,
        APPROVED_WRITTEN_DELETE_DATE,
        APPROVED_WRITTEN_REINSTATE_DATE,
        VERSION,
        SURVEY_RECORD1982,
        APPROVED_CREATION_DATE,
        APPROVED_DELETE_DATE,
        APPROVED_REINSTATE_DATE,
        APPROVED_AMENDMENT_DATE,
        JOB_NO,
        CLEARANCE_NO,
        APPROVED_WRITTEN_AMENDMENT_DATE,
        CASE_FILE,
        APPROVED_WRITTEN_CREATION_DATE,
        CREATED_AT,
        HD161FORM_RECORD_DATE_RAW,
        UPDATED_AT,
        APPROVE_STATUS,
        APPROVE_TYPE
    )
VALUES (
        rec.SQUATTER_GUID,
        v_guid,
        rec.OBJECTID,
        rec.SQUATTERID,
        rec.DIMENSION_L,
        rec.DIMENSION_B,
        rec.DIMENSION_H,
        rec.LOCATION,
        v_dlo_id,
        rec.FILENAME,
        rec.STATUS,
        rec.SQUATTERDISTRICT,
        rec.PLANFILENAME,
        rec.CREATED_USER,
        rec.LAST_EDITED_USER,
        rec.LAST_EDITED_DATE,
        rec.CISSQUATTERID,
        rec.BOOKNO,
        rec.SERIALNO,
        rec.SURVEYNO,
        rec.FILEREF,
        rec.ISSUE,
        rec.SCOFFICE,
        rec.SURVEYNOPREFIX,
        rec.HASREMARK,
        rec.HOUSENO,
        rec.DISPLAYNAME,
        rec.BOUNDARYSTATUS,
        rec.DIMENSIONUNIT,
        rec.SERIALNO_EDIT,
        rec.RECORDDATE_EDIT,
        rec.DELETE_REASON,
        rec.DELETE_DATE,
        rec.REINSTATE_DATE,
        rec.VERSION,
        rec.SURVEYRECORD_1982,
        rec.APPROVED_CREATION_DATE,
        rec.APPROVED_DELETE_DATE,
        rec.APPROVED_REINSTATE_DATE,
        rec.APPROVED_AMEND_DATE,
        rec.JOBNO,
        rec.CLEARANCE_NO,
        rec.AMEND_DATE,
        rec.CASEFILE,
        rec.CREATION_DATE,
        rec.CREATED_DATE,
        rec.RECORDDATE,
        rec.LAST_EDITED_DATE,
        CASE
            WHEN NVL(rec.APPROVE_STATUS, 'NULL') = 'UPDATE_PENDING' THEN 'PendingApprover'
            WHEN NVL(rec.APPROVE_STATUS, 'NULL') = 'DELETE_PENDING' THEN 'PendingApprover'
            ELSE 'ERROR'
        END,
        CASE
            WHEN NVL(rec.APPROVE_STATUS, 'NULL') = 'UPDATE_PENDING' THEN 'Update'
            WHEN NVL(rec.APPROVE_STATUS, 'NULL') = 'DELETE_PENDING' THEN 'Delete'
            ELSE 'ERROR'
        END
        );
END IF;
EXCEPTION
WHEN OTHERS THEN v_error_message := SQLERRM;
log_error('SQUATTERS_PRO', v_error_message, rec.OBJECTID);
CONTINUE;
END;
END LOOP;
END;