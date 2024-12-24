-- PART 1: CHK_GLL_DETAILS: detail checking of GLL
-- 1.1 Remove table if exist
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE CHK_GLL_DETAILS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

-- 1.2 Create table recording checking details
CREATE TABLE CHK_GLL_DETAILS AS 
WITH selected AS (
    SELECT objectid
    FROM (
        SELECT 
            sg.objectid,
            dense_rank() OVER (PARTITION BY sg.dlooffice ORDER BY sg.objectid) AS rnk 
        FROM SDE.GOVERNMENTLANDLICENCE sg
    )
    WHERE rnk <= 100
), sde_glls AS (
    SELECT sg.*
    FROM SDE.GOVERNMENTLANDLICENCE sg 
    JOIN selected se ON sg.objectid = se.objectid
), gll_glls AS (
    SELECT
		gg.objectid_d 								AS OBJECTID, 
		d.dlo_name									AS DLOOFFICE, 
		gg.gll_no									AS GLLNUMBER, 
		gg.LOCATION_OF_LAND							AS LOCATION, 
		gg.ROOFEDAREA_D								AS ROOFEDAREA, 
		gg.ROOFEDAREAUNIT_D							AS ROOFEDAREAUNIT, 
		gg.OPENSPACEAREA_D							AS OPENSPACEAREA, 
		gg.OPENSPACEAREAUNIT_D						AS OPENSPACEAREAUNIT, 
		gg.TOTAL_AREA								AS TOTALAREA, 
		gg.TOTAL_AREA_TYPE							AS TOTALAREAUNIT, 
		gg.COMMENCEMENT_DATE						AS COMMENCEMENTDATE, 
		gg.PERIOD									AS PERIOD, 
		gg.EXPIRY_DATE								AS EXPIRYDATE, 
		gg.PURPOSE									AS GLLPURPOSE, 
		gg.TYPEOFPERMIT_D							AS TYPEOFPERMIT, 
		gg.PLANAREA_D								AS PLANAREA, 
		gg.PLANAREAUNIT_D							AS PLANAREAUNIT, 
		gg.LICENSE_PLAN_NO							AS PLANNUMBER, 
		gg.REMARKS									AS REMARKS, 
		gg.GLL_STATUS								AS GLLSTATUS, 
		gg.TERMINATION_REASON						AS REASONSFORTERMINATION, 
		(SELECT URL FROM GLL.ATTACHMENTS a JOIN GLL.ATTACHMENT_GLL ag ON ag.ATTACHMENT_ID = a.ID JOIN GLL.GLLS g ON g.ID = ag.SCANNED_LICENSES_GLL_ID WHERE g.objectid_d = se.objectid)							AS FILEPATH, 
		gg.STTNUMBER_D								AS STTNUMBER, 
		gg.CASEID_D									AS CASE_ID, 
		gg.FORMERGLLNUMBER_D						AS FORMERGLLNUMBER, 
		gg.CREATED_AT								AS CREATIONDATE, 
		gg.UPDATED_AT								AS LASTAMENDMENTDATE, 
		gg.MODIFIEDBY_D								AS MODIFIEDBY, 
		gg.GLOBALID_D								AS GLOBALID, 
		gg.CISLICID_D								AS CISLICID, 
		gg.GOVERNMENTLANDLICENCEID_D				AS GOVERNMENTLANDLICENCEID, 
		gg.SCOFFICE_D								AS SCOFFICE, 
		gg.SC_NUMBER_AFFECTED						AS SCNUMBER, 
		gg.ANNUAL_FEE								AS ANNUALPERMITFEE, 
		(SELECT URL FROM GLL.ATTACHMENTS a JOIN GLL.ATTACHMENT_GLL ag ON ag.ATTACHMENT_ID = a.ID JOIN GLL.GLLS g ON g.ID = ag.SCANNED_SQUATTER_CONTROL_INFORMATIONS_GLL_ID WHERE g.objectid_d = se.objectid)			AS SCPath, 
		gg.ITEMSOFNTSPECIALRATES_D					AS ITEMSOFNTSPECIALRATES, 
		gg.ITEMSOFUASPECIALRATES_D					AS ITEMSOFUASPECIALRATES, 
		gg.LICENCEANDPERMITPOLYID_D					AS LICENCEANDPERMITPOLYID, 
		gg.AREA_REMARKS								AS AREAREMARKS, 
		gg.LICENSE_ENGLISH_NAME						AS LICENSEEENGLISH, 
		gg.LICENSE_CHINESE_NAME						AS LICENSEECHINESE, 
		gg.INPUTTED_BY								AS INPUTTEDBY, 
		gg.APPROVED_BY_POST_NAME					AS CHECKEDBY, 
		(SELECT URL FROM GLL.ATTACHMENTS a JOIN GLL.ATTACHMENT_GLL ag ON ag.ATTACHMENT_ID = a.ID JOIN GLL.GLLS g ON g.ID = ag.SCANNED_GLL_FEE_ASSESSMENT_SHEETS_GLL_ID WHERE g.objectid_d = se.objectid)							AS LICENCEFEEFILEPATH, 
		gg.TYPE_OF_LICENSE							AS FEATURECODE, 
		gg.CATEGORY_OF_LICENSE						AS LICENSECAT, 
		gg.LICENSEE_TYPE							AS LICENSEHELD, 
		gg.DEPARTMENT_D								AS DEPARTMENT, 
		gg.TOTALAREAMETRIC_D						AS TOTALAREAMETRIC, 
		(SELECT URL FROM GLL.ATTACHMENTS a JOIN GLL.ATTACHMENT_GLL ag ON ag.ATTACHMENT_ID = a.ID JOIN GLL.GLLS g ON g.ID = ag.SITE_INSPECTION_REPORTS_GLL_ID WHERE g.objectid_d = se.objectid)							AS SIRPath, 
		(SELECT URL FROM GLL.ATTACHMENTS a JOIN GLL.ATTACHMENT_GLL ag ON ag.ATTACHMENT_ID = a.ID JOIN GLL.GLLS g ON g.ID = ag.SQUATTER_OCCUPANTS_LETTERS_GLL_ID WHERE g.objectid_d = se.objectid)							AS RLPath, 
		gg.ISLINE_D									AS ISLINE
    FROM gll.GLLS gg 
    JOIN gll.DLOS d ON gg.dlo_id = d.id
    JOIN selected se ON gg.objectid_d = se.objectid
), details AS (
SELECT 
    s.objectid
    , s.DLOOFFICE
    , CASE WHEN nvl(s.DLOOFFICE, 0) = nvl(regexp_replace(regexp_replace(regexp_replace(g.DLOOFFICE, '(DLO\/)|(\&)|(TW\&)', ''), '^N$', 'ND'), '^EMS$', 'EM'), 0) THEN 'pass' ELSE 'fail' END AS DLOOFFICE_chk
    , CASE WHEN nvl(s.OBJECTID, 0) = nvl(g.OBJECTID, 0) THEN 'pass' ELSE 'fail' END AS OBJECTID_chk
    , CASE WHEN nvl(s.GLLNUMBER, 'null') = nvl(g.GLLNUMBER, 'null') THEN 'pass' ELSE 'fail' END AS GLLNUMBER_chk
    , CASE WHEN nvl(s.LOCATION, 'null') = nvl(g.LOCATION, 'null') THEN 'pass' ELSE 'fail' END AS LOCATION_chk
    , CASE WHEN nvl(s.ROOFEDAREA, 0) = nvl(g.ROOFEDAREA, 0) THEN 'pass' ELSE 'fail' END AS ROOFEDAREA_chk
    , CASE WHEN nvl(s.ROOFEDAREAUNIT, 'null') = nvl(g.ROOFEDAREAUNIT, 'null') THEN 'pass' ELSE 'fail' END AS ROOFEDAREAUNIT_chk
    , CASE WHEN nvl(s.OPENSPACEAREA, 0) = nvl(g.OPENSPACEAREA, 0) THEN 'pass' ELSE 'fail' END AS OPENSPACEAREA_chk
    , CASE WHEN nvl(s.OPENSPACEAREAUNIT, 'null') = nvl(g.OPENSPACEAREAUNIT, 'null') THEN 'pass' ELSE 'fail' END AS OPENSPACEAREAUNIT_chk
    , CASE WHEN nvl(s.TOTALAREA, 0) = nvl(g.TOTALAREA, 0) THEN 'pass' ELSE 'fail' END AS TOTALAREA_chk
    , CASE WHEN nvl(s.TOTALAREAUNIT, 'null') = nvl(g.TOTALAREAUNIT, 'null') THEN 'pass' ELSE 'fail' END AS TOTALAREAUNIT_chk
    , CASE WHEN nvl(s.COMMENCEMENTDATE, timestamp '2999-12-31 12:00:00.000') = nvl(g.COMMENCEMENTDATE, timestamp '2999-12-31 12:00:00.000') THEN 'pass' ELSE 'fail' END AS COMMENCEMENTDATE_chk
    , CASE WHEN nvl(s.PERIOD, 0) = nvl(g.PERIOD, 0) THEN 'pass' ELSE 'fail' END AS PERIOD_chk
    , CASE WHEN nvl(s.EXPIRYDATE, timestamp '2999-12-31 12:00:00.000') = nvl(g.EXPIRYDATE, timestamp '2999-12-31 12:00:00.000') THEN 'pass' ELSE 'fail' END AS EXPIRYDATE_chk
    , CASE WHEN nvl(s.GLLPURPOSE, 'null') = nvl(g.GLLPURPOSE, 'null') THEN 'pass' ELSE 'fail' END AS GLLPURPOSE_chk
    , CASE WHEN nvl(s.TYPEOFPERMIT, 'null') = nvl(g.TYPEOFPERMIT, 'null') THEN 'pass' ELSE 'fail' END AS TYPEOFPERMIT_chk
    , CASE WHEN nvl(s.PLANAREA, 0) = nvl(g.PLANAREA, 0) THEN 'pass' ELSE 'fail' END AS PLANAREA_chk
    , CASE WHEN nvl(s.PLANAREAUNIT, 'null') = nvl(g.PLANAREAUNIT, 'null') THEN 'pass' ELSE 'fail' END AS PLANAREAUNIT_chk
    , CASE WHEN nvl(s.PLANNUMBER, 0) = nvl(g.PLANNUMBER, 0) THEN 'pass' ELSE 'fail' END AS PLANNUMBER_chk
    , CASE WHEN nvl(s.REMARKS, 'null') = nvl(g.REMARKS, 'null') THEN 'pass' ELSE 'fail' END AS REMARKS_chk
    , CASE WHEN nvl(s.GLLSTATUS, 'null') = nvl(g.GLLSTATUS, 'null') THEN 'pass' ELSE 'fail' END AS GLLSTATUS_chk
    , CASE WHEN nvl(s.REASONSFORTERMINATION, 'null') = nvl(g.REASONSFORTERMINATION, 'null') THEN 'pass' ELSE 'fail' END AS REASONSFORTERMINATION_chk
    , CASE WHEN nvl(s.STTNUMBER, 0) = nvl(g.STTNUMBER, 0) THEN 'pass' ELSE 'fail' END AS STTNUMBER_chk
    , CASE WHEN nvl(s.CASE_ID, 'null') = nvl(g.CASE_ID, 'null') THEN 'pass' ELSE 'fail' END AS CASE_ID_chk
    , CASE WHEN nvl(s.FORMERGLLNUMBER, 0) = nvl(g.FORMERGLLNUMBER, 0) THEN 'pass' ELSE 'fail' END AS FORMERGLLNUMBER_chk
    , CASE WHEN nvl(s.CREATIONDATE,  timestamp '2999-12-31 12:00:00.000') = nvl(g.CREATIONDATE, timestamp '2999-12-31 12:00:00.000') THEN 'pass' ELSE 'fail' END AS CREATIONDATE_chk
    , CASE WHEN nvl(s.LASTAMENDMENTDATE, timestamp '2999-12-31 12:00:00.000') = nvl(g.LASTAMENDMENTDATE, timestamp '2999-12-31 12:00:00.000') THEN 'pass' ELSE 'fail' END AS LASTAMENDMENTDATE_chk
    , CASE WHEN nvl(s.MODIFIEDBY, 'null') = nvl(g.MODIFIEDBY, 'null') THEN 'pass' ELSE 'fail' END AS MODIFIEDBY_chk
    , CASE WHEN nvl(s.GLOBALID, 'null') = nvl(g.GLOBALID, 'null') THEN 'pass' ELSE 'fail' END AS GLOBALID_chk
    , CASE WHEN nvl(s.CISLICID, 'null') = nvl(g.CISLICID, 'null') THEN 'pass' ELSE 'fail' END AS CISLICID_chk
    , CASE WHEN nvl(s.GOVERNMENTLANDLICENCEID, 0) = nvl(g.GOVERNMENTLANDLICENCEID, 0) THEN 'pass' ELSE 'fail' END AS GOVERNMENTLANDLICENCEID_chk
    , CASE WHEN nvl(s.SCOFFICE, 'null') = nvl(g.SCOFFICE, 'null') THEN 'pass' ELSE 'fail' END AS SCOFFICE_chk
    , CASE WHEN nvl(s.SCNUMBER, 'null') = nvl(g.SCNUMBER, 'null') THEN 'pass' ELSE 'fail' END AS SCNUMBER_chk
    , CASE WHEN nvl(regexp_replace(regexp_replace(s.ANNUALPERMITFEE, 'O', '0'), '['||chr(9)||chr(10)||chr(13)||'|\$|\,]|p.a.', ''), 'null') = nvl(g.ANNUALPERMITFEE, 'null') THEN 'pass' ELSE 'fail' END AS ANNUALPERMITFEE_chk
    , CASE WHEN nvl(s.ITEMSOFNTSPECIALRATES, 'null') = nvl(g.ITEMSOFNTSPECIALRATES, 'null') THEN 'pass' ELSE 'fail' END AS ITEMSOFNTSPECIALRATES_chk
    , CASE WHEN nvl(s.ITEMSOFUASPECIALRATES, 'null') = nvl(g.ITEMSOFUASPECIALRATES, 'null') THEN 'pass' ELSE 'fail' END AS ITEMSOFUASPECIALRATES_chk
    , CASE WHEN nvl(s.LICENCEANDPERMITPOLYID, 0) = nvl(g.LICENCEANDPERMITPOLYID, 0) THEN 'pass' ELSE 'fail' END AS LICENCEANDPERMITPOLYID_chk
    , CASE WHEN nvl(s.AREAREMARKS, 'null') = nvl(g.AREAREMARKS, 'null') THEN 'pass' ELSE 'fail' END AS AREAREMARKS_chk
    , CASE WHEN nvl(s.LICENSEEENGLISH, 'null') = nvl(g.LICENSEEENGLISH, 'null') THEN 'pass' ELSE 'fail' END AS LICENSEEENGLISH_chk
    , CASE WHEN nvl(s.LICENSEECHINESE, 'null') = nvl(g.LICENSEECHINESE, 'null') THEN 'pass' ELSE 'fail' END AS LICENSEECHINESE_chk
    , CASE WHEN nvl(s.INPUTTEDBY, 'null') = nvl(g.INPUTTEDBY, 'null') THEN 'pass' ELSE 'fail' END AS INPUTTEDBY_chk
    , CASE WHEN nvl(s.CHECKEDBY, 'null') = nvl(g.CHECKEDBY, 'null') THEN 'pass' ELSE 'fail' END AS CHECKEDBY_chk
    , CASE WHEN nvl(s.FEATURECODE, 'null') = nvl(g.FEATURECODE, 'null') THEN 'pass' ELSE 'fail' END AS FEATURECODE_chk
    , CASE WHEN nvl(s.LICENSECAT, 'null') = nvl(g.LICENSECAT, 'null') THEN 'pass' ELSE 'fail' END LICENSECAT_chk
    , CASE WHEN nvl(s.LICENSEHELD, 'null') = nvl(g.LICENSEHELD, 'null') THEN 'pass' ELSE 'fail' END AS LICENSEHELD_chk
    , CASE WHEN nvl(s.DEPARTMENT, 'null') = nvl(g.DEPARTMENT, 'null') THEN 'pass' ELSE 'fail' END AS DEPARTMENT_chk
    , CASE WHEN nvl(s.TOTALAREAMETRIC, 0) = nvl(g.TOTALAREAMETRIC, 0) THEN 'pass' ELSE 'fail' END AS TOTALAREAMETRIC_chk
    , CASE WHEN nvl(s.ISLINE, 'null') = nvl(g.ISLINE, 'null') THEN 'pass' ELSE 'fail' END AS ISLINE_chk
    , CASE WHEN nvl(s.FILEPATH, 'null') = nvl(g.FILEPATH, 'null') THEN 'pass' ELSE 'fail' END AS FILEPATH_chk
    , CASE WHEN nvl(s.SCPATH, 'null') = nvl(g.SCPATH, 'null') THEN 'pass' ELSE 'fail' END AS FSCPATH_chk
    , CASE WHEN nvl(s.LICENCEFEEFILEPATH, 'null') = nvl(g.LICENCEFEEFILEPATH, 'null') THEN 'pass' ELSE 'fail' END AS LICENCEFEEFILEPATH_chk
    , CASE WHEN nvl(s.SIRPATH, 'null') = nvl(g.SIRPATH, 'null') THEN 'pass' ELSE 'fail' END AS SIRPATH_chk
    , CASE WHEN nvl(s.RLPATH, 'null') = nvl(g.RLPath, 'null') THEN 'pass' ELSE 'fail' END AS RLPath_chk
FROM sde_glls s
FULL OUTER JOIN gll_glls g ON s.objectid = g.objectid
ORDER BY s.dlooffice
)
SELECT * 
FROM details d
; 

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
-- PART 2: CHK_GLL_SUMMARY: record the passing rate of on GLL checking
-- 1.1 Remove table if exist
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE CHK_GLL_SUMMARY';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

