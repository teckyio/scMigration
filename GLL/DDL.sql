--------------------------------------------------------
--  DDL for Table GLLS
--------------------------------------------------------

  CREATE TABLE "GLL"."GLLS" 
   (	"ID" RAW(16), 
	"PURPOSE" NVARCHAR2(100), 
	"RATE_ITEMS" NVARCHAR2(2000), 
	"LICENSE_CHINESE_NAME" NVARCHAR2(200), 
	"LICENSE_ENGLISH_NAME" NVARCHAR2(200), 
	"TOTAL_AREA" NUMBER(12,2), 
	"TOTAL_AREA_TYPE" NVARCHAR2(2), 
	"COMMENCEMENT_DATE" TIMESTAMP (7), 
	"PERIOD" NUMBER(10,0), 
	"EXPIRY_DATE" TIMESTAMP (7), 
	"TYPE_OF_LICENSE" NVARCHAR2(50), 
	"LICENSE_PLAN_NO" NVARCHAR2(100), 
	"LICENSEE_TYPE" NVARCHAR2(50), 
	"REMARKS" NVARCHAR2(500), 
	"LOCATION_OF_LAND" NVARCHAR2(100), 
	"SPECIAL_RATE" NVARCHAR2(2000), 
	"SC_NUMBER_AFFECTED" NVARCHAR2(2000), 
	"AREA_REMARKS" NVARCHAR2(2000), 
	"CATEGORY_OF_LICENSE" NVARCHAR2(2000), 
	"ANNUAL_TYPE" NVARCHAR2(2000), 
	"GLL_NO" NVARCHAR2(20), 
	"INPUTTED_BY" NVARCHAR2(50), 
	"ANNUAL_FEE" NUMBER(12,2), 
	"CREATED_AT" TIMESTAMP (7), 
	"UPDATED_AT" TIMESTAMP (7), 
	"CREATOR_ID" RAW(16), 
	"UPDATETOR_ID" RAW(16), 
	"GLL_STATUS" NVARCHAR2(10), 
	"TERMINATION_REASON" NVARCHAR2(100), 
	"TERMINATION_REMARKS" NVARCHAR2(2000), 
	"DLO_ID" RAW(16) DEFAULT HEXTORAW('00000000000000000000000000000000'), 
	"ILES_TASK_ID" RAW(16), 
	"POLYLINE" NVARCHAR2(2000), 
	"ENFORCEMENT_CASE_ID" NVARCHAR2(2000), 
	"E_FOLDER_ID" NVARCHAR2(2000), 
	"OLD_GLL_ID" RAW(16), 
	"RE_ISSUE_TIME" TIMESTAMP (7) DEFAULT TO_TIMESTAMP('0001-01-01 00:00:00.0000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 
	"CANCEL_TIME" TIMESTAMP (7), 
	"RATE_TYPE_D" NVARCHAR2(10), 
	"RATE_CODE_D" NVARCHAR2(50), 
	"RATE_METRIC_D" BINARY_DOUBLE, 
	"TYPEOFPERMIT_D" NVARCHAR2(10), 
	"POLYGON" NVARCHAR2(2000), 
	"APPROVED_BY" NVARCHAR2(50), 
	"CASEID_D" NVARCHAR2(13), 
	"CISLICID_D" NVARCHAR2(22), 
	"DEPARTMENT_D" NVARCHAR2(50), 
	"DLOOFFICE_D" NVARCHAR2(5), 
	"FORMERGLLNUMBER_D" NVARCHAR2(20), 
	"GLOBALID_D" RAW(16), 
	"GOVERNMENTLANDLICENCEID_D" NUMBER(10,0), 
	"ISLINE_D" NVARCHAR2(1), 
	"ITEMSOFNTSPECIALRATES_D" NVARCHAR2(5), 
	"ITEMSOFUASPECIALRATES_D" NVARCHAR2(50), 
	"LICENCEANDPERMITPOLYID_D" NUMBER(10,0), 
	"MODIFIEDBY_D" NVARCHAR2(51), 
	"OBJECTID_D" NUMBER(10,0), 
	"OPENSPACEAREAUNIT_D" NVARCHAR2(2), 
	"OPENSPACEAREA_D" NUMBER(38,8), 
	"PLANAREAUNIT_D" NVARCHAR2(2), 
	"PLANAREA_D" NUMBER(38,8), 
	"RATE_AREA_D" NVARCHAR2(10), 
	"ROOFEDAREAUNIT_D" NVARCHAR2(2), 
	"ROOFEDAREA_D" NUMBER(38,8), 
	"SCOFFICE_D" NVARCHAR2(20), 
	"STTNUMBER_D" NVARCHAR2(20), 
	"TOTALAREAMETRIC_D" NUMBER(38,8)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index PK_GLLS
--------------------------------------------------------

  CREATE UNIQUE INDEX "GLL"."PK_GLLS" ON "GLL"."GLLS" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index IX_GLLS_DLO_ID
--------------------------------------------------------

  CREATE INDEX "GLL"."IX_GLLS_DLO_ID" ON "GLL"."GLLS" ("DLO_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index IX_GLLS_OLD_GLL_ID
--------------------------------------------------------

  CREATE UNIQUE INDEX "GLL"."IX_GLLS_OLD_GLL_ID" ON "GLL"."GLLS" ("OLD_GLL_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  Constraints for Table GLLS
--------------------------------------------------------

  ALTER TABLE "GLL"."GLLS" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "GLL"."GLLS" MODIFY ("DLO_ID" NOT NULL ENABLE);
  ALTER TABLE "GLL"."GLLS" ADD CONSTRAINT "PK_GLLS" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table GLLS
--------------------------------------------------------

  ALTER TABLE "GLL"."GLLS" ADD CONSTRAINT "FK_GLLS_DLOS_DLO_ID" FOREIGN KEY ("DLO_ID")
	  REFERENCES "GLL"."DLOS" ("ID") ON DELETE CASCADE ENABLE;
  ALTER TABLE "GLL"."GLLS" ADD CONSTRAINT "FK_GLLS_GLLS_OLD_GLL_ID" FOREIGN KEY ("OLD_GLL_ID")
	  REFERENCES "GLL"."GLLS" ("ID") ENABLE;


--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--  DDL for Table DLOS
--------------------------------------------------------

  CREATE TABLE "GLL"."DLOS" 
   (	"ID" RAW(16), 
	"DLO_NAME" NVARCHAR2(2000), 
	"DLO_DISPLAY_NAME" NVARCHAR2(2000), 
	"SORTING_INDEX" NUMBER(10,0), 
	"CREATED_AT" TIMESTAMP (7), 
	"UPDATED_AT" TIMESTAMP (7), 
	"DLO_ADDRESS_EN" NVARCHAR2(2000), 
	"DLO_ADDRESS_ZH" NVARCHAR2(2000), 
	"DLO_EMAIL" NVARCHAR2(2000), 
	"DLO_FAX" NVARCHAR2(2000), 
	"DLO_FULL_NAME_EN" NVARCHAR2(2000), 
	"DLO_FULL_NAME_ZH" NVARCHAR2(2000), 
	"DLO_PHONE" NVARCHAR2(2000)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index PK_DLOS
--------------------------------------------------------

  CREATE UNIQUE INDEX "GLL"."PK_DLOS" ON "GLL"."DLOS" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  Constraints for Table DLOS
--------------------------------------------------------

  ALTER TABLE "GLL"."DLOS" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "GLL"."DLOS" MODIFY ("DLO_NAME" NOT NULL ENABLE);
  ALTER TABLE "GLL"."DLOS" MODIFY ("SORTING_INDEX" NOT NULL ENABLE);
  ALTER TABLE "GLL"."DLOS" MODIFY ("CREATED_AT" NOT NULL ENABLE);
  ALTER TABLE "GLL"."DLOS" MODIFY ("UPDATED_AT" NOT NULL ENABLE);
  ALTER TABLE "GLL"."DLOS" ADD CONSTRAINT "PK_DLOS" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;



--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--  DDL for Table GLL_STRUCTURES
--------------------------------------------------------

  CREATE TABLE "GLL"."GLL_STRUCTURES" 
   (	"ID" RAW(16), 
	"GLL_ID" RAW(16), 
	"STRUCTURE_ID" NUMBER(10,0), 
	"DESCRIPTION" NVARCHAR2(255), 
	"LENGTH" NUMBER(38,8), 
	"WIDTH" NUMBER(38,8), 
	"HEIGHT" NUMBER(38,8), 
	"AREA" NUMBER(38,8), 
	"LENGTH_UNIT" NVARCHAR2(2), 
	"WIDTH_UNIT" NVARCHAR2(2), 
	"AREA_UNIT" NVARCHAR2(2), 
	"AREA_METRIC" NUMBER(38,8), 
	"PERCENT_AREA" NUMBER(38,8), 
	"GLL_SUB_USAGE_ID" RAW(16), 
	"GLL_USAGE_ID" RAW(16), 
	"STRUCT_TYPE" NVARCHAR2(20), 
	"RATE_METRIC" BINARY_DOUBLE, 
	"CALC_FEE" BINARY_DOUBLE, 
	"CREATOR_ID" RAW(16), 
	"UPDATETOR_ID" RAW(16), 
	"CREATED_AT" TIMESTAMP (7), 
	"UPDATED_AT" TIMESTAMP (7), 
	"FEE_REVIEW_ID" RAW(16) DEFAULT HEXTORAW('00000000000000000000000000000000'), 
	"CALCFEE_D" NUMBER(38,8), 
	"GLLUSERINFOID_D" NUMBER(10,0), 
	"GLOBALID_D" RAW(16), 
	"GOVERNMENTLANDLICENCEID_D" NUMBER(10,0), 
	"HEIGHT_UNIT_D" NVARCHAR2(2), 
	"MODIFIEDBY_D" NVARCHAR2(51), 
	"OBJECTID_D" NUMBER(10,0), 
	"PURPOSECODE_D" NUMBER(10,0), 
	"RATEMETRIC_D" NUMBER(38,8), 
	"RATEVALUE_D" NUMBER(38,8), 
	"SUBPURPOSECODE_D" NUMBER(10,0), 
	"TSUNIT_D" NVARCHAR2(2)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index IX_GLL_STRUCTURES_FEE_REVIEW_ID
--------------------------------------------------------

  CREATE INDEX "GLL"."IX_GLL_STRUCTURES_FEE_REVIEW_ID" ON "GLL"."GLL_STRUCTURES" ("FEE_REVIEW_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index IX_GLL_STRUCTURES_CREATOR_ID
--------------------------------------------------------

  CREATE INDEX "GLL"."IX_GLL_STRUCTURES_CREATOR_ID" ON "GLL"."GLL_STRUCTURES" ("CREATOR_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index IX_GLL_STRUCTURES_GLL_ID
--------------------------------------------------------

  CREATE INDEX "GLL"."IX_GLL_STRUCTURES_GLL_ID" ON "GLL"."GLL_STRUCTURES" ("GLL_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index IX_GLL_STRUCTURES_GLL_SUB_USAGE_ID
--------------------------------------------------------

  CREATE INDEX "GLL"."IX_GLL_STRUCTURES_GLL_SUB_USAGE_ID" ON "GLL"."GLL_STRUCTURES" ("GLL_SUB_USAGE_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index IX_GLL_STRUCTURES_GLL_USAGE_ID
--------------------------------------------------------

  CREATE INDEX "GLL"."IX_GLL_STRUCTURES_GLL_USAGE_ID" ON "GLL"."GLL_STRUCTURES" ("GLL_USAGE_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index IX_GLL_STRUCTURES_UPDATETOR_ID
--------------------------------------------------------

  CREATE INDEX "GLL"."IX_GLL_STRUCTURES_UPDATETOR_ID" ON "GLL"."GLL_STRUCTURES" ("UPDATETOR_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index PK_GLL_STRUCTURES
--------------------------------------------------------

  CREATE UNIQUE INDEX "GLL"."PK_GLL_STRUCTURES" ON "GLL"."GLL_STRUCTURES" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  Constraints for Table GLL_STRUCTURES
--------------------------------------------------------

  ALTER TABLE "GLL"."GLL_STRUCTURES" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "GLL"."GLL_STRUCTURES" MODIFY ("GLL_ID" NOT NULL ENABLE);
  ALTER TABLE "GLL"."GLL_STRUCTURES" MODIFY ("CREATED_AT" NOT NULL ENABLE);
  ALTER TABLE "GLL"."GLL_STRUCTURES" MODIFY ("UPDATED_AT" NOT NULL ENABLE);
  ALTER TABLE "GLL"."GLL_STRUCTURES" ADD CONSTRAINT "PK_GLL_STRUCTURES" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;
  ALTER TABLE "GLL"."GLL_STRUCTURES" MODIFY ("FEE_REVIEW_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Ref Constraints for Table GLL_STRUCTURES
--------------------------------------------------------

  ALTER TABLE "GLL"."GLL_STRUCTURES" ADD CONSTRAINT "FK_GLL_STRUCTURES_GLLS_GLL_ID" FOREIGN KEY ("GLL_ID")
	  REFERENCES "GLL"."GLLS" ("ID") ON DELETE CASCADE ENABLE;
  ALTER TABLE "GLL"."GLL_STRUCTURES" ADD CONSTRAINT "FK_GLL_STRUCTURES_POSTS_CREATOR_ID" FOREIGN KEY ("CREATOR_ID")
	  REFERENCES "GLL"."POSTS" ("ID") ENABLE;
  ALTER TABLE "GLL"."GLL_STRUCTURES" ADD CONSTRAINT "FK_GLL_STRUCTURES_POSTS_UPDATETOR_ID" FOREIGN KEY ("UPDATETOR_ID")
	  REFERENCES "GLL"."POSTS" ("ID") ENABLE;
  ALTER TABLE "GLL"."GLL_STRUCTURES" ADD CONSTRAINT "FK_GLL_STRUCTURES_GLL_SUB_USAGE_GLL_SUB_USAGE_ID" FOREIGN KEY ("GLL_SUB_USAGE_ID")
	  REFERENCES "GLL"."GLL_SUB_USAGE" ("ID") ENABLE;
  ALTER TABLE "GLL"."GLL_STRUCTURES" ADD CONSTRAINT "FK_GLL_STRUCTURES_GLL_USAGES_GLL_USAGE_ID" FOREIGN KEY ("GLL_USAGE_ID")
	  REFERENCES "GLL"."GLL_USAGES" ("ID") ENABLE;
  ALTER TABLE "GLL"."GLL_STRUCTURES" ADD CONSTRAINT "FK_GLL_STRUCTURES_FEE_REVIEWS_FEE_REVIEW_ID" FOREIGN KEY ("FEE_REVIEW_ID")
	  REFERENCES "GLL"."FEE_REVIEWS" ("ID") ON DELETE CASCADE ENABLE;



--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--  DDL for Table ATTACHMENT_GLL
--------------------------------------------------------

  CREATE TABLE "GLL"."ATTACHMENT_GLL" 
   (	"ID" RAW(16), 
	"ATTACHMENT_ID" RAW(16), 
	"SCANNED_LICENSES_GLL_ID" RAW(16), 
	"SCANNED_SQUATTER_CONTROL_INFORMATIONS_GLL_ID" RAW(16), 
	"SITE_INSPECTION_REPORTS_GLL_ID" RAW(16), 
	"SQUATTER_OCCUPANTS_LETTERS_GLL_ID" RAW(16), 
	"SCANNED_GLL_FEE_ASSESSMENT_SHEETS_GLL_ID" RAW(16), 
	"CREATED_AT" TIMESTAMP (7), 
	"UPDATED_AT" TIMESTAMP (7)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index PK_ATTACHMENT_GLL
--------------------------------------------------------

  CREATE UNIQUE INDEX "GLL"."PK_ATTACHMENT_GLL" ON "GLL"."ATTACHMENT_GLL" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index IX_ATTACHMENT_GLL_ATTACHMENT_ID
--------------------------------------------------------

  CREATE INDEX "GLL"."IX_ATTACHMENT_GLL_ATTACHMENT_ID" ON "GLL"."ATTACHMENT_GLL" ("ATTACHMENT_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index IX_ATTACHMENT_GLL_SCANNED_GLL_FEE_ASSESSMENT_SHEETS_GLL_ID
--------------------------------------------------------

  CREATE INDEX "GLL"."IX_ATTACHMENT_GLL_SCANNED_GLL_FEE_ASSESSMENT_SHEETS_GLL_ID" ON "GLL"."ATTACHMENT_GLL" ("SCANNED_GLL_FEE_ASSESSMENT_SHEETS_GLL_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index IX_ATTACHMENT_GLL_SCANNED_LICENSES_GLL_ID
--------------------------------------------------------

  CREATE INDEX "GLL"."IX_ATTACHMENT_GLL_SCANNED_LICENSES_GLL_ID" ON "GLL"."ATTACHMENT_GLL" ("SCANNED_LICENSES_GLL_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index IX_ATTACHMENT_GLL_SCANNED_SQUATTER_CONTROL_INFORMATIONS_GLL_ID
--------------------------------------------------------

  CREATE INDEX "GLL"."IX_ATTACHMENT_GLL_SCANNED_SQUATTER_CONTROL_INFORMATIONS_GLL_ID" ON "GLL"."ATTACHMENT_GLL" ("SCANNED_SQUATTER_CONTROL_INFORMATIONS_GLL_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index IX_ATTACHMENT_GLL_SITE_INSPECTION_REPORTS_GLL_ID
--------------------------------------------------------

  CREATE INDEX "GLL"."IX_ATTACHMENT_GLL_SITE_INSPECTION_REPORTS_GLL_ID" ON "GLL"."ATTACHMENT_GLL" ("SITE_INSPECTION_REPORTS_GLL_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index IX_ATTACHMENT_GLL_SQUATTER_OCCUPANTS_LETTERS_GLL_ID
--------------------------------------------------------

  CREATE INDEX "GLL"."IX_ATTACHMENT_GLL_SQUATTER_OCCUPANTS_LETTERS_GLL_ID" ON "GLL"."ATTACHMENT_GLL" ("SQUATTER_OCCUPANTS_LETTERS_GLL_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  Constraints for Table ATTACHMENT_GLL
--------------------------------------------------------

  ALTER TABLE "GLL"."ATTACHMENT_GLL" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "GLL"."ATTACHMENT_GLL" MODIFY ("ATTACHMENT_ID" NOT NULL ENABLE);
  ALTER TABLE "GLL"."ATTACHMENT_GLL" MODIFY ("CREATED_AT" NOT NULL ENABLE);
  ALTER TABLE "GLL"."ATTACHMENT_GLL" MODIFY ("UPDATED_AT" NOT NULL ENABLE);
  ALTER TABLE "GLL"."ATTACHMENT_GLL" ADD CONSTRAINT "PK_ATTACHMENT_GLL" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ATTACHMENT_GLL
--------------------------------------------------------

  ALTER TABLE "GLL"."ATTACHMENT_GLL" ADD CONSTRAINT "FK_ATTACHMENT_GLL_ATTACHMENTS_ATTACHMENT_ID" FOREIGN KEY ("ATTACHMENT_ID")
	  REFERENCES "GLL"."ATTACHMENTS" ("ID") ON DELETE CASCADE ENABLE;
  ALTER TABLE "GLL"."ATTACHMENT_GLL" ADD CONSTRAINT "FK_ATTACHMENT_GLL_GLLS_SCANNED_GLL_FEE_ASSESSMENT_SHEETS_GLL_ID" FOREIGN KEY ("SCANNED_GLL_FEE_ASSESSMENT_SHEETS_GLL_ID")
	  REFERENCES "GLL"."GLLS" ("ID") ENABLE;
  ALTER TABLE "GLL"."ATTACHMENT_GLL" ADD CONSTRAINT "FK_ATTACHMENT_GLL_GLLS_SCANNED_LICENSES_GLL_ID" FOREIGN KEY ("SCANNED_LICENSES_GLL_ID")
	  REFERENCES "GLL"."GLLS" ("ID") ENABLE;
  ALTER TABLE "GLL"."ATTACHMENT_GLL" ADD CONSTRAINT "FK_ATTACHMENT_GLL_GLLS_SCANNED_SQUATTER_CONTROL_INFORMATIONS_GLL_ID" FOREIGN KEY ("SCANNED_SQUATTER_CONTROL_INFORMATIONS_GLL_ID")
	  REFERENCES "GLL"."GLLS" ("ID") ENABLE;
  ALTER TABLE "GLL"."ATTACHMENT_GLL" ADD CONSTRAINT "FK_ATTACHMENT_GLL_GLLS_SITE_INSPECTION_REPORTS_GLL_ID" FOREIGN KEY ("SITE_INSPECTION_REPORTS_GLL_ID")
	  REFERENCES "GLL"."GLLS" ("ID") ENABLE;
  ALTER TABLE "GLL"."ATTACHMENT_GLL" ADD CONSTRAINT "FK_ATTACHMENT_GLL_GLLS_SQUATTER_OCCUPANTS_LETTERS_GLL_ID" FOREIGN KEY ("SQUATTER_OCCUPANTS_LETTERS_GLL_ID")
	  REFERENCES "GLL"."GLLS" ("ID") ENABLE;

--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--  DDL for Table ATTACHMENTS
--------------------------------------------------------

  CREATE TABLE "GLL"."ATTACHMENTS" 
   (	"ID" RAW(16), 
	"FULL_FILENAME" NVARCHAR2(2000), 
	"DISPLAYNAME" NVARCHAR2(2000), 
	"FILE_SIZE" BINARY_FLOAT, 
	"URL" NVARCHAR2(2000), 
	"CREATED_AT" TIMESTAMP (7), 
	"UPDATED_AT" TIMESTAMP (7)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index PK_ATTACHMENTS
--------------------------------------------------------

  CREATE UNIQUE INDEX "GLL"."PK_ATTACHMENTS" ON "GLL"."ATTACHMENTS" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  Constraints for Table ATTACHMENTS
--------------------------------------------------------

  ALTER TABLE "GLL"."ATTACHMENTS" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "GLL"."ATTACHMENTS" MODIFY ("FULL_FILENAME" NOT NULL ENABLE);
  ALTER TABLE "GLL"."ATTACHMENTS" MODIFY ("DISPLAYNAME" NOT NULL ENABLE);
  ALTER TABLE "GLL"."ATTACHMENTS" MODIFY ("FILE_SIZE" NOT NULL ENABLE);
  ALTER TABLE "GLL"."ATTACHMENTS" MODIFY ("CREATED_AT" NOT NULL ENABLE);
  ALTER TABLE "GLL"."ATTACHMENTS" MODIFY ("UPDATED_AT" NOT NULL ENABLE);
  ALTER TABLE "GLL"."ATTACHMENTS" ADD CONSTRAINT "PK_ATTACHMENTS" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;



--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--  DDL for Table FEE_REVIEWS
--------------------------------------------------------

  CREATE TABLE "GLL"."FEE_REVIEWS" 
   (	"ID" RAW(16), 
	"RATE_TYPE" NVARCHAR2(255), 
	"RATE_AREA" NVARCHAR2(255), 
	"RATE_CODE" NVARCHAR2(255), 
	"RATE_DESCRIPTION" NVARCHAR2(2000), 
	"RATE_NATURE" NVARCHAR2(255), 
	"RATE_PER_UNIT" NVARCHAR2(255), 
	"RATE_FACTOR" BINARY_DOUBLE, 
	"RATE_VALUE" BINARY_DOUBLE, 
	"RATE_REMARKS" NVARCHAR2(255), 
	"START_AT" TIMESTAMP (7), 
	"END_AT" TIMESTAMP (7), 
	"IS_DELETED" NUMBER(1,0), 
	"IS_ACTIVE" NUMBER(1,0), 
	"CREATED_AT" TIMESTAMP (7), 
	"UPDATED_AT" TIMESTAMP (7), 
	"STRUCTURE_TYPE" NVARCHAR2(2000), 
	"OBJECTID_D" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index PK_FEE_REVIEWS
--------------------------------------------------------

  CREATE UNIQUE INDEX "GLL"."PK_FEE_REVIEWS" ON "GLL"."FEE_REVIEWS" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  Constraints for Table FEE_REVIEWS
--------------------------------------------------------

  ALTER TABLE "GLL"."FEE_REVIEWS" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "GLL"."FEE_REVIEWS" MODIFY ("CREATED_AT" NOT NULL ENABLE);
  ALTER TABLE "GLL"."FEE_REVIEWS" MODIFY ("UPDATED_AT" NOT NULL ENABLE);
  ALTER TABLE "GLL"."FEE_REVIEWS" ADD CONSTRAINT "PK_FEE_REVIEWS" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;


--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--  DDL for Table GLL_SUB_USAGE
--------------------------------------------------------

  CREATE TABLE "GLL"."GLL_SUB_USAGE" 
   (	"ID" RAW(16), 
	"GLL_USAGE_ID" RAW(16), 
	"SUB_USAGE_CODE" NUMBER(10,0), 
	"DESCRIPTION" NVARCHAR2(2000), 
	"CREATED_AT" TIMESTAMP (7), 
	"UPDATED_AT" TIMESTAMP (7), 
	"OBJECTID_D" NUMBER(10,0), 
	"USAGE_CODE_D" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index PK_GLL_SUB_USAGE
--------------------------------------------------------

  CREATE UNIQUE INDEX "GLL"."PK_GLL_SUB_USAGE" ON "GLL"."GLL_SUB_USAGE" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index IX_GLL_SUB_USAGE_GLL_USAGE_ID
--------------------------------------------------------

  CREATE INDEX "GLL"."IX_GLL_SUB_USAGE_GLL_USAGE_ID" ON "GLL"."GLL_SUB_USAGE" ("GLL_USAGE_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  Constraints for Table GLL_SUB_USAGE
--------------------------------------------------------

  ALTER TABLE "GLL"."GLL_SUB_USAGE" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "GLL"."GLL_SUB_USAGE" MODIFY ("CREATED_AT" NOT NULL ENABLE);
  ALTER TABLE "GLL"."GLL_SUB_USAGE" MODIFY ("UPDATED_AT" NOT NULL ENABLE);
  ALTER TABLE "GLL"."GLL_SUB_USAGE" ADD CONSTRAINT "PK_GLL_SUB_USAGE" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table GLL_SUB_USAGE
--------------------------------------------------------

  ALTER TABLE "GLL"."GLL_SUB_USAGE" ADD CONSTRAINT "FK_GLL_SUB_USAGE_GLL_USAGES_GLL_USAGE_ID" FOREIGN KEY ("GLL_USAGE_ID")
	  REFERENCES "GLL"."GLL_USAGES" ("ID") ENABLE;



--------------------------------------------------------
--------------------------------------------------------

--------------------------------------------------------
--  DDL for Table GLL_USAGES
--------------------------------------------------------

  CREATE TABLE "GLL"."GLL_USAGES" 
   (	"ID" RAW(16), 
	"USAGE_CODE" NUMBER(10,0), 
	"DESCRIPTION" NVARCHAR2(255), 
	"CREATED_AT" TIMESTAMP (7), 
	"UPDATED_AT" TIMESTAMP (7), 
	"OBJECTID_D" NUMBER(10,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Index PK_GLL_USAGES
--------------------------------------------------------

  CREATE UNIQUE INDEX "GLL"."PK_GLL_USAGES" ON "GLL"."GLL_USAGES" ("ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  Constraints for Table GLL_USAGES
--------------------------------------------------------

  ALTER TABLE "GLL"."GLL_USAGES" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "GLL"."GLL_USAGES" MODIFY ("CREATED_AT" NOT NULL ENABLE);
  ALTER TABLE "GLL"."GLL_USAGES" MODIFY ("UPDATED_AT" NOT NULL ENABLE);
  ALTER TABLE "GLL"."GLL_USAGES" ADD CONSTRAINT "PK_GLL_USAGES" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM"  ENABLE;



--------------------------------------------------------
--------------------------------------------------------
