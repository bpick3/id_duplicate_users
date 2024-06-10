WITH user_committees AS (
    SELECT
        user_id,
        first_name,
        last_name,
        email,
        home_phone,
        cell_phone,
        committee_id,
        date_of_last_login
    FROM
        demswasp.vansync.users -- Replace state code
),
multi_account_users AS (
    SELECT
        user_id,
        first_name,
        last_name,
        email,
        home_phone,
        cell_phone,
        COUNT(DISTINCT committee_id) AS committee_count
    FROM
        user_committees
    GROUP BY
        user_id, first_name, last_name, email, home_phone, cell_phone
    HAVING
        committee_count > 1
)
SELECT
    uc.user_id,
    uc.first_name,
    uc.last_name,
    uc.email,
    uc.home_phone,
    uc.cell_phone,
    uc.committee_id,
    uc.date_of_last_login
FROM
    user_committees uc
JOIN
    multi_account_users mau
ON
    (uc.user_id = mau.user_id OR
     uc.email = mau.email OR
     uc.home_phone = mau.home_phone OR
     uc.cell_phone = mau.cell_phone)
ORDER BY
    uc.email, uc.home_phone, uc.cell_phone, uc.user_id, uc.committee_id;
