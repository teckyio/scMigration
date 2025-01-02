CREATE TABLE data_validation_squatter_his (
                          objectid NUMBER,
                          target_objectid NUMBER null,
                          error_msg CLOB,
                          is_valid NUMBER(1)
                      );

CREATE TABLE data_validation_squatters (
                          objectid NUMBER,
                          target_objectid NUMBER null,
                          error_msg CLOB,
                          is_valid NUMBER(1)
                      );

CREATE TABLE data_validation_attachment (
                          objectid NUMBER,
                          target_objectid NUMBER null,
                          error_msg CLOB,
                          is_valid NUMBER(1)
                      );