-- 1.2 Create table passing rate of on GLL checking

CREATE TABLE CHK_GLL_SUMMARY AS 
WITH selected AS (
    SELECT objectid
    FROM (
        SELECT 
            sg.objectid,
            dense_rank() OVER (PARTITION BY sg.dlooffice ORDER BY sg.objectid) AS rnk 
        FROM SDE.GOVERNMENTLANDLICENCE sg
    )
    WHERE rnk <= 100
), sde_glls AS (
    SELECT sg.*
    FROM SDE.GOVERNMENTLANDLICENCE sg 
    JOIN selected se ON sg.objectid = se.objectid
), gll_glls AS (
    SELECT
		gg.objectid_d 								AS OBJECTID, 
		d.dlo_name									AS DLOOFFICE, 
		gg.gll_no									AS GLLNUMBER, 
		gg.LOCATION_OF_LAND							AS LOCATION, 
		gg.ROOFEDAREA_D								AS ROOFEDAREA, 
		gg.ROOFEDAREAUNIT_D							AS ROOFEDAREAUNIT, 
		gg.OPENSPACEAREA_D							AS OPENSPACEAREA, 
		gg.OPENSPACEAREAUNIT_D						AS OPENSPACEAREAUNIT, 
		gg.TOTAL_AREA								AS TOTALAREA, 
		gg.TOTAL_AREA_TYPE							AS TOTALAREAUNIT, 
		gg.COMMENCEMENT_DATE						AS COMMENCEMENTDATE, 
		gg.PERIOD									AS PERIOD, 
		gg.EXPIRY_DATE								AS EXPIRYDATE, 
		gg.PURPOSE									AS GLLPURPOSE, 
		gg.TYPEOFPERMIT_D							AS TYPEOFPERMIT, 
		gg.PLANAREA_D								AS PLANAREA, 
		gg.PLANAREAUNIT_D							AS PLANAREAUNIT, 
		gg.LICENSE_PLAN_NO							AS PLANNUMBER, 
		gg.REMARKS									AS REMARKS, 
		gg.GLL_STATUS								AS GLLSTATUS, 
		gg.TERMINATION_REASON						AS REASONSFORTERMINATION, 
		(SELECT URL FROM GLL.ATTACHMENTS a JOIN GLL.ATTACHMENT_GLL ag ON ag.ATTACHMENT_ID = a.ID JOIN GLL.GLLS g ON g.ID = ag.SCANNED_LICENSES_GLL_ID WHERE g.objectid_d = se.objectid)							AS FILEPATH, 
		gg.STTNUMBER_D								AS STTNUMBER, 
		gg.CASEID_D									AS CASE_ID, 
		gg.FORMERGLLNUMBER_D						AS FORMERGLLNUMBER, 
		gg.CREATED_AT								AS CREATIONDATE, 
		gg.UPDATED_AT								AS LASTAMENDMENTDATE, 
		gg.MODIFIEDBY_D								AS MODIFIEDBY, 
		gg.GLOBALID_D								AS GLOBALID, 
		gg.CISLICID_D								AS CISLICID, 
		gg.GOVERNMENTLANDLICENCEID_D				AS GOVERNMENTLANDLICENCEID, 
		gg.SCOFFICE_D								AS SCOFFICE, 
		gg.SC_NUMBER_AFFECTED						AS SCNUMBER, 
		gg.ANNUAL_FEE								AS ANNUALPERMITFEE, 
		(SELECT URL FROM GLL.ATTACHMENTS a JOIN GLL.ATTACHMENT_GLL ag ON ag.ATTACHMENT_ID = a.ID JOIN GLL.GLLS g ON g.ID = ag.SCANNED_SQUATTER_CONTROL_INFORMATIONS_GLL_ID WHERE g.objectid_d = se.objectid)			AS SCPath, 
		gg.ITEMSOFNTSPECIALRATES_D					AS ITEMSOFNTSPECIALRATES, 
		gg.ITEMSOFUASPECIALRATES_D					AS ITEMSOFUASPECIALRATES, 
		gg.LICENCEANDPERMITPOLYID_D					AS LICENCEANDPERMITPOLYID, 
		gg.AREA_REMARKS								AS AREAREMARKS, 
		gg.LICENSE_ENGLISH_NAME						AS LICENSEEENGLISH, 
		gg.LICENSE_CHINESE_NAME						AS LICENSEECHINESE, 
		gg.INPUTTED_BY								AS INPUTTEDBY, 
		gg.APPROVED_BY_POST_NAME					AS CHECKEDBY, 
		(SELECT URL FROM GLL.ATTACHMENTS a JOIN GLL.ATTACHMENT_GLL ag ON ag.ATTACHMENT_ID = a.ID JOIN GLL.GLLS g ON g.ID = ag.SCANNED_GLL_FEE_ASSESSMENT_SHEETS_GLL_ID WHERE g.objectid_d = se.objectid)							AS LICENCEFEEFILEPATH, 
		gg.TYPE_OF_LICENSE							AS FEATURECODE, 
		gg.CATEGORY_OF_LICENSE						AS LICENSECAT, 
		gg.LICENSEE_TYPE							AS LICENSEHELD, 
		gg.DEPARTMENT_D								AS DEPARTMENT, 
		gg.TOTALAREAMETRIC_D						AS TOTALAREAMETRIC, 
		(SELECT URL FROM GLL.ATTACHMENTS a JOIN GLL.ATTACHMENT_GLL ag ON ag.ATTACHMENT_ID = a.ID JOIN GLL.GLLS g ON g.ID = ag.SITE_INSPECTION_REPORTS_GLL_ID WHERE g.objectid_d = se.objectid)							AS SIRPath, 
		(SELECT URL FROM GLL.ATTACHMENTS a JOIN GLL.ATTACHMENT_GLL ag ON ag.ATTACHMENT_ID = a.ID JOIN GLL.GLLS g ON g.ID = ag.SQUATTER_OCCUPANTS_LETTERS_GLL_ID WHERE g.objectid_d = se.objectid)							AS RLPath, 
		gg.ISLINE_D									AS ISLINE
    FROM gll.GLLS gg 
    JOIN gll.DLOS d ON gg.dlo_id = d.id
    JOIN selected se ON gg.objectid_d = se.objectid
), details as (
    SELECT 
        s.objectid
        , s.DLOOFFICE
        , CASE WHEN nvl(s.DLOOFFICE, 0) = nvl(regexp_replace(regexp_replace(regexp_replace(g.DLOOFFICE, '(DLO\/)|(\&)|(TW\&)', ''), '^N$', 'ND'), '^EMS$', 'EM'), 0) THEN 1 ELSE 0 END AS DLOOFFICE_chk
        , CASE WHEN nvl(s.OBJECTID, 0) = nvl(g.OBJECTID, 0) THEN 1 ELSE 0 END AS OBJECTID_chk
        , CASE WHEN nvl(s.GLLNUMBER, 'null') = nvl(g.GLLNUMBER, 'null') THEN 1 ELSE 0 END AS GLLNUMBER_chk
        , CASE WHEN nvl(s.LOCATION, 'null') = nvl(g.LOCATION, 'null') THEN 1 ELSE 0 END AS LOCATION_chk
        , CASE WHEN nvl(s.ROOFEDAREA, 0) = nvl(g.ROOFEDAREA, 0) THEN 1 ELSE 0 END AS ROOFEDAREA_chk
        , CASE WHEN nvl(s.ROOFEDAREAUNIT, 'null') = nvl(g.ROOFEDAREAUNIT, 'null') THEN 1 ELSE 0 END AS ROOFEDAREAUNIT_chk
        , CASE WHEN nvl(s.OPENSPACEAREA, 0) = nvl(g.OPENSPACEAREA, 0) THEN 1 ELSE 0 END AS OPENSPACEAREA_chk
        , CASE WHEN nvl(s.OPENSPACEAREAUNIT, 'null') = nvl(g.OPENSPACEAREAUNIT, 'null') THEN 1 ELSE 0 END AS OPENSPACEAREAUNIT_chk
        , CASE WHEN nvl(s.TOTALAREA, 0) = nvl(g.TOTALAREA, 0) THEN 1 ELSE 0 END AS TOTALAREA_chk
        , CASE WHEN nvl(s.TOTALAREAUNIT, 'null') = nvl(g.TOTALAREAUNIT, 'null') THEN 1 ELSE 0 END AS TOTALAREAUNIT_chk
        , CASE WHEN nvl(s.COMMENCEMENTDATE, timestamp '2999-12-31 12:00:00.000') = nvl(g.COMMENCEMENTDATE, timestamp '2999-12-31 12:00:00.000') THEN 1 ELSE 0 END AS COMMENCEMENTDATE_chk
        , CASE WHEN nvl(s.PERIOD, 0) = nvl(g.PERIOD, 0) THEN 1 ELSE 0 END AS PERIOD_chk
        , CASE WHEN nvl(s.EXPIRYDATE, timestamp '2999-12-31 12:00:00.000') = nvl(g.EXPIRYDATE, timestamp '2999-12-31 12:00:00.000') THEN 1 ELSE 0 END AS EXPIRYDATE_chk
        , CASE WHEN nvl(s.GLLPURPOSE, 'null') = nvl(g.GLLPURPOSE, 'null') THEN 1 ELSE 0 END AS GLLPURPOSE_chk
        , CASE WHEN nvl(s.TYPEOFPERMIT, 'null') = nvl(g.TYPEOFPERMIT, 'null') THEN 1 ELSE 0 END AS TYPEOFPERMIT_chk
        , CASE WHEN nvl(s.PLANAREA, 0) = nvl(g.PLANAREA, 0) THEN 1 ELSE 0 END AS PLANAREA_chk
        , CASE WHEN nvl(s.PLANAREAUNIT, 'null') = nvl(g.PLANAREAUNIT, 'null') THEN 1 ELSE 0 END AS PLANAREAUNIT_chk
        , CASE WHEN nvl(s.PLANNUMBER, 0) = nvl(g.PLANNUMBER, 0) THEN 1 ELSE 0 END AS PLANNUMBER_chk
        , CASE WHEN nvl(s.REMARKS, 'null') = nvl(g.REMARKS, 'null') THEN 1 ELSE 0 END AS REMARKS_chk
        , CASE WHEN nvl(s.GLLSTATUS, 'null') = nvl(g.GLLSTATUS, 'null') THEN 1 ELSE 0 END AS GLLSTATUS_chk
        , CASE WHEN nvl(s.REASONSFORTERMINATION, 'null') = nvl(g.REASONSFORTERMINATION, 'null') THEN 1 ELSE 0 END AS REASONSFORTERMINATION_chk
        , CASE WHEN nvl(s.STTNUMBER, 0) = nvl(g.STTNUMBER, 0) THEN 1 ELSE 0 END AS STTNUMBER_chk
        , CASE WHEN nvl(s.CASE_ID, 'null') = nvl(g.CASE_ID, 'null') THEN 1 ELSE 0 END AS CASE_ID_chk
        , CASE WHEN nvl(s.FORMERGLLNUMBER, 0) = nvl(g.FORMERGLLNUMBER, 0) THEN 1 ELSE 0 END AS FORMERGLLNUMBER_chk
        , CASE WHEN nvl(s.CREATIONDATE,  timestamp '2999-12-31 12:00:00.000') = nvl(g.CREATIONDATE, timestamp '2999-12-31 12:00:00.000') THEN 1 ELSE 0 END AS CREATIONDATE_chk
        , CASE WHEN nvl(s.LASTAMENDMENTDATE, timestamp '2999-12-31 12:00:00.000') = nvl(g.LASTAMENDMENTDATE, timestamp '2999-12-31 12:00:00.000') THEN 1 ELSE 0 END AS LASTAMENDMENTDATE_chk
        , CASE WHEN nvl(s.MODIFIEDBY, 'null') = nvl(g.MODIFIEDBY, 'null') THEN 1 ELSE 0 END AS MODIFIEDBY_chk
        , CASE WHEN nvl(s.GLOBALID, 'null') = nvl(g.GLOBALID, 'null') THEN 1 ELSE 0 END AS GLOBALID_chk
        , CASE WHEN nvl(s.CISLICID, 'null') = nvl(g.CISLICID, 'null') THEN 1 ELSE 0 END AS CISLICID_chk
        , CASE WHEN nvl(s.GOVERNMENTLANDLICENCEID, 0) = nvl(g.GOVERNMENTLANDLICENCEID, 0) THEN 1 ELSE 0 END AS GOVERNMENTLANDLICENCEID_chk
        , CASE WHEN nvl(s.SCOFFICE, 'null') = nvl(g.SCOFFICE, 'null') THEN 1 ELSE 0 END AS SCOFFICE_chk
        , CASE WHEN nvl(s.SCNUMBER, 'null') = nvl(g.SCNUMBER, 'null') THEN 1 ELSE 0 END AS SCNUMBER_chk
        , CASE WHEN nvl(regexp_replace(regexp_replace(s.ANNUALPERMITFEE, 'O', '0'), '['||chr(9)||chr(10)||chr(13)||'|\$|\,]|p.a.', ''), 'null') = nvl(g.ANNUALPERMITFEE, 'null') THEN 1 ELSE 0 END AS ANNUALPERMITFEE_chk
        , CASE WHEN nvl(s.ITEMSOFNTSPECIALRATES, 'null') = nvl(g.ITEMSOFNTSPECIALRATES, 'null') THEN 1 ELSE 0 END AS ITEMSOFNTSPECIALRATES_chk
        , CASE WHEN nvl(s.ITEMSOFUASPECIALRATES, 'null') = nvl(g.ITEMSOFUASPECIALRATES, 'null') THEN 1 ELSE 0 END AS ITEMSOFUASPECIALRATES_chk
        , CASE WHEN nvl(s.LICENCEANDPERMITPOLYID, 0) = nvl(g.LICENCEANDPERMITPOLYID, 0) THEN 1 ELSE 0 END AS LICENCEANDPERMITPOLYID_chk
        , CASE WHEN nvl(s.AREAREMARKS, 'null') = nvl(g.AREAREMARKS, 'null') THEN 1 ELSE 0 END AS AREAREMARKS_chk
        , CASE WHEN nvl(s.LICENSEEENGLISH, 'null') = nvl(g.LICENSEEENGLISH, 'null') THEN 1 ELSE 0 END AS LICENSEEENGLISH_chk
        , CASE WHEN nvl(s.LICENSEECHINESE, 'null') = nvl(g.LICENSEECHINESE, 'null') THEN 1 ELSE 0 END AS LICENSEECHINESE_chk
        , CASE WHEN nvl(s.INPUTTEDBY, 'null') = nvl(g.INPUTTEDBY, 'null') THEN 1 ELSE 0 END AS INPUTTEDBY_chk
        , CASE WHEN nvl(s.CHECKEDBY, 'null') = nvl(g.CHECKEDBY, 'null') THEN 1 ELSE 0 END AS CHECKEDBY_chk
        , CASE WHEN nvl(s.FEATURECODE, 'null') = nvl(g.FEATURECODE, 'null') THEN 1 ELSE 0 END AS FEATURECODE_chk
        , CASE WHEN nvl(s.LICENSECAT, 'null') = nvl(g.LICENSECAT, 'null') THEN 1 ELSE 0 END LICENSECAT_chk
        , CASE WHEN nvl(s.LICENSEHELD, 'null') = nvl(g.LICENSEHELD, 'null') THEN 1 ELSE 0 END AS LICENSEHELD_chk
        , CASE WHEN nvl(s.DEPARTMENT, 'null') = nvl(g.DEPARTMENT, 'null') THEN 1 ELSE 0 END AS DEPARTMENT_chk
        , CASE WHEN nvl(s.TOTALAREAMETRIC, 0) = nvl(g.TOTALAREAMETRIC, 0) THEN 1 ELSE 0 END AS TOTALAREAMETRIC_chk
        , CASE WHEN nvl(s.ISLINE, 'null') = nvl(g.ISLINE, 'null') THEN 1 ELSE 0 END AS ISLINE_chk
        , CASE WHEN nvl(s.FILEPATH, 'null') = nvl(g.FILEPATH, 'null') THEN 1 ELSE 0 END AS FILEPATH_chk
        , CASE WHEN nvl(s.SCPATH, 'null') = nvl(g.SCPATH, 'null') THEN 1 ELSE 0 END AS FSCPATH_chk
        , CASE WHEN nvl(s.LICENCEFEEFILEPATH, 'null') = nvl(g.LICENCEFEEFILEPATH, 'null') THEN 1 ELSE 0 END AS LICENCEFEEFILEPATH_chk
        , CASE WHEN nvl(s.SIRPATH, 'null') = nvl(g.SIRPATH, 'null') THEN 1 ELSE 0 END AS SIRPATH_chk
        , CASE WHEN nvl(s.RLPATH, 'null') = nvl(g.RLPath, 'null') THEN 1 ELSE 0 END AS RLPath_chk
    FROM sde_glls s
    FULL OUTER JOIN gll_glls g ON s.objectid = g.objectid
    ORDER BY s.dlooffice
)
select
        distinct d.DLOOFFICE
        , count(1) AS TOTAL_COUNT
        , 100 * sum(DLOOFFICE_chk) / count(1) || '%' as DLOOFFICE_pass_count
        , 100 * sum(OBJECTID_chk) / count(1) || '%' as OBJECTID_pass_count
        , 100 * sum(GLLNUMBER_chk) / count(1) || '%' as GLLNUMBER_pass_count
        , 100 * sum(LOCATION_chk) / count(1) || '%' as LOCATION_pass_count
        , 100 * sum(ROOFEDAREA_chk) / count(1) || '%' as ROOFEDAREA_pass_count
        , 100 * sum(ROOFEDAREAUNIT_chk) / count(1) || '%' as ROOFEDAREAUNIT_pass_count
        , 100 * sum(OPENSPACEAREA_chk) / count(1) || '%' as OPENSPACEAREA_pass_count
        , 100 * sum(OPENSPACEAREAUNIT_chk) / count(1) || '%' as OPENSPACEAREAUNIT_pass_count
        , 100 * sum(TOTALAREA_chk) / count(1) || '%' as TOTALAREA_pass_count
        , 100 * sum(TOTALAREAUNIT_chk) / count(1) || '%' as TOTALAREAUNIT_pass_count
        , 100 * sum(COMMENCEMENTDATE_chk) / count(1) || '%' as COMMENCEMENTDATE_pass_count
        , 100 * sum(PERIOD_chk) / count(1) || '%' as PERIOD_pass_count
        , 100 * sum(EXPIRYDATE_chk) / count(1) || '%' as EXPIRYDATE_pass_count
        , 100 * sum(GLLPURPOSE_chk) / count(1) || '%' as GLLPURPOSE_pass_count
        , 100 * sum(TYPEOFPERMIT_chk) / count(1) || '%' as TYPEOFPERMIT_pass_count
        , 100 * sum(PLANAREA_chk) / count(1) || '%' as PLANAREA_pass_count
        , 100 * sum(PLANAREAUNIT_chk) / count(1) || '%' as PLANAREAUNIT_pass_count
        , 100 * sum(PLANNUMBER_chk) / count(1) || '%' as PLANNUMBER_pass_count
        , 100 * sum(REMARKS_chk) / count(1) || '%' as REMARKS_pass_count
        , 100 * sum(GLLSTATUS_chk) / count(1) || '%' as GLLSTATUS_pass_count
        , 100 * sum(REASONSFORTERMINATION_chk) / count(1) || '%' as REASONSFORTERMINATION_pass_count
        , 100 * sum(STTNUMBER_chk) / count(1) || '%' as STTNUMBER_pass_count
        , 100 * sum(CASE_ID_chk) / count(1) || '%' as CASE_ID_pass_count
        , 100 * sum(FORMERGLLNUMBER_chk) / count(1) || '%' as FORMERGLLNUMBER_pass_count
        , 100 * sum(CREATIONDATE_chk) / count(1) || '%' as CREATIONDATE_pass_count
        , 100 * sum(LASTAMENDMENTDATE_chk) / count(1) || '%' as LASTAMENDMENTDATE_pass_count
        , 100 * sum(MODIFIEDBY_chk) / count(1) || '%' as MODIFIEDBY_pass_count
        , 100 * sum(GLOBALID_chk) / count(1) || '%' as GLOBALID_pass_count
        , 100 * sum(CISLICID_chk) / count(1) || '%' as CISLICID_pass_count
        , 100 * sum(GOVERNMENTLANDLICENCEID_chk) / count(1) || '%' as GOVERNMENTLANDLICENCEID_pass_count
        , 100 * sum(SCOFFICE_chk) / count(1) || '%' as SCOFFICE_pass_count
        , 100 * sum(SCNUMBER_chk) / count(1) || '%' as SCNUMBER_pass_count
        , 100 * sum(ANNUALPERMITFEE_chk) / count(1) || '%' as ANNUALPERMITFEE_pass_count
        , 100 * sum(ITEMSOFNTSPECIALRATES_chk) / count(1) || '%' as ITEMSOFNTSPECIALRATES_pass_count
        , 100 * sum(ITEMSOFUASPECIALRATES_chk) / count(1) || '%' as ITEMSOFUASPECIALRATES_pass_count
        , 100 * sum(LICENCEANDPERMITPOLYID_chk) / count(1) || '%' as LICENCEANDPERMITPOLYID_pass_count
        , 100 * sum(AREAREMARKS_chk) / count(1) || '%' as AREAREMARKS_pass_count
        , 100 * sum(LICENSEEENGLISH_chk) / count(1) || '%' as LICENSEEENGLISH_pass_count
        , 100 * sum(LICENSEECHINESE_chk) / count(1) || '%' as LICENSEECHINESE_pass_count
        , 100 * sum(INPUTTEDBY_chk) / count(1) || '%' as INPUTTEDBY_pass_count
        , 100 * sum(CHECKEDBY_chk) / count(1) || '%' as CHECKEDBY_pass_count
        , 100 * sum(FEATURECODE_chk) / count(1) || '%' as FEATURECODE_pass_count
        , 100 * sum(LICENSECAT_chk) / count(1) || '%' as LICENSECAT_pass_count
        , 100 * sum(LICENSEHELD_chk) / count(1) || '%' as LICENSEHELD_pass_count
        , 100 * sum(DEPARTMENT_chk) / count(1) || '%' as DEPARTMENT_pass_count
        , 100 * sum(TOTALAREAMETRIC_chk) / count(1) || '%' as TOTALAREAMETRIC_pass_count
        , 100 * sum(ISLINE_chk) / count(1) || '%' as ISLINE_pass_count
        , 100 * sum(FILEPATH_chk) / count(1) || '%' as FILEPATH_pass_count
        , 100 * sum(FSCPATH_chk) / count(1) || '%' as FSCPATH_pass_count
        , 100 * sum(LICENCEFEEFILEPATH_chk) / count(1) || '%' as LICENCEFEEFILEPATH_pass_count
        , 100 * sum(SIRPATH_chk) / count(1) || '%' as SIRPATH_pass_count
        , 100 * sum(RLPath_chk) / count(1) || '%' as RLPath_pass_count
from details d
group by d.DLOOFFICE
;