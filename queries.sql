1.
SELECT cu.cuisine_id, cu.title, c.cook_id, concat(c.first_name, ' ', c.last_name) AS full_name, avg(jrc.rating) AS average_rating
FROM cuisine cu 
INNER JOIN episode_selection es ON es.cuisine_id = cu.cuisine_id
INNER JOIN cook c ON c.cook_id = es.cook_id
INNER JOIN judge_rates_cook jrc ON jrc.cook_id = c.cook_id
GROUP BY cu.cuisine_id, cu.title, c.cook_id, concat(c.first_name, ' ', c.last_name);


2.
--First Create the views, Then run the select query
DROP VIEW v1;
DROP VIEW v2;

CREATE VIEW v1 AS
SELECT c.cook_id, c.first_name, c.last_name
FROM cook c
INNER JOIN cook_cuisine ck ON c.cook_id = ck.cook_id
INNER JOIN cuisine n ON n.cuisine_id = ck.cuisine_id
WHERE n.title = "United Kingdom";

CREATE VIEW v2 AS
SELECT c.cook_id, c.first_name, c.last_name
FROM episode_selection es 
INNER JOIN episode e ON e.episode_id = es.episode_id
INNER JOIN cuisine cu ON cu.cuisine_id = es.cuisine_id
INNER JOIN cook c ON c.cook_id = es.cook_id
WHERE e.season = '2022' AND cu.title = 'United Kingdom';

--@block
SELECT v1.cook_id, concat(v1.first_name, ' ', v1.last_name) AS cook_name, CASE WHEN v1.cook_id IN (SELECT v2.cook_id FROM v2) THEN "Participant" ELSE "Not Participant" END AS Participant_status
FROM v1;


3.
SELECT 
    c.cook_id,
    c.first_name,
    c.last_name,
    c.age,
    COUNT(rc.recipe_id) AS recipe_count
FROM 
    cook c
JOIN 
    recipe_cook rc ON c.cook_id = rc.cook_id
WHERE 
    c.age < 30
GROUP BY 
    c.cook_id
ORDER BY 
    recipe_count DESC,
    c.age ASC
LIMIT 10;


4.
SELECT 
    c.cook_id,
    c.first_name,
    c.last_name
FROM 
    cook c
LEFT JOIN 
    episode_judge ej ON c.cook_id = ej.cook_id
WHERE 
    ej.cook_id IS NULL;


6.
WITH TagPairs AS (
    SELECT 
        rt1.recipe_id,
        t1.tag_id AS tag1_id,
        t1.title AS tag1,
        t2.tag_id AS tag2_id,
        t2.title AS tag2
    FROM 
        recipe_tag rt1
    JOIN 
        recipe_tag rt2 ON rt1.recipe_id = rt2.recipe_id AND rt1.tag_id < rt2.tag_id
    JOIN 
        tag t1 ON rt1.tag_id = t1.tag_id
    JOIN 
        tag t2 ON rt2.tag_id = t2.tag_id
),
TagPairCounts AS (
    SELECT 
        tag1, tag2, COUNT(*) AS pair_count
    FROM 
        TagPairs
    GROUP BY 
        tag1, tag2
)
SELECT 
    tag1, tag2, pair_count
FROM 
    TagPairCounts
ORDER BY 
    pair_count DESC
LIMIT 3;

-- This one uses indeces
WITH TagPairs AS (
    SELECT 
        rt1.recipe_id,
        t1.tag_id AS tag1_id,
        t1.title AS tag1,
        t2.tag_id AS tag2_id,
        t2.title AS tag2
    FROM 
        recipe_tag rt1 FORCE INDEX (idx_recipe_tag_recipe_id)
    JOIN 
        recipe_tag rt2 FORCE INDEX (idx_recipe_tag_recipe_id) 
        ON rt1.recipe_id = rt2.recipe_id AND rt1.tag_id < rt2.tag_id
    JOIN 
        tag t1 ON rt1.tag_id = t1.tag_id
    JOIN 
        tag t2 ON rt2.tag_id = t2.tag_id
),
TagPairCounts AS (
    SELECT 
        tag1, tag2, COUNT(*) AS pair_count
    FROM 
        TagPairs
    GROUP BY 
        tag1, tag2
)
SELECT 
    tag1, tag2, pair_count
FROM 
    TagPairCounts
