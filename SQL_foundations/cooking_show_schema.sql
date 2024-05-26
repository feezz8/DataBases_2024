    DROP TABLE IF EXISTS recipe_meal_type; 
    DROP TABLE IF EXISTS recipe_tag; 
    DROP TABLE IF EXISTS recipe_equipment; 
    DROP TABLE IF EXISTS recipe_tip;
    DROP TABLE IF EXISTS recipe_ingredient;
    DROP TABLE IF EXISTS recipe_cook; 
    DROP TABLE IF EXISTS cook_cuisine; 
    DROP TABLE IF EXISTS episode_selection;
    DROP TABLE IF EXISTS episode_judge; 
    DROP TABLE IF EXISTS judge_rates_cook;
    DROP TABLE IF EXISTS cook; 
    DROP TABLE IF EXISTS recipe_theme; 
    DROP TABLE IF EXISTS step; 
    DROP TABLE IF EXISTS recipe; 
    DROP TABLE IF EXISTS cuisine; 
    DROP TABLE IF EXISTS meal_type; 
    DROP TABLE IF EXISTS tag; 
    DROP TABLE IF EXISTS tip; 
    DROP TABLE IF EXISTS equipment; 
    DROP TABLE IF EXISTS ingredient; 
    DROP TABLE IF EXISTS food_group; 
    DROP TABLE IF EXISTS theme; 
    DROP TABLE IF EXISTS cook_role; 
    DROP TABLE IF EXISTS episode;
    DROP TABLE IF EXISTS user_cook;
    DROP TABLE IF EXISTS user_admin;
    DROP TABLE IF EXISTS database_user;



    CREATE TABLE cuisine(
        cuisine_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        title VARCHAR(255) NOT NULL,
        PRIMARY KEY (cuisine_id)
    );

    CREATE TABLE recipe(
        recipe_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        baking BOOLEAN NOT NULL,
        cuisine_id INT UNSIGNED NOT NULL,
        difficulty TINYINT NOT NULL,
        title VARCHAR(255) NOT NULL,
        recipe_description TEXT NOT NULL,
        prep_time INT NOT NULL,
        cook_time INT NOT NULL,
        portions SMALLINT NOT NULL,
        fat_portion SMALLINT NOT NULL,
        protein_portion SMALLINT NOT NULL,
        carbo_portion SMALLINT NOT NULL,
        cal_portion FLOAT NOT NULL DEFAULT 0,
        picture VARCHAR(255),
        picture_description TEXT,
        PRIMARY KEY(recipe_id),
        CONSTRAINT fk_recipecuisine FOREIGN KEY(cuisine_id) REFERENCES cuisine(cuisine_id)
    );


    CREATE TABLE meal_type(
        meal_type_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        title VARCHAR(255) NOT NULL,
        PRIMARY KEY (meal_type_id)
    );

    CREATE TABLE recipe_meal_type(
        recipe_id INT UNSIGNED NOT NULL,
        meal_type_id INT UNSIGNED NOT NULL,
        PRIMARY KEY (recipe_id, meal_type_id),
        CONSTRAINT fk_recipe_meal_type_recipe FOREIGN KEY(recipe_id) REFERENCES recipe(recipe_id) ON UPDATE CASCADE,
        CONSTRAINT fk_recipe_meal_type_meal_type FOREIGN KEY(meal_type_id) REFERENCES meal_type(meal_type_id) ON UPDATE CASCADE
    );

    CREATE TABLE tag(
        tag_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        title VARCHAR(255) NOT NULL,
        PRIMARY KEY (tag_id)
    );

    CREATE TABLE recipe_tag(
        recipe_id INT UNSIGNED NOT NULL,
        tag_id INT UNSIGNED NOT NULL,
        PRIMARY KEY (recipe_id, tag_id),    CONSTRAINT fk_recipe_tag_recipe FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id) ON UPDATE CASCADE,
        CONSTRAINT fk_recipe_tag_tag FOREIGN KEY (tag_id) REFERENCES tag(tag_id) ON UPDATE CASCADE
    );

    CREATE TABLE tip(
        tip_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        title VARCHAR(255) NOT NULL,
        PRIMARY KEY (tip_id)
    );

    CREATE TABLE recipe_tip(
        recipe_id INT UNSIGNED NOT NULL,
        tip_id INT UNSIGNED NOT NULL,
        PRIMARY KEY (recipe_id, tip_id),
        CONSTRAINT fk_recipe_tip_recipe FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id) ON UPDATE CASCADE,
        CONSTRAINT fk_recipe_tip_tip FOREIGN KEY (tip_id) REFERENCES tip (tip_id) ON UPDATE CASCADE
    );


    CREATE TABLE equipment(
        equipment_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        title VARCHAR(255) NOT NULL,
        details TEXT NOT NULL,
        picture VARCHAR(255),
        picture_description TEXT,
        PRIMARY KEY(equipment_id)
    );

    CREATE TABLE recipe_equipment(
        recipe_id INT UNSIGNED NOT NULL,
        equipment_id INT UNSIGNED NOT NULL,
        num SMALLINT NOT NULL,
        PRIMARY KEY (recipe_id, equipment_id),
        CONSTRAINT fk_recipe_equipment_recipe FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id) ON UPDATE CASCADE,
        CONSTRAINT fk_recipe_equipment_equipment FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id) ON UPDATE CASCADE
    );

    CREATE TABLE step(
        step_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        recipe_id INT UNSIGNED NOT NULL,
        step_order SMALLINT NOT NULL,
        details TEXT NOT NULL,
        PRIMARY KEY (step_id),
        CONSTRAINT fk_step_recipe FOREIGN KEY (recipe_id) REFERENCES recipe (recipe_id) ON UPDATE CASCADE
    );

    CREATE TABLE food_group(
        food_group_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        title VARCHAR(255) NOT NULL,
        food_group_description TEXT NOT NULL,
        char_if_main TEXT NOT NULL,
        picture VARCHAR(255),
        picture_description TEXT,
        PRIMARY KEY(food_group_id)
    );


    CREATE TABLE ingredient(
        ingredient_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        title VARCHAR(255) NOT NULL,
        cal_gr INT NOT NULL,
        cal_ml INT NOT NULL,
        food_group_id INT UNSIGNED NOT NULL,
        picture VARCHAR(255),
        picture_description TEXT,
        PRIMARY KEY (ingredient_id),
        CONSTRAINT fk_ingredient_food_group FOREIGN KEY (food_group_id) REFERENCES food_group (food_group_id) ON UPDATE CASCADE
    );

    CREATE TABLE recipe_ingredient(
        recipe_id INT UNSIGNED NOT NULL,
        ingredient_id INT UNSIGNED NOT NULL,
        quantity INT,
        recipe_ingredient_description VARCHAR(255),
        main BOOLEAN NOT NULL,
        PRIMARY KEY (recipe_id, ingredient_id),
        CONSTRAINT fk_recipe_ingredient_recipe FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id) ON UPDATE CASCADE,
        CONSTRAINT fk_recipe_ingredient_ingredient FOREIGN KEY (ingredient_id) REFERENCES ingredient (ingredient_id) ON UPDATE CASCADE
    );



    CREATE TABLE theme(
        theme_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        title VARCHAR(255) NOT NULL,
        theme_description TEXT NOT NULL,
        picture VARCHAR(255),
        picture_description TEXT,
        PRIMARY KEY (theme_id)
    );

    CREATE TABLE recipe_theme(
        recipe_id INT UNSIGNED NOT NULL,
        theme_id INT UNSIGNED NOT NULL,
        PRIMARY KEY (recipe_id, theme_id),
        CONSTRAINT fk_recipe_theme_recipe FOREIGN KEY (recipe_id) REFERENCES recipe (recipe_id) ON UPDATE CASCADE,
        CONSTRAINT fk_recipe_theme_theme FOREIGN KEY (theme_id) REFERENCES theme (theme_id) ON UPDATE CASCADE
    );

    CREATE TABLE cook_role(
        cook_role_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        title VARCHAR(255),
        PRIMARY KEY (cook_role_id)
    );


    CREATE TABLE cook(
        cook_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        first_name VARCHAR(255) NOT NULL,
        last_name VARCHAR(255) NOT NULL,
        phone VARCHAR (10) NOT NULL,
        d_birth DATE NOT NULL,
        age SMALLINT,
        exp_years SMALLINT NOT NULL,
        cook_role_id INT UNSIGNED NOT NULL,
        picture VARCHAR(255),
        picture_description TEXT,
        PRIMARY KEY (cook_id),
        CONSTRAINT fk_cook_cook_role FOREIGN KEY (cook_role_id) REFERENCES cook_role (cook_role_id) ON UPDATE CASCADE
    );

    CREATE TABLE recipe_cook(
        recipe_id INT UNSIGNED NOT NULL,
        cook_id INT UNSIGNED NOT NULL,
        PRIMARY KEY (recipe_id, cook_id),
        CONSTRAINT fk_recipe_cook_recipe FOREIGN KEY (recipe_id) REFERENCES recipe (recipe_id) ON UPDATE CASCADE,
        CONSTRAINT fk_recipe_cook_cook FOREIGN KEY (cook_id) REFERENCES cook (cook_id) ON UPDATE CASCADE
    );

    CREATE TABLE cook_cuisine(
        cook_id INT UNSIGNED NOT NULL,
        cuisine_id INT UNSIGNED NOT NULL,
        PRIMARY KEY (cook_id, cuisine_id),
        CONSTRAINT fk_cook_cuisine_cook FOREIGN KEY (cook_id) REFERENCES cook (cook_id) ON UPDATE CASCADE,
        CONSTRAINT fk_cook_cuisine_cuisine FOREIGN KEY (cuisine_id) REFERENCES cuisine (cuisine_id) ON UPDATE CASCADE
    );

    CREATE TABLE episode (
        episode_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        season CHAR(4) NOT NULL,
        ep_num TINYINT NOT NULL,
        picture VARCHAR(255),
        picture_description TEXT,
        PRIMARY KEY (episode_id)
    );

    CREATE TABLE episode_selection(
        episode_id INT UNSIGNED NOT NULL,
        cook_id INT UNSIGNED NOT NULL,
        cuisine_id INT UNSIGNED,
        recipe_id INT UNSIGNED NOT NULL,
        PRIMARY KEY (episode_id, cook_id, cuisine_id, recipe_id),
        CONSTRAINT fk_episode_selection_episode FOREIGN KEY (episode_id) REFERENCES episode (episode_id) ON UPDATE CASCADE,
        CONSTRAINT fk_episode_selection_cook FOREIGN KEY (cook_id) REFERENCES cook (cook_id) ON UPDATE CASCADE,
        CONSTRAINT fk_episode_selection_cuisine FOREIGN KEY (cuisine_id) REFERENCES cuisine (cuisine_id) ON UPDATE CASCADE,
        CONSTRAINT fk_episode_selection_recipe FOREIGN KEY (recipe_id) REFERENCES recipe (recipe_id) ON UPDATE CASCADE
    );

    CREATE TABLE episode_judge(
        episode_id INT UNSIGNED NOT NULL,
        cook_id INT UNSIGNED NOT NULL,
        PRIMARY KEY (episode_id, cook_id),
        CONSTRAINT fk_episode_judge_episode FOREIGN KEY (episode_id) REFERENCES episode (episode_id) ON UPDATE CASCADE,
        CONSTRAINT fk_episode_judge_cook FOREIGN KEY (cook_id) REFERENCES cook (cook_id) ON UPDATE CASCADE
    );

    CREATE TABLE judge_rates_cook(
        episode_id INT UNSIGNED NOT NULL,
        judge_id INT UNSIGNED NOT NULL,
        cook_id INT UNSIGNED NOT NULL,
        rating TINYINT NOT NULL,
        PRIMARY KEY (episode_id, judge_id, cook_id),
        CONSTRAINT fk_judge_rates_cook_episode FOREIGN KEY (episode_id) REFERENCES episode (episode_id) ON UPDATE CASCADE,
        CONSTRAINT fk_judge_rates_cook_judge FOREIGN KEY (judge_id) REFERENCES cook (cook_id) ON UPDATE CASCADE,
        CONSTRAINT fk_judge_rates_cook_cook FOREIGN KEY (cook_id) REFERENCES cook (cook_id) ON UPDATE CASCADE
    );

    CREATE TABLE database_user(
        database_user_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        username VARCHAR(30) NOT NULL UNIQUE,
        user_password VARCHAR(50) NOT NULL UNIQUE,
        PRIMARY KEY (database_user_id)
    );

    CREATE TABLE user_cook(
        database_user_id INT UNSIGNED NOT NULL UNIQUE,
        CONSTRAINT fk_user_cook FOREIGN KEY (database_user_id) REFERENCES database_user (database_user_id) ON DELETE CASCADE
    );

    CREATE TABLE user_admin(
        database_user_id INT UNSIGNED NOT NULL UNIQUE,
        CONSTRAINT fk_user_admin FOREIGN KEY (database_user_id) REFERENCES database_user (database_user_id) ON DELETE CASCADE
    );

    
