DECLARE    
    v_batch_size      NUMBER := 50;
    v_max_id          NUMBER;
    v_min_id          NUMBER;
BEGIN 
    SELECT
        min(s.objectid)
        , max(s.objectid) 
        INTO v_min_id
        , v_max_id
    FROM
        SDE_SQ.SQUATTER s;

    WHILE v_min_id <= v_max_id LOOP
        FOR sde IN (
            SELECT 
                s.AMEND_DATE
                , s.APPROVE_STATUS
                , s.APPROVED_AMEND_DATE
                , s.APPROVED_CREATION_DATE
                , s.APPROVED_DELETE_DATE
                , s.APPROVED_REINSTATE_DATE
                , s.BOOKNO
                , s.BOUNDARYSTATUS
                , s.CASEFILE
                , s.CISSQUATTERID
                , s.CLEARANCE_NO
                , s.CREATED_DATE
                , s.CREATED_USER
                , s.CREATION_DATE
                , s.DELETE_DATE
                , s.DELETE_REASON
                , s.DIMENSION_B
                , s.DIMENSION_H
                , s.DIMENSION_L
                , s.DIMENSIONUNIT
                , s.DISPLAYNAME
                , s.DLOOFFICE
                , s.FILENAME
                , s.FILEREF
                , s.HASREMARK
                , s.HOUSENO
                , s.ISSUE
                , s.JOBNO
                , s.LAST_EDITED_DATE
                , s.LAST_EDITED_USER
                , s.LOCATION
                , s.OBJECTID
                , s.PLANFILENAME
                , s.RECORDDATE
                , s.RECORDDATE_EDIT
                , s.REINSTATE_DATE
                , s.SCOFFICE
                , s.SERIALNO
                , s.SERIALNO_EDIT
                , s.SQUATTERDISTRICT
                , s.SQUATTERID
                , s.STATUS
                , s.SURVEYNO
                , s.SURVEYNOPREFIX
                , s.SURVEYRECORD_1982
                , s.VERSION
            FROM SDE_SQ.SQUATTER s 
            WHERE s.OBJECTID BETWEEN v_min_id AND v_min_id + v_batch_size - 1
        ) LOOP
            BEGIN 
                INSERT INTO TMP_CHK
                WITH checking AS (
                    SELECT
                        sde.OBJECTID AS OBJECTID
                        , sde.OBJECTID AS TARGET_OBJECTID
                        , (
							-- checkings: ****NEED DOUBLE CHECK*****
                            CASE WHEN NOT sq.OBJECT_ID = sde.OBJECTID THEN 'Problem SQUATTER.OBJECTID' ELSE NULL END
                            || CASE WHEN NOT sq.AMEND_DATE = sde.AMEND_DATE THEN '; Problem SQUATTER.AMEND_DATE' ELSE NULL END
							|| CASE WHEN NOT sq.AMEND_DATE  = sde.AMEND_DATE THEN '; Problem on sde.AMEND_DATE' ELSE NULL END
							|| CASE WHEN NOT sq.APPROVE_STATUS  = sde.APPROVE_STATUS THEN '; Problem on sde.APPROVE_STATUS' ELSE NULL END
							|| CASE WHEN NOT sq.APPROVED_AMEND_DATE  = sde.APPROVED_AMEND_DATE THEN '; Problem on sde.APPROVED_AMEND_DATE' ELSE NULL END
							|| CASE WHEN NOT sq.APPROVED_CREATION_DATE  = sde.APPROVED_CREATION_DATE THEN '; Problem on sde.APPROVED_CREATION_DATE' ELSE NULL END
							|| CASE WHEN NOT sq.APPROVED_DELETE_DATE  = sde.APPROVED_DELETE_DATE THEN '; Problem on sde.APPROVED_DELETE_DATE' ELSE NULL END
							|| CASE WHEN NOT sq.APPROVED_REINSTATE_DATE  = sde.APPROVED_REINSTATE_DATE THEN '; Problem on sde.APPROVED_REINSTATE_DATE' ELSE NULL END
							|| CASE WHEN NOT sq.BOOKNO  = sde.BOOKNO THEN '; Problem on sde.BOOKNO' ELSE NULL END
							|| CASE WHEN NOT sq.BOUNDARYSTATUS  = sde.BOUNDARYSTATUS THEN '; Problem on sde.BOUNDARYSTATUS' ELSE NULL END
							|| CASE WHEN NOT sq.CASEFILE  = sde.CASEFILE THEN '; Problem on sde.CASEFILE' ELSE NULL END
							|| CASE WHEN NOT sq.CISSQUATTERID  = sde.CISSQUATTERID THEN '; Problem on sde.CISSQUATTERID' ELSE NULL END
							|| CASE WHEN NOT sq.CLEARANCE_NO  = sde.CLEARANCE_NO THEN '; Problem on sde.CLEARANCE_NO' ELSE NULL END
							|| CASE WHEN NOT sq.CREATED_DATE  = sde.CREATED_DATE THEN '; Problem on sde.CREATED_DATE' ELSE NULL END
							|| CASE WHEN NOT sq.CREATED_USER  = sde.CREATED_USER THEN '; Problem on sde.CREATED_USER' ELSE NULL END
							|| CASE WHEN NOT sq.CREATION_DATE  = sde.CREATION_DATE THEN '; Problem on sde.CREATION_DATE' ELSE NULL END
							|| CASE WHEN NOT sq.DELETE_DATE  = sde.DELETE_DATE THEN '; Problem on sde.DELETE_DATE' ELSE NULL END
							|| CASE WHEN NOT sq.DELETE_REASON  = sde.DELETE_REASON THEN '; Problem on sde.DELETE_REASON' ELSE NULL END
							|| CASE WHEN NOT sq.DIMENSION_B  = sde.DIMENSION_B THEN '; Problem on sde.DIMENSION_B' ELSE NULL END
							|| CASE WHEN NOT sq.DIMENSION_H  = sde.DIMENSION_H THEN '; Problem on sde.DIMENSION_H' ELSE NULL END
							|| CASE WHEN NOT sq.DIMENSION_L  = sde.DIMENSION_L THEN '; Problem on sde.DIMENSION_L' ELSE NULL END
							|| CASE WHEN NOT sq.DIMENSIONUNIT  = sde.DIMENSIONUNIT THEN '; Problem on sde.DIMENSIONUNIT' ELSE NULL END
							|| CASE WHEN NOT sq.DISPLAYNAME  = sde.DISPLAYNAME THEN '; Problem on sde.DISPLAYNAME' ELSE NULL END
							|| CASE WHEN NOT sq.DLOOFFICE  = sde.DLOOFFICE THEN '; Problem on sde.DLOOFFICE' ELSE NULL END
							|| CASE WHEN NOT sq.FILENAME  = sde.FILENAME THEN '; Problem on sde.FILENAME' ELSE NULL END
							|| CASE WHEN NOT sq.FILEREF  = sde.FILEREF THEN '; Problem on sde.FILEREF' ELSE NULL END
							|| CASE WHEN NOT sq.HASREMARK  = sde.HASREMARK THEN '; Problem on sde.HASREMARK' ELSE NULL END
							|| CASE WHEN NOT sq.HOUSENO  = sde.HOUSENO THEN '; Problem on sde.HOUSENO' ELSE NULL END
							|| CASE WHEN NOT sq.ISSUE  = sde.ISSUE THEN '; Problem on sde.ISSUE' ELSE NULL END
							|| CASE WHEN NOT sq.JOBNO  = sde.JOBNO THEN '; Problem on sde.JOBNO' ELSE NULL END
							|| CASE WHEN NOT sq.LAST_EDITED_DATE  = sde.LAST_EDITED_DATE THEN '; Problem on sde.LAST_EDITED_DATE' ELSE NULL END
							|| CASE WHEN NOT sq.LAST_EDITED_USER  = sde.LAST_EDITED_USER THEN '; Problem on sde.LAST_EDITED_USER' ELSE NULL END
							|| CASE WHEN NOT sq.LOCATION  = sde.LOCATION THEN '; Problem on sde.LOCATION' ELSE NULL END
							|| CASE WHEN NOT sq.OBJECTID  = sde.OBJECTID THEN '; Problem on sde.OBJECTID' ELSE NULL END
							|| CASE WHEN NOT sq.PLANFILENAME  = sde.PLANFILENAME THEN '; Problem on sde.PLANFILENAME' ELSE NULL END
							|| CASE WHEN NOT sq.RECORDDATE  = sde.RECORDDATE THEN '; Problem on sde.RECORDDATE' ELSE NULL END
							|| CASE WHEN NOT sq.RECORDDATE_EDIT  = sde.RECORDDATE_EDIT THEN '; Problem on sde.RECORDDATE_EDIT' ELSE NULL END
							|| CASE WHEN NOT sq.REINSTATE_DATE  = sde.REINSTATE_DATE THEN '; Problem on sde.REINSTATE_DATE' ELSE NULL END
							|| CASE WHEN NOT sq.SCOFFICE  = sde.SCOFFICE THEN '; Problem on sde.SCOFFICE' ELSE NULL END
							|| CASE WHEN NOT sq.SERIALNO  = sde.SERIALNO THEN '; Problem on sde.SERIALNO' ELSE NULL END
							|| CASE WHEN NOT sq.SERIALNO_EDIT  = sde.SERIALNO_EDIT THEN '; Problem on sde.SERIALNO_EDIT' ELSE NULL END
							|| CASE WHEN NOT sq.SQUATTERDISTRICT  = sde.SQUATTERDISTRICT THEN '; Problem on sde.SQUATTERDISTRICT' ELSE NULL END
							|| CASE WHEN NOT sq.SQUATTERID  = sde.SQUATTERID THEN '; Problem on sde.SQUATTERID' ELSE NULL END
							|| CASE WHEN NOT sq.STATUS  = sde.STATUS THEN '; Problem on sde.STATUS' ELSE NULL END
							|| CASE WHEN NOT sq.SURVEYNO  = sde.SURVEYNO THEN '; Problem on sde.SURVEYNO' ELSE NULL END
							|| CASE WHEN NOT sq.SURVEYNOPREFIX  = sde.SURVEYNOPREFIX THEN '; Problem on sde.SURVEYNOPREFIX' ELSE NULL END
							|| CASE WHEN NOT sq.SURVEYRECORD_1982  = sde.SURVEYRECORD_1982 THEN '; Problem on sde.SURVEYRECORD_1982' ELSE NULL END
							|| CASE WHEN NOT sq.VERSION  = sde.VERSION THEN '; Problem on sde.VERSION' ELSE NULL END
                        ) AS ERROR_MSG
                        , '' AS IS_VALID
                    FROM SQUATTERS sq 
                    WHERE sq.OBJECT_ID = sde.OBJECTID
                )
                SELECT
                    c.OBJECTID AS OBJECTID
                    , c.TARGET_OBJECTID AS TARGET_OBJECTID
                    , c.ERROR_MSG AS ERROR_MSG
                    , CASE WHEN c.ERROR_MSG IS NULL THEN 1 ELSE 0 END AS IS_VALID
                FROM checking c;

                COMMIT;
                
            EXCEPTION 
                WHEN OTHERS THEN
                    dbms_output.put_line('Error processing OBJECTID: ' || sde.OBJECTID);
                    dbms_output.put_line('Error: ' || SQLERRM);
                    dbms_output.put_line('Error Code: ' || SQLCODE);
                    ROLLBACK;
            END;
        END LOOP;
        
        v_min_id := v_min_id + v_batch_size;  -- Increment the minimum ID
        COMMIT;
        
    END LOOP;
    
EXCEPTION 
    WHEN OTHERS THEN
        dbms_output.put_line('Fatal error occurred');
        dbms_output.put_line('Error: ' || SQLERRM);
        dbms_output.put_line('Error Code: ' || SQLCODE);
        ROLLBACK;
        RAISE;
END;