-- CLEAN UP TABLES
TRUNCATE TABLE migration_log;

TRUNCATE TABLE attachment_gll;

TRUNCATE TABLE attachments;

TRUNCATE TABLE gll_structures;

TRUNCATE TABLE glls;

TRUNCATE TABLE gll_sub_usage;

TRUNCATE TABLE gll_usages;

TRUNCATE TABLE fee_reviews;

-- execute migration process
CALL gll.perform_migration();

-- error log
SELECT
    *
FROM
    migration_log ml
WHERE
    ml.status != 'SUCCESS'
ORDER BY
    created_at DESC;

-- migration summary

SELECT
    *
FROM
    migration_summary;

-- total logs
SELECT
    count(1)
FROM
    migration_log ml;

-- number of rows check: SDE.COVERSERSION_RATES VS FEE_REVIEW
SELECT
    count(1)
FROM
    sde_gll.conversion_rates cr;

SELECT
    count(1)
FROM
    fee_reviews fr;

SELECT
    count(1)
FROM
    migration_log ml
WHERE
    ml.entity_name = 'FEE_REVIEWS'
    AND ml.status = 'SUCCESS';

-- number of rows check: PURPOSE VS USAGE
SELECT
    count(1)
FROM
    sde_gll.gll_purposes gp;

SELECT
    count(1)
FROM
    gll_usages gu;

SELECT
    count(1)
FROM
    migration_log ml
WHERE
    ml.entity_name = 'GLL_USAGES'
    AND ml.status = 'SUCCESS';

-- number of rows check: SUB_PURPOSE VS SUB_USAGE
SELECT
    count(1)
FROM
    sde_gll.gll_sub_purposes gsp;

SELECT
    count(1)
FROM
    gll_sub_usage gsu;

SELECT
    count(1)
FROM
    migration_log ml
WHERE
    ml.entity_name = 'GLL_SUB_USAGE'
    AND ml.status = 'SUCCESS';

-- number of rows check: SDE.GOVERNMENTLANDLICENCE VS GLLS
SELECT
    count(1)
FROM
    sde_gll.governmentlandlicence g;

SELECT
    count(1)
FROM
    glls g;

SELECT
    count(1)
FROM
    migration_log ml
WHERE
    ml.entity_name = 'GLLS'
    AND ml.status = 'SUCCESS';

-- number of rows check: SDE.GLLUSERINFO VS GLLS_STRUCTURES
SELECT
    count(1)
FROM
    sde_gll.glluserinfo g;

SELECT
    count(1)
FROM
    gll_structures gs;

SELECT
    count(1)
FROM
    migration_log ml
WHERE
    ml.entity_name = 'GLL_STRUCTURES'
    AND ml.status = 'SUCCESS';