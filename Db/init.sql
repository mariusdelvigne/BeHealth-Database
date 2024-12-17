-- docker build --debug --no-cache --progress plain -t "be_health_db:1" .
CREATE DATABASE be_health_db;
GO
USE be_health_db;
GO
CREATE TABLE users (
    user_id INT NOT NULL IDENTITY,
    user_role VARCHAR(5) NOT NULL,
    user_mail VARCHAR(255) NOT NULL UNIQUE,
    user_username VARCHAR(63) NOT NULL UNIQUE,
    user_birth_date DATETIME2 NOT NULL,
    user_gender VARCHAR(63) NOT NULL,
    user_name VARCHAR(127) NOT NULL,
    user_surname VARCHAR(127) NOT NULL,
    user_banned BIT NOT NULL DEFAULT 0,

    PRIMARY KEY (user_id)
);
GO
CREATE TABLE user_passwords (
    password_id INT NOT NULL IDENTITY,
    password_password BINARY(60) NOT NULL,
    password_end_datetime DATETIME2,
    
    user_id INT NOT NULL,

    PRIMARY KEY (password_id)
);
GO
CREATE TABLE user_preferences (
    user_id INT NOT NULL,

    PRIMARY KEY (user_id)
);
GO
CREATE TABLE global_messages (
    message_id INT NOT NULL IDENTITY,
    message_description VARCHAR(511) NOT NULL,
    message_start_datetime DATETIME2 NOT NULL,
    message_end_datetime DATETIME2 NOT NULL,
    
    creator_id INT,

    PRIMARY KEY (message_id)
);
GO
CREATE TABLE notifications (
    notification_id INT NOT NULL IDENTITY,
    notification_title VARCHAR(63) NOT NULL,
    notification_category VARCHAR(63) NOT NULL,
    notification_description VARCHAR(511) NOT NULL,
    notification_datetime DATETIME2 NOT NULL,
    notification_seen BIT NOT NULL,

    user_id INT NOT NULL,

    PRIMARY KEY (notification_id)
);
GO
CREATE TABLE user_sleeps (
    sleep_id INT NOT NULL IDENTITY,
    sleep_start_datetime DATETIME2 NOT NULL,
    sleep_end_datetime DATETIME2 NOT NULL,

    user_id INT NOT NULL,

    PRIMARY KEY (sleep_id)
);
GO
CREATE TABLE user_periods (
    period_id INT NOT NULL IDENTITY,
    period_start_date DATETIME2 NOT NULL,
    period_end_date DATETIME2 NOT NULL,
    
    user_id INT NOT NULL,

    PRIMARY KEY (period_id)
);
GO
CREATE TABLE ast_users_foods (
    ast_id INT NOT NULL IDENTITY,
    ast_datetime DATETIME2 NOT NULL,
    ast_quantity_in_g INT NOT NULL,
    
    user_id INT NOT NULL,
    food_id INT NOT NULL,

    PRIMARY KEY (ast_id)
);
GO
CREATE TABLE ast_users_sports (
    ast_id INT NOT NULL IDENTITY,
    ast_start_datetime DATETIME2 NOT NULL,
    ast_end_datetime DATETIME2 NOT NULL,
    ast_calories_burned INT NOT NULL,
    
    user_id INT NOT NULL,
    sport_id INT NOT NULL,

    PRIMARY KEY (ast_id)
);
GO
CREATE TABLE user_weights (
    weight_id INT NOT NULL IDENTITY,
    weight_in_g INT NOT NULL,
    weight_date DATETIME2 NOT NULL,
    
    user_id INT NOT NULL,

    PRIMARY KEY (weight_id)
);

