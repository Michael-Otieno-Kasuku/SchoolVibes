/*---------------PostgreSQL 13.10------------*/
/*access the postgresSQL terminal*/
sudo -i -u postgres
psql
/* Create the database */
CREATE DATABASE uririconnectdb;

/* Grant all the permissions to user kasuku */
GRANT ALL PRIVILEGES ON DATABASE uririconnectdb TO kasuku;

/* Connect to the database as kasuku */
psql -h localhost -U kasuku -d uririconnectdb -W

/* Start a transaction */
BEGIN;

/* Create Roles Table */
CREATE TABLE IF NOT EXISTS Roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);

/* Create Users Table */
CREATE TABLE IF NOT EXISTS Users (
    user_id SERIAL PRIMARY KEY,
    role_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email_address VARCHAR(100) UNIQUE NOT NULL,
    user_password VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

/* Create User_Phone_Numbers Table */
CREATE TABLE IF NOT EXISTS User_Phone_Numbers (
    user_id INT,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    PRIMARY KEY (user_id, phone_number),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

/* Create Events Table */
CREATE TABLE IF NOT EXISTS Events (
    event_id SERIAL PRIMARY KEY,
    title VARCHAR(100) UNIQUE NOT NULL,
    event_description TEXT,
    event_date DATE,
    event_location VARCHAR(100),
    organizer_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (organizer_id) REFERENCES Users(user_id)
);

/* Create Event_Registrations Table */
CREATE TABLE IF NOT EXISTS Event_Registrations (
    event_reg_id SERIAL PRIMARY KEY,
    event_id INT,
    user_id INT,
    registration_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (event_id, user_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

/* Create User_Resources Table */
CREATE TABLE IF NOT EXISTS User_Resources (
    user_id INT,
    resource_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    resource_description TEXT,
    file_path VARCHAR(255),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (title, user_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

/* Create Classes Table */
CREATE TABLE IF NOT EXISTS Classes (
    class_id SERIAL PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL,
    teacher_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (class_name, teacher_id),
    FOREIGN KEY (teacher_id) REFERENCES Users(user_id)
);

/* Create Messages Table */
CREATE TABLE IF NOT EXISTS Messages (
    message_id SERIAL PRIMARY KEY,
    sender_id INT,
    receiver_id INT,
    message_content TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (sender_id, receiver_id),
    FOREIGN KEY (sender_id) REFERENCES Users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES Users(user_id)
);

/* Create Security_Incidents Table */
CREATE TABLE IF NOT EXISTS Security_Incidents (
    security_id SERIAL PRIMARY KEY,
    reporter_id INT,
    incident_details TEXT,
    time_reported TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    report_status VARCHAR(20) CHECK (report_status IN ('Reported', 'Under Investigation', 'Resolved')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (reporter_id, incident_details),
    FOREIGN KEY (reporter_id) REFERENCES Users(user_id)
);

/* Create Assignments Table */
CREATE TABLE IF NOT EXISTS Assignments (
    assignment_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    assignment_description TEXT,
    due_date DATE,
    teacher_id INT,
    class_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (title, due_date, class_id),
    FOREIGN KEY (teacher_id) REFERENCES Users(user_id),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);

/* Create Grades Table */
CREATE TABLE IF NOT EXISTS Grades (
    grade_id SERIAL PRIMARY KEY,
    assignment_id INT,
    student_id INT,
    score DECIMAL(5,2),
    grading_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (assignment_id, student_id),
    FOREIGN KEY (assignment_id) REFERENCES Assignments(assignment_id),
    FOREIGN KEY (student_id) REFERENCES Users(user_id)
);

/* Commit the transaction */
COMMIT;