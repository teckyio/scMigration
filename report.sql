select 
  (SELECT COUNT(*) FROM SDE_SQ.SQUATTER) AS "SQ_TOTAL",
  (SELECT COUNT(*) FROM SQ.SQUATTERS) AS "SQ_SUCCESS",
  (SELECT COUNT(*) FROM SQ.ELLOR_LOG el  WHERE el.TABLE_NAME = 'SQUATTERS') AS "SQ_ERROR",

  (SELECT COUNT(*) FROM SDE_SQ.SQUATTER_HIS) AS "SQ_HIS_TOTAL",
  (SELECT COUNT(*) FROM SQ.SQUATTER_HISTORIES) AS "SQ_HIS_SUCCESS",
  (SELECT COUNT(*) FROM SQ.ELLOR_LOG el  WHERE el.TABLE_NAME = 'SQUATTERS_HIS') AS "SQ_HIS_ERROR",

  (SELECT COUNT(*) FROM SDE_SQ.SQUATTERUSE) AS "SQ_USE_TOTAL",
  (SELECT COUNT(*) FROM SQ.SQUATTER_USES) AS "SQ_USE_SUCCESS",
  (SELECT COUNT(*) FROM SQ.ELLOR_LOG el  WHERE el.TABLE_NAME = 'SQUATTER_USE') AS "SQ_USE_ERROR",

  (SELECT COUNT(*) FROM SDE_SQ.SQUATTERMATERIAL) AS "SQ_MAT_TOTAL",
  (SELECT COUNT(*) FROM SQ.SQUATTER_MATERIALS) AS "SQ_MATERIAL_SUCCESS",
  (SELECT COUNT(*) FROM SQ.ELLOR_LOG el  WHERE el.TABLE_NAME = 'SQUATTER_MATERIAL') AS "SQ_MAT_ERROR",

  (SELECT COUNT(*) FROM SDE_SQ.SQUATTERUSE_HIS) AS "SQ_USE_HIS_TOTAL",
  (SELECT COUNT(*) FROM SQ.SQUATTER_USE_HIS) AS "SQ_USE_HIS_SUCCESS",
  (SELECT COUNT(*) FROM SQ.ELLOR_LOG el  WHERE el.TABLE_NAME = 'SQUATTER_USE_HIS') AS "SQ_USE_HIS_ERROR",

  (SELECT COUNT(*) FROM SDE_SQ.SQUATTERMATERIAL_HIS) AS "SQ_MAT_HIS_TOTAL",
  (SELECT COUNT(*) FROM SQ.SQUATTER_MATERIAL_HIS) AS "SQ_MATERIA_HISL_SUCCESS",
  (SELECT COUNT(*) FROM SQ.ELLOR_LOG el  WHERE el.TABLE_NAME = 'SQUATTER_MATERIAL_HIS') AS "SQ_MAT_HIS_ERROR"
FROM dual;