GO
CREATE TABLE user_heights (
    height_id INT NOT NULL IDENTITY,
    height_in_cm INT NOT NULL,
    height_date DATETIME2 NOT NULL,
    
    user_id INT NOT NULL,

    PRIMARY KEY (height_id)
);
GO
CREATE TABLE plans (
    plan_id INT NOT NULL IDENTITY,
    plan_name VARCHAR(255) NOT NULL,
    plan_category VARCHAR(5) NOT NULL,
    plan_privacy VARCHAR(7) NOT NULL,
    plan_creation_datetime DATETIME2 NOT NULL,
    plan_description VARCHAR(2047),
    plan_duration_in_days INT NOT NULL,

    creator_id INT,

    PRIMARY KEY (plan_id)
);
GO
CREATE TABLE sleeps (
    plan_id INT NOT NULL,
    sleep_start_time TIME NOT NULL,
    sleep_duration_in_min INT NOT NULL,

    PRIMARY KEY (plan_id)
);
GO
CREATE TABLE sports (
    sport_id INT NOT NULL IDENTITY,
    sport_name VARCHAR(127) NOT NULL UNIQUE,

    creator_id INT,

    PRIMARY KEY (sport_id)
);
GO
CREATE TABLE foods (
    food_id INT NOT NULL IDENTITY,
    food_name VARCHAR(127) NOT NULL UNIQUE,

    food_serving_weights INT NOT NULL,
    food_calories FLOAT NOT NULL,
    food_total_fats FLOAT NOT NULL,
    food_saturated_fats FLOAT NOT NULL,
    food_cholesterol FLOAT NOT NULL,
    food_sodium FLOAT NOT NULL,
    food_total_carbohydrates FLOAT NOT NULL,
    food_dietary_fiber FLOAT NOT NULL,
    food_sugars FLOAT NOT NULL,
    food_proteins FLOAT NOT NULL,
    food_potassium FLOAT NOT NULL,
    
    creator_id INT,

    PRIMARY KEY (food_id)
);
GO
CREATE TABLE ast_plans_foods (
    ast_id INT NOT NULL IDENTITY,
    ast_day_number INT NOT NULL,
    ast_day_time TIME NOT NULL,
    ast_quantity_in_g INT NOT NULL,

    plan_id INT NOT NULL,
    food_id INT NOT NULL,

    PRIMARY KEY (ast_id)
);
GO
CREATE TABLE ast_plans_sports (
    ast_id INT NOT NULL IDENTITY,
    ast_day_number INT NOT NULL,
    ast_day_time TIME NOT NULL,
    ast_duration_in_min INT NOT NULL,

    plan_id INT NOT NULL,
    sport_id INT NOT NULL,

    PRIMARY KEY (ast_id)
);
GO
CREATE TABLE tags (
    tag_id INT NOT NULL IDENTITY,
    tag_name VARCHAR(63) NOT NULL,
    tag_category VARCHAR(5) NOT NULL,

    creator_id INT,

    PRIMARY KEY (tag_id)
);
GO
CREATE TABLE ast_plans_tags (
    ast_id INT NOT NULL IDENTITY,
    tag_id INT NOT NULL,
    plan_id INT NOT NULL,

    PRIMARY KEY (ast_id)
);
GO
CREATE TABLE health_programs (
    program_id INT NOT NULL IDENTITY,
    program_title VARCHAR(255) NOT NULL,
    program_privacy VARCHAR(7) NOT NULL,
    program_creation_datetime DATETIME2 NOT NULL,
    program_description VARCHAR(2047) NOT NULL,

    creator_id INT,
    sleep_plan_id INT,
    food_plan_id INT,
    sport_plan_id INT,

    PRIMARY KEY (program_id)
);
GO
CREATE TABLE ast_health_programs_users (
    ast_id INT NOT NULL IDENTITY,
    ast_relation_type VARCHAR(12) NOT NULL,

    program_id INT NOT NULL,
    user_id INT NOT NULL,

    PRIMARY KEY (ast_id)
);
GO
CREATE TABLE program_feedbacks (
    feedback_id INT NOT NULL IDENTITY,
    feedback_rating INT NOT NULL,
    feedback_description VARCHAR(1023) NOT NULL,
    feedback_creation_datetime DATETIME2 NOT NULL,

    creator_id INT NOT NULL,
    program_id INT NOT NULL,

    PRIMARY KEY (feedback_id)
);
---------------------------------------------------------------------------
GO
ALTER TABLE user_preferences
ADD CONSTRAINT fk_user_preferences_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id)
ON DELETE CASCADE

