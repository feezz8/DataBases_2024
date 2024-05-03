DROP TABLE IF EXISTS episode_recipes;
DROP TABLE IF EXISTS episode_contestants;
DROP TABLE IF EXISTS episode_judges;
DROP TABLE IF EXISTS episode;
DROP TABLE IF EXISTS nutritional_info;
DROP TABLE IF EXISTS knows_recipe;
DROP TABLE IF EXISTS recipe_type;
DROP TABLE IF EXISTS recipe_steps;
DROP TABLE IF EXISTS recipe_tags;
DROP TABLE IF EXISTS recipe_theme;
DROP TABLE IF EXISTS recipe_description;
DROP TABLE IF EXISTS recipe_tips;
DROP TABLE IF EXISTS recipe_execution;
DROP TABLE IF EXISTS recipe;
DROP TABLE IF EXISTS ingredient;
DROP TABLE IF EXISTS cuisine;
DROP TABLE IF EXISTS theme;
DROP TABLE IF EXISTS cook;

CREATE TABLE ingredient(
    ingredient_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ingredient_name VARCHAR(255) NOT NULL,
    food_group VARCHAR(255) NOT NULL
);
CREATE TABLE nutritional_info(
    ingredient_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    carbs INT NOT NULL,
    fat INT NOT NULL,
    protein INT NOT NULL,
    calories INT NOT NULL,
    FOREIGN KEY(ingredient_id) REFERENCES ingredient(ingredient_id)
);
CREATE TABLE cuisine(
    cuisine_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cuisine_name VARCHAR(255) NOT NULL
);

CREATE TABLE theme(
    theme_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    theme_name VARCHAR(255) NOT NULL,
    theme_description TEXT NOT NULL
);
CREATE TABLE cook(
    cook_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    phone_number VARCHAR(10) NOT NULL,
    years_pro INT NOT NULL,
    cook_level INT NOT NULL
);
CREATE TABLE episode(
    episode_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_aired DATE NOT NULL,
    winner_id INT NOT NULL,
    FOREIGN KEY(winner_id) REFERENCES cook(cook_id)
);
CREATE TABLE recipe(
    recipe_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    main_ingredient INT NOT NULL,
    cuisine_id INT NOT NULL,
    recipe_name VARCHAR(255) NOT NULL,
    difiiculty_level INT NOT NULL,
    recipe_description TEXT NOT NULL,
    FOREIGN KEY(main_ingredient) REFERENCES ingredient(ingredient_id),
    FOREIGN KEY(cuisine_id) REFERENCES cuisine(cuisine_id)
);
CREATE TABLE knows_recipe(
    cook_id INT NOT NULL,
    recipe_id INT NOT NULL,
    CONSTRAINT PK_knows_recipe PRIMARY KEY(cook_id,recipe_id),
    FOREIGN KEY(cook_id) REFERENCES cook(cook_id),
    FOREIGN KEY(recipe_id) REFERENCES recipe(recipe_id)
);
CREATE TABLE recipe_type(
    recipe_id INT NOT NULL,
    main_ingredient INT NOT NULL,
    type_name VARCHAR(255) NOT NULL,
    CONSTRAINT PK_recipe_type PRIMARY KEY(recipe_id, main_ingredient),
    FOREIGN KEY(recipe_id) REFERENCES recipe(recipe_id),
    FOREIGN KEY(main_ingredient) REFERENCES ingredient(ingredient_id)
);
CREATE TABLE recipe_theme(
    recipe_id INT NOT NULL,
    theme_id INT NOT NULL,
    CONSTRAINT PK_recipe_theme PRIMARY KEY(recipe_id, theme_id),
    FOREIGN KEY(recipe_id) REFERENCES recipe(recipe_id),
    FOREIGN KEY(theme_id) REFERENCES theme(theme_id)
);
CREATE TABLE recipe_execution(
    recipe_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    prep_time INT NOT NULL,
    cooking_time INT NOT NULL,
    servings INT NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id)
);
CREATE TABLE recipe_tips(
    tip_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT NOT NULL,
    tip_description TEXT NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id)
);
CREATE TABLE recipe_tags(
    tag_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT NOT NULL,
    tag_description TEXT NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id)
);
CREATE TABLE recipe_steps(
    step_id INT NOT NULL AUTO_INCREMENT,
    recipe_id INT NOT NULL,
    step_no INT NOT NULL,
    step_description TEXT NOT NULL,
    CONSTRAINT PK_recipe_steps PRIMARY KEY(step_id, recipe_id),
    FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id)
);
CREATE TABLE episode_contestants(
    episode_id INT NOT NULL,
    contestant_id INT NOT NULL,
    rating INT NOT NULL,
    CONSTRAINT PK_episode_contestants PRIMARY KEY (episode_id,contestant_id,rating),
    FOREIGN KEY(episode_id) REFERENCES episode(episode_id),
    FOREIGN KEY(contestant_id) REFERENCES cook(cook_id)
);
CREATE TABLE episode_judges(
    episode_id INT NOT NULL,
    judge_id INT NOT NULL,
    CONSTRAINT PK_episode_judges PRIMARY KEY (episode_id,judge_id),
    FOREIGN KEY(episode_id) REFERENCES episode(episode_id),
    FOREIGN KEY(judge_id) REFERENCES cook(cook_id)
);
CREATE TABLE episode_recipes(
    episode_id INT NOT NULL,
    recipe_id INT NOT NULL,
    contestant_id INT NOT NULL,
    CONSTRAINT PK_episode_recipes PRIMARY KEY (episode_id,recipe_id,contestant_id),
    FOREIGN KEY(episode_id) REFERENCES episode(episode_id),
    FOREIGN KEY(recipe_id) REFERENCES recipe(recipe_id),
    FOREIGN KEY(contestant_id) REFERENCES episode_contestants(contestant_id)
);