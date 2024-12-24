----------------------- Procedure to migrate a single GLL record -----------------------
--  [TODO]: debugging --
CREATE OR REPLACE PROCEDURE migrate_single_gll (
    p_source_id IN NUMBER
  , p_target_id OUT RAW
) AS
BEGIN
    MERGE INTO gll.glls ge USING (
        SELECT
            objectid                                                                                                     AS objectid_d
          , featurecode                                                                                                  AS type_of_license
          , arearemarks                                                                                                  AS area_remarks
          , period                                                                                                       AS period
          , licenseeenglish                                                                                              AS license_english_name
          , licenseechinese                                                                                              AS license_chinese_name
          , licenseheld                                                                                                  AS licensee_type
          , null                                                                                                         AS annual_type
 -- [UPDATED]: original / destination column are both varchar2. keep special descriptions. remove wired characters.
          , regexp_replace(regexp_replace(annualpermitfee, 'O', '0'), '['||chr(9)||chr(10)||chr(13)||'|\$|\,]|p.a.', '') AS annual_fee --handling character ',' in original data
          , scnumber                                                                                                     AS sc_number_affected
          , null                                                                                                         AS rate_items
          , null                                                                                                         AS special_rate
          , gllstatus                                                                                                    AS gll_status
          , reasonsfortermination                                                                                        AS termination_reason
          , null                                                                                                         AS termination_remarks
          , inputtedby                                                                                                   AS inputted_by
          , checkedby                                                                                                    AS approved_by
          , creationdate                                                                                                 AS created_at
          , lastamendmentdate                                                                                            AS updated_at
          , null                                                                                                         AS polygon
          , null                                                                                                         AS polyline
          , null                                                                                                         AS e_folder_id
          , null                                                                                                         AS enforcement_case_id
          , null                                                                                                         AS date_of_re_issue
          , null                                                                                                         AS rate_area_d
          , null                                                                                                         AS rate_type_d
          , null                                                                                                         AS rate_code_d
          , null                                                                                                         AS rate_metric_d
          , dlooffice                                                                                                    AS dlooffice_d
          , gllnumber                                                                                                    AS gll_no
          , location                                                                                                     AS location_of_land
          , roofedarea                                                                                                   AS roofedarea_d
          , roofedareaunit                                                                                               AS roofedareaunit_d
          , openspacearea                                                                                                AS openspacearea_d
          , openspaceareaunit                                                                                            AS openspaceareaunit_d
          , licensecat                                                                                                   AS category_of_license
          , totalarea                                                                                                    AS total_area
          , totalareaunit                                                                                                AS total_area_type
          , commencementdate                                                                                             AS commencement_date
          , expirydate                                                                                                   AS expiry_date
          , gllpurpose                                                                                                   AS purpose
          , typeofpermit                                                                                                 AS typeofpermit_d
          , planarea                                                                                                     AS planarea_d
          , planareaunit                                                                                                 AS planareaunit_d
          , plannumber                                                                                                   AS license_plan_no
          , remarks                                                                                                      AS remarks
          , sttnumber                                                                                                    AS sttnumber_d
          , case_id                                                                                                      AS caseid_d
          , formergllnumber                                                                                              AS formergllnumber_d
          , modifiedby                                                                                                   AS modifiedby_d
          , globalid                                                                                                     AS globalid_d
          , cislicid                                                                                                     AS cislicid_d
          , governmentlandlicenceid                                                                                      AS governmentlandlicenceid_d
          , scoffice                                                                                                     AS scoffice_d
          , itemsofntspecialrates                                                                                        AS itemsofntspecialrates_d
          , itemsofuaspecialrates                                                                                        AS itemsofuaspecialrates_d
          , licenceandpermitpolyid                                                                                       AS licenceandpermitpolyid_d
          , department                                                                                                   AS department_d
          , totalareametric                                                                                              AS totalareametric_d
          , isline                                                                                                       AS isline_d
          , null                                                                                                         AS date_of_termination
          , null                                                                                                         AS reason_of_re_issue
          , null                                                                                                         AS length_unit
          , null                                                                                                         AS total_length
        FROM
            sde_gll.governmentlandlicence
        WHERE
            objectid = p_source_id
    ) src ON (ge.objectid_d = src.objectid_d) WHEN MATCHED THEN UPDATE SET ge.type_of_license = src.type_of_license, ge.area_remarks = src.area_remarks, ge.period = src.period, ge.license_english_name = src.license_english_name, ge.license_chinese_name = src.license_chinese_name, ge.licensee_type = src.licensee_type, ge.annual_type = src.annual_type, ge.annual_fee = src.annual_fee, ge.sc_number_affected = src.sc_number_affected, ge.rate_items = src.rate_items, ge.special_rate = src.special_rate, ge.gll_status = src.gll_status, ge.termination_reason = src.termination_reason, ge.termination_remarks = src.termination_remarks, ge.inputted_by = src.inputted_by, ge.approved_by = src.approved_by, ge.created_at = src.created_at, ge.updated_at = src.updated_at, ge.polygon = src.polygon, ge.polyline = src.polyline, ge.e_folder_id = src.e_folder_id, ge.enforcement_case_id = src.enforcement_case_id, ge.date_of_re_issue = src.date_of_re_issue, ge.rate_area_d = src.rate_area_d, ge.rate_type_d = src.rate_type_d, ge.rate_code_d = src.rate_code_d, ge.rate_metric_d = src.rate_metric_d, ge.dlooffice_d = src.dlooffice_d, ge.gll_no = src.gll_no, ge.location_of_land = src.location_of_land, ge.roofedarea_d = src.roofedarea_d, ge.roofedareaunit_d = src.roofedareaunit_d, ge.openspacearea_d = src.openspacearea_d, ge.openspaceareaunit_d = src.openspaceareaunit_d, ge.category_of_license = src.category_of_license, ge.total_area = src.total_area, ge.total_area_type = src.total_area_type, ge.commencement_date = src.commencement_date, ge.expiry_date = src.expiry_date, ge.purpose = src.purpose, ge.typeofpermit_d = src.typeofpermit_d, ge.planarea_d = src.planarea_d, ge.planareaunit_d = src.planareaunit_d, ge.license_plan_no = src.license_plan_no, ge.remarks = src.remarks, ge.sttnumber_d = src.sttnumber_d, ge.caseid_d = src.caseid_d, ge.formergllnumber_d = src.formergllnumber_d, ge.modifiedby_d = src.modifiedby_d, ge.globalid_d = src.globalid_d, ge.cislicid_d = src.cislicid_d, ge.governmentlandlicenceid_d = src.governmentlandlicenceid_d, ge.scoffice_d = src.scoffice_d, ge.itemsofntspecialrates_d = src.itemsofntspecialrates_d, ge.itemsofuaspecialrates_d = src.itemsofuaspecialrates_d, ge.licenceandpermitpolyid_d = src.licenceandpermitpolyid_d, ge.department_d = src.department_d, ge.totalareametric_d = src.totalareametric_d, ge.isline_d = src.isline_d,
 -- Foreign keys set to NULL with comments
    -- GE.DLO_ID = NULL, -- DLOID: Should be mapped from DloEntity
    ge.dlo_id = (
        SELECT
            d.id
        FROM
            gll.dlos d
        WHERE
            regexp_replace(d.dlo_name, '(DLO\/)|(\&)|(TW\&)', '') = regexp_replace(regexp_replace(regexp_replace(src.dlooffice_d, '(DLO\/)|(\&)|(TW\&)', ''), 'ND', 'N'), 'EM', 'EMS')
    ), ge.creator_id = NULL, -- CREATORID: Should be mapped from PostEntity
    ge.updatetor_id = NULL, -- UPDATETORID: Should be mapped from PostEntity
    ge.iles_task_id = NULL, -- ILESTASKID: Should be mapped from appropriate table
    ge.old_gll_id = NULL -- OLDGLLID: Should be mapped from GllEntity (self-referencing)
    WHEN NOT MATCHED THEN INSERT ( id, objectid_d, type_of_license, area_remarks, period, license_english_name, license_chinese_name, licensee_type, annual_type, annual_fee, sc_number_affected, rate_items, special_rate, gll_status, termination_reason, termination_remarks, inputted_by, approved_by, created_at, updated_at, polygon, polyline, e_folder_id, enforcement_case_id, date_of_re_issue, rate_area_d, rate_type_d, rate_code_d, rate_metric_d, dlooffice_d, gll_no, location_of_land, roofedarea_d, roofedareaunit_d, openspacearea_d, openspaceareaunit_d, category_of_license, total_area, total_area_type, commencement_date, expiry_date, purpose, typeofpermit_d, planarea_d, planareaunit_d, license_plan_no, remarks, sttnumber_d, caseid_d, formergllnumber_d, modifiedby_d, globalid_d, cislicid_d, governmentlandlicenceid_d, scoffice_d, itemsofntspecialrates_d, itemsofuaspecialrates_d, licenceandpermitpolyid_d, department_d, totalareametric_d, isline_d,
 -- Foreign keys set to NULL with comments
    dlo_id, creator_id, updatetor_id, iles_task_id, old_gll_id ) VALUES ( sys_guid(), src.objectid_d, src.type_of_license, src.area_remarks, src.period, src.license_english_name, src.license_chinese_name, src.licensee_type, src.annual_type, src.annual_fee, src.sc_number_affected, src.rate_items, src.special_rate, src.gll_status, src.termination_reason, src.termination_remarks, src.inputted_by, src.approved_by, src.created_at, src.updated_at, src.polygon, src.polyline, src.e_folder_id, src.enforcement_case_id, src.date_of_re_issue, src.rate_area_d, src.rate_type_d, src.rate_code_d, src.rate_metric_d, src.dlooffice_d, src.gll_no, src.location_of_land, src.roofedarea_d, src.roofedareaunit_d, src.openspacearea_d, src.openspaceareaunit_d, src.category_of_license, src.total_area, src.total_area_type, src.commencement_date, src.expiry_date, src.purpose, src.typeofpermit_d, src.planarea_d, src.planareaunit_d, src.license_plan_no, src.remarks, src.sttnumber_d, src.caseid_d, src.formergllnumber_d, src.modifiedby_d, src.globalid_d, src.cislicid_d, src.governmentlandlicenceid_d, src.scoffice_d, src.itemsofntspecialrates_d, src.itemsofuaspecialrates_d, src.licenceandpermitpolyid_d, src.department_d, src.totalareametric_d, src.isline_d,
 -- Foreign keys set to NULL with comments
    (
        SELECT
            d.id
        FROM
            gll.dlos d
        WHERE
            regexp_replace(d.dlo_name, '(DLO\/)|(\&)|(TW\&)', '') = regexp_replace(regexp_replace(regexp_replace(src.dlooffice_d, '(DLO\/)|(\&)|(TW\&)', ''), 'ND', 'N'), 'EM', 'EMS')
    ), -- DLOID: Should be mapped from DloEntity
    NULL, -- CREATORID: Should be mapped from PostEntity
    NULL, -- UPDATETORID: Should be mapped from PostEntity
    NULL, -- ILESTASKID: Should be mapped from appropriate table
    NULL -- OLDGLLID: Should be mapped from GllEntity (self-referencing)
    );
    SELECT
        g.id INTO p_target_id
    FROM
        gll.glls g
    WHERE
        g.objectid_d = p_source_id;
    log_migration('GLLS', p_source_id, p_target_id, 'SUCCESS');
EXCEPTION
    WHEN OTHERS THEN
        log_migration('GLLS', p_source_id, NULL, 'FAILED', sqlerrm);
        raise;
END migrate_single_gll;