GO
ALTER TABLE user_passwords
ADD CONSTRAINT fk_user_passwords_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id)
ON DELETE CASCADE

GO
ALTER TABLE global_messages
ADD CONSTRAINT fk_global_messages_users_creator_id
FOREIGN KEY (creator_id) REFERENCES users (user_id)
ON DELETE SET NULL;
GO
ALTER TABLE notifications
ADD CONSTRAINT fk_notifications_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id)
ON DELETE CASCADE

GO
ALTER TABLE user_sleeps
ADD CONSTRAINT fk_user_sleeps_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id)
ON DELETE CASCADE

GO
ALTER TABLE user_periods
ADD CONSTRAINT fk_user_periods_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id)
ON DELETE CASCADE

GO
ALTER TABLE ast_users_foods
ADD CONSTRAINT fk_ast_users_foods_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id)
ON DELETE CASCADE

GO
ALTER TABLE ast_users_foods
ADD CONSTRAINT fk_ast_users_foods_foods_food_id
FOREIGN KEY (food_id) REFERENCES foods (food_id)
ON DELETE CASCADE

GO
ALTER TABLE ast_users_sports
ADD CONSTRAINT fk_ast_users_sports_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id)
ON DELETE CASCADE

GO
ALTER TABLE ast_users_sports
ADD CONSTRAINT fk_ast_users_sports_sports_sport_id
FOREIGN KEY (sport_id) REFERENCES sports (sport_id)
ON DELETE CASCADE

GO
ALTER TABLE user_weights
ADD CONSTRAINT fk_user_weights_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id)
ON DELETE CASCADE

GO
ALTER TABLE user_heights
ADD CONSTRAINT fk_user_heights_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id)
ON DELETE CASCADE

GO
ALTER TABLE plans
ADD CONSTRAINT fk_plans_users_creator_id
FOREIGN KEY (creator_id) REFERENCES users (user_id)
ON DELETE SET NULL

GO
ALTER TABLE sleeps
ADD CONSTRAINT fk_sleeps_plans_plan_id
FOREIGN KEY (plan_id) REFERENCES plans (plan_id)
ON DELETE CASCADE

GO
ALTER TABLE sports
ADD CONSTRAINT fk_sports_users_creator_id
FOREIGN KEY (creator_id) REFERENCES users (user_id)
ON DELETE SET NULL

GO
ALTER TABLE foods
ADD CONSTRAINT fk_foods_users_creator_id
FOREIGN KEY (creator_id) REFERENCES users (user_id)
ON DELETE SET NULL

GO
ALTER TABLE ast_plans_foods
ADD CONSTRAINT fk_ast_plans_foods_foods_food_id
FOREIGN KEY (food_id) REFERENCES foods (food_id)
ON DELETE CASCADE

GO
ALTER TABLE ast_plans_foods
ADD CONSTRAINT fk_ast_plans_foods_plans_plan_id
FOREIGN KEY (plan_id) REFERENCES plans (plan_id)
ON DELETE CASCADE

GO
ALTER TABLE ast_plans_sports
ADD CONSTRAINT fk_ast_plans_sports_sports_sport_id
FOREIGN KEY (sport_id) REFERENCES sports (sport_id)
ON DELETE CASCADE

GO
ALTER TABLE ast_plans_sports
ADD CONSTRAINT fk_ast_plans_sports_plans_plan_id
FOREIGN KEY (plan_id) REFERENCES plans (plan_id)
ON DELETE CASCADE

