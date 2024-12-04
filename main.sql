-- First run setup (reset tables)
@reset.sql

-- Then migrate data in sequence
@use.sql
@material.sql
@squatter.sql
@squatter_his.sql
@squatterMaterial.sql 
@squatterMaterialHis.sql
@squatterUse.sql
@squatterUseHis.sql
@"file(VRS & RR).sql"
