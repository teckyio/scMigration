
DECLARE
    v_error_message VARCHAR2(4000);
    v_guid VARCHAR2(36);
    v_dlo_id VARCHAR2(36);
BEGIN
    FOR rec IN (
        SELECT
            st.OBJECTID,
            st.SQUATTERID,
            st.DIMENSION_L,
            st.DIMENSION_B,
            st.DIMENSION_H,
            st.LOCATION,
            st.DLOOFFICE,
            st.FILENAME,
            st.STATUS,
            st.RECORDDATE,
            st.SQUATTERDISTRICT,
            st.PLANFILENAME,
            st.CREATED_USER,
            st.CREATED_DATE,
            st.LAST_EDITED_USER,
            st.LAST_EDITED_DATE,
            st.CISSQUATTERID,
            st.BOOKNO,
            st.SERIALNO,
            st.SURVEYNO,
            st.FILEREF,
            st.ISSUE,
            st.SCOFFICE,
            st.SURVEYNOPREFIX,
            st.HASREMARK,
            st.HOUSENO,
            st.DISPLAYNAME,
            st.BOUNDARYSTATUS,
            st.DIMENSIONUNIT,
            st.SERIALNO_EDIT,
            st.RECORDDATE_EDIT,
            st.JOBNO,
            st.CREATION_DATE,
            st.CASEFILE,
            st.AMEND_DATE,
            st.DELETE_REASON,
            st.CLEARANCE_NO,
            st.DELETE_DATE,
            st.REINSTATE_DATE,
            st.APPROVE_STATUS,
            st.VERSION,
            st.SURVEYRECORD_1982,
            st.APPROVED_CREATION_DATE,
            st.APPROVED_DELETE_DATE,
            st.APPROVED_REINSTATE_DATE,
            st.APPROVED_AMEND_DATE,
            s.ID AS SQUATTER_GUID
        FROM SDE_SQ.SQUATTER_TEMP st
        LEFT JOIN SQ.SQUATTERS s ON st.SQUATTERID = s.SQUATTER_ID 
        WHERE OBJECTID NOT IN (SELECT OBJECT_ID FROM SQ.SQUATTER_PENDS WHERE OBJECT_ID IS NOT NULL)
    ) LOOP
        BEGIN
            generate_Formatted_GUID(v_guid);
            find_dlo_id(rec.DLOOFFICE, v_dlo_id);
            -- Insert into new table
            INSERT INTO SQ.SQUATTER_PENDS (
                ID, 
                SQUATTER_GUID,
                OBJECT_ID, SQUATTER_ID, DIMENSIONS_L, DIMENSIONS_B, DIMENSIONS_H, 
                SURVEY_LOCATION, DLO_ID, 
                FILE_NAME, STATUS, CREATED_DATE, DISTRICT, 
                PLAN_FILE_NAME, 
                CREATED_USER, LAST_EDITED_USER, LAST_EDITED_DATE, 
                CIS_SQUATTER_ID, 
                BOOK_NO, SERIAL_NO, SURVEY_NO, CASE_REFERENCE, ISSUE, 
                SC_OFFICE, SURVEY_NO_PREFIX, 
                HAS_REMARK, HOUSE_NO, DISPLAY_NAME,
                BOUNDARY_STATUS, UNITS, 
                SERIAL_NO_EDIT, RECORD_DATE_EDIT, 
                DELETE_REASON,
                DELETE_DATE, 
                RE_INSTATE_DATE,VERSION, 
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
                rec.SQUATTER_GUID,
                rec.OBJECTID, rec.SQUATTERID, rec.DIMENSION_L, rec.DIMENSION_B, rec.DIMENSION_H, 
                rec.LOCATION, v_dlo_id, 
                rec.FILENAME, rec.STATUS, SUBSTR(rec.CREATION_DATE, 1, 10), rec.SQUATTERDISTRICT, 
                rec.PLANFILENAME, 
                rec.CREATED_USER, rec.LAST_EDITED_USER, SUBSTR(rec.LAST_EDITED_DATE,1,10), 
                rec.CISSQUATTERID, 
                rec.BOOKNO, rec.SERIALNO, rec.SURVEYNO, rec.FILEREF, rec.ISSUE, 
                rec.SCOFFICE, rec.SURVEYNOPREFIX, 
                CASE
                    WHEN rec.HASREMARK = 'true' then 1
                    ELSE 0
                END,
                rec.HOUSENO, rec.DISPLAYNAME, 
                rec.BOUNDARYSTATUS, rec.DIMENSIONUNIT, 
                rec.SERIALNO_EDIT, rec.RECORDDATE_EDIT, 
                rec.DELETE_REASON, 
                CASE 
                    WHEN rec.DELETE_DATE IS NOT NULL THEN SUBSTR(rec.DELETE_DATE, 1, 10) 
                    ELSE NULL 
                END, 
                CASE 
                    WHEN rec.REINSTATE_DATE IS NOT NULL THEN SUBSTR(rec.REINSTATE_DATE, 1, 10) 
                    ELSE NULL 
                END, 
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
                log_error('SQUATTERS', v_error_message);
                CONTINUE;
        END;
    END LOOP;
END;