GO
ALTER TABLE tags
ADD CONSTRAINT fk_tags_users_creator_id
FOREIGN KEY (creator_id) REFERENCES users (user_id)
ON DELETE SET NULL

GO
ALTER TABLE ast_plans_tags
ADD CONSTRAINT fk_ast_plans_tags_plans_plan_id
FOREIGN KEY (plan_id) REFERENCES plans (plan_id)
ON DELETE CASCADE

GO
ALTER TABLE ast_plans_tags
ADD CONSTRAINT fk_ast_plans_tags_tags_tag_id
FOREIGN KEY (tag_id) REFERENCES tags (tag_id)
ON DELETE CASCADE

GO
ALTER TABLE health_programs
ADD CONSTRAINT fk_health_programs_plans_sleep_plan_id
FOREIGN KEY (sleep_plan_id) REFERENCES plans (plan_id)

GO
ALTER TABLE health_programs
ADD CONSTRAINT fk_health_programs_plans_food_plan_id
FOREIGN KEY (food_plan_id) REFERENCES plans (plan_id)

GO
ALTER TABLE health_programs
ADD CONSTRAINT fk_health_programs_plans_sport_plan_id
FOREIGN KEY (sport_plan_id) REFERENCES plans (plan_id)

GO
ALTER TABLE health_programs
ADD CONSTRAINT fk_health_programs_users_creator_id
FOREIGN KEY (creator_id) REFERENCES users (user_id)
ON DELETE SET NULL

GO
ALTER TABLE ast_health_programs_users
ADD CONSTRAINT fk_ast_health_programs_users_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id)
ON DELETE CASCADE

GO
ALTER TABLE ast_health_programs_users
ADD CONSTRAINT fk_ast_health_programs_users_health_programs_program_id
FOREIGN KEY (program_id) REFERENCES health_programs (program_id)
ON DELETE CASCADE

GO
ALTER TABLE program_feedbacks
ADD CONSTRAINT fk_program_feedbacks_users_creator_id
FOREIGN KEY (creator_id) REFERENCES users (user_id)
ON DELETE CASCADE

GO
ALTER TABLE program_feedbacks
ADD CONSTRAINT fk_program_feedbacks_health_programs_program_id
FOREIGN KEY (program_id) REFERENCES health_programs (program_id)
ON DELETE CASCADE
GO
-- MANAGE PLAN DELETIONS
CREATE TRIGGER trg_plans_delete
ON plans
INSTEAD OF DELETE
AS
BEGIN
    
    UPDATE health_programs
    SET food_plan_id = NULL
    WHERE food_plan_id IN (SELECT plan_id FROM DELETED);

    UPDATE health_programs
    SET sport_plan_id = NULL
    WHERE sport_plan_id IN (SELECT plan_id FROM DELETED);

    UPDATE health_programs
    SET sleep_plan_id = NULL
    WHERE sleep_plan_id IN (SELECT plan_id FROM DELETED);

    DELETE FROM plans
    WHERE plan_id IN (SELECT plan_id FROM DELETED);
END;

---------------------------------------------------------------------------

-- INSERTIONS D'UTILISATEURS

GO
INSERT INTO users (user_role, User_mail, user_username, user_birth_date, user_gender, user_name, user_surname) VALUES (
    'Admin', 'Warrior3000@mail.com', 'Warrior3000', GETDATE(), 'Male', 'Warrior', '3000'
);