DROP TRIGGER IF EXISTS tr_recipe_difficulty;
DROP TRIGGER IF EXISTS tr_recipe_ingredient_not_null;
DROP TRIGGER IF EXISTS tr_cook_age_and_experience;
DROP TRIGGER IF EXISTS tr_cook_role;
DROP TRIGGER IF EXISTS tr_episode;
DROP TRIGGER IF EXISTS tr_tip_up_to_3;
DROP TRIGGER IF EXISTS tr_recipe_ingredient_one_main;
DROP TRIGGER IF EXISTS tr_episode_selection;
DROP TRIGGER IF EXISTS tr_recipe_cook_learns_cuisine;
DROP TRIGGER IF EXISTS tr_episode_judge_sel;
DROP TRIGGER IF EXISTS tr_judge_rates_cook;
DROP TRIGGER IF EXISTS tr_cal_portion_calculate;
DROP PROCEDURE IF EXISTS insert_episode_selection;
DROP PROCEDURE IF EXISTS insert_episode_judge;
DROP PROCEDURE IF EXISTS insert_judge_rates_cook;
DROP PROCEDURE IF EXISTS winner;
DROP PROCEDURE IF EXISTS insert_one_episode;
DROP PROCEDURE IF EXISTS insert_one_year;

DELIMITER //

