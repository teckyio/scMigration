CREATE OR REPLACE PROCEDURE generate_report (
    p_starttime IN TIMESTAMP
  , p_endtime IN TIMESTAMP
) IS
BEGIN
 
    -- report on | sde_gll.CONVERSION_RATES      | GLL.FEE_REVIEWS    |
    INSERT INTO migration_summary (
        start_time
      , end_time
      , original_entity
      , new_entity
      , total_records
      , migrated_records
      , failed_records
    ) WITH cnt AS (
        SELECT
            (
                SELECT
                    count(1)
                FROM
                    sde_gll.conversion_rates
            ) AS total_records
          , (
                SELECT
                    count(1)
                FROM
                    fee_reviews
            ) AS migrated_records
        FROM
            dual
    )
        SELECT
            p_starttime                              AS start_time
          , p_endtime                                AS end_time
          , 'sde_gll.CONVERSION_RATES'               AS original_entity
          , 'FEE_REVIEWS'                            AS new_entity
          , cnt.total_records                        AS total_records
          , cnt.migrated_records                     AS migrated_records
          , cnt.total_records - cnt.migrated_records AS failed_records
        FROM
            cnt;
 
    -- report on | sde_gll.GLLUSERINFO           | GLL.GLL_STRUCTURES |
    INSERT INTO migration_summary (
        start_time
      , end_time
      , original_entity
      , new_entity
      , total_records
      , migrated_records
      , failed_records
    ) WITH cnt AS (
        SELECT
            (
                SELECT
                    count(1)
                FROM
                    sde_gll.glluserinfo
            ) AS total_records
          , (
                SELECT
                    count(1)
                FROM
                    gll_structures
                WHERE
                    objectid_d IS NOT NULL
            ) AS migrated_records
        FROM
            dual
    )
        SELECT
            p_starttime                              AS start_time
          , p_endtime                                AS end_time
          , 'sde_gll.GLLUSERINFO'                    AS original_entity
          , 'GLL_STRUCTURES'                         AS new_entity
          , cnt.total_records                        AS total_records
          , cnt.migrated_records                     AS migrated_records
          , cnt.total_records - cnt.migrated_records AS failed_records
        FROM
            cnt;
 
    -- report on | sde_gll.GLL_PURPOSES          | GLL.GLL_USAGES     |
    INSERT INTO migration_summary (
        start_time
      , end_time
      , original_entity
      , new_entity
      , total_records
      , migrated_records
      , failed_records
    ) WITH cnt AS (
        SELECT
            (
                SELECT
                    count(1)
                FROM
                    sde_gll.gll_purposes
            ) AS total_records
          , (
                SELECT
                    count(1)
                FROM
                    gll_usages
            ) AS migrated_records
        FROM
            dual
    )
        SELECT
            p_starttime                              AS start_time
          , p_endtime                                AS end_time
          , 'sde_gll.GLL_PURPOSES'                   AS original_entity
          , 'GLL_USAGES'                             AS new_entity
          , cnt.total_records                        AS total_records
          , cnt.migrated_records                     AS migrated_records
          , cnt.total_records - cnt.migrated_records AS failed_records
        FROM
            cnt;
 
    -- report on | sde_gll.GLL_SUB_PURPOSES      | GLL.GLL_SUB_USAGE  |
    INSERT INTO migration_summary (
        start_time
      , end_time
      , original_entity
      , new_entity
      , total_records
      , migrated_records
      , failed_records
    ) WITH cnt AS (
        SELECT
            (
                SELECT
                    count(1)
                FROM
                    sde_gll.gll_sub_purposes
            ) AS total_records
          , (
                SELECT
                    count(1)
                FROM
                    gll_sub_usage
            ) AS migrated_records
        FROM
            dual
    )
        SELECT
            p_starttime                              AS start_time
          , p_endtime                                AS end_time
          , 'sde_gll.GLL_SUB_PURPOSES'               AS original_entity
          , 'GLL_SUB_USAGE'                          AS new_entity
          , cnt.total_records                        AS total_records
          , cnt.migrated_records                     AS migrated_records
          , cnt.total_records - cnt.migrated_records AS failed_records
        FROM
            cnt;
 
    -- report on | sde_gll.GOVERNMENTLANDLICENCE | GLL.GLLS           |
    INSERT INTO migration_summary (
        start_time
      , end_time
      , original_entity
      , new_entity
      , total_records
      , migrated_records
      , failed_records
    ) WITH cnt AS (
        SELECT
            (
                SELECT
                    count(1)
                FROM
                    sde_gll.governmentlandlicence
            ) AS total_records
          , (
                SELECT
                    count(1)
                FROM
                    glls
                WHERE
                    objectid_d IS NOT NULL
            ) AS migrated_records
        FROM
            dual
    )
        SELECT
            p_starttime                              AS start_time
          , p_endtime                                AS end_time
          , 'sde_gll.GOVERNMENTLANDLICENCE'          AS original_entity
          , 'GLLS'                                   AS new_entity
          , cnt.total_records                        AS total_records
          , cnt.migrated_records                     AS migrated_records
          , cnt.total_records - cnt.migrated_records AS failed_records
        FROM
            cnt;
 
    -- report on | sde_gll.GOVERNMENTLANDLICENCE | GLL.ATTACHMENTS    |
    INSERT INTO migration_summary (
        start_time
      , end_time
      , original_entity
      , new_entity
      , total_records
      , migrated_records
      , failed_records
    ) WITH cnt AS (
        SELECT
            (
                SELECT
                    count(1)
                FROM
                    sde_gll.governmentlandlicence g
                WHERE
                    g.filepath IS NOT NULL
                    AND g.filepath != 'null'
            ) + (
                SELECT
                    count(1)
                FROM
                    sde_gll.governmentlandlicence g
                WHERE
                    g.scpath IS NOT NULL
                    AND g.scpath != 'null'
            ) + (
                SELECT
                    count(1)
                FROM
                    sde_gll.governmentlandlicence g
                WHERE
                    g.licencefeefilepath IS NOT NULL
                    AND g.licencefeefilepath != 'null'
            ) + (
                SELECT
                    count(1)
                FROM
                    sde_gll.governmentlandlicence g
                WHERE
                    g.sirpath IS NOT NULL
                    AND g.sirpath != 'null'
            ) + (
                SELECT
                    count(1)
                FROM
                    sde_gll.governmentlandlicence g
                WHERE
                    g.rlpath IS NOT NULL
                    AND g.rlpath != 'null'
            ) AS total_records
          , (
                SELECT
                    count(1)
                FROM
                    attachments
                WHERE
                    url is not null
            ) AS migrated_records
        FROM
            dual
    )
        SELECT
            p_starttime                              AS start_time
          , p_endtime                                AS end_time
          , 'sde_gll.GOVERNMENTLANDLICENCE'          AS original_entity
          , 'ATTACHMENTS'                            AS new_entity
          , cnt.total_records                        AS total_records
          , cnt.migrated_records                     AS migrated_records
          , cnt.total_records - cnt.migrated_records AS failed_records
        FROM
            cnt;
 
    -- report on | sde_gll.GOVERNMENTLANDLICENCE | GLL.ATTACHMENT_GLL |
    INSERT INTO migration_summary (
        start_time
      , end_time
      , original_entity
      , new_entity
      , total_records
      , migrated_records
      , failed_records
    ) WITH cnt AS (
        SELECT
            (
                SELECT
                    count(1)
                FROM
                    sde_gll.governmentlandlicence g
                WHERE
                    g.filepath IS NOT NULL
                    AND g.filepath != 'null'
            ) + (
                SELECT
                    count(1)
                FROM
                    sde_gll.governmentlandlicence g
                WHERE
                    g.scpath IS NOT NULL
                    AND g.scpath != 'null'
            ) + (
                SELECT
                    count(1)
                FROM
                    sde_gll.governmentlandlicence g
                WHERE
                    g.licencefeefilepath IS NOT NULL
                    AND g.licencefeefilepath != 'null'
            ) + (
                SELECT
                    count(1)
                FROM
                    sde_gll.governmentlandlicence g
                WHERE
                    g.sirpath IS NOT NULL
                    AND g.sirpath != 'null'
            ) + (
                SELECT
                    count(1)
                FROM
                    sde_gll.governmentlandlicence g
                WHERE
                    g.rlpath IS NOT NULL
                    AND g.rlpath != 'null'
            ) AS total_records
          , (
                SELECT
                    count(1)
                FROM
                    attachment_gll
                WHERE
                    created_at < timestamp '2024-12-05 00:00:00.000'
            ) AS migrated_records
        FROM
            dual
    )
        SELECT
            p_starttime                              AS start_time
          , p_endtime                                AS end_time
          , 'sde_gll.GOVERNMENTLANDLICENCE'          AS original_entity
          , 'ATTACHMENT_GLL'                         AS new_entity
          , cnt.total_records                        AS total_records
          , cnt.migrated_records                     AS migrated_records
          , cnt.total_records - cnt.migrated_records AS failed_records
        FROM
            cnt;
END generate_report;