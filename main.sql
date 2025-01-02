-- main.sql
SET ECHO ON
SET SERVEROUTPUT ON
SET FEEDBACK ON

-- Include individual scripts
@squatter.sql
@squatter_his.sql
@squatter_pend.sql
@use.sql
@material.sql
@attachment.sql
@squatter_use.sql
@squatter_use_his.sql
@squatter_material.sql
@squatter_material_his.sql

-- Add any additional scripts here