CREATE TRIGGER tr_recipe_difficulty BEFORE INSERT ON recipe FOR EACH ROW
BEGIN
    IF new.difficulty NOT IN (1,2,3,4,5) THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "Cannot insert recipe because difficutly isn't between 1 and 5";
    END IF;
END//

CREATE TRIGGER tr_cal_portion_calculate AFTER INSERT ON recipe_ingredient FOR EACH ROW
BEGIN
    DECLARE add_calories INT;
    DECLARE old_cal_portion INT;

    SELECT cal_portion INTO old_cal_portion
    FROM recipe
    WHERE recipe_id = new.recipe_id;

    IF new.recipe_ingredient_description = 'gr' THEN
        SELECT (r.quantity/100)*i.cal_gr INTO add_calories
        FROM recipe_ingredient r
        INNER JOIN ingredient i ON i.ingredient_id = r.ingredient_id
        WHERE i.ingredient_id = new.ingredient_id AND r.recipe_id = new.recipe_id;
    ELSEIF new.recipe_ingredient_description = 'ml' THEN
        SELECT (r.quantity/100)*i.cal_ml INTO add_calories
        FROM recipe_ingredient r
        INNER JOIN ingredient i ON i.ingredient_id = r.ingredient_id
        WHERE i.ingredient_id = new.ingredient_id AND r.recipe_id = new.recipe_id;
    ELSE
        SET add_calories = 0;
    END IF;

    UPDATE recipe
    SET cal_portion = (old_cal_portion*portions + add_calories)/ portions
    WHERE recipe_id = new.recipe_id;
