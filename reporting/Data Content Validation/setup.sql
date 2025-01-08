CREATE TABLE data_validation_squatter_use_pro (
                          objectid NUMBER,
                          target_objectid NUMBER null,
                          error_msg CLOB,
                          is_valid NUMBER(1),
                          dlo VARCHAR2(40)
                      );
CREATE TABLE data_validation_squatter_use_his (
                          objectid NUMBER,
                          target_objectid NUMBER null,
                          error_msg CLOB,
                          is_valid NUMBER(1),
                          dlo VARCHAR2(40)
                      );
CREATE TABLE data_validation_squatter_use (
                          objectid NUMBER,
                          target_objectid NUMBER null,
                          error_msg CLOB,
                          is_valid NUMBER(1),
                          dlo VARCHAR2(40)
                      );

CREATE TABLE data_validation_squatter_material_pro (
                          objectid NUMBER,
                          target_objectid NUMBER null,
                          error_msg CLOB,
                          is_valid NUMBER(1),
                          dlo VARCHAR2(40)
                      );

CREATE TABLE data_validation_squatter_material_his (
                          objectid NUMBER,
                          target_objectid NUMBER null,
                          error_msg CLOB,
                          is_valid NUMBER(1),
                          dlo VARCHAR2(40)
                      );

CREATE TABLE data_validation_squatter_material (
                          objectid NUMBER,
                          target_objectid NUMBER null,
                          error_msg CLOB,
                          is_valid NUMBER(1),
                          dlo VARCHAR2(40)
                      );

CREATE TABLE data_validation_squatter_histories (
                          objectid NUMBER,
                          target_objectid NUMBER null,
                          error_msg CLOB,
                          is_valid NUMBER(1),
                          dlo VARCHAR2(40)
                      );
        
CREATE TABLE data_validation_squatter_pends (
                          objectid NUMBER,
                          target_objectid NUMBER null,
                          error_msg CLOB,
                          is_valid NUMBER(1),
                          dlo VARCHAR2(40)
                      );

CREATE TABLE data_validation_squatters (
                          objectid NUMBER,
                          target_objectid NUMBER null,
                          error_msg CLOB,
                          is_valid NUMBER(1),
                          dlo VARCHAR2(40)
                      );

CREATE TABLE data_validation_attachment (
                          objectid NUMBER,
                          target_objectid NUMBER null,
                          error_msg CLOB,
                          is_valid NUMBER(1),
                          dlo VARCHAR2(40)
                      );