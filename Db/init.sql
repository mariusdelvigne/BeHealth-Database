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

    PRIMARY KEY (user_id)
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
    
    creator_id INT NOT NULL,

    PRIMARY KEY (message_id)
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
    period_begin_date DATETIME2 NOT NULL,
    period_end_date DATETIME2 NOT NULL,
    
    user_id INT NOT NULL,

    PRIMARY KEY (period_id)
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
CREATE TABLE user_foods (
    food_id INT NOT NULL IDENTITY,
    food_name VARCHAR(127) NOT NULL,
    food_quantity_in_g INT NOT NULL,
    food_datetime DATETIME2 NOT NULL,
    
    user_id INT NOT NULL,

    PRIMARY KEY (food_id)
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
CREATE TABLE user_sports (
    sport_id INT NOT NULL IDENTITY,
    sport_name VARCHAR(63) NOT NULL,
    sport_start_datetime DATETIME2 NOT NULL,
    sport_end_datetime DATETIME2 NOT NULL,
    
    user_id INT NOT NULL,

    PRIMARY KEY (sport_id)
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
ALTER TABLE notifications
ADD CONSTRAINT fk_notifications_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id);
GO
ALTER TABLE user_preferences
ADD CONSTRAINT fk_user_preferences_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id);
GO
ALTER TABLE global_messages
ADD CONSTRAINT fk_global_messages_users_creator_id
FOREIGN KEY (creator_id) REFERENCES users (user_id);
GO
ALTER TABLE user_sleeps
ADD CONSTRAINT fk_user_sleeps_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id);
GO
ALTER TABLE user_periods
ADD CONSTRAINT fk_user_periods_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id);
GO
ALTER TABLE user_weights
ADD CONSTRAINT fk_user_weights_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id);
GO
ALTER TABLE user_foods
ADD CONSTRAINT fk_user_foods_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id);
GO
ALTER TABLE user_heights
ADD CONSTRAINT fk_user_heights_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id);
GO
ALTER TABLE user_sports
ADD CONSTRAINT fk_user_sports_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id);
GO
ALTER TABLE user_passwords
ADD CONSTRAINT fk_user_passwords_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id);
---------------------------------------------------------------------------
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

    creator_id INT NOT NULL,

    PRIMARY KEY (sport_id)
);
GO
CREATE TABLE foods (
    food_id INT NOT NULL IDENTITY,
    food_name VARCHAR(127) NOT NULL UNIQUE,

    creator_id INT NOT NULL,

    PRIMARY KEY (food_id)
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

    creator_id INT NOT NULL,

    PRIMARY KEY (plan_id)
);
GO
CREATE TABLE ast_plans_foods (
    ast_id INT NOT NULL IDENTITY,
    ast_day_number INT NOT NULL,
    ast_quantity_in_g INT NOT NULL,

    plan_id INT NOT NULL,
    food_id INT NOT NULL,

    PRIMARY KEY (ast_id)
);
GO
CREATE TABLE ast_plans_sports (
    ast_id INT NOT NULL IDENTITY,
    ast_day_number INT NOT NULL,
    ast_duration_in_min INT NOT NULL,

    plan_id INT NOT NULL,
    sport_id INT NOT NULL,

    PRIMARY KEY (ast_id)
);
GO
CREATE TABLE tags (
    tag_id INT NOT NULL IDENTITY,
    tag_name VARCHAR(63) NOT NULL,

    creator_id INT NOT NULL,

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
    program_name VARCHAR(255) NOT NULL,
    program_privacy VARCHAR(7) NOT NULL,
    program_creation_datetime DATETIME2 NOT NULL,
    program_description VARCHAR(2047) NOT NULL,

    creator_id INT NOT NULL,
    sleep_plan_id INT,
    food_plan_id INT,
    sport_plan_id INT,

    PRIMARY KEY (program_id)
);
GO
CREATE TABLE ast_favorite_plans_users (
    ast_id INT NOT NULL IDENTITY,

    plan_id INT NOT NULL,
    user_id INT NOT NULL,

    PRIMARY KEY (ast_id)
);
GO
CREATE TABLE ast_subscription_plans_users (
    ast_id INT NOT NULL IDENTITY,

    plan_id INT NOT NULL,
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
GO
ALTER TABLE sports
ADD CONSTRAINT fk_sports_users_creator_id
FOREIGN KEY (creator_id) REFERENCES users (user_id);
GO
ALTER TABLE foods
ADD CONSTRAINT fk_foods_users_creator_id
FOREIGN KEY (creator_id) REFERENCES users (user_id);
GO
ALTER TABLE sleeps
ADD CONSTRAINT fk_sleeps_plans_plan_id
FOREIGN KEY (plan_id) REFERENCES plans (plan_id);
GO
ALTER TABLE ast_plans_foods
ADD CONSTRAINT fk_ast_plans_foods_foods_food_id
FOREIGN KEY (food_id) REFERENCES foods (food_id);
GO
ALTER TABLE ast_plans_foods
ADD CONSTRAINT fk_ast_plans_foods_plans_plan_id
FOREIGN KEY (plan_id) REFERENCES plans (plan_id);
GO
ALTER TABLE ast_plans_sports
ADD CONSTRAINT fk_ast_plans_sports_sports_sport_id
FOREIGN KEY (sport_id) REFERENCES sports (sport_id);
GO
ALTER TABLE ast_plans_sports
ADD CONSTRAINT fk_ast_plans_sports_plans_plan_id
FOREIGN KEY (plan_id) REFERENCES plans (plan_id);
GO
ALTER TABLE health_programs
ADD CONSTRAINT fk_health_programs_plans_sleep_plan_id
FOREIGN KEY (sleep_plan_id) REFERENCES plans (plan_id);
GO
ALTER TABLE health_programs
ADD CONSTRAINT fk_health_programs_plans_food_plan_id
FOREIGN KEY (food_plan_id) REFERENCES plans (plan_id);
GO
ALTER TABLE health_programs
ADD CONSTRAINT fk_health_programs_plans_sport_plan_id
FOREIGN KEY (sport_plan_id) REFERENCES plans (plan_id);
GO
ALTER TABLE ast_plans_tags
ADD CONSTRAINT fk_ast_plans_tags_plans_plan_id
FOREIGN KEY (plan_id) REFERENCES plans (plan_id);
GO
ALTER TABLE ast_plans_tags
ADD CONSTRAINT fk_ast_plans_tags_tags_tag_id
FOREIGN KEY (tag_id) REFERENCES tags (tag_id);
GO
ALTER TABLE tags
ADD CONSTRAINT fk_tags_users_creator_id
FOREIGN KEY (creator_id) REFERENCES users (user_id);
GO
ALTER TABLE plans
ADD CONSTRAINT fk_plans_users_creator_id
FOREIGN KEY (creator_id) REFERENCES users (user_id);
GO
ALTER TABLE program_feedbacks
ADD CONSTRAINT fk_program_feedbacks_users_creator_id
FOREIGN KEY (creator_id) REFERENCES users (user_id);
GO
ALTER TABLE program_feedbacks
ADD CONSTRAINT fk_program_feedbacks_health_programs_program_id
FOREIGN KEY (program_id) REFERENCES health_programs (program_id);
GO
ALTER TABLE health_programs
ADD CONSTRAINT fk_health_programs_users_creator_id
FOREIGN KEY (creator_id) REFERENCES users (user_id);
GO
ALTER TABLE ast_subscription_plans_users
ADD CONSTRAINT fk_ast_subscription_plans_users_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id);
GO
ALTER TABLE ast_subscription_plans_users
ADD CONSTRAINT fk_ast_subscription_plans_users_plans_plan_id
FOREIGN KEY (plan_id) REFERENCES plans (plan_id);
GO
ALTER TABLE ast_favorite_plans_users
ADD CONSTRAINT fk_ast_favorite_plans_users_users_user_id
FOREIGN KEY (user_id) REFERENCES users (user_id);
GO
ALTER TABLE ast_favorite_plans_users
ADD CONSTRAINT fk_ast_favorite_plans_users_plans_plan_id
FOREIGN KEY (plan_id) REFERENCES plans (plan_id);
GO
INSERT INTO users (user_role, User_mail, user_username, user_birth_date, user_gender, user_name, user_surname) VALUES (
    'Admin', 'test@mail.com', 'test', GETDATE(), 'Male', 'test', 'test'
)