GO
DECLARE @HashedPassword VARBINARY(60);
SET @HashedPassword = CONVERT(VARBINARY(60), '$2b$10$qmteKMrbxP0f98ViI5Ep6e2GCl1x3wgZap2Ii5yAu/MdlXmraF5Yi');
INSERT INTO user_passwords (password_password, user_id) VALUES (
    @HashedPassword, '1'
);
--mdp = adminPassword
GO
INSERT INTO users (user_role, User_mail, user_username, user_birth_date, user_gender, user_name, user_surname) VALUES (
    'Admin', 'Marius@mail.com', 'Marius', '2000-2-12', 'Male', 'Marius', 'Delvigne'
);
GO
DECLARE @HashedPassword VARBINARY(60);
SET @HashedPassword = CONVERT(VARBINARY(60), '$2b$12$TCBkjqei0seeBdmWMNHahuYPepWQ67.p5vL0qNOcKNMSP715mmGXa');
INSERT INTO user_passwords (password_password, user_id) VALUES (
    @HashedPassword, '2'
);
--mdp = MariusDelvigne
GO
INSERT INTO users (user_role, User_mail, user_username, user_birth_date, user_gender, user_name, user_surname) VALUES (
    'User', 'Matteo@mail.com', 'Matteo', '2004-11-25', 'Female', 'Matteo', 'Leroy'
);
GO
DECLARE @HashedPassword VARBINARY(60);
SET @HashedPassword = CONVERT(VARBINARY(60), '$2b$12$4YCqbKhd8oLr8Iro/BHeEOSncQUf7mRJvAcCKSEx2/HdEiDoOF8RK');
INSERT INTO user_passwords (password_password, user_id) VALUES (
    @HashedPassword, '3'
);
--mdp = MatteoLeroy
GO
INSERT INTO users (user_role, User_mail, user_username, user_birth_date, user_gender, user_name, user_surname) VALUES (
    'User', 'Nathan@mail.com', 'Nathan', '2004-10-30', 'Female', 'Nathan', 'Malbecq'
);
GO
DECLARE @HashedPassword VARBINARY(60);
SET @HashedPassword = CONVERT(VARBINARY(60), '$2b$12$OXTa.6Kdp3Elr0s18kpw.OkDmcp6gblEfz.4CFC8/qsYvBvkQRoIy');
INSERT INTO user_passwords (password_password, user_id) VALUES (
    @HashedPassword, '4'
);
--mdp = NathanMalbecq
GO
INSERT INTO users (user_role, User_mail, user_username, user_birth_date, user_gender, user_name, user_surname) VALUES (
    'User', 'Robin@mail.com', 'Robin', '1991-08-19', 'Other', 'Robin', 'Reynaert'
);
GO
DECLARE @HashedPassword VARBINARY(60);
SET @HashedPassword = CONVERT(VARBINARY(60), '$2b$12$Rvzs2RZ5ZGhdSZblblk1jOI5RQIOCWT958TE03i94yMR3oNlLegDa');
INSERT INTO user_passwords (password_password, user_id) VALUES (
    @HashedPassword, '5'
);
--mdp = RobinReynaert

-- INSERTION GLOBAL_MESSAGES
GO
INSERT INTO global_messages (message_description, message_start_datetime, message_end_datetime, creator_id) VALUES
('Test GlobalMessage Warrior3000', '2024-12-15 10:00:00', '2024-12-24 23:59:59', 1),
('Maintenance scheduled for Saturday, December 17, 2024.', '2024-12-18 08:00:00', '2024-12-30 18:00:00', 2);

-- INSERTION NOTIFICATIONS
GO
INSERT INTO notifications (notification_title, notification_category, notification_description, notification_datetime, notification_seen, user_id) VALUES
('New update', 'General', 'A new update is available now.', '2024-11-23 09:00:00', 0, 1),
('meeting reminder', 'General', 'Don''t forget the project meeting at 3:00 p.m.', '2024-11-23 08:00:00', 0, 2),
('scheduled maintenance', 'General', 'Maintenance scheduled on November 30, 2024 from 02:00 p.m. to 04:00 p.m.', '2024-11-22 12:00:00', 0, 1);