END//


CREATE TRIGGER tr_recipe_ingredient_not_null BEFORE INSERT ON recipe_ingredient FOR EACH ROW
BEGIN
    IF (new.quantity IS NULL AND new.recipe_ingredient_description IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "At least one of the two fields, quantity and recipe_ingredient_description, needs to not be null";
    END IF;
END//

CREATE TRIGGER tr_recipe_ingredient_one_main BEFORE INSERT ON recipe_ingredient FOR EACH ROW
BEGIN
    IF (new.main = 1) AND ((SELECT count(*) FROM recipe_ingredient WHERE main =1 AND recipe_id=new.recipe_id) <> 0) THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "Each recipe has only one main ingredient";
    END IF;
END//

CREATE TRIGGER tr_cook_age_and_experience BEFORE INSERT ON cook FOR EACH ROW
BEGIN 
    IF new.age IS NULL THEN
        SET new.age = (SELECT YEAR(now()) - YEAR(new.d_birth));
    END IF;
    IF new.exp_years >= (SELECT YEAR(now()) - YEAR(new.d_birth)) THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "A cook cannot have more years of experience than years of existance";
    END IF;
END//

CREATE TRIGGER tr_cook_role BEFORE INSERT ON cook_role FOR EACH ROW
BEGIN
    IF new.title NOT IN ("Chef", "Sous-chef", "A cook", "B cook", "C cook") THEN 
        SIGNAL SQLSTATE '45000'
        SET message_text = "Not valid cook role";
    END IF;
END//


CREATE TRIGGER tr_episode BEFORE INSERT ON episode FOR EACH ROW
BEGIN 
    IF (new.ep_num < 1 OR new.ep_num > 10) THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "Not valid episode number";
    END IF;
    IF (SELECT count(*) FROM episode WHERE season = new.season and ep_num = new.ep_num) >= 1 THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "This episode has already been added";
    END IF;
END//

CREATE TRIGGER tr_tip_up_to_3 BEFORE INSERT ON recipe_tip FOR EACH ROW
BEGIN
    IF (SELECT count(*) FROM recipe_tip WHERE recipe_id = new.recipe_id) >=3 THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "Cannot add more tips for this recipe";
    END IF;
END//





CREATE TRIGGER tr_episode_selection BEFORE INSERT ON episode_selection FOR EACH ROW
BEGIN
    DECLARE sel_count INT;
    DECLARE cook_count INT;
    DECLARE nat_count INT;
    DECLARE rec_count INT;
    DECLARE cook_recipe_count INT;
    DECLARE rec_nat INT;

    DECLARE consec INT;
    SET consec=0;


    SELECT cuisine_id INTO rec_nat FROM recipe WHERE recipe_id = new.recipe_id;
    SET new.cuisine_id = rec_nat;
    SELECT count(*) INTO sel_count FROM episode_selection WHERE episode_id = new.episode_id;
    IF sel_count >= 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Only 10 selections per episode';
    END IF;
    SELECT count(*) INTO cook_count FROM episode_selection WHERE episode_id = new.episode_id AND cook_id = new.cook_id;
    IF cook_count >=1 THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "This cook has already been selected for this episode";
    END IF;
    SELECT count(*) INTO nat_count FROM episode_selection WHERE episode_id = new.episode_id AND cuisine_id = new.cuisine_id;
    IF nat_count >=1 THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "This cuisine has already been selected for this episode";
    END IF;
    SELECT count(*) INTO rec_count FROM episode_selection WHERE episode_id = new.episode_id AND recipe_id = new.recipe_id;
    IF rec_count >=1 THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "This recipe has already been selected for this episode";
    END IF;
    SELECT count(*) INTO cook_recipe_count FROM recipe_cook WHERE recipe_id = new.recipe_id AND cook_id = new.cook_id;
    IF cook_recipe_count = 0 THEN   
        INSERT INTO recipe_cook VALUES (new.recipe_id, new.cook_id);
    END IF;




    SELECT count(*) INTO consec FROM episode_selection
    WHERE cook_id = new.cook_id AND (episode_id = new.episode_id +1 OR episode_id = new.episode_id +2 OR episode_id = new.episode_id +3);
    IF consec =3 THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "A cook cannot participate in 3 consecutive episodes";
    END IF;

    IF new.episode_id > 1 THEN
        SELECT count(*) INTO consec FROM episode_selection
        WHERE cook_id = new.cook_id AND (episode_id = new.episode_id -1 OR episode_id = new.episode_id +1 OR episode_id = new.episode_id +2);
        IF consec =3 THEN
            SIGNAL SQLSTATE '45000'
            SET message_text = "A cook cannot participate in 3 consecutive episodes";
        END IF;
    END IF;

    IF new.episode_id >2 THEN
        SELECT count(*) INTO consec FROM episode_selection
        WHERE cook_id = new.cook_id AND (episode_id = new.episode_id -2 OR episode_id = new.episode_id -1 OR episode_id = new.episode_id+1);
        IF consec =3 THEN
            SIGNAL SQLSTATE '45000'
            SET message_text = "A cook cannot participate in 3 consecutive episodes";
        END IF;
    END IF;

    IF new.episode_id >3 THEN
        SELECT count(*) INTO consec FROM episode_selection
        WHERE cook_id = new.cook_id AND (episode_id = new.episode_id -3 OR episode_id = new.episode_id -2 OR episode_id = new.episode_id-1);
        IF consec =3 THEN
            SIGNAL SQLSTATE '45000'
            SET message_text = "A cook cannot participate in 3 consecutive episodes";
        END IF;
    END IF;






    SELECT count(*) INTO consec FROM episode_selection
    WHERE cuisine_id = new.cuisine_id AND (episode_id = new.episode_id +1 OR episode_id = new.episode_id +2 OR episode_id = new.episode_id +3);
    IF consec =3 THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "A cuisine cannot participate in 3 consecutive episodes";
    END IF;

    IF new.episode_id > 1 THEN
        SELECT count(*) INTO consec FROM episode_selection
        WHERE cuisine_id = new.cuisine_id AND (episode_id = new.episode_id -1 OR episode_id = new.episode_id +1 OR episode_id = new.episode_id +2);
        IF consec =3 THEN
            SIGNAL SQLSTATE '45000'
            SET message_text = "A cuisine cannot participate in 3 consecutive episodes";
        END IF;
    END IF;

    IF new.episode_id >2 THEN
        SELECT count(*) INTO consec FROM episode_selection
        WHERE cuisine_id = new.cuisine_id AND (episode_id = new.episode_id -2 OR episode_id = new.episode_id -1 OR episode_id = new.episode_id+1);
        IF consec =3 THEN
            SIGNAL SQLSTATE '45000'
            SET message_text = "A cuisine cannot participate in 3 consecutive episodes";
        END IF;
    END IF;

    IF new.episode_id >3 THEN
        SELECT count(*) INTO consec FROM episode_selection
        WHERE cuisine_id = new.cuisine_id AND (episode_id = new.episode_id -3 OR episode_id = new.episode_id -2 OR episode_id = new.episode_id-1);
        IF consec =3 THEN
            SIGNAL SQLSTATE '45000'
            SET message_text = "A cuisine cannot participate in 3 consecutive episodes";
        END IF;
    END IF;






    SELECT count(*) INTO consec FROM episode_selection
    WHERE recipe_id = new.recipe_id AND (episode_id = new.episode_id +1 OR episode_id = new.episode_id +2 OR episode_id = new.episode_id +3);
    IF consec =3 THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "A recipe cannot participate in 3 consecutive episodes";
    END IF;

    IF new.episode_id > 1 THEN
        SELECT count(*) INTO consec FROM episode_selection
        WHERE recipe_id = new.recipe_id AND (episode_id = new.episode_id -1 OR episode_id = new.episode_id +1 OR episode_id = new.episode_id +2);
        IF consec =3 THEN
            SIGNAL SQLSTATE '45000'
            SET message_text = "A recipe cannot participate in 3 consecutive episodes";
        END IF;
    END IF;

    IF new.episode_id >2 THEN
        SELECT count(*) INTO consec FROM episode_selection
        WHERE recipe_id = new.recipe_id AND (episode_id = new.episode_id -2 OR episode_id = new.episode_id -1 OR episode_id = new.episode_id+1);
        IF consec =3 THEN
            SIGNAL SQLSTATE '45000'
            SET message_text = "A recipe cannot participate in 3 consecutive episodes";
        END IF;
    END IF;

    IF new.episode_id >3 THEN
        SELECT count(*) INTO consec FROM episode_selection
        WHERE recipe_id = new.recipe_id AND (episode_id = new.episode_id -3 OR episode_id = new.episode_id -2 OR episode_id = new.episode_id-1);
        IF consec =3 THEN
            SIGNAL SQLSTATE '45000'
            SET message_text = "A recipe cannot participate in 3 consecutive episodes";
        END IF;
    END IF;
END//


CREATE TRIGGER tr_recipe_cook_learns_cuisine AFTER INSERT ON recipe_cook FOR EACH ROW
BEGIN
    DECLARE nat_id INT;
    DECLARE already_exists INT;
    SELECT cuisine_id INTO nat_id FROM recipe WHERE recipe_id = new.recipe_id;
    SELECT count(*) INTO already_exists FROM cook_cuisine WHERE cook_id = new.cook_id AND cuisine_id = nat_id;
    IF already_exists = 0 THEN 
        INSERT INTO cook_cuisine VALUES (new.cook_id, nat_id);
    END IF;
END//


CREATE TRIGGER tr_episode_judge_sel BEFORE INSERT ON episode_judge FOR EACH ROW
BEGIN 
    DECLARE judge_count INT;
    DECLARE judge_as_competitor INT;
    DECLARE consec INT;
    SET consec =0;

    SELECT count(*) INTO judge_count FROM episode_judge WHERE episode_id = new.episode_id;
    IF judge_count >=3 THEN 
        SIGNAL SQLSTATE '45000'
        SET message_text = "Only 3 judges per episode please";
    END IF;
    SELECT count(*) INTO judge_as_competitor FROM episode_selection WHERE episode_id = new.episode_id AND cook_id = new.cook_id;
    IF judge_as_competitor <> 0 THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "A cook cannot be a judge in an episode they compete in";
    END IF;


    SELECT count(*) INTO consec FROM episode_judge
    WHERE cook_id = new.cook_id AND (episode_id = new.episode_id +1 OR episode_id = new.episode_id +2 OR episode_id = new.episode_id +3);
    IF consec =3 THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "A judge cannot participate in 3 consecutive episodes";
    END IF;

    IF new.episode_id > 1 THEN
        SELECT count(*) INTO consec FROM episode_judge
        WHERE cook_id = new.cook_id AND (episode_id = new.episode_id -1 OR episode_id = new.episode_id +1 OR episode_id = new.episode_id+2);
        IF consec =3 THEN
            SIGNAL SQLSTATE '45000'
            SET message_text = "A judge cannot participate in 3 consecutive episodes";
        END IF;
    END IF;

    IF new.episode_id >2 THEN
        SELECT count(*) INTO consec FROM episode_judge
        WHERE cook_id = new.cook_id AND (episode_id = new.episode_id -2 OR episode_id = new.episode_id -1 OR episode_id = new.episode_id+1);
        IF consec =3 THEN
            SIGNAL SQLSTATE '45000'
            SET message_text = "A judge cannot participate in 3 consecutive episodes";
        END IF;
    END IF;

    IF new.episode_id >3 THEN
        SELECT count(*) INTO consec FROM episode_judge
        WHERE cook_id = new.cook_id AND (episode_id = new.episode_id -3 OR episode_id = new.episode_id -2 OR episode_id = new.episode_id-1);
        IF consec =3 THEN
            SIGNAL SQLSTATE '45000'
            SET message_text = "A judge cannot participate in 3 consecutive episodes";
        END IF;
    END IF;
END//

CREATE TRIGGER tr_judge_rates_cook BEFORE INSERT ON judge_rates_cook FOR EACH ROW
BEGIN
    DECLARE judge_in_episode INT;
    DECLARE cook_in_episode INT;

    IF (new.rating > 5 OR new.rating <1) THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "Rating has to be between 1 and 5";
    END IF;

    SELECT count(*) INTO judge_in_episode FROM episode_judge WHERE episode_id = new.episode_id AND cook_id = new.judge_id;
    SELECT count(*) INTO cook_in_episode FROM episode_selection WHERE episode_id = new.episode_id AND cook_id = new.cook_id;
    IF judge_in_episode = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "This cook isn't a judge in this episode";
    END IF;

    IF cook_in_episode = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET message_text = "This cook isn't competitor in this episode";
    END IF;
END//


CREATE PROCEDURE insert_episode_selection()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE j INT DEFAULT 1;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;

    WHILE i <= (SELECT count(*) FROM episode) DO
        IF (SELECT count(*) FROM episode_selection WHERE episode_id = i) = 0 THEN 
            WHILE j <= 50 DO
                BEGIN
                    INSERT INTO episode_selection VALUES (i, FLOOR(RAND()*52+1), NULL, FLOOR(RAND()*55+1));
                END;
            SET j = j + 1;
            END WHILE;
        END IF;
        SET j = 1;
        SET i = i + 1;
    END WHILE;
END//


CREATE PROCEDURE insert_episode_judge()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE j INT DEFAULT 1;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;

    WHILE i <= (SELECT count(*) FROM episode) DO
        IF (SELECT count(*) FROM episode_judge WHERE episode_id = i) = 0 THEN
            WHILE j <= 10 DO
                BEGIN
                    INSERT INTO episode_judge VALUES (i, FLOOR(RAND()*52+1));
                END;
                SET j = j + 1;
            END WHILE;
        END IF;
        SET j = 1;
        SET i = i + 1;
    END WHILE;
END//

CREATE PROCEDURE insert_judge_rates_cook()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE j INT DEFAULT 1;
    DECLARE j1 INT;
    DECLARE j2 INT;
    DECLARE j3 INT;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
 
    WHILE i <= (SELECT count(*) FROM episode) DO
        IF (SELECT count(*) FROM judge_rates_cook WHERE episode_id = i) = 0 THEN
            SELECT cook_id INTO j1 FROM episode_judge WHERE episode_id = i ORDER BY cook_id ASC LIMIT 1;
            SELECT cook_id INTO j2 FROM episode_judge WHERE episode_id = i ORDER BY cook_id ASC LIMIT 1 OFFSET 1;
            SELECT cook_id INTO j3 FROM episode_judge WHERE episode_id = i ORDER BY cook_id ASC LIMIT 1 OFFSET 2;

            WHILE j<=600 DO
                BEGIN
                    INSERT INTO judge_rates_cook VALUES (i, j1,FLOOR(RAND()*52+1), FLOOR(RAND()*5+1));
                    INSERT INTO judge_rates_cook VALUES (i, j2,FLOOR(RAND()*52+1), FLOOR(RAND()*5+1));
                    INSERT INTO judge_rates_cook VALUES (i, j3,FLOOR(RAND()*52+1), FLOOR(RAND()*5+1));
                END;
                SET j= j+1;
            END WHILE;
        END IF;
        SET i = i + 1;
        SET j =1;
    END WHILE;
END//


CREATE PROCEDURE winner(IN ep_id INT, OUT winner_id INT)
BEGIN
    SELECT j.cook_id INTO winner_id
    FROM judge_rates_cook j
    INNER JOIN cook c ON j.cook_id = c.cook_id
    WHERE j.episode_id = ep_id
    GROUP BY j.cook_id
    HAVING sum(rating) = (
        SELECT sum(rating) FROM judge_rates_cook WHERE episode_id = ep_id GROUP BY cook_id ORDER BY sum(rating) DESC LIMIT 1
    )
    ORDER BY c.cook_role_id LIMIT 1;
END//







CREATE PROCEDURE insert_one_episode(IN ep_id INT)
BEGIN
    DECLARE j INT DEFAULT 1;
    DECLARE j1 INT;
    DECLARE j2 INT;
    DECLARE j3 INT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
    
    IF (SELECT count(*) FROM episode_selection WHERE episode_id = ep_id) = 0 THEN
        WHILE j <= 100 DO
            BEGIN
                INSERT INTO episode_selection VALUES (ep_id, FLOOR(RAND()*52+1), NULL, FLOOR(RAND()*55+1));
            END;
            SET j = j + 1;
        END WHILE;
    END IF;

    SET j=1;    
    IF (SELECT count(*) FROM episode_judge WHERE episode_id = ep_id) = 0 THEN
        WHILE j <= 10 DO
            BEGIN
                INSERT INTO episode_judge VALUES (ep_id, FLOOR(RAND()*52+1));
            END;
            SET j = j + 1;
        END WHILE;
    END IF;




    SET j=1;    
    IF (SELECT count(*) FROM judge_rates_cook WHERE episode_id = ep_id) = 0 THEN
        SELECT cook_id INTO j1 FROM episode_judge WHERE episode_id = ep_id ORDER BY cook_id ASC LIMIT 1;
        SELECT cook_id INTO j2 FROM episode_judge WHERE episode_id = ep_id ORDER BY cook_id ASC LIMIT 1 OFFSET 1;
        SELECT cook_id INTO j3 FROM episode_judge WHERE episode_id = ep_id ORDER BY cook_id ASC LIMIT 1 OFFSET 2;

        WHILE j<=600 DO
            BEGIN
                INSERT INTO judge_rates_cook VALUES (ep_id, j1,FLOOR(RAND()*52+1), FLOOR(RAND()*5+1));
                INSERT INTO judge_rates_cook VALUES (ep_id, j2,FLOOR(RAND()*52+1), FLOOR(RAND()*5+1));
                INSERT INTO judge_rates_cook VALUES (ep_id, j3,FLOOR(RAND()*52+1), FLOOR(RAND()*5+1));
            END;
            SET j= j+1;
        END WHILE;
    END IF;
END//

CREATE PROCEDURE insert_one_year(IN y INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE j INT;

    SET j = 1 + (y - 2019)*10;

    WHILE (i<=10) DO
        CALL insert_one_episode(j);
        SET i=i+1;
        SET j=j+1;
    END WHILE;
END//

DELIMITER ;
