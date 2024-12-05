
update SQ.ATTACHMENTS set name = '551 SOV_repair_已標記密文.pdf' where OBJECTID = 16;
update sde_sq.SQUATTER_UPLOAD set name = 'notification form (edited copy for DFA)_已標記密文.pdf' where OBJECTID = 17;
update sde_sq.SQUATTER_UPLOAD set name = '551 SOV_repair_已標記密文.pdf' where OBJECTID = 20;
update sde_sq.SQUATTER_UPLOAD set name = 'renewed notification form_已標記密文.pdf' where OBJECTID = 23;
update sde_sq.SQUATTER_UPLOAD set name = '551 SOV_repair_已標記密文.pdf' where OBJECTID = 24;
update sde_sq.SQUATTER_UPLOAD set name = '修葺重建登記寮屋通知書 (RTW-4B-211)--[SCTW 180-21].pdf' where OBJECTID = 88;
update sde_sq.SQUATTER_UPLOAD set name = '已登記寮屋通知書.pdf' where OBJECTID = 242;
update sde_sq.SQUATTER_UPLOAD set name = '已登記寮屋通知書.pdf' where OBJECTID = 243;
update sde_sq.SQUATTER_UPLOAD set name = '已登記寮屋通知書.pdf' where OBJECTID = 244;
update sde_sq.SQUATTER_UPLOAD set name = '已登記寮屋通知書.pdf' where OBJECTID = 245;
update sde_sq.SQUATTER_UPLOAD set name = '220125_TP VRS C 136-22_申請記錄在案-redacted.pdf' where OBJECTID = 1061;
update sde_sq.SQUATTER_UPLOAD set name = '220602_VRS C 19-21_81-000584 申請記錄在案-redacted.pdf' where OBJECTID = 1062;
update sde_sq.SQUATTER_UPLOAD set name = '220602_VRS C 19-21_81-000584 申請記錄在案-redacted.pdf' where OBJECTID = 1063;
update sde_sq.SQUATTER_UPLOAD set name = '220602_VRS C 19-21_81-000584 申請記錄在案-redacted.pdf' where OBJECTID = 1064;
update sde_sq.SQUATTER_UPLOAD set name = '220324-220207_TP VRS C 17-21_申請記錄在案-redacted.pdf' where OBJECTID = 1077;
update sde_sq.SQUATTER_UPLOAD set name = '220602_VRS C 39-21_81-000817 申請記錄在案-redacted.pdf' where OBJECTID = 1097;
update sde_sq.SQUATTER_UPLOAD set name = '220216_TP VRS C 7-21_申請記錄在案-redacted.pdf' where OBJECTID = 1116;
update sde_sq.SQUATTER_UPLOAD set name = '221220_VRS C 155-22_TP018 申請記錄在案 redacted.pdf' where OBJECTID = 1117;
update sde_sq.SQUATTER_UPLOAD set name = '211229_TP VRS A 25-21_申請記錄在案-redacted.pdf' where OBJECTID = 1118;
update sde_sq.SQUATTER_UPLOAD set name = '211229_TP VRS A 25-21_申請記錄在案-redacted.pdf' where OBJECTID = 1119;
update sde_sq.SQUATTER_UPLOAD set name = '220406_VRS B 27-21_61-000225_申請記錄在案-redacted.pdf' where OBJECTID = 1126;
update sde_sq.SQUATTER_UPLOAD set name = '220125_TP VRS C 34-21_申請記錄在案-redacted.pdf' where OBJECTID = 1134;
update sde_sq.SQUATTER_UPLOAD set name = '220125_TP VRS C 34-21_申請記錄在案-redacted.pdf' where OBJECTID = 1135;
update sde_sq.SQUATTER_UPLOAD set name = 'Approval Letter 吳茵妮 LDE_VRS_4_23 SK017.pdf' where OBJECTID = 841;
update sde_sq.SQUATTER_UPLOAD set name = '211230_TP VRS A 23-21_申請記錄在案-redacted.pdf' where OBJECTID = 1020;
update sde_sq.SQUATTER_UPLOAD set name = '220321_TP VRS C 30-21_申請記錄在案-redacted.pdf' where OBJECTID = 1021;
update sde_sq.SQUATTER_UPLOAD set name = '220526_VRS C 89-21_61-000029 申請記錄在案-redacted.pdf' where OBJECTID = 1029;
update sde_sq.SQUATTER_UPLOAD set name = '220526_VRS C 89-21_61-000029 申請記錄在案-redacted.pdf' where OBJECTID = 1030;
update sde_sq.SQUATTER_UPLOAD set name = '220527_VRS B 21-21_61-000194 申請記錄在案-redacted.pdf' where OBJECTID = 1043;
update sde_sq.SQUATTER_UPLOAD set name = '220527_VRS B 21-21_61-000194 申請記錄在案-redacted.pdf' where OBJECTID = 1044;
update sde_sq.SQUATTER_UPLOAD set name = '220527_VRS B 21-21_61-000194 申請記錄在案-redacted.pdf' where OBJECTID = 1045;