-- INSERTION USER_SLEEPS
GO 
INSERT INTO user_sleeps (sleep_start_datetime, sleep_end_datetime, user_id) VALUES
('2024-11-22 22:30:00', '2024-11-23 06:30:00', 1),
('2024-11-21 23:00:00', '2024-11-22 07:00:00', 2),
('2024-11-20 21:45:00', '2024-11-21 05:45:00', 3),
('2024-11-19 00:15:00', '2024-11-19 08:15:00', 4),
('2024-11-18 22:00:00', '2024-11-19 06:00:00', 5);

-- INSERTION USER_PERIODS
GO
INSERT INTO user_periods (period_start_date, period_end_date, user_id) VALUES
('2024-11-15 08:00:00', '2024-11-22 16:00:00', 3),
('2024-11-16 09:00:00', '2024-11-21 17:00:00', 4);

-- INSERTION USER_WEIGHTS
GO
INSERT INTO user_weights (weight_in_g, weight_date, user_id) VALUES
(70000, '2024-01-01 08:00:00', 1),
(70500, '2024-02-01 08:00:00', 1),
(71000, '2024-03-01 08:00:00', 1),

(82000, '2024-01-05 08:00:00', 2),
(82500, '2024-02-05 08:00:00', 2),
(83000, '2024-03-05 08:00:00', 2),

(64000, '2024-01-10 08:00:00', 3),
(67500, '2024-02-13 08:00:00', 3),
(65000, '2024-03-09 08:00:00', 3),

(75000, '2024-01-15 08:00:00', 4),
(71500, '2024-10-15 08:00:00', 4),
(68000, '2024-12-30 08:00:00', 4),

(68000, '2024-01-10 08:00:00', 5),
(64500, '2024-05-22 08:00:00', 5),
(73000, '2024-10-04 08:00:00', 5);

-- INSERTION USER_HEIGHTS
GO
INSERT INTO user_heights (height_in_cm, height_date, user_id) VALUES
(175, '2024-01-01 08:00:00', 1),
(176, '2024-02-01 08:00:00', 1),
(177, '2024-03-01 08:00:00', 1),

(182, '2024-01-05 08:00:00', 2),
(181, '2024-02-05 08:00:00', 2),
(180, '2024-03-05 08:00:00', 2),

(160, '2024-01-10 08:00:00', 3),
(165, '2024-02-20 08:00:00', 3),
(171, '2024-04-09 08:00:00', 3),

(201, '2024-01-04 08:00:00', 4),
(201, '2024-03-15 08:00:00', 4),
(201, '2024-05-10 08:00:00', 4),

(165, '2024-01-15 08:00:00', 5),
(169, '2024-10-24 08:00:00', 5),
(167, '2024-12-21 08:00:00', 5);

-- INSERTION SPORTS
GO
INSERT INTO sports (sport_name, creator_id) VALUES
('Football', 1),
('Basketball', 2),
('Tennis', 3),
('Swimming', 4),
('Athletics', 5),
('Cycling', 1),
('Handball', 2),
('Rugby', 3),
('Boxing', 4),
('Fencing', 5);

-- INSERTION FOODS
GO
INSERT INTO foods (food_name, food_serving_weights, food_calories, food_total_fats, food_saturated_fats, food_cholesterol, food_sodium, food_total_carbohydrates, food_dietary_fiber, food_sugars, food_proteins, food_potassium, creator_id) VALUES
('Apple', 100, 52.20, 0.16, 0.05, 0.00, 1.10, 13.74, 2.42, 10.44, 0.27, 107.14, 1),
('Banana', 100, 89.00, 0.25, 0.08, 0.00, 0.85, 22.88, 2.63, 11.86, 1.10, 357.63, 2),
('Orange', 100, 47.33, 0.15, 0.00, 0.00, 0.00, 11.45, 2.37, 9.16, 0.92, 180.92, 3),
('Strawberry', 100, 32.24, 0.33, 0.00, 0.00, 0.66, 7.89, 1.97, 4.61, 0.66, 144.74, 4),
('White rice', 100, 129.75, 0.25, 0.06, 0.00, 0.63, 28.48, 0.38, 0.06, 2.72, 34.81, 5),
('Whole wheat bread', 100, 246.43, 3.93, 0.71, 0.00, 478.57, 42.86, 7.14, 7.14, 12.86, 264.29, 1),
('Mozzarella cheese', 100, 303.57, 22.50, 13.21, 78.57, 492.86, 3.57, 0.00, 0.00, 22.50, 25.00, 2),
('Tuna', 100, 116.23, 0.65, 0.19, 32.47, 27.27, 0.00, 0.00, 0.00, 25.52, 282.47, 3),
('Beef steak', 100, 250.59, 15.29, 6.12, 74.12, 62.35, 0.00, 0.00, 0.00, 24.12, 370.59, 4),
('Potato', 100, 77.00, 0.09, 0.00, 0.00, 11.27, 17.37, 2.21, 0.80, 2.02, 421.13, 5);


