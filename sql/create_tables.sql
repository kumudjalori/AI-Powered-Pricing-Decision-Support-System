/* =====================================================================
   AI-Powered Pricing Strategy Assistant
   File: create_tables.sql
   Purpose: Define the database schema for the EdTech learner dataset.

   Design decision:
   - Kept the schema SIMPLE but not fully flat: two small lookup
     (dimension) tables for Subscription Plans and Learner Segments,
     plus one main fact table (Learners) that references them via
     foreign keys.
   - This shows normalization awareness without over-engineering.
     If you want a single flat table instead (for max simplicity),
     see the "FLAT VERSION" note at the bottom of this file.
   ===================================================================== */

-- ---------------------------------------------------------------------
-- 1. Lookup Table: Subscription_Plans
-- ---------------------------------------------------------------------
CREATE TABLE Subscription_Plans (
    Plan_Name     VARCHAR(20) PRIMARY KEY,   -- Basic, Standard, Pro, Premium
    Monthly_Fee   DECIMAL(10,2) NOT NULL,
    Target_Audience VARCHAR(100)
);

-- ---------------------------------------------------------------------
-- 2. Lookup Table: Learner_Segments
-- ---------------------------------------------------------------------
CREATE TABLE Learner_Segments (
    Segment_Name        VARCHAR(30) PRIMARY KEY,  -- e.g. 'Power Learner'
    Typical_Budget       VARCHAR(20),              -- Low / Medium / High sensitivity
    Renewal_Tendency      VARCHAR(20)               -- Low / Medium / High
);

-- ---------------------------------------------------------------------
-- 3. Fact Table: Learners
-- ---------------------------------------------------------------------
CREATE TABLE Learners (
    Learner_ID          VARCHAR(10) PRIMARY KEY,     -- e.g. L00001
    Age                 INT NOT NULL,
    Profession           VARCHAR(50),
    Region               VARCHAR(50),
    Learner_Segment       VARCHAR(30) NOT NULL,
    Subscription_Plan     VARCHAR(20) NOT NULL,
    Monthly_Fee          DECIMAL(10,2) NOT NULL,
    Months_Active         INT NOT NULL,
    Courses_Enrolled      INT NOT NULL,
    Courses_Completed     INT NOT NULL,
    Completion_Rate       DECIMAL(4,2) NOT NULL,      -- 0.00 - 1.00
    Weekly_Hours          DECIMAL(5,2) NOT NULL,
    Login_Frequency        INT NOT NULL,               -- logins per month
    Last_Login_Days        INT NOT NULL,               -- days since last login
    Coupon_Used           CHAR(1) NOT NULL,           -- 'Y' / 'N'
    Discount_Availed       INT NOT NULL DEFAULT 0,     -- % discount
    Payment_Mode          VARCHAR(20),
    Support_Tickets       INT NOT NULL DEFAULT 0,
    Renewed_Last_Cycle     CHAR(1) NOT NULL,           -- 'Y' / 'N'

    CONSTRAINT fk_plan
        FOREIGN KEY (Subscription_Plan) REFERENCES Subscription_Plans(Plan_Name),
    CONSTRAINT fk_segment
        FOREIGN KEY (Learner_Segment) REFERENCES Learner_Segments(Segment_Name)
);

-- ---------------------------------------------------------------------
-- 4. Seed the lookup tables
-- ---------------------------------------------------------------------
INSERT INTO Subscription_Plans (Plan_Name, Monthly_Fee, Target_Audience) VALUES
    ('Basic',    299.00, 'Casual Learners, budget College Students'),
    ('Standard', 599.00, 'College Students, Certification Seekers'),
    ('Pro',      999.00, 'Working Professionals, Career Switchers'),
    ('Premium', 1499.00, 'Power Learners, senior Working Professionals');

INSERT INTO Learner_Segments (Segment_Name, Typical_Budget, Renewal_Tendency) VALUES
    ('College Student',      'High Sensitivity',   'Low-Medium'),
    ('Working Professional', 'Low Sensitivity',     'High'),
    ('Career Switcher',      'Medium Sensitivity',  'Medium-High'),
    ('Certification Seeker', 'Medium Sensitivity',  'Medium'),
    ('Casual Learner',       'High Sensitivity',    'Low'),
    ('Power Learner',        'Low Sensitivity',     'Very High');

-- ---------------------------------------------------------------------
-- 5. Indexes (optional, but good practice to mention in interviews)
-- ---------------------------------------------------------------------
CREATE INDEX idx_learners_segment ON Learners(Learner_Segment);
CREATE INDEX idx_learners_plan    ON Learners(Subscription_Plan);
CREATE INDEX idx_learners_renewed ON Learners(Renewed_Last_Cycle);

/* =====================================================================
   CSV IMPORT INSTRUCTIONS
   ===================================================================== */

-- Option A: MySQL / MariaDB
-- ---------------------------------------------------------------------
-- LOAD DATA LOCAL INFILE 'learner_data.csv'
-- INTO TABLE Learners
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (Learner_ID, Age, Profession, Region, Learner_Segment, Subscription_Plan,
--  Monthly_Fee, Months_Active, Courses_Enrolled, Courses_Completed,
--  Completion_Rate, Weekly_Hours, Login_Frequency, Last_Login_Days,
--  Coupon_Used, Discount_Availed, Payment_Mode, Support_Tickets,
--  Renewed_Last_Cycle);

-- Option B: PostgreSQL
-- ---------------------------------------------------------------------
-- \copy Learners(Learner_ID, Age, Profession, Region, Learner_Segment,
--   Subscription_Plan, Monthly_Fee, Months_Active, Courses_Enrolled,
--   Courses_Completed, Completion_Rate, Weekly_Hours, Login_Frequency,
--   Last_Login_Days, Coupon_Used, Discount_Availed, Payment_Mode,
--   Support_Tickets, Renewed_Last_Cycle)
-- FROM 'learner_data.csv' DELIMITER ',' CSV HEADER;

-- Option C: SQLite (via command line shell)
-- ---------------------------------------------------------------------
-- sqlite3 pricing_assistant.db
-- .mode csv
-- .import --skip 1 learner_data.csv Learners

-- Option D: DB Browser for SQLite (GUI - recommended for beginners)
-- ---------------------------------------------------------------------
-- File > Import > Table from CSV file... > select learner_data.csv
-- > Map columns to match the Learners table > Import

/* =====================================================================
   FLAT VERSION NOTE
   ---------------------------------------------------------------------
   If you'd rather skip the two lookup tables and just have ONE flat
   table (fastest to explain, zero JOINs required), simply:
     1. Drop Subscription_Plans and Learner_Segments
     2. Remove the two FOREIGN KEY constraints from Learners
     3. Import learner_data.csv directly into Learners

   Both versions are valid. The two-table version shows you understand
   normalization; the flat version is faster to query and explain.
   This project's analysis_queries.sql works with EITHER version -
   JOINs to the lookup tables are optional enrichments, not required.
   ===================================================================== */
