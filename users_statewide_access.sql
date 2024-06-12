WITH user_committees AS (
    SELECT
        uc.user_id,
        uc.first_name,
        uc.last_name,
        uc.email,
        uc.home_phone,
        uc.cell_phone,
        uc.committee_id,
        c.committee_name,
        c.committee_type_name
    FROM
        demswasp.vansync.users AS uc
    JOIN
        demswasp.vansync.committees AS c
    ON
        uc.committee_id = c.committee_id
),
statewide_access AS (
    SELECT
        user_id,
        is_statewide,
        is_active
    FROM
        demswasp.vansync.users_databases
)
SELECT
    uc.user_id,
    uc.first_name,
    uc.last_name,
    uc.email,
    uc.home_phone,
    uc.cell_phone,
    uc.committee_id,
    uc.committee_name,
    uc.committee_type_name,
    sa.is_statewide
FROM
    user_committees uc
JOIN
    statewide_access sa
ON
    uc.user_id = sa.user_id
WHERE
    sa.is_statewide = TRUE
AND sa.is_active = TRUE
GROUP BY 1,2,3,4,5,6,7,8,9,10
ORDER BY
    uc.user_id, uc.committee_id