-- INSERTION AST_USERS_FOODS
GO
INSERT INTO ast_users_foods (ast_quantity_in_g, ast_datetime, user_id, food_id) VALUES
(150, '2024-11-01 12:00:00', 1, 2),
(200, '2024-11-02 18:30:00', 2, 4),
(100, '2024-11-03 07:45:00', 3, 7),
(250, '2024-11-04 14:15:00', 4, 9),
(180, '2024-11-05 20:00:00', 5, 5);

-- INSERTION AST_USERS_SPORTS
GO
INSERT INTO ast_users_sports (ast_start_datetime, ast_end_datetime, ast_calories_burned, user_id, sport_id) VALUES
('2024-11-01 12:00:00', '2024-11-01 13:00:00', 100, 1, 1),
('2024-11-02 18:30:00', '2024-11-02 20:00:00', 101, 2, 4),
('2024-11-03 07:45:00', '2024-11-03 09:00:00', 102, 3, 3),
('2024-11-04 14:15:00', '2024-11-04 16:00:00', 103, 4, 6),
('2024-11-05 20:00:00', '2024-11-05 21:30:00', 104, 5, 5);

-- INSERTION TAGS
GO
INSERT INTO tags (tag_name, tag_category, creator_id) VALUES
('Healthy', 'Food', 1),
('Sporty', 'Sport', 2),
('Vegan', 'Food', 3),
('Cardio', 'Sport', 4),
('Protein', 'Food', 5),
('Strength', 'Sport', 1),
('Vegetarian', 'Food', 2),
('Endurance', 'Sport', 3),
('Gluten-free', 'Food', 4),
('Flexibility', 'Sport', 5);

-- INSERTION PLANS
GO
INSERT INTO plans (plan_name, plan_category, plan_privacy, plan_creation_datetime, plan_description, plan_duration_in_days, creator_id) VALUES
('Morning Jog Routine', 'sport', 'public', '2024-11-23 08:00:00', 'A daily morning jog routine to boost energy levels and fitness.', 30, 1),
('Balanced Diet Plan', 'food', 'private', '2024-11-23 09:00:00', 'A comprehensive diet plan focusing on balanced nutrition and healthy eating habits.', 60, 2),
('Weekly Yoga Sessions', 'sport', 'public', '2024-11-23 10:00:00', 'A weekly yoga plan to enhance flexibility, strength, and mindfulness.', 45, 3),
('Healthy Meal Prep', 'food', 'private', '2024-11-23 11:00:00', 'A meal preparation plan to ensure healthy eating throughout the week.', 7, 4),
('Sleep Improvement Program', 'sleep', 'public', '2024-11-23 12:00:00', 'A program designed to improve sleep quality with tips and routines.', 21, 5),
('Post-Workout Nutrition', 'food', 'private', '2024-11-23 13:00:00', 'Nutrition tips and meal plans for optimal recovery after workouts.', 30, 1);

