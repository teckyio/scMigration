TRUNCATE TABLE data_validation_squatters;
DECLARE quantity INT := 481;
table_count INT;
v_dlo_id VARCHAR2(36);
BEGIN -- Insert data into the table with validation checks
INSERT INTO data_validation_squatters (objectid, target_ObjectId, error_msg, is_valid)
SELECT rec.objectid AS objectid,
	s.OBJECT_ID AS target_ObjectId,
	-- Concatenate error messages for all mismatched fields
	RTRIM(
		CASE
			WHEN rec.OBJECTID = s.OBJECT_ID THEN ''
			ELSE 'OBJECT_ID;'
		END || CASE
			WHEN rec.SQUATTERID = s.squatter_id THEN ''
			ELSE 'SQUATTER_ID;'
		END || CASE
			WHEN NVL(rec.DIMENSION_L, -1) = NVL(s.dimensions_l, -1) THEN ''
			ELSE 'DIMENSIONS_L;'
		END || CASE
			WHEN NVL(rec.DIMENSION_B, -1) = NVL(s.dimensions_b, -1) THEN ''
			ELSE 'DIMENSIONS_B'
		END || CASE
			WHEN NVL(rec.DIMENSION_H, -1) = NVL(s.dimensions_h, -1) THEN ''
			ELSE 'DIMENSIONS_H'
		END || CASE
			WHEN rec.LOCATION = s.survey_location THEN ''
			ELSE 'SURVEY_LOCATION;'
		END || CASE
			WHEN rec.FILENAME = s.file_name THEN ''
			ELSE 'FILE_NAME;'
		END || CASE
			WHEN rec.STATUS = s.status THEN ''
			ELSE 'STATUS;'
		END || CASE
			WHEN rec.SQUATTERDISTRICT = s.district THEN ''
			ELSE 'DISTRICT;'
		END || CASE
			WHEN rec.PLANFILENAME = s.SC_PLAN_NO THEN ''
			ELSE 'PLAN_FILE_NAME;'
		END || CASE
			WHEN rec.CREATED_USER = s.created_user THEN ''
			ELSE 'CREATED_USER;'
		END || CASE
			WHEN rec.LAST_EDITED_USER = s.last_edited_user THEN ''
			ELSE 'LAST_EDITED_USER;'
		END || CASE
			WHEN rec.LAST_EDITED_DATE = s.last_edited_date THEN ''
			ELSE 'LAST_EDITED_DATE;'
		END || CASE
			WHEN rec.CISSQUATTERID = s.cis_squatter_id THEN ''
			ELSE 'CIS_SQUATTER_ID;'
		END || CASE
			WHEN NVL(rec.BOOKNO, 'NULL') = NVL(s.book_no, 'NULL') THEN ''
			ELSE 'BOOK_NO;'
		END || CASE
			WHEN NVL(rec.SERIALNO,'NULL') = NVL(s.serial_no,'NULL') THEN ''
			ELSE 'SERIAL_NO;'
		END || CASE
			WHEN NVL(rec.SURVEYNO, 'NULL') = NVL(s.survey_no, 'NULL') THEN ''
			ELSE 'SURVEY_NO;'
		END || CASE
			WHEN NVL(rec.FILEREF, 'NULL') = NVL(s.case_reference, 'NULL') THEN ''
			ELSE 'CASE_REFERENCE;'
		END || CASE
			WHEN NVL(rec.ISSUE, -1) = NVL(s.DATA_PROBLEM, -1) THEN ''
			ELSE 'ISSUE;'
		END || CASE
			WHEN rec.SCOFFICE = s.sc_office THEN ''
			ELSE 'SC_OFFICE;'
		END || CASE
			WHEN NVL(rec.SURVEYNOPREFIX, 'NULL') = NVL(s.survey_no_prefix, 'NULL') THEN ''
			ELSE 'SURVEY_NO_PREFIX;'
		END || CASE
			WHEN NVL(rec.HASREMARK, 'NULL') = NVL(s.has_remark, 'NULL') THEN ''
			ELSE 'HAS_REMARK;'
		END || CASE
			WHEN NVL(rec.HOUSENO, -1) = NVL(s.house_no, -1) THEN ''
			ELSE 'HOUSE_NO;'
		END || CASE
			WHEN NVL(rec.DISPLAYNAME, 'NULL') = NVL(s.display_name, 'NULL') THEN ''
			ELSE 'DISPLAY_NAME;'
		END || CASE
			WHEN rec.BOUNDARYSTATUS = s.CERTAINTY_OF_DIGITIZED_POLYGON THEN ''
			ELSE 'BOUNDARY_STATUS;'
		END || CASE
			WHEN rec.DIMENSIONUNIT = s.units THEN ''
			ELSE 'UNITS;'
		END || CASE
			WHEN NVL(rec.SERIALNO_EDIT, 'NULL') = NVL(s.serial_no_edit, 'NULL') THEN ''
			ELSE 'SERIAL_NO_EDIT;'
		END || CASE
			WHEN NVL(
				rec.RECORDDATE_EDIT,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.HD161FORM_RECORD_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'RECORD_DATE_EDIT;'
		END || CASE
			WHEN NVL(rec.DELETE_REASON, -1) = NVL(s.DELETE_REASON, -1) THEN ''
			ELSE 'DELETE_REASON;'
		END || CASE
			WHEN NVL(
				rec.DELETE_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.delete_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'DELETE_DATE;'
		END || CASE
			WHEN NVL(
				rec.REINSTATE_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.re_instate_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'RE_INSTATE_DATE;'
		END || CASE
			WHEN rec.VERSION = s.version THEN ''
			ELSE 'VERSION;'
		END || CASE
			WHEN NVL(rec.SURVEYRECORD_1982, 'NULL') = NVL(s.survey_record1982, 'NULL') THEN ''
			ELSE 'SURVEY_RECORD_1982;'
		END || CASE
			WHEN NVL(
				rec.APPROVED_CREATION_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.approved_creation_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'APPROVED_CREATION_DATE;'
		END || CASE
			WHEN NVL(
				rec.APPROVED_DELETE_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.approved_delete_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'APPROVED_DELETE_DATE;'
		END || CASE
			WHEN NVL(
				rec.APPROVED_REINSTATE_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.approved_reinstate_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'APPROVED_REINSTATE_DATE;'
		END || CASE
			WHEN NVL(
				rec.APPROVED_AMEND_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.approved_amendment_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'APPROVED_AMENDMENT_DATE;'
		END || CASE
			WHEN NVL(rec.JOBNO, 'NULL') = NVL(s.job_no, 'NULL') THEN ''
			ELSE 'JOB_NO;'
		END || CASE
			WHEN NVL(rec.CLEARANCE_NO, 'NULL') = NVL(s.clearance_no, 'NULL') THEN ''
			ELSE 'CLEARANCE_NO;'
		END || CASE
			WHEN NVL(
				rec.AMEND_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.amend_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'AMEND_DATE;'
		END || CASE
			WHEN NVL(
				rec.CASEFILE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(s.case_file, TO_DATE('1900-01-01', 'YYYY-MM-DD')) THEN ''
			ELSE 'CASE_FILE;'
		END || CASE
			WHEN NVL(
				rec.RECORDDATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.record_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'RECORD_DATE;'
		END || CASE
			WHEN NVL(
				rec.CREATED_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.created_at,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'CREATED_DATE;'
		END || CASE
			WHEN NVL(
				rec.LAST_EDITED_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.updated_at,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'UPDATED_AT;'
		END,
		'; '
	),
	CASE
		WHEN (
		CASE
			WHEN rec.OBJECTID = s.OBJECT_ID THEN ''
			ELSE 'OBJECT_ID;'
		END || CASE
			WHEN rec.SQUATTERID = s.squatter_id THEN ''
			ELSE 'SQUATTER_ID;'
		END || CASE
			WHEN NVL(rec.DIMENSION_L, -1) = NVL(s.dimensions_l, -1) THEN ''
			ELSE 'DIMENSIONS_L;'
		END || CASE
			WHEN NVL(rec.DIMENSION_B, -1) = NVL(s.dimensions_b, -1) THEN ''
			ELSE 'DIMENSIONS_B'
		END || CASE
			WHEN NVL(rec.DIMENSION_H, -1) = NVL(s.dimensions_h, -1) THEN ''
			ELSE 'DIMENSIONS_H'
		END || CASE
			WHEN rec.LOCATION = s.survey_location THEN ''
			ELSE 'SURVEY_LOCATION;'
		END || CASE
			WHEN rec.FILENAME = s.file_name THEN ''
			ELSE 'FILE_NAME;'
		END || CASE
			WHEN rec.STATUS = s.status THEN ''
			ELSE 'STATUS;'
		END || CASE
			WHEN rec.SQUATTERDISTRICT = s.district THEN ''
			ELSE 'DISTRICT;'
		END || CASE
			WHEN rec.PLANFILENAME = s.SC_PLAN_NO THEN ''
			ELSE 'PLAN_FILE_NAME;'
		END || CASE
			WHEN rec.CREATED_USER = s.created_user THEN ''
			ELSE 'CREATED_USER;'
		END || CASE
			WHEN rec.LAST_EDITED_USER = s.last_edited_user THEN ''
			ELSE 'LAST_EDITED_USER;'
		END || CASE
			WHEN rec.LAST_EDITED_DATE = s.last_edited_date THEN ''
			ELSE 'LAST_EDITED_DATE;'
		END || CASE
			WHEN rec.CISSQUATTERID = s.cis_squatter_id THEN ''
			ELSE 'CIS_SQUATTER_ID;'
		END || CASE
			WHEN NVL(rec.BOOKNO, 'NULL') = NVL(s.book_no, 'NULL') THEN ''
			ELSE 'BOOK_NO;'
		END || CASE
			WHEN NVL(rec.SERIALNO,'NULL') = NVL(s.serial_no,'NULL') THEN ''
			ELSE 'SERIAL_NO;'
		END || CASE
			WHEN NVL(rec.SURVEYNO, 'NULL') = NVL(s.survey_no, 'NULL') THEN ''
			ELSE 'SURVEY_NO;'
		END || CASE
			WHEN NVL(rec.FILEREF, 'NULL') = NVL(s.case_reference, 'NULL') THEN ''
			ELSE 'CASE_REFERENCE;'
		END || CASE
			WHEN NVL(rec.ISSUE, -1) = NVL(s.DATA_PROBLEM, -1) THEN ''
			ELSE 'ISSUE;'
		END || CASE
			WHEN rec.SCOFFICE = s.sc_office THEN ''
			ELSE 'SC_OFFICE;'
		END || CASE
			WHEN NVL(rec.SURVEYNOPREFIX, 'NULL') = NVL(s.survey_no_prefix, 'NULL') THEN ''
			ELSE 'SURVEY_NO_PREFIX;'
		END || CASE
			WHEN NVL(rec.HASREMARK, 'NULL') = NVL(s.has_remark, 'NULL') THEN ''
			ELSE 'HAS_REMARK;'
		END || CASE
			WHEN NVL(rec.HOUSENO, -1) = NVL(s.house_no, -1) THEN ''
			ELSE 'HOUSE_NO;'
		END || CASE
			WHEN NVL(rec.DISPLAYNAME, 'NULL') = NVL(s.display_name, 'NULL') THEN ''
			ELSE 'DISPLAY_NAME;'
		END || CASE
			WHEN rec.BOUNDARYSTATUS = s.CERTAINTY_OF_DIGITIZED_POLYGON THEN ''
			ELSE 'BOUNDARY_STATUS;'
		END || CASE
			WHEN rec.DIMENSIONUNIT = s.units THEN ''
			ELSE 'UNITS;'
		END || CASE
			WHEN NVL(rec.SERIALNO_EDIT, 'NULL') = NVL(s.serial_no_edit, 'NULL') THEN ''
			ELSE 'SERIAL_NO_EDIT;'
		END || CASE
			WHEN NVL(
				rec.RECORDDATE_EDIT,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.HD161FORM_RECORD_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'RECORD_DATE_EDIT;'
		END || CASE
			WHEN NVL(rec.DELETE_REASON, -1) = NVL(s.DELETE_REASON, -1) THEN ''
			ELSE 'DELETE_REASON;'
		END || CASE
			WHEN NVL(
				rec.DELETE_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.delete_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'DELETE_DATE;'
		END || CASE
			WHEN NVL(
				rec.REINSTATE_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.re_instate_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'RE_INSTATE_DATE;'
		END || CASE
			WHEN rec.VERSION = s.version THEN ''
			ELSE 'VERSION;'
		END || CASE
			WHEN NVL(rec.SURVEYRECORD_1982, 'NULL') = NVL(s.survey_record1982, 'NULL') THEN ''
			ELSE 'SURVEY_RECORD_1982;'
		END || CASE
			WHEN NVL(
				rec.APPROVED_CREATION_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.approved_creation_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'APPROVED_CREATION_DATE;'
		END || CASE
			WHEN NVL(
				rec.APPROVED_DELETE_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.approved_delete_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'APPROVED_DELETE_DATE;'
		END || CASE
			WHEN NVL(
				rec.APPROVED_REINSTATE_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.approved_reinstate_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'APPROVED_REINSTATE_DATE;'
		END || CASE
			WHEN NVL(
				rec.APPROVED_AMEND_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.approved_amendment_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'APPROVED_AMENDMENT_DATE;'
		END || CASE
			WHEN NVL(rec.JOBNO, 'NULL') = NVL(s.job_no, 'NULL') THEN ''
			ELSE 'JOB_NO;'
		END || CASE
			WHEN NVL(rec.CLEARANCE_NO, 'NULL') = NVL(s.clearance_no, 'NULL') THEN ''
			ELSE 'CLEARANCE_NO;'
		END || CASE
			WHEN NVL(
				rec.AMEND_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.amend_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'AMEND_DATE;'
		END || CASE
			WHEN NVL(
				rec.CASEFILE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(s.case_file, TO_DATE('1900-01-01', 'YYYY-MM-DD')) THEN ''
			ELSE 'CASE_FILE;'
		END || CASE
			WHEN NVL(
				rec.RECORDDATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.record_date,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'RECORD_DATE;'
		END || CASE
			WHEN NVL(
				rec.CREATED_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.created_at,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'CREATED_DATE;'
		END || CASE
			WHEN NVL(
				rec.LAST_EDITED_DATE,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) = NVL(
				s.updated_at,
				TO_DATE('1900-01-01', 'YYYY-MM-DD')
			) THEN ''
			ELSE 'UPDATED_AT;'
		END
	) IS NULL THEN 1
		ELSE 0
	END AS is_valid
FROM SDE_SQ.SQUATTER rec
	LEFT JOIN SQ.SQUATTERS s ON rec.OBJECTID = s.object_id
WHERE quantity = 0
	OR ROWNUM <= quantity;
-- Commit transaction
COMMIT;
END;
SELECT *
FROM data_validation_squatters;