SELECT COUNT(*) AS SUCCESS_COUNT
FROM sde_sq.SQUATTER_UPLOAD
WHERE
  ( name = '551 SOV_repair_已標記密文.pdf' AND OBJECTID = 16) OR
  ( name = 'notification form (edited copy for DFA)_已標記密文.pdf' AND OBJECTID = 17) OR
  ( name = '551 SOV_repair_已標記密文.pdf' AND OBJECTID = 20) OR
  ( name = 'renewed notification form_已標記密文.pdf' AND OBJECTID = 23) OR
  ( name = '551 SOV_repair_已標記密文.pdf' AND OBJECTID = 24) OR
  ( name = '修葺重建登記寮屋通知書 (RTW-4B-211)--[SCTW 180-21].pdf' AND OBJECTID = 88) OR
  ( name = '已登記寮屋通知書.pdf' AND OBJECTID = 242) OR
  ( name = '已登記寮屋通知書.pdf' AND OBJECTID = 243) OR
  ( name = '已登記寮屋通知書.pdf' AND OBJECTID = 244) OR
  ( name = '已登記寮屋通知書.pdf' AND OBJECTID = 245) OR
  ( name = '220125_TP VRS C 136-22_申請記錄在案-redacted.pdf' AND OBJECTID = 1061) OR
  ( name = '220602_VRS C 19-21_81-000584 申請記錄在案-redacted.pdf' AND OBJECTID = 1062) OR
  ( name = '220602_VRS C 19-21_81-000584 申請記錄在案-redacted.pdf' AND OBJECTID = 1063) OR
  ( name = '220602_VRS C 19-21_81-000584 申請記錄在案-redacted.pdf' AND OBJECTID = 1064) OR
  ( name = '220324-220207_TP VRS C 17-21_申請記錄在案-redacted.pdf' AND OBJECTID = 1077) OR
  ( name = '220602_VRS C 39-21_81-000817 申請記錄在案-redacted.pdf' AND OBJECTID = 1097) OR
  ( name = '220216_TP VRS C 7-21_申請記錄在案-redacted.pdf' AND OBJECTID = 1116) OR
  ( name = '221220_VRS C 155-22_TP018 申請記錄在案 redacted.pdf' AND OBJECTID = 1117) OR
  ( name = '211229_TP VRS A 25-21_申請記錄在案-redacted.pdf' AND OBJECTID = 1118) OR
  ( name = '211229_TP VRS A 25-21_申請記錄在案-redacted.pdf' AND OBJECTID = 1119) OR
  ( name = '220406_VRS B 27-21_61-000225_申請記錄在案-redacted.pdf' AND OBJECTID = 1126) OR
  ( name = '220125_TP VRS C 34-21_申請記錄在案-redacted.pdf' AND OBJECTID = 1134) OR
  ( name = '220125_TP VRS C 34-21_申請記錄在案-redacted.pdf' AND OBJECTID = 1135) OR
  ( name = 'Approval Letter 吳茵妮 LDE_VRS_4_23 SK017.pdf' AND OBJECTID = 841) OR
  ( name = '211230_TP VRS A 23-21_申請記錄在案-redacted.pdf' AND OBJECTID = 1020) OR
  ( name = '220321_TP VRS C 30-21_申請記錄在案-redacted.pdf' AND OBJECTID = 1021) OR
  ( name = '220526_VRS C 89-21_61-000029 申請記錄在案-redacted.pdf' AND OBJECTID = 1029) OR
  ( name = '220526_VRS C 89-21_61-000029 申請記錄在案-redacted.pdf' AND OBJECTID = 1030) OR
  ( name = '220527_VRS B 21-21_61-000194 申請記錄在案-redacted.pdf' AND OBJECTID = 1043) OR
  ( name = '220527_VRS B 21-21_61-000194 申請記錄在案-redacted.pdf' AND OBJECTID = 1044) OR
  ( name = '220527_VRS B 21-21_61-000194 申請記錄在案-redacted.pdf' AND OBJECTID = 1045);
