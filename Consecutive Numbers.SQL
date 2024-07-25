# ------ FIRST SOLUTION (Beats 27.67% and 689ms)
# Temporal table 
-- WITH flags_is_consecutive AS (
--   SELECT
--     num,
--     CASE
--         # Checking if num value 2 rows back is equal to num value one row back and num value one row back is equal to current num (3rd place)
--         WHEN
--             LAG(num, 2) OVER (ORDER BY id) = LAG(num, 1) OVER (ORDER BY id)
--             AND LAG(num, 1) OVER (ORDER BY id) = num AND LAG(id, 2) OVER (ORDER BY id) +  1 = LAG(id, 1) OVER (ORDER BY id) and LAG(id, 1) OVER (ORDER BY id) + 1 = id
--         THEN 1
--         # Checking if num value 1 row back is equal to current num and num value is equal to one row forward (2nd place)
--         WHEN
--             LAG(num, 1) OVER (ORDER BY id) = num
--             AND num = LEAD(num, 1) OVER (ORDER BY id) AND LAG(id, 1) OVER (ORDER BY id) + 1 = id AND LEAD(id, 1) OVER (ORDER BY id) - 1 = id
--         THEN 1
--         # Checking if num value 1 row forward is equal to current num value and if num value 2 rows forward is equal to num value 1 row forward (1st place)
--         WHEN
--             num = LEAD(num, 1) OVER (ORDER BY id)
--             AND LEAD(num, 1) OVER (ORDER BY id) = LEAD(num, 2) OVER (ORDER BY id) AND LEAD(id, 1) OVER (ORDER BY id) - 1 = id AND LEAD(id, 2) OVER (ORDER BY id) - 2 = id
--         THEN 1
--         ELSE 0
--     END flag
--   FROM Logs
-- )

-- SELECT
--     DISTINCT(num) as ConsecutiveNums
-- FROM
--     flags_is_consecutive
-- WHERE
--     flag = 1



# ------ SECOND SOLUTION (Beats 72.29% and 496ms)
SELECT *
    DISTINCT num AS ConsecutiveNums
FROM (
    # Select from the previous id, current id, and next id as well as previous num, current num, and next num
    SELECT 
        LAG(id) OVER (ORDER BY id) AS prev_id,
        id,
        LEAD(id) OVER (ORDER BY id) AS next_id,
        LAG(num) OVER (ORDER BY id) AS prev_num,
        num,
        LEAD(num) OVER (ORDER BY id) AS next_num
    FROM logs
) subquery
# Validates that previous num is equal to current num and next num
# Validats id are consecutive
WHERE
    prev_num = num 
    AND num = next_num
    AND next_id - id = 1 
    AND id - prev_id = 1;