ORDER BY 
    pair_count DESC
LIMIT 3;



7.
SELECT c.cook_id, concat(c.first_name, ' ', c.last_name) 'Cooks who have participated in at least 5 less episodes that the cook with the most episodes', count(*) 'Number of episodes'
FROM cook c
INNER JOIN episode_selection se ON se.cook_id = c.cook_id
GROUP BY c.cook_id
HAVING count(*) <= -5 + (
    SELECT count(*)
    FROM cook c
    INNER JOIN episode_selection se ON se.cook_id = c.cook_id
    GROUP BY c.cook_id
    ORDER BY count(*) DESC LIMIT 1
)
ORDER BY count(*);

8.
SELECT 
    es.episode_id,
    COUNT(re.equipment_id) AS equipment_count
FROM 
    episode_selection es
JOIN 
    recipe_equipment re ON es.recipe_id = re.recipe_id
GROUP BY 
    es.episode_id
ORDER BY 
    equipment_count DESC
LIMIT 1;

--This one uses indeces
SELECT 
    es.episode_id,
    COUNT(re.equipment_id) AS equipment_count
FROM 
    episode_selection es FORCE INDEX (idx_episode_selection_recipe_id)
JOIN 
    recipe_equipment re FORCE INDEX (idx_recipe_equipment_recipe_id, idx_recipe_equipment_equipment_id) 
    ON es.recipe_id = re.recipe_id
GROUP BY 
    es.episode_id
ORDER BY 
    equipment_count DESC
LIMIT 1;



9. 
SELECT 
    e.season,
    AVG(r.carbo_portion*r.portions) AS avg_carbo_grams
FROM 
    episode_selection es
JOIN 
    recipe r ON es.recipe_id = r.recipe_id
JOIN 
    episode e ON es.episode_id = e.episode_id
GROUP BY 
    e.season
ORDER BY 
    e.season;

10.
WITH YearlyCuisineParticipations AS (
    SELECT 
        es.cuisine_id,
        e.season,
        COUNT(*) AS participation_count
    FROM 
        episode_selection es
    JOIN 
        episode e ON es.episode_id = e.episode_id
    WHERE 
        es.cuisine_id IS NOT NULL
    GROUP BY 
        es.cuisine_id, e.season
    HAVING 
        COUNT(*) >= 3
), ConsecutiveYearParticipations AS (
    SELECT 
        yc1.cuisine_id,
        yc1.season AS season1,
        yc1.participation_count AS participation_count1,
        yc2.season AS season2,
        yc2.participation_count AS participation_count2
    FROM 
        YearlyCuisineParticipations yc1
    JOIN 
        YearlyCuisineParticipations yc2 
    ON 
        yc1.cuisine_id = yc2.cuisine_id
        AND yc1.season = yc2.season - 1
)
SELECT 
    c.cuisine_id,
    c.title
    c.title AS cuisine_name,
    cy1.season1,
    cy1.participation_count1,
    cy1.season2,
    cy1.participation_count2
FROM 
    ConsecutiveYearParticipations cy1
JOIN 
    cuisine c ON cy1.cuisine_id = c.cuisine_id
WHERE 
    cy1.participation_count1 = cy1.participation_count2
ORDER BY 
    c.cuisine_id, cy1.season1;


11.
SELECT jrc.judge_id, concat(j.first_name, ' ', j.last_name) AS judge_name, c.cook_id, concat(c.first_name, ' ', c.last_name) AS cook_name, avg(rating) AS average_rating
FROM judge_rates_cook jrc
INNER JOIN cook c ON c.cook_id = jrc.cook_id
INNER JOIN cook j ON j.cook_id = jrc.judge_id 
GROUP BY cook_id, concat(c.first_name, ' ', c.last_name), jrc.judge_id, concat(j.first_name, ' ', j.last_name)
ORDER BY sum(rating) DESC LIMIT 5;