-- INSERTION AST_PLANS_FOODS
GO
INSERT INTO ast_plans_foods (ast_day_number, ast_day_time, ast_quantity_in_g, plan_id, food_id) VALUES
(1, '08:00:00', 200, 1, 2),
(2, '12:00:00', 150, 2, 4),
(3, '18:00:00', 100, 3, 7),
(4, '09:00:00', 250, 4, 9),
(5, '20:00:00', 180, 5, 5),
(6, '07:00:00', 300, 6, 1);

-- INSERTION AST_PLANS_SPORTS
GO
INSERT INTO ast_plans_sports (ast_day_number, ast_day_time, ast_duration_in_min, plan_id, sport_id) VALUES
(1, '06:00:00', 30, 1, 3),
(2, '07:30:00', 45, 2, 1),
(3, '17:00:00', 60, 3, 8),
(4, '19:00:00', 50, 4, 10),
(5, '05:00:00', 40, 5, 5),
(6, '08:00:00', 90, 6, 2);

-- INSERTION AST_PLANS_TAGS
GO
INSERT INTO ast_plans_tags (tag_id, plan_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);

-- INSERTION SLEEPS
GO
INSERT INTO sleeps (plan_id, sleep_start_time, sleep_duration_in_min) VALUES
(1, '22:00:00', 480),
(2, '23:00:00', 450),
(3, '21:30:00', 500),
(4, '22:30:00', 470),
(5, '20:45:00', 490),
(6, '23:15:00', 450);

-- INSERTION HEALTH_PROGRAMS
GO
INSERT INTO health_programs (program_title, program_privacy, program_creation_datetime, program_description, creator_id, sleep_plan_id, food_plan_id, sport_plan_id) VALUES
('Ultimate Wellness Plan', 'public', '2024-11-23 09:00:00', 'A comprehensive wellness program incorporating balanced diet, regular exercise, and improved sleep habits.', 1, 5, 2, 3),
('Balanced Life Program', 'private', '2024-11-23 10:00:00', 'A program focused on balancing nutrition, physical activity, and sleep for overall health.', 2, NULL, 4, NULL),
('Fitness and Nutrition Plan', 'public', '2024-11-23 11:00:00', 'A plan combining nutritious meal preparation with effective fitness routines.', 3, NULL, 6, 1),
('Healthy Lifestyle Program', 'private', '2024-11-23 12:00:00', 'An integrative health program for promoting a healthy lifestyle through diet, exercise, and rest.', 4, 5, NULL, NULL),
('Sleep and Fitness Routine', 'public', '2024-11-23 13:00:00', 'A dedicated routine to enhance sleep quality and maintain physical fitness.', 5, 5, NULL, 3);

-- INSERTION AST_HEALTH_PROGRAMS_USERS
GO
INSERT INTO ast_health_programs_users (ast_relation_type, program_id, user_id) VALUES
('favorite', 1, 2),
('favorite', 1, 3),
('subscription', 3, 4),
('favorite', 3, 5),
('subscription', 5, 1),
('subscription', 4, 3),
('subscription', 2, 4),
('favorite', 2, 5);

-- INSERTION PROGRAM_FEEDBACKS
GO
INSERT INTO program_feedbacks (feedback_rating, feedback_description, feedback_creation_datetime, creator_id, program_id) VALUES
(5, 'This program has been life-changing for me. I feel healthier and more energized than ever before.', '2024-11-23 09:00:00', 2, 1),
(4, 'I have seen great results with this program. It has helped me stay on track with my fitness goals.', '2024-11-23 10:00:00', 3, 2),
(3, 'The nutrition plan was good, but I struggled with the exercise routines. Overall, a decent program.', '2024-11-23 11:00:00', 4, 3),
(2, 'I found the lifestyle program to be too restrictive. It didn''t suit my preferences and lifestyle.', '2024-11-23 12:00:00', 5, 4),
(1, 'The sleep routine was too challenging for me. I couldn''t stick to the schedule and felt exhausted.', '2024-11-23 13:00:00', 1, 5);