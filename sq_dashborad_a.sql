CREATE OR REPLACE VIEW SQUATTER_DASHBOARD AS
SELECT 
    s.ID,
    s.SQUATTER_ID AS SQUATTERID,
    s.DIMENSIONS_L AS DIMENSION_L,
    s.DIMENSIONS_B AS DIMENSION_B,
    s.DIMENSIONS_H AS DIMENSION_H,
    s.SQUATTER_LOCATION AS LOCATION,
    d.DLO_NAME AS DLOOFFICE,
    s.FILE_NAME AS FILENAME,
    s.STATUS,
    s.HD161FORM_RECORD_DATE_RAW AS RECORDDATE,
    s.DISTRICT AS SQUATTERDISTRICT,
    s.SC_PLAN_NO AS PLANFILENAME,
    s.CREATED_USER,
    s.CREATED_AT AS CREATED_DATE,
    s.LAST_EDITED_USER,
    s.UPDATED_AT AS LAST_EDITED_DATE,
    s.CIS_SQUATTER_ID AS CISSQUATTERID,
    s.BOOK_NO AS BOOKNO,
    s.SERIAL_NO AS SERIALNO,
    s.SURVEY_NO AS SURVEYNO,
    s.FILEREF,
    s.DATA_PROBLEM AS ISSUE,
    s.SC_OFFICE AS SCOFFICE,
    s.SURVEY_NO_PREFIX AS SURVEYNOPREFIX,
    s.HAS_REMARK,
    s.HOUSE_NO AS HOUSENO,
    s.DISPLAY_NAME AS DISPLAYNAME,
    s.CERTAINTY_OF_DIGITIZED_POLYGON AS BOUNDARYSTATUS,
    s.UNITS AS DIMENSIONUNIT,
    s.SERIAL_NO_EDIT AS SERIALNO_EDIT,
    s.HD161FORM_RECORD_DATE AS RECORDDATE_EDIT,
    s.JOB_NO AS JOBNO,
    s.APPROVED_WRITTEN_CREATION_DATE AS CREATION_DATE,
    s.CASE_FILE AS CASEFILE,
    s.APPROVED_AMENDMENT_DATE AS AMEND_DATE,
    s.DELETE_REASON,
    s.CLEARANCE_NO,
    s.APPROVED_WRITTEN_DELETE_DATE AS DELETE_DATE,
    s.APPROVED_WRITTEN_REINSTATE_DATE AS REINSTATE_DATE,
    s.APPROVE_STATUS,
    s.VERSION,
    s.SURVEY_RECORD1982 AS SURVEYRECORD_1982,
    s.APPROVED_CREATION_DATE,
    s.APPROVED_DELETE_DATE,
    s.APPROVED_REINSTATE_DATE,
    s.APPROVED_WRITTEN_AMENDMENT_DATE AS APPROVED_AMEND_DATE,
    s.SURVEY_No_PREFIX || s.SURVEY_NO AS SURVEYNOPREFIX_SURVEYNO,
    LISTAGG(CASE WHEN asq.TYPE = 'RepairRebuildNoti' THEN a.URL END, ', ') 
        WITHIN GROUP (ORDER BY a.URL) AS REPAIR_REBUILD,
    LISTAGG(CASE WHEN asq.TYPE = 'OccupantsVRNotiLetter' THEN a.URL END, ', ') 
        WITHIN GROUP (ORDER BY a.URL) AS VRS,
    LISTAGG(u.Name, ', ') WITHIN GROUP (ORDER BY u.Name) AS GIRS2_USE,
    LISTAGG(m.Name, ', ') WITHIN GROUP (ORDER BY m.Name) AS GIRS2_Material,
    sp.SHAPE,
    sp.GDB_GEOMATTR_DATA,
CASE 
        WHEN s.DISTRICT = 'LYM' THEN 'Lei Yue Mun'
        WHEN s.DISTRICT = 'TWKT' THEN 'Tsuen Wan and Kwai Tsing'
        WHEN s.DISTRICT = 'HK' THEN 'Hong Kong'
        WHEN s.DISTRICT = 'IS' THEN 'Islands'
        WHEN s.DISTRICT = 'SK' THEN 'Sai Kung'
        WHEN s.DISTRICT = 'TM' THEN 'Tuen Mun'
        WHEN s.DISTRICT = 'TP' THEN 'Tai Po'
        WHEN s.DISTRICT = 'YL' THEN 'Yuen Long'
        WHEN s.DISTRICT = 'ST' THEN 'Sha Tin'
        WHEN s.DISTRICT = 'K' THEN 'Kowloon'
        WHEN s.DISTRICT = 'N' THEN 'North'
        ELSE s.DISTRICT
    END AS DSO
FROM SQUATTERS s
LEFT JOIN DLOS d ON s.DLO_ID = d.ID
LEFT JOIN SQUATTER_USES sq ON s.ID = sq.SQUATTER_GUID
LEFT JOIN USES u ON sq.USE_ID = u.ID
LEFT JOIN SQUATTER_MATERIALS sm ON s.ID = sm.SQUATTER_GUID
LEFT JOIN MATERIALS m ON sm.MATERIAL_ID = m.ID
LEFT JOIN SQUATTER_POLY sp ON s.SQUATTER_ID = sp.SQUATTERID
LEFT JOIN ATTACHMENT_SQ asq ON s.ID = asq.SQUATTER_GUID
LEFT JOIN ATTACHMENT a ON asq.AttachmentId = a.ID

GROUP BY 
    s.ID, s.SQUATTER_ID, s.DIMENSIONS_L, s.DIMENSIONS_B, s.DIMENSIONS_H, 
    s.SQUATTER_LOCATION, d.DLO_NAME, s.FILE_NAME, s.STATUS, 
    s.HD161FORM_RECORD_DATE_RAW, s.DISTRICT, s.SC_PLAN_NO, 
    s.CREATED_USER, s.CREATED_AT, s.LAST_EDITED_USER, s.UPDATED_AT, 
    s.CIS_SQUATTER_ID, s.BOOK_NO, s.SERIAL_NO, s.SURVEY_NO, s.FILEREF, 
    s.DATA_PROBLEM, s.SC_OFFICE, s.SURVEY_NO_PREFIX, s.HAS_REMARK, 
    s.HOUSE_NO, s.DISPLAY_NAME, s.CERTAINTY_OF_DIGITIZED_POLYGON, 
    s.UNITS, s.SERIAL_NO_EDIT, s.HD161FORM_RECORD_DATE, s.JOB_NO, 
    s.APPROVED_WRITTEN_CREATION_DATE, s.CASE_FILE, s.APPROVED_AMENDMENT_DATE, 
    s.DELETE_REASON, s.CLEARANCE_NO, s.APPROVED_WRITTEN_DELETE_DATE, 
    s.APPROVED_WRITTEN_REINSTATE_DATE, s.APPROVE_STATUS, s.VERSION, 
    s.SURVEY_RECORD1982, s.APPROVED_CREATION_DATE, s.APPROVED_DELETE_DATE, 
    s.APPROVED_REINSTATE_DATE, s.APPROVED_WRITTEN_AMENDMENT_DATE, 
    s.SURVEY_No_PREFIX || s.SURVEY_NO, s.SURVEY_NO, sp.SHAPE, sp.GDB_GEOMATTR_DATA;


    -- SDE_STATE_ID            NUMBER(19),
    --    PDF_FILEPATH            NVARCHAR2(200) ??DMS\HD161?,
    --     VRS_PDF                 NVARCHAR2(2),
    -- REPAIR_REBUILD_PDF      NVARCHAR2(2),