12. 
SELECT * FROM (
    SELECT e.season, e.episode_id, e.ep_num, sum(r.difficulty) AS total_difficulty
    FROM episode_selection es
    INNER JOIN episode e ON e.episode_id = es.episode_id
    INNER JOIN recipe r ON r.recipe_id = es.recipe_id
    WHERE season = "2019"
    GROUP BY e.episode_id, e.ep_num
    ORDER BY sum(r.difficulty) DESC LIMIT 1
) AS subq1
UNION ALL
SELECT * FROM (
    SELECT e.season, e.episode_id, e.ep_num, sum(r.difficulty) AS total_difficulty
    FROM episode_selection es
    INNER JOIN episode e ON e.episode_id = es.episode_id
    INNER JOIN recipe r ON r.recipe_id = es.recipe_id
    WHERE season = "2020"
    GROUP BY e.episode_id, e.ep_num
    ORDER BY sum(r.difficulty) DESC LIMIT 1
) AS subq2
UNION ALL
SELECT * FROM (
    SELECT e.season, e.episode_id, e.ep_num, sum(r.difficulty) AS total_difficulty
    FROM episode_selection es
    INNER JOIN episode e ON e.episode_id = es.episode_id
    INNER JOIN recipe r ON r.recipe_id = es.recipe_id
    WHERE season = "2021"
    GROUP BY e.episode_id, e.ep_num
    ORDER BY sum(r.difficulty) DESC LIMIT 1
) AS subq3
UNION ALL
SELECT * FROM (
    SELECT e.season, e.episode_id, e.ep_num, sum(r.difficulty) AS total_difficulty
    FROM episode_selection es
    INNER JOIN episode e ON e.episode_id = es.episode_id
    INNER JOIN recipe r ON r.recipe_id = es.recipe_id
    WHERE season = "2022"
    GROUP BY e.episode_id, e.ep_num
    ORDER BY sum(r.difficulty) DESC LIMIT 1
) AS subq4
UNION ALL
SELECT * FROM (
    SELECT e.season, e.episode_id, e.ep_num, sum(r.difficulty) AS total_difficulty
    FROM episode_selection es
    INNER JOIN episode e ON e.episode_id = es.episode_id
    INNER JOIN recipe r ON r.recipe_id = es.recipe_id
    WHERE season = "2023"
    GROUP BY e.episode_id, e.ep_num
    ORDER BY sum(r.difficulty) DESC LIMIT 1
) AS subq5
UNION ALL
SELECT * FROM (
    SELECT e.season, e.episode_id, e.ep_num, sum(r.difficulty) AS total_difficulty
    FROM episode_selection es
    INNER JOIN episode e ON e.episode_id = es.episode_id
    INNER JOIN recipe r ON r.recipe_id = es.recipe_id
    WHERE season = "2024"
    GROUP BY e.episode_id, e.ep_num
    ORDER BY sum(r.difficulty) DESC LIMIT 1
) AS subq6;


13.
SELECT episode_id, season, ep_num, SUM(total_sum) AS 'least_skilled(Higher number = less capable)'
FROM (
    SELECT e.episode_id, e.season, e.ep_num, SUM(c.cook_role_id) AS total_sum
    FROM episode e
    INNER JOIN episode_selection es ON es.episode_id = e.episode_id
    INNER JOIN cook c ON c.cook_id = es.cook_id
    GROUP BY e.episode_id, e.season, e.ep_num

    UNION ALL

    SELECT e.episode_id, e.season, e.ep_num, SUM(c.cook_role_id) AS total_sum
    FROM episode e
    INNER JOIN episode_judge ej ON ej.episode_id = e.episode_id
    INNER JOIN cook c ON c.cook_id = ej.cook_id
    GROUP BY e.episode_id, e.season, e.ep_num
) AS combined_data
GROUP BY episode_id, season, ep_num
ORDER BY SUM(total_sum) DESC LIMIT 1;


14.
SELECT 
    t.theme_id,
    t.title AS theme_name,
    COUNT(*) AS appearance_count
FROM 
    theme t
JOIN 
    recipe_theme rt ON t.theme_id = rt.theme_id
JOIN 
    episode_selection es ON rt.recipe_id = es.recipe_id
GROUP BY 
    t.theme_id, t.title
ORDER BY 
    appearance_count DESC
LIMIT 1;

15.
SELECT food_group_id,
    title AS food_group_name
FROM
    food_group
WHERE food_group_id NOT IN (
    SELECT DISTINCT fg.food_group_id
    FROM food_group fg
    JOIN ingredient i ON fg.food_group_id = i.food_group_id
    JOIN recipe_ingredient ri ON i.ingredient_id = ri.ingredient_id
    JOIN episode_selection es ON ri.recipe_id = es.recipe_id
);
