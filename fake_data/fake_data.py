
import random
import faker
import itertools
import datetime
from faker.providers import BaseProvider, ElementsType
from datetime import date


random.seed(9)
faker.Faker.seed(9)

N_RECIPES = 100
N_CUISINES = 50
N_COOKS = 200
N_INGREDIENTS = 365
N_EQUIPMENT = 20
N_TAG = 100
N_TIPS = 40
N_THEME = 40
N_MEAL_TYPE = 6
N_FOOD_GROUP = 20
N_COOK_ROLES = 5
START_DATE = date(1960,1, 1)
END_DATE = date(2000, 1, 1)
N_EPISODES = 60
FIRST_EPISODE = 2018


def fake_recipes_ingredients_cooks(f):
    fake = faker.Faker()

    file_obj = open("Fake_data_info/ingredients.txt", "r")
    file_data = file_obj.read()
    ingredientstext = file_data.splitlines()
    file_obj.close

    file_obj = open("Fake_data_info/recipe_names.txt", "r")
    file_data = file_obj.read()
    namestext = file_data.splitlines()
    file_obj.close

    file_obj = open("Fake_data_info/recipe_steps.txt", "r")
    file_data = file_obj.read()
    stepstext = file_data.splitlines()
    file_obj.close

    file_obj = open("Fake_data_info/equipment.txt", "r")
    file_data = file_obj.read()
    equipmenttext = file_data.splitlines()
    file_obj.close

    file_obj = open("Fake_data_info/recipe_tags.txt", "r")
    file_data = file_obj.read()
    tagstext = file_data.splitlines()
    file_obj.close

    file_obj = open("Fake_data_info/tips.txt", "r")
    file_data = file_obj.read()
    tipstext = file_data.splitlines()
    file_obj.close

    file_obj = open("Fake_data_info/recipe_themes.txt", "r")
    file_data = file_obj.read()
    themestext = file_data.splitlines()
    file_obj.close

    file_obj = open("Fake_data_info/food_groups.txt", "r")
    file_data = file_obj.read()
    foodgroupstext = file_data.splitlines()
    file_obj.close

    cook_level_elements = ["C cook", "B cook", "A cook", "Sous-chef", "Chef"]

    class CookingFakeData(BaseProvider):

        equipment_elements: ElementsType[str] = equipmenttext
        
        ingredient_elements: ElementsType[str] = ingredientstext
        
        tips_elements: ElementsType[str] = tipstext
        
        recipe_elements: ElementsType[str] = namestext
        
        steps_elements: ElementsType[str] = stepstext
        
        tags_elements: ElementsType[str] = tagstext
        
        themes_elements: ElementsType[str] = themestext
        
        food_groups_elements: ElementsType[str] = foodgroupstext
        
        meal_type_elements: ElementsType[str] = [
            "Breakfast", "Lunch", "Dinner", "Brunch", "Snack", "After-noon snack"
        ]
        
        food_group_char_elements: ElementsType[str] = [
            "Vegeterian", "Pesceterian", "Meat-Lovers", "Pork-based", "Chiken-based", "For vegans", "Soy-Based",
            "Gluten-Free", "Spicy", "Keto", "Party-platters", "Spreadable and maintanable", "Kids will love it", "Low-calorie snacks",
            "Water-based", "Milk-based", "Soups for the winter", "Full of protein and fats", "Nut-Based", "Perfect dinner-date", "Pasta-Lovers",
             
            
        ]
        quantity_elements: ElementsType[str] = [
            "ml", "gr", "Few", "A little", "NULL", "A pinch", "A cup", "A tablespoon of"
            , "A teaspoon of", 
        ]
        
        def equipment(self) -> str:
            return self.random_element(self.equipment_elements)
        
        def ingredient(self) -> str:
            return self.random_element(self.ingredient_elements)
        
        def recipe(self) -> str:
            return self.random_element(self.recipe_elements)
        
        def steps(self) -> str:
            return self.random_element(self.steps_elements)
        
        def tags(self) -> str:
            return self.random_element(self.tags_elements)       
        
        def tips(self) -> str:
            return self.random_element(self.tips_elements)
        
        def themes(self) -> str:
            return self.random_element(self.themes_elements)
        
        def foodgroups(self) -> str:
            return self.random_element(self.food_groups_elements)
        
        def meal_type(self) -> str:
            return self.random_element(self.meal_type_elements)
        
        def food_group_char(self) -> str:
            return self.random_element(self.food_group_char_elements)
        
        def quantity(self) -> str:
            return self.random_element(self.quantity_elements)
    
            
        
    fake.add_provider(CookingFakeData)
    
    def build_cook():
        first_name = fake.first_name()
        last_name = fake.last_name()
        phone = fake.unique.numerify('69########')
        d_birth = fake.date_between_dates(date_start = START_DATE, date_end = END_DATE)
        year_born = d_birth.year
        age = 2018 - year_born
        experience = (random.randint(1, age - 17))
        cook_role_id = random.randint(1, 5)
        picture_uri = fake.image_url()
        picture_description = fake.sentence()
        return f"INSERT INTO cook(first_name, last_name, phone, d_birth, age, exp_years, cook_role_id, picture, picture_description) VALUES\
('{first_name}', '{last_name}', {phone}, '{d_birth}', NULL, {experience}, {cook_role_id}, '{picture_uri}', '{picture_description}');\n"
                   
    
    def build_food_group():
        title = fake.unique.foodgroups()
        food_group_description = fake.unique.paragraph(nb_sentences = 2)
        char_if_main = fake.unique.food_group_char()
        picture_uri = fake.image_url()
        picture_description = fake.sentence()
        return f"INSERT INTO food_group(title, food_group_description, char_if_main, picture, picture_description) VALUES\
('{title}', '{food_group_description}', '{char_if_main}', '{picture_uri}', '{picture_description}');\n"

    def build_ingredient():
        ingredient_title = fake.unique.ingredient()
        cal_gr = random.randint(1, 10)
        cal_ml = random.randint(1, 10)
        food_group = random.randint(1, N_FOOD_GROUP)
        picture_uri = fake.image_url()
        picture_description = fake.sentence()
        return f"INSERT INTO ingredient(title, cal_gr, cal_ml, food_group_id, picture, picture_description) VALUES\
('{ingredient_title}', {cal_gr}, {cal_ml}, {food_group}, '{picture_uri}', '{picture_description}');\n"
    
    def build_recipe(recipe_id):
        baking = random.randint(0,1)
        cuisine = random.randint(1, N_CUISINES)
        difficulty = random.randint(1, 5)
        recipe_title = fake.unique.recipe()
        recipe_decription = fake.paragraph(nb_sentences = 4)
        prep_time = random.randrange(15, 130, 10)
        cook_time = random.randrange(0, 130, 10)
        portions = random.randint(1, 5)
        fat_portion = random.randrange(0, 60, 5)
        protein_portion = random.randrange(0, 70, 5)
        carbs_portion = random.randrange(0, 90, 5)
        picture_uri = fake.image_url()
        picture_description = fake.sentence()
        tags = random.sample(range(1, N_TAG + 1), random.randint(1, 8))
        equipments = random.sample(range(1, N_EQUIPMENT + 1), random.randint(3, 7))
        recipe_cooks = random.sample(range(1, N_COOKS + 1), random.randint(1, N_COOKS))
        themes = random.sample(range(1, N_THEME + 1), random.randint(1, 3))
        tips = random.sample(range(1, N_TIPS + 1), random.randint(1, 3))
        return [f"INSERT INTO recipe(baking, cuisine_id, difficulty, title, recipe_description, prep_time, cook_time, portions, fat_portion, protein_portion, carbo_portion, picture, picture_description) VALUES\
({baking}, {cuisine}, {difficulty},'{recipe_title}', '{recipe_decription}', {prep_time}, {cook_time}, {portions}, {fat_portion}, {protein_portion},\
{carbs_portion}, '{picture_uri}', '{picture_description}');\n",\
            *[f"INSERT INTO recipe_meal_type(recipe_id, meal_type_id) VALUES ({recipe_id}, {random.randint(1, N_MEAL_TYPE)});\n"],\
            *[f"INSERT INTO recipe_tag(recipe_id, tag_id) VALUES ({recipe_id}, {tag_id});\n" for tag_id in tags],\
            *[f"INSERT INTO recipe_equipment(recipe_id, equipment_id, num) VALUES ({recipe_id}, {equipment_id}, {random.randint(1, 4)});\n" for equipment_id in equipments],\
            *[f"INSERT INTO recipe_cook(recipe_id, cook_id) VALUES ({recipe_id}, {cook_id});\n" for cook_id in recipe_cooks],\
            *[f"INSERT INTO recipe_theme(recipe_id, theme_id) VALUES ({recipe_id}, {theme_id});\n" for theme_id in themes],\
            *[f"INSERT INTO recipe_tip(recipe_id, tip_id) VALUES ({recipe_id}, {tip_id});\n" for tip_id in tips]]
     
    def build_step_order(step_order, recipe_id):
        details = fake.steps()
        return f"INSERT INTO step(recipe_id, step_order, details) VALUES ({recipe_id}, {step_order}, '{details}');\n"
    
    def build_episodes(episode_id):
        year = FIRST_EPISODE + ((episode_id // 10) + 1)
        ep_num = (episode_id % 10) + 1
        picture = fake.image_url()
        picture_description = fake.sentence()
        return f"INSERT INTO episode(season, ep_num, picture, picture_description) VALUES ({year}, {ep_num}, '{picture}', '{picture_description}');\n"
            
    def build_recipe_ingredient(recipe_id):
        for _ in range(random.randint(5, 15)):
            ingredient_id = random.randint(1, 299)
            description = fake.quantity()
            if description == "NULL":
                quantity = random.randint(2, 8)
                f.write(f"INSERT INTO recipe_ingredient(recipe_id, ingredient_id, quantity, recipe_ingredient_description, main) VALUES\
({recipe_id}, {ingredient_id}, {quantity}, {description}, 0);\n")
            elif description == "ml":
                quantity = random.randrange(50, 700, 20)
                f.write(f"INSERT INTO recipe_ingredient(recipe_id, ingredient_id, quantity, recipe_ingredient_description, main) VALUES\
({recipe_id}, {ingredient_id}, {quantity}, '{description}', 0);\n")
            elif description == "gr":
                quantity = random.randrange(50, 700, 20)
                f.write(f"INSERT INTO recipe_ingredient(recipe_id, ingredient_id, quantity, recipe_ingredient_description, main) VALUES\
({recipe_id}, {ingredient_id}, {quantity}, '{description}', 0);\n")
            else:
                f.write(f"INSERT INTO recipe_ingredient(recipe_id, ingredient_id, quantity, recipe_ingredient_description, main) VALUES\
({recipe_id}, {ingredient_id}, NULL, '{description}', 0);\n")
                

    cuisines = (fake.unique.country() for _ in range(N_CUISINES))
    meal_types = (fake.unique.meal_type() for _ in range(N_MEAL_TYPE))
    themes = list((fake.unique.themes() for _ in range(N_THEME)))
    themes_description = list((fake.unique.paragraph(nb_sentences = 2 ) for _ in range(N_THEME)))
    tags = (fake.unique.tags() for _ in range(N_TAG))
    tips = (fake.unique.tips() for _ in range(N_TIPS))
    equipments = list((fake.unique.equipment() for _ in range(N_EQUIPMENT)))
    equipments_details = list((fake.unique.paragraph(nb_sentences = 2) for _ in range(N_EQUIPMENT)))
    equipments_pictures = list((fake.unique.image_url() for _ in range(N_EQUIPMENT)))
    equipments_pictures_details = list(fake.unique.sentence() for _ in range(N_EQUIPMENT))
    cook_roles = (cook_level_elements[i] for i in range(4, -1, -1))
    food_groups = (build_food_group() for _ in range(1, N_FOOD_GROUP + 1))
    cooks = (build_cook() for _ in range(1, N_COOKS + 1))
    ingredients = (build_ingredient() for _ in range(1, 300))
    recipes = (build_recipe(recipe_id) for recipe_id in range(1, N_RECIPES + 1))
    episodes = (build_episodes(episode_id) for episode_id in range(0, N_EPISODES + 1))
    
    for cuisine in cuisines:
            f.write(f"INSERT INTO cuisine (title) VALUES ('{cuisine}');\n")
    f.write("\n")
    
    for meal_type in meal_types:
        f.write(f"INSERT INTO meal_type (title) VALUES ('{meal_type}');\n")
    f.write("\n")
    
    for i in range(N_THEME):
        theme = themes[i]  
        theme_description = themes_description[i]
        f.write(f"INSERT INTO theme (title, theme_description) VALUES ('{theme}', '{theme_description}');\n")
    f.write("\n")
    
    for tag in tags:
        f.write(f"INSERT INTO tag (title) VALUES ('{tag}');\n")
    f.write("\n")
    
    for tip in tips:
        f.write(f"INSERT INTO tip(title) VALUES ('{tip}');\n")
    f.write("\n")
    
    for i in range(N_EQUIPMENT):
        equipment = equipments[i]
        equipment_detail = equipments_details[i]
        equipment_picture = equipments_pictures[i]
        equipment_picture_details = equipments_pictures_details[i]
        f.write(f"INSERT INTO equipment (title, details, picture, picture_description) VALUES\
('{equipment}', '{equipment_detail}', '{equipment_picture}', '{equipment_picture_details}');\n")
    f.write("\n")
    
    for cook_role in cook_roles:
        f.write(f"INSERT INTO cook_role (title) VALUES ('{cook_role}');\n")
    f.write("\n")
    
    for food_group in food_groups:
        f.write(food_group)
    f.write("\n")
    
    for cook in cooks:
        f.write(cook)
    f.write("\n")
    
    for ingredient in ingredients:
        f.write(ingredient)
    f.write("\n")
    
    for recipe in recipes:
        for sql in recipe: f.write(sql)
        f.write("\n")
    f.write("\n")
    
    for recipe_id in range(1,  N_RECIPES + 1):
        f.write(f"INSERT INTO recipe_ingredient(recipe_id, ingredient_id, quantity, recipe_ingredient_description, main) VALUES\
({recipe_id}, {random.randint(1, 299)}, 1, NULL, 1);\n")
        build_recipe_ingredient(recipe_id)
        f.write("\n")
    f.write("\n")

    for recipe_id in range(1, N_RECIPES + 1):
        for step_order in range(1, random.randint(7, 15)):
            f.write(build_step_order(step_order, recipe_id))
    f.write("\n")
    
    for episode in episodes:
        for sql in episode: f.write(sql)
        f.write("\n")
    f.write("\n")
    
with open("fake_data.sql", "w") as f:
    fake_recipes_ingredients_cooks(f)
    f.write("\n")
    

         
   
         
