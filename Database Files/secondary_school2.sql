/*---------------PostgreSQL 13.10------------*/
/*access the postgresSQL terminal*/
sudo -i -u postgres
psql
/* Create the database */
CREATE DATABASE secondarydb;

/* Grant all the permissions to user kasuku */
GRANT ALL PRIVILEGES ON DATABASE secondarydb TO kasuku;

/* Connect to the database as kasuku */
psql -h localhost -U kasuku -d secondarydb -W

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

/* 
    Inserting 5 records into the Roles table
    Roles: Admin, Teacher, Student, Parent, Security Officer
*/

INSERT INTO Roles (role_name) VALUES
    ('Admin'),            /* Role for administrators */
    ('Teacher'),          /* Role for teachers */
    ('Student'),          /* Role for students */
    ('Parent'),           /* Role for parents */
    ('Security Officer'); /* Role for security officers */
/*
    Inserting users with different roles into the Users table
    
    Roles:
    1: Admin
    2: Teacher
    3: Student
    4: Parent
    5: Security Officer
*/
BEGIN;

/* Inserting 2 Admins */
INSERT INTO Users (role_id, first_name, last_name, email_address, user_password)
VALUES
    ((SELECT role_id FROM Roles WHERE role_name = 'Admin'), 'John', 'Kamau', 'johnkamau1@example.com', 'admin_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Admin'), 'Mary', 'Wanjiku', 'marywanjiku1@example.com', 'admin_password');

/* Inserting 10 Teachers */
INSERT INTO Users (role_id, first_name, last_name, email_address, user_password)
VALUES
    ((SELECT role_id FROM Roles WHERE role_name = 'Teacher'), 'David', 'Ochieng', 'davidochieng2@example.com', 'teacher_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Teacher'), 'Jane', 'Muthoni', 'janemuthoni2@example.com', 'teacher_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Teacher'), 'Alice', 'Korir', 'alicekorir2@example.com', 'teacher_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Teacher'), 'Brian', 'Maina', 'brianmaina2@example.com', 'teacher_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Teacher'), 'Grace', 'Wambui', 'gracewambui2@example.com', 'teacher_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Teacher'), 'Cynthia', 'Nyambura', 'cynthianyambura2@example.com', 'teacher_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Teacher'), 'Daniel', 'Ogutu', 'danielogutu2@example.com', 'teacher_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Teacher'), 'Eunice', 'Mwende', 'eunicemwende2@example.com', 'teacher_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Teacher'), 'Joseph', 'Kamau', 'josephkamau2@example.com', 'teacher_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Teacher'), 'Kamau', 'Njoroge', 'kamaunjoroge2@example.com', 'teacher_password');

/* Inserting 20 Students */
INSERT INTO Users (role_id, first_name, last_name, email_address, user_password)
VALUES
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Brian', 'Maina', 'brianmaina3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Grace', 'Wambui', 'gracewambui3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Cynthia', 'Nyambura', 'cynthianyambura3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Dennis', 'Mwangi', 'dennismwangi3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Esther', 'Wanjiru', 'estherwanjiru3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Felix', 'Kiprop', 'felixkiprop3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Gladys', 'Muthoni', 'gladysmuthoni3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Harrison', 'Omondi', 'harrisonomondi3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Irene', 'Korir', 'irenekorir3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Jackline', 'Kamau', 'jacklinekamau3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Kennedy', 'Oduor', 'kennedyoduor3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Linda', 'Wambui', 'lindawambui3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Martin', 'Gitau', 'martingitau3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Nancy', 'Wanjiku', 'nancywanjiku3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Oscar', 'Njoroge', 'oscarnjoroge3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Pauline', 'Muthoni', 'paulinemuthoni3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Quincy', 'Omondi', 'quincyomondi3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Rachel', 'Wanjiru', 'rachelwanjiru3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Samuel', 'Kiprop', 'samuelkiprop3@example.com', 'student_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Student'), 'Tabitha', 'Korir', 'tabithakorir3@example.com', 'student_password');

/* Inserting 10 Parents */
INSERT INTO Users (role_id, first_name, last_name, email_address, user_password)
VALUES
    ((SELECT role_id FROM Roles WHERE role_name = 'Parent'), 'Daniel', 'Ogutu', 'danielogutu4@example.com', 'parent_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Parent'), 'Eunice', 'Mwende', 'eunicemwende4@example.com', 'parent_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Parent'), 'Joseph', 'Kamau', 'josephkamau4@example.com', 'parent_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Parent'), 'Jane', 'Kiprono', 'janekiprono4@example.com', 'parent_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Parent'), 'Simon', 'Waweru', 'simonwaweru4@example.com', 'parent_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Parent'), 'Sarah', 'Wanjiru', 'sarahwanjiru4@example.com', 'parent_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Parent'), 'Philip', 'Omondi', 'philipomondi4@example.com', 'parent_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Parent'), 'Hellen', 'Wambui', 'hellenwambui4@example.com', 'parent_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Parent'), 'George', 'Mwangi', 'georgemwangi4@example.com', 'parent_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Parent'), 'Lilian', 'Korir', 'liliankorir4@example.com', 'parent_password');

/* Inserting 4 Security Officers */
INSERT INTO Users (role_id, first_name, last_name, email_address, user_password)
VALUES
    ((SELECT role_id FROM Roles WHERE role_name = 'Security Officer'), 'Wanjiru', 'Ogutu', 'wanjiruogutu5@example.com', 'security_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Security Officer'), 'Mwende', 'Muthoni', 'mwendemuthoni5@example.com', 'security_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Security Officer'), 'Kamau', 'Njoroge', 'kamaunjoroge5@example.com', 'security_password'),
    ((SELECT role_id FROM Roles WHERE role_name = 'Security Officer'), 'Waweru', 'Omondi', 'waweruomondi5@example.com', 'security_password');

COMMIT;

BEGIN;

/*
   Inserting phone numbers for Admins
*/
INSERT INTO User_Phone_Numbers (user_id, phone_number)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'johnkamau1@example.com'), '+1234567890'),
    ((SELECT user_id FROM Users WHERE email_address = 'marywanjiku1@example.com'), '+9876543210');

/*
   Inserting phone numbers for Teachers
*/
INSERT INTO User_Phone_Numbers (user_id, phone_number)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'davidochieng2@example.com'), '+1112233441'),
    ((SELECT user_id FROM Users WHERE email_address = 'janemuthoni2@example.com'), '+5556677882'),
    ((SELECT user_id FROM Users WHERE email_address = 'alicekorir2@example.com'), '+9998887773'),
    ((SELECT user_id FROM Users WHERE email_address = 'brianmaina2@example.com'), '+3334445554'),
    ((SELECT user_id FROM Users WHERE email_address = 'gracewambui2@example.com'), '+7778889995'),
    ((SELECT user_id FROM Users WHERE email_address = 'cynthianyambura2@example.com'), '+2221110006'),
    ((SELECT user_id FROM Users WHERE email_address = 'danielogutu2@example.com'), '+4445556668'),
    ((SELECT user_id FROM Users WHERE email_address = 'eunicemwende2@example.com'), '+8889990008'),
    ((SELECT user_id FROM Users WHERE email_address = 'josephkamau2@example.com'), '+5554443339'),
    ((SELECT user_id FROM Users WHERE email_address = 'kamaunjoroge2@example.com'), '+6667778880');

/*
   Inserting phone numbers for Students
*/
INSERT INTO User_Phone_Numbers (user_id, phone_number)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'brianmaina3@example.com'), '+3334445551'),
    ((SELECT user_id FROM Users WHERE email_address = 'gracewambui3@example.com'), '+7778889992'),
    ((SELECT user_id FROM Users WHERE email_address = 'cynthianyambura3@example.com'), '+2221110002'),
    ((SELECT user_id FROM Users WHERE email_address = 'dennismwangi3@example.com'), '+9990001113'),
    ((SELECT user_id FROM Users WHERE email_address = 'estherwanjiru3@example.com'), '+8881112224'),
    ((SELECT user_id FROM Users WHERE email_address = 'felixkiprop3@example.com'), '+7772223335'),
    ((SELECT user_id FROM Users WHERE email_address = 'gladysmuthoni3@example.com'), '+6663334446'),
    ((SELECT user_id FROM Users WHERE email_address = 'harrisonomondi3@example.com'), '+5554445557'),
    ((SELECT user_id FROM Users WHERE email_address = 'irenekorir3@example.com'), '+4445556667'),
    ((SELECT user_id FROM Users WHERE email_address = 'jacklinekamau3@example.com'), '+3336667779'),
    ((SELECT user_id FROM Users WHERE email_address = 'kennedyoduor3@example.com'), '+2227778880'),
    ((SELECT user_id FROM Users WHERE email_address = 'lindawambui3@example.com'), '+1118889991'),
    ((SELECT user_id FROM Users WHERE email_address = 'martingitau3@example.com'), '+9990001112'),
    ((SELECT user_id FROM Users WHERE email_address = 'nancywanjiku3@example.com'), '+8881112223'),
    ((SELECT user_id FROM Users WHERE email_address = 'oscarnjoroge3@example.com'), '+7772223334'),
    ((SELECT user_id FROM Users WHERE email_address = 'paulinemuthoni3@example.com'), '+6663334445'),
    ((SELECT user_id FROM Users WHERE email_address = 'quincyomondi3@example.com'), '+5554445556'),
    ((SELECT user_id FROM Users WHERE email_address = 'rachelwanjiru3@example.com'), '+4445556660'),
    ((SELECT user_id FROM Users WHERE email_address = 'samuelkiprop3@example.com'), '+3336667778'),
    ((SELECT user_id FROM Users WHERE email_address = 'tabithakorir3@example.com'), '+2227778889');

/*
   Inserting phone numbers for Parents
*/
INSERT INTO User_Phone_Numbers (user_id, phone_number)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'danielogutu4@example.com'), '+4445556661'),
    ((SELECT user_id FROM Users WHERE email_address = 'eunicemwende4@example.com'), '+8889990002'),
    ((SELECT user_id FROM Users WHERE email_address = 'josephkamau4@example.com'), '+5554443333'),
    ((SELECT user_id FROM Users WHERE email_address = 'janekiprono4@example.com'), '+6667778884'),
    ((SELECT user_id FROM Users WHERE email_address = 'simonwaweru4@example.com'), '+7778889990'),
    ((SELECT user_id FROM Users WHERE email_address = 'sarahwanjiru4@example.com'), '+1112223336'),
    ((SELECT user_id FROM Users WHERE email_address = 'philipomondi4@example.com'), '+2223334447'),
    ((SELECT user_id FROM Users WHERE email_address = 'hellenwambui4@example.com'), '+3334445558'),
    ((SELECT user_id FROM Users WHERE email_address = 'georgemwangi4@example.com'), '+4445556669'),
    ((SELECT user_id FROM Users WHERE email_address = 'liliankorir4@example.com'), '+5556667770');

/*
   Inserting phone numbers for Security Officers
*/
INSERT INTO User_Phone_Numbers (user_id, phone_number)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'wanjiruogutu5@example.com'), '+1239874561'),
    ((SELECT user_id FROM Users WHERE email_address = 'mwendemuthoni5@example.com'), '+4567890122'),
    ((SELECT user_id FROM Users WHERE email_address = 'kamaunjoroge5@example.com'), '+7890123453'),
    ((SELECT user_id FROM Users WHERE email_address = 'waweruomondi5@example.com'), '+2345678904');

COMMIT;

BEGIN;
/* Inserting events for School Assemblies organized by Admins */
INSERT INTO Events (title, event_description, event_date, event_location, organizer_id)
VALUES
    ('Monthly Assembly', 'Monthly school assembly for updates and announcements', '2023-11-15', 'School Auditorium', (SELECT user_id FROM Users WHERE email_address = 'johnkamau1@example.com')),
    ('Achievement Celebration', 'Special assembly to celebrate academic achievements', '2023-12-05', 'School Grounds', (SELECT user_id FROM Users WHERE email_address = 'marywanjiku1@example.com'));

/* Inserting events for Parent-Teacher Meetings organized by Teachers */
INSERT INTO Events (title, event_description, event_date, event_location, organizer_id)
VALUES
    ('Academic Progress Meeting', 'Discussing student academic progress and school activities', '2023-11-25', 'Classrooms', (SELECT user_id FROM Users WHERE email_address = 'janemuthoni2@example.com')),
    ('Feedback Session', 'Addressing concerns and feedback from parents', '2023-12-10', 'School Hall', (SELECT user_id FROM Users WHERE email_address = 'alicekorir2@example.com'));

/* Inserting events for Extracurricular Activities organized by Teachers */
INSERT INTO Events (title, event_description, event_date, event_location, organizer_id)
VALUES
    ('Annual Sports Day', 'Annual sports competition among students', '2023-12-08', 'School Sports Grounds', (SELECT user_id FROM Users WHERE email_address = 'davidochieng2@example.com')),
    ('Science Fair Exhibition', 'Showcasing science projects by students', '2024-01-15', 'Science Lab', (SELECT user_id FROM Users WHERE email_address = 'brianmaina2@example.com')),
    ('Drama Club Performance', 'School play organized by the drama club', '2024-02-05', 'School Auditorium', (SELECT user_id FROM Users WHERE email_address = 'cynthianyambura2@example.com'));

/* Additional Events */
INSERT INTO Events (title, event_description, event_date, event_location, organizer_id)
VALUES
    ('Music Club Concert', 'Concert showcasing talents from the music club', '2024-03-10', 'School Auditorium', (SELECT user_id FROM Users WHERE email_address = 'danielogutu2@example.com')),
    ('Mathematics Olympiad', 'Competition to showcase mathematical skills', '2024-03-25', 'Classrooms', (SELECT user_id FROM Users WHERE email_address = 'eunicemwende2@example.com')),
    ('Debate Competition', 'Inter-school debate competition', '2024-04-05', 'School Hall', (SELECT user_id FROM Users WHERE email_address = 'josephkamau2@example.com')),
    ('Career Guidance Seminar', 'Seminar to guide students on career choices', '2024-04-20', 'School Auditorium', (SELECT user_id FROM Users WHERE email_address = 'kamaunjoroge2@example.com'));
COMMIT;

/* Inserting 30 Event Registrations */
BEGIN;
/* Event 1 - Monthly Assembly */
INSERT INTO Event_Registrations (event_id, user_id, registration_date)
VALUES
    ((SELECT event_id FROM Events WHERE title = 'Monthly Assembly'), (SELECT user_id FROM Users WHERE email_address = 'brianmaina3@example.com'), '2023-11-10'),
    ((SELECT event_id FROM Events WHERE title = 'Monthly Assembly'), (SELECT user_id FROM Users WHERE email_address = 'gracewambui3@example.com'), '2023-11-11'),
    ((SELECT event_id FROM Events WHERE title = 'Monthly Assembly'), (SELECT user_id FROM Users WHERE email_address = 'cynthianyambura3@example.com'), '2023-11-12');
    /* Add more registrations as needed */

/* Event 2 - Achievement Celebration */
INSERT INTO Event_Registrations (event_id, user_id, registration_date)
VALUES
    ((SELECT event_id FROM Events WHERE title = 'Achievement Celebration'), (SELECT user_id FROM Users WHERE email_address = 'dennismwangi3@example.com'), '2023-11-20'),
    ((SELECT event_id FROM Events WHERE title = 'Achievement Celebration'), (SELECT user_id FROM Users WHERE email_address = 'estherwanjiru3@example.com'), '2023-11-21'),
    ((SELECT event_id FROM Events WHERE title = 'Achievement Celebration'), (SELECT user_id FROM Users WHERE email_address = 'felixkiprop3@example.com'), '2023-11-22');
    /* Add more registrations as needed */

/* Event 3 - Academic Progress Meeting */
INSERT INTO Event_Registrations (event_id, user_id, registration_date)
VALUES
    ((SELECT event_id FROM Events WHERE title = 'Academic Progress Meeting'), (SELECT user_id FROM Users WHERE email_address = 'gladysmuthoni3@example.com'), '2023-11-28'),
    ((SELECT event_id FROM Events WHERE title = 'Academic Progress Meeting'), (SELECT user_id FROM Users WHERE email_address = 'harrisonomondi3@example.com'), '2023-11-29'),
    ((SELECT event_id FROM Events WHERE title = 'Academic Progress Meeting'), (SELECT user_id FROM Users WHERE email_address = 'irenekorir3@example.com'), '2023-11-30');
    /* Add more registrations as needed */

/* Event 4 - Feedback Session */
INSERT INTO Event_Registrations (event_id, user_id, registration_date)
VALUES
    ((SELECT event_id FROM Events WHERE title = 'Feedback Session'), (SELECT user_id FROM Users WHERE email_address = 'jacklinekamau3@example.com'), '2023-12-05'),
    ((SELECT event_id FROM Events WHERE title = 'Feedback Session'), (SELECT user_id FROM Users WHERE email_address = 'kennedyoduor3@example.com'), '2023-12-06'),
    ((SELECT event_id FROM Events WHERE title = 'Feedback Session'), (SELECT user_id FROM Users WHERE email_address = 'lindawambui3@example.com'), '2023-12-07');
    /* Add more registrations as needed */

/* Event 5 - Annual Sports Day */
INSERT INTO Event_Registrations (event_id, user_id, registration_date)
VALUES
    ((SELECT event_id FROM Events WHERE title = 'Annual Sports Day'), (SELECT user_id FROM Users WHERE email_address = 'martingitau3@example.com'), '2023-12-02'),
    ((SELECT event_id FROM Events WHERE title = 'Annual Sports Day'), (SELECT user_id FROM Users WHERE email_address = 'nancywanjiku3@example.com'), '2023-12-03'),
    ((SELECT event_id FROM Events WHERE title = 'Annual Sports Day'), (SELECT user_id FROM Users WHERE email_address = 'oscarnjoroge3@example.com'), '2023-12-04');
    /* Add more registrations as needed */

/* Event 6 - Science Fair Exhibition */
INSERT INTO Event_Registrations (event_id, user_id, registration_date)
VALUES
    ((SELECT event_id FROM Events WHERE title = 'Science Fair Exhibition'), (SELECT user_id FROM Users WHERE email_address = 'paulinemuthoni3@example.com'), '2024-01-10'),
    ((SELECT event_id FROM Events WHERE title = 'Science Fair Exhibition'), (SELECT user_id FROM Users WHERE email_address = 'quincyomondi3@example.com'), '2024-01-11'),
    ((SELECT event_id FROM Events WHERE title = 'Science Fair Exhibition'), (SELECT user_id FROM Users WHERE email_address = 'rachelwanjiru3@example.com'), '2024-01-12');
    /* Add more registrations as needed */

/* Event 7 - Drama Club Performance */
INSERT INTO Event_Registrations (event_id, user_id, registration_date)
VALUES
    ((SELECT event_id FROM Events WHERE title = 'Drama Club Performance'), (SELECT user_id FROM Users WHERE email_address = 'samuelkiprop3@example.com'), '2024-02-01'),
    ((SELECT event_id FROM Events WHERE title = 'Drama Club Performance'), (SELECT user_id FROM Users WHERE email_address = 'tabithakorir3@example.com'), '2024-02-02'),
    ((SELECT event_id FROM Events WHERE title = 'Drama Club Performance'), (SELECT user_id FROM Users WHERE email_address = 'wanjiruogutu5@example.com'), '2024-02-03');
    /* Add more registrations as needed */
COMMIT;

BEGIN;
/* Inserting 30 User Resources */

/* Resource 1 */
INSERT INTO User_Resources (user_id, title, resource_description, file_path)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'johnkamau1@example.com'), 'Resource Title 1', 'Description for Resource 1', '/path/to/resource1'),
    ((SELECT user_id FROM Users WHERE email_address = 'marywanjiku1@example.com'), 'Resource Title 2', 'Description for Resource 2', '/path/to/resource2'),
    ((SELECT user_id FROM Users WHERE email_address = 'davidochieng2@example.com'), 'Resource Title 3', 'Description for Resource 3', '/path/to/resource3');
    /* Add more resources as needed */

/* Resource 2 */
INSERT INTO User_Resources (user_id, title, resource_description, file_path)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'janemuthoni2@example.com'), 'Resource Title 4', 'Description for Resource 4', '/path/to/resource4'),
    ((SELECT user_id FROM Users WHERE email_address = 'alicekorir2@example.com'), 'Resource Title 5', 'Description for Resource 5', '/path/to/resource5'),
    ((SELECT user_id FROM Users WHERE email_address = 'brianmaina2@example.com'), 'Resource Title 6', 'Description for Resource 6', '/path/to/resource6');
    /* Add more resources as needed */

/* Resource 3 */
INSERT INTO User_Resources (user_id, title, resource_description, file_path)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'gracewambui2@example.com'), 'Resource Title 7', 'Description for Resource 7', '/path/to/resource7'),
    ((SELECT user_id FROM Users WHERE email_address = 'cynthianyambura2@example.com'), 'Resource Title 8', 'Description for Resource 8', '/path/to/resource8'),
    ((SELECT user_id FROM Users WHERE email_address = 'danielogutu2@example.com'), 'Resource Title 9', 'Description for Resource 9', '/path/to/resource9');
    /* Add more resources as needed */

/* Resource 4 */
INSERT INTO User_Resources (user_id, title, resource_description, file_path)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'eunicemwende2@example.com'), 'Resource Title 10', 'Description for Resource 10', '/path/to/resource10'),
    ((SELECT user_id FROM Users WHERE email_address = 'josephkamau2@example.com'), 'Resource Title 11', 'Description for Resource 11', '/path/to/resource11'),
    ((SELECT user_id FROM Users WHERE email_address = 'kamaunjoroge2@example.com'), 'Resource Title 12', 'Description for Resource 12', '/path/to/resource12');
    /* Add more resources as needed */

/* Resource 5 */
INSERT INTO User_Resources (user_id, title, resource_description, file_path)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'brianmaina3@example.com'), 'Resource Title 13', 'Description for Resource 13', '/path/to/resource13'),
    ((SELECT user_id FROM Users WHERE email_address = 'gracewambui3@example.com'), 'Resource Title 14', 'Description for Resource 14', '/path/to/resource14'),
    ((SELECT user_id FROM Users WHERE email_address = 'cynthianyambura3@example.com'), 'Resource Title 15', 'Description for Resource 15', '/path/to/resource15');
    /* Add more resources as needed */

/* Resource 6 */
INSERT INTO User_Resources (user_id, title, resource_description, file_path)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'dennismwangi3@example.com'), 'Resource Title 16', 'Description for Resource 16', '/path/to/resource16'),
    ((SELECT user_id FROM Users WHERE email_address = 'estherwanjiru3@example.com'), 'Resource Title 17', 'Description for Resource 17', '/path/to/resource17'),
    ((SELECT user_id FROM Users WHERE email_address = 'felixkiprop3@example.com'), 'Resource Title 18', 'Description for Resource 18', '/path/to/resource18');
    /* Add more resources as needed */

/* Resource 7 */
INSERT INTO User_Resources (user_id, title, resource_description, file_path)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'gladysmuthoni3@example.com'), 'Resource Title 19', 'Description for Resource 19', '/path/to/resource19'),
    ((SELECT user_id FROM Users WHERE email_address = 'harrisonomondi3@example.com'), 'Resource Title 20', 'Description for Resource 20', '/path/to/resource20'),
    ((SELECT user_id FROM Users WHERE email_address = 'irenekorir3@example.com'), 'Resource Title 21', 'Description for Resource 21', '/path/to/resource21');
    /* Add more resources as needed */

/* Resource 8 */
INSERT INTO User_Resources (user_id, title, resource_description, file_path)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'jacklinekamau3@example.com'), 'Resource Title 22', 'Description for Resource 22', '/path/to/resource22'),
    ((SELECT user_id FROM Users WHERE email_address = 'kennedyoduor3@example.com'), 'Resource Title 23', 'Description for Resource 23', '/path/to/resource23'),
    ((SELECT user_id FROM Users WHERE email_address = 'lindawambui3@example.com'), 'Resource Title 24', 'Description for Resource 24', '/path/to/resource24');
    /* Add more resources as needed */

/* Resource 9 */
INSERT INTO User_Resources (user_id, title, resource_description, file_path)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'martingitau3@example.com'), 'Resource Title 25', 'Description for Resource 25', '/path/to/resource25'),
    ((SELECT user_id FROM Users WHERE email_address = 'nancywanjiku3@example.com'), 'Resource Title 26', 'Description for Resource 26', '/path/to/resource26'),
    ((SELECT user_id FROM Users WHERE email_address = 'oscarnjoroge3@example.com'), 'Resource Title 27', 'Description for Resource 27', '/path/to/resource27');
    /* Add more resources as needed */

/* Resource 10 */
INSERT INTO User_Resources (user_id, title, resource_description, file_path)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'paulinemuthoni3@example.com'), 'Resource Title 28', 'Description for Resource 28', '/path/to/resource28'),
    ((SELECT user_id FROM Users WHERE email_address = 'quincyomondi3@example.com'), 'Resource Title 29', 'Description for Resource 29', '/path/to/resource29'),
    ((SELECT user_id FROM Users WHERE email_address = 'rachelwanjiru3@example.com'), 'Resource Title 30', 'Description for Resource 30', '/path/to/resource30');
    /* Add more resources as needed */
COMMIT;

BEGIN;
/* Inserting 20 Classes */

/* Class 1 */
INSERT INTO Classes (class_name, teacher_id)
VALUES
    ('Math Class A', (SELECT user_id FROM Users WHERE email_address = 'davidochieng2@example.com')),
    ('Science Class B', (SELECT user_id FROM Users WHERE email_address = 'janemuthoni2@example.com')),
    ('English Class C', (SELECT user_id FROM Users WHERE email_address = 'alicekorir2@example.com')),
    ('History Class D', (SELECT user_id FROM Users WHERE email_address = 'brianmaina2@example.com')),
    ('Geography Class E', (SELECT user_id FROM Users WHERE email_address = 'gracewambui2@example.com')),
    ('Physics Class F', (SELECT user_id FROM Users WHERE email_address = 'cynthianyambura2@example.com')),
    ('Chemistry Class G', (SELECT user_id FROM Users WHERE email_address = 'danielogutu2@example.com')),
    ('Biology Class H', (SELECT user_id FROM Users WHERE email_address = 'eunicemwende2@example.com')),
    ('Computer Science Class I', (SELECT user_id FROM Users WHERE email_address = 'josephkamau2@example.com')),
    ('Physical Education Class J', (SELECT user_id FROM Users WHERE email_address = 'kamaunjoroge2@example.com'));
    /* Add more classes as needed */

/* Class 2 */
INSERT INTO Classes (class_name, teacher_id)
VALUES
    ('Literature Class K', (SELECT user_id FROM Users WHERE email_address = 'davidochieng2@example.com')),
    ('Art Class L', (SELECT user_id FROM Users WHERE email_address = 'janemuthoni2@example.com')),
    ('Music Class M', (SELECT user_id FROM Users WHERE email_address = 'alicekorir2@example.com')),
    ('Drama Class N', (SELECT user_id FROM Users WHERE email_address = 'brianmaina2@example.com')),
    ('Social Studies Class O', (SELECT user_id FROM Users WHERE email_address = 'gracewambui2@example.com')),
    ('Economics Class P', (SELECT user_id FROM Users WHERE email_address = 'cynthianyambura2@example.com')),
    ('Political Science Class Q', (SELECT user_id FROM Users WHERE email_address = 'danielogutu2@example.com')),
    ('Sociology Class R', (SELECT user_id FROM Users WHERE email_address = 'eunicemwende2@example.com')),
    ('Psychology Class S', (SELECT user_id FROM Users WHERE email_address = 'josephkamau2@example.com')),
    ('Philosophy Class T', (SELECT user_id FROM Users WHERE email_address = 'kamaunjoroge2@example.com'));
    /* Add more classes as needed */

/* Class 3 */
INSERT INTO Classes (class_name, teacher_id)
VALUES
    ('French Class U', (SELECT user_id FROM Users WHERE email_address = 'davidochieng2@example.com')),
    ('Spanish Class V', (SELECT user_id FROM Users WHERE email_address = 'janemuthoni2@example.com')),
    ('German Class W', (SELECT user_id FROM Users WHERE email_address = 'alicekorir2@example.com')),
    ('Chinese Class X', (SELECT user_id FROM Users WHERE email_address = 'brianmaina2@example.com')),
    ('Japanese Class Y', (SELECT user_id FROM Users WHERE email_address = 'gracewambui2@example.com')),
    ('Italian Class Z', (SELECT user_id FROM Users WHERE email_address = 'cynthianyambura2@example.com')),
    ('Russian Class AA', (SELECT user_id FROM Users WHERE email_address = 'danielogutu2@example.com')),
    ('Arabic Class AB', (SELECT user_id FROM Users WHERE email_address = 'eunicemwende2@example.com')),
    ('Swahili Class AC', (SELECT user_id FROM Users WHERE email_address = 'josephkamau2@example.com')),
    ('Portuguese Class AD', (SELECT user_id FROM Users WHERE email_address = 'kamaunjoroge2@example.com'));
    /* Add more classes as needed */
COMMIT;

BEGIN;
/* Inserting 30 Messages */

/* Message 1-10: Admins to Teachers */
INSERT INTO Messages (sender_id, receiver_id, message_content, is_read)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'johnkamau1@example.com'), (SELECT user_id FROM Users WHERE email_address = 'davidochieng2@example.com'), 'Hello David, how are you?', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'marywanjiku1@example.com'), (SELECT user_id FROM Users WHERE email_address = 'janemuthoni2@example.com'), 'Hi Jane, do you have a moment?', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'johnkamau1@example.com'), (SELECT user_id FROM Users WHERE email_address = 'alicekorir2@example.com'), 'Alice, could you assist with the new curriculum?', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'marywanjiku1@example.com'), (SELECT user_id FROM Users WHERE email_address = 'brianmaina2@example.com'), 'Brian, let us discuss the upcoming parent-teacher meeting.', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'johnkamau1@example.com'), (SELECT user_id FROM Users WHERE email_address = 'gracewambui2@example.com'), 'Grace, any updates on the school event?', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'marywanjiku1@example.com'), (SELECT user_id FROM Users WHERE email_address = 'cynthianyambura2@example.com'), 'Cynthia, please share the latest student progress report.', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'johnkamau1@example.com'), (SELECT user_id FROM Users WHERE email_address = 'danielogutu2@example.com'), 'Daniel, can we meet to discuss security measures?', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'marywanjiku1@example.com'), (SELECT user_id FROM Users WHERE email_address = 'eunicemwende2@example.com'), 'Eunice, any incidents reported recently?', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'johnkamau1@example.com'), (SELECT user_id FROM Users WHERE email_address = 'josephkamau2@example.com'), 'Joseph, how are you managing your class?', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'marywanjiku1@example.com'), (SELECT user_id FROM Users WHERE email_address = 'kamaunjoroge2@example.com'), 'Kamau, any challenges with the students?', FALSE),

/* Message 11-20: Teachers to Students */
    ((SELECT user_id FROM Users WHERE email_address = 'davidochieng2@example.com'), (SELECT user_id FROM Users WHERE email_address = 'brianmaina3@example.com'), 'Brian, please review the last lecture.', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'janemuthoni2@example.com'), (SELECT user_id FROM Users WHERE email_address = 'gracewambui3@example.com'), 'Grace, do not forget about the upcoming test.', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'alicekorir2@example.com'), (SELECT user_id FROM Users WHERE email_address = 'cynthianyambura3@example.com'), 'Cynthia, your project submission is due next week.', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'brianmaina2@example.com'), (SELECT user_id FROM Users WHERE email_address = 'dennismwangi3@example.com'), 'Dennis, any questions about the assignment?', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'gracewambui2@example.com'), (SELECT user_id FROM Users WHERE email_address = 'estherwanjiru3@example.com'), 'Esther, make sure to attend the extra class for clarification.', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'cynthianyambura2@example.com'), (SELECT user_id FROM Users WHERE email_address = 'felixkiprop3@example.com'), 'Felix, your participation in the science fair is appreciated.', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'danielogutu2@example.com'), (SELECT user_id FROM Users WHERE email_address = 'gladysmuthoni3@example.com'), 'Gladys, keep up the good work!', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'eunicemwende2@example.com'), (SELECT user_id FROM Users WHERE email_address = 'harrisonomondi3@example.com'), 'Harrison, prepare for the upcoming quiz.', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'josephkamau2@example.com'), (SELECT user_id FROM Users WHERE email_address = 'irenekorir3@example.com'), 'Irene, any issues in your class? Let me know.', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'kamaunjoroge2@example.com'), (SELECT user_id FROM Users WHERE email_address = 'jacklinekamau3@example.com'), 'Jackline, keep up the positive attitude in class.', FALSE),

/* Message 21-30: Students to Parents */
    ((SELECT user_id FROM Users WHERE email_address = 'brianmaina3@example.com'), (SELECT user_id FROM Users WHERE email_address = 'danielogutu4@example.com'), 'Dad, I need some money for school supplies.', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'gracewambui3@example.com'), (SELECT user_id FROM Users WHERE email_address = 'eunicemwende4@example.com'), 'Mom, can you sign my permission slip?', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'cynthianyambura3@example.com'), (SELECT user_id FROM Users WHERE email_address = 'josephkamau4@example.com'), 'Dad, I have a school project coming up.', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'dennismwangi3@example.com'), (SELECT user_id FROM Users WHERE email_address = 'janekiprono4@example.com'), 'Mom, I need help with my homework.', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'estherwanjiru3@example.com'), (SELECT user_id FROM Users WHERE email_address = 'simonwaweru4@example.com'), 'Dad, can you attend the parent-teacher meeting?', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'felixkiprop3@example.com'), (SELECT user_id FROM Users WHERE email_address = 'sarahwanjiru4@example.com'), 'Mom, I will be participating in a school event.', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'gladysmuthoni3@example.com'), (SELECT user_id FROM Users WHERE email_address = 'philipomondi4@example.com'), 'Dad, I need a new set of art supplies.', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'harrisonomondi3@example.com'), (SELECT user_id FROM Users WHERE email_address = 'hellenwambui4@example.com'), 'Mom, can you help me with my science project?', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'irenekorir3@example.com'), (SELECT user_id FROM Users WHERE email_address = 'georgemwangi4@example.com'), 'Dad, I got good grades in the recent exams.', FALSE),
    ((SELECT user_id FROM Users WHERE email_address = 'jacklinekamau3@example.com'), (SELECT user_id FROM Users WHERE email_address = 'liliankorir4@example.com'), 'Mom, I need your signature on my report card.', FALSE);
COMMIT;

BEGIN;
/* Inserting 10 Security Incidents */

/* Security Incident 1-5: Wanjiru Ogutu */
INSERT INTO Security_Incidents (reporter_id, incident_details, report_status)
VALUES
    ((SELECT user_id FROM Users WHERE email_address = 'wanjiruogutu5@example.com'), 'Unauthorized person on school premises.', 'Reported'),
    ((SELECT user_id FROM Users WHERE email_address = 'wanjiruogutu5@example.com'), 'Suspicious activity near the school gate.', 'Reported'),
    ((SELECT user_id FROM Users WHERE email_address = 'wanjiruogutu5@example.com'), 'Vandalism in the parking area.', 'Reported'),
    ((SELECT user_id FROM Users WHERE email_address = 'wanjiruogutu5@example.com'), 'Broken window near the gymnasium.', 'Under Investigation'),
    ((SELECT user_id FROM Users WHERE email_address = 'wanjiruogutu5@example.com'), 'Possible theft in the staff lounge.', 'Under Investigation'),

/* Security Incident 6-10: Mwende Muthoni */
    ((SELECT user_id FROM Users WHERE email_address = 'mwendemuthoni5@example.com'), 'Student altercation in the cafeteria.', 'Reported'),
    ((SELECT user_id FROM Users WHERE email_address = 'mwendemuthoni5@example.com'), 'Unauthorized access to the computer lab.', 'Reported'),
    ((SELECT user_id FROM Users WHERE email_address = 'mwendemuthoni5@example.com'), 'Unknown person in the school library.', 'Under Investigation'),
    ((SELECT user_id FROM Users WHERE email_address = 'mwendemuthoni5@example.com'), 'Report of missing school property.', 'Under Investigation'),
    ((SELECT user_id FROM Users WHERE email_address = 'mwendemuthoni5@example.com'), 'Resolved issue: Misplaced items found.', 'Resolved');
COMMIT;

BEGIN;
/* Inserting 20 Assignments */

/* Assignment 1-5: David Ochieng - Math Class A */
INSERT INTO Assignments (title, assignment_description, due_date, teacher_id, class_id)
VALUES
    ('Math Homework 1', 'Complete exercises 1-10 in the textbook.', '2023-12-01', (SELECT user_id FROM Users WHERE email_address = 'davidochieng2@example.com'), 1),
    ('Math Quiz 1', 'Answer questions on algebra and geometry.', '2023-12-05', (SELECT user_id FROM Users WHERE email_address = 'davidochieng2@example.com'), 1),
    ('Math Homework 2', 'Solve problems related to calculus.', '2023-12-10', (SELECT user_id FROM Users WHERE email_address = 'davidochieng2@example.com'), 1),
    ('Math Project', 'Create a presentation on a mathematical concept of your choice.', '2023-12-15', (SELECT user_id FROM Users WHERE email_address = 'davidochieng2@example.com'), 1),
    ('Math Final Exam', 'Comprehensive exam covering all topics studied in the semester.', '2023-12-20', (SELECT user_id FROM Users WHERE email_address = 'davidochieng2@example.com'), 1),

/* Assignment 6-10: Jane Muthoni - Science Class B */
    ('Science Lab Report', 'Document the results of the recent chemistry experiment.', '2023-12-02', (SELECT user_id FROM Users WHERE email_address = 'janemuthoni2@example.com'), 2),
    ('Science Quiz 1', 'Test your knowledge on physics principles.', '2023-12-07', (SELECT user_id FROM Users WHERE email_address = 'janemuthoni2@example.com'), 2),
    ('Science Research Paper', 'Write a paper on a chosen scientific discovery.', '2023-12-12', (SELECT user_id FROM Users WHERE email_address = 'janemuthoni2@example.com'), 2),
    ('Science Homework 2', 'Complete assigned problems in the science workbook.', '2023-12-17', (SELECT user_id FROM Users WHERE email_address = 'janemuthoni2@example.com'), 2),
    ('Science Final Exam', 'Comprehensive exam covering all science topics studied in the semester.', '2023-12-22', (SELECT user_id FROM Users WHERE email_address = 'janemuthoni2@example.com'), 2),

/* Add more assignments for other teachers and classes as needed */

/* Assignment 11-15: Alice Korir - English Class C */
    ('English Essay', 'Write an essay on a classic piece of literature.', '2023-12-03', (SELECT user_id FROM Users WHERE email_address = 'alicekorir2@example.com'), 3),
    ('English Vocabulary Quiz', 'Test your vocabulary knowledge with a quiz.', '2023-12-08', (SELECT user_id FROM Users WHERE email_address = 'alicekorir2@example.com'), 3),
    ('English Project', 'Create a presentation on a literary analysis topic.', '2023-12-13', (SELECT user_id FROM Users WHERE email_address = 'alicekorir2@example.com'), 3),
    ('English Homework 2', 'Complete exercises on grammar and syntax.', '2023-12-18', (SELECT user_id FROM Users WHERE email_address = 'alicekorir2@example.com'), 3),
    ('English Final Exam', 'Comprehensive exam covering all English literature and language topics studied in the semester.', '2023-12-23', (SELECT user_id FROM Users WHERE email_address = 'alicekorir2@example.com'), 3),

/* Assignment 16-20: Brian Maina - History Class D */
    ('History Research Paper', 'Write a paper on a historical event of your choice.', '2023-12-04', (SELECT user_id FROM Users WHERE email_address = 'brianmaina2@example.com'), 4),
    ('History Quiz 1', 'Test your knowledge on world history.', '2023-12-09', (SELECT user_id FROM Users WHERE email_address = 'brianmaina2@example.com'), 4),
    ('History Presentation', 'Give a presentation on a significant historical figure.', '2023-12-14', (SELECT user_id FROM Users WHERE email_address = 'brianmaina2@example.com'), 4),
    ('History Homework 2', 'Answer questions on a specific historical era.', '2023-12-19', (SELECT user_id FROM Users WHERE email_address = 'brianmaina2@example.com'), 4),
    ('History Final Exam', 'Comprehensive exam covering all history topics studied in the semester.', '2023-12-24', (SELECT user_id FROM Users WHERE email_address = 'brianmaina2@example.com'), 4);
COMMIT;

BEGIN;
/* Inserting 60 Grades Records */

/* Grades for Assignments 1-5: David Ochieng - Math Class A */
INSERT INTO Grades (assignment_id, student_id, score, grading_date)
VALUES
    (1, (SELECT user_id FROM Users WHERE email_address = 'brianmaina3@example.com'), 85.5, '2023-12-02'),
    (2, (SELECT user_id FROM Users WHERE email_address = 'gracewambui3@example.com'), 92.0, '2023-12-07'),
    (3, (SELECT user_id FROM Users WHERE email_address = 'cynthianyambura3@example.com'), 78.5, '2023-12-12'),
    (4, (SELECT user_id FROM Users WHERE email_address = 'dennismwangi3@example.com'), 94.0, '2023-12-17'),
    (5, (SELECT user_id FROM Users WHERE email_address = 'estherwanjiru3@example.com'), 88.5, '2023-12-22'),

/* Grades for Assignments 6-10: Jane Muthoni - Science Class B */
    (6, (SELECT user_id FROM Users WHERE email_address = 'felixkiprop3@example.com'), 76.0, '2023-12-03'),
    (7, (SELECT user_id FROM Users WHERE email_address = 'gladysmuthoni3@example.com'), 89.5, '2023-12-08'),
    (8, (SELECT user_id FROM Users WHERE email_address = 'harrisonomondi3@example.com'), 95.5, '2023-12-13'),
    (9, (SELECT user_id FROM Users WHERE email_address = 'irenekorir3@example.com'), 81.0, '2023-12-18'),
    (10, (SELECT user_id FROM Users WHERE email_address = 'jacklinekamau3@example.com'), 90.0, '2023-12-23'),

/* Add more grades for other assignments, students, and classes as needed */

/* Grades for Assignments 11-15: Alice Korir - English Class C */
    (11, (SELECT user_id FROM Users WHERE email_address = 'kennedyoduor3@example.com'), 87.5, '2023-12-04'),
    (12, (SELECT user_id FROM Users WHERE email_address = 'lindawambui3@example.com'), 93.0, '2023-12-09'),
    (13, (SELECT user_id FROM Users WHERE email_address = 'martingitau3@example.com'), 79.5, '2023-12-14'),
    (14, (SELECT user_id FROM Users WHERE email_address = 'nancywanjiku3@example.com'), 96.0, '2023-12-19'),
    (15, (SELECT user_id FROM Users WHERE email_address = 'oscarnjoroge3@example.com'), 84.5, '2023-12-24'),

/* Grades for Assignments 16-20: Brian Maina - History Class D */
    (16, (SELECT user_id FROM Users WHERE email_address = 'paulinemuthoni3@example.com'), 91.0, '2023-12-05'),
    (17, (SELECT user_id FROM Users WHERE email_address = 'quincyomondi3@example.com'), 77.5, '2023-12-10'),
    (18, (SELECT user_id FROM Users WHERE email_address = 'rachelwanjiru3@example.com'), 85.0, '2023-12-15'),
    (19, (SELECT user_id FROM Users WHERE email_address = 'samuelkiprop3@example.com'), 92.5, '2023-12-20'),
    (20, (SELECT user_id FROM Users WHERE email_address = 'tabithakorir3@example.com'), 88.0, '2023-12-25');
COMMIT;

/* Begin a new transaction */
BEGIN;

/* Create a view to display Users with their assigned Roles */
CREATE VIEW UserWithRole AS
SELECT Users.user_id, first_name, last_name, email_address, role_name
FROM Users
JOIN Roles ON Users.role_id = Roles.role_id;

/* Create a view to display Events with their Organizers' details */
CREATE VIEW EventWithOrganizer AS
SELECT Events.event_id, title, event_description, event_date, event_location, organizer_id, first_name as organizer_first_name, last_name as organizer_last_name
FROM Events
JOIN Users ON Events.organizer_id = Users.user_id;

/* Create a view to display Event Registrations with Users' details */
CREATE VIEW EventRegistrationsWithUsers AS
SELECT Event_Registrations.event_reg_id, Events.title as event_title, Users.user_id, first_name, last_name, registration_date
FROM Event_Registrations
JOIN Events ON Event_Registrations.event_id = Events.event_id
JOIN Users ON Event_Registrations.user_id = Users.user_id;

/* Create a view to display Messages with sender and receiver details */
CREATE VIEW MessagesWithUsers AS
SELECT Messages.message_id, sender_id, receiver_id, message_content, sent_at, is_read,
       sender.first_name AS sender_first_name, sender.last_name AS sender_last_name,
       receiver.first_name AS receiver_first_name, receiver.last_name AS receiver_last_name
FROM Messages
JOIN Users AS sender ON Messages.sender_id = sender.user_id
JOIN Users AS receiver ON Messages.receiver_id = receiver.user_id;

/* Create a view to display Grades with assignment details */
CREATE VIEW GradesWithDetails AS
SELECT Grades.grade_id, Assignments.title as assignment_title, Users.user_id as student_id, score, grading_date
FROM Grades
JOIN Assignments ON Grades.assignment_id = Assignments.assignment_id
JOIN Users ON Grades.student_id = Users.user_id;

/* Commit the transaction */
COMMIT;

/* Begin a new transaction */
BEGIN;

/* Create a view to display Users with their assigned Classes */
CREATE VIEW UsersWithClasses AS
SELECT Users.user_id, first_name, last_name, email_address, class_name
FROM Users
LEFT JOIN Assignments ON Users.user_id = Assignments.teacher_id
LEFT JOIN Classes ON Assignments.class_id = Classes.class_id;

/* Create a view to display Events with the count of registrations */
CREATE VIEW EventsWithRegistrationCounts AS
SELECT Events.event_id, title, event_description, event_date, event_location, organizer_id, COUNT(Event_Registrations.user_id) AS registration_count
FROM Events
LEFT JOIN Event_Registrations ON Events.event_id = Event_Registrations.event_id
GROUP BY Events.event_id;

/* Create a view to display Unresolved Security Incidents with reporter details */
CREATE VIEW UnresolvedSecurityIncidents AS
SELECT Security_Incidents.security_id, Users.user_id as reporter_id, first_name, last_name, incident_details, time_reported, report_status
FROM Security_Incidents
JOIN Users ON Security_Incidents.reporter_id = Users.user_id
WHERE report_status IN ('Reported', 'Under Investigation');

/* Create a view to display Students with their average grades */
CREATE VIEW StudentsWithGrades AS
SELECT Users.user_id, first_name, last_name, AVG(Grades.score) AS average_score
FROM Users
LEFT JOIN Grades ON Users.user_id = Grades.student_id
WHERE Users.role_id = (SELECT role_id FROM Roles WHERE role_name = 'Student')
GROUP BY Users.user_id;

/* Create a view to display Top Event Organizers with registration counts */
CREATE VIEW TopEventOrganizers AS
SELECT organizer_id, first_name, last_name, COUNT(event_reg_id) AS registration_count
FROM Users
JOIN Events ON Users.user_id = Events.organizer_id
LEFT JOIN Event_Registrations ON Events.event_id = Event_Registrations.event_id
GROUP BY organizer_id, first_name, last_name
ORDER BY registration_count DESC;

/* Create a view to display Classes with average scores */
CREATE VIEW ClassesWithAverageScores AS
SELECT Classes.class_id, class_name, AVG(Grades.score) AS average_score
FROM Classes
LEFT JOIN Assignments ON Classes.class_id = Assignments.class_id
LEFT JOIN Grades ON Assignments.assignment_id = Grades.assignment_id
GROUP BY Classes.class_id, class_name
ORDER BY average_score DESC;

/* Create a view to display Users with the timestamp of their latest message */
CREATE VIEW UsersWithLatestMessage AS
SELECT Users.user_id, first_name, last_name, MAX(sent_at) AS latest_message_time
FROM Users
LEFT JOIN Messages ON Users.user_id = Messages.sender_id OR Users.user_id = Messages.receiver_id
GROUP BY Users.user_id, first_name, last_name;

/* Commit the transaction */
COMMIT;

/* Begin a new transaction */
BEGIN;

/* Create a function to insert a new user into the Users table */
CREATE OR REPLACE FUNCTION InsertUser(
    in_first_name VARCHAR(50),
    in_last_name VARCHAR(50),
    in_email_address VARCHAR(100),
    in_user_password VARCHAR(255),
    in_role_id INT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO Users(first_name, last_name, email_address, user_password, role_id)
    VALUES (in_first_name, in_last_name, in_email_address, in_user_password, in_role_id);
END;
$$ LANGUAGE plpgsql;

/* Create a function to register a user for a specific event */
CREATE OR REPLACE FUNCTION RegisterForEvent(
    in_event_id INT,
    in_user_id INT,
    in_registration_date DATE
) RETURNS VOID AS $$
BEGIN
    INSERT INTO Event_Registrations(event_id, user_id, registration_date)
    VALUES (in_event_id, in_user_id, in_registration_date);
END;
$$ LANGUAGE plpgsql;

/* Create a function to retrieve grades for a user in a specific class */
CREATE OR REPLACE FUNCTION GetUserGradesForClass(
    in_user_id INT,
    in_class_id INT
) RETURNS TABLE (
    assignment_title VARCHAR(100),
    score DECIMAL(5,2),
    grading_date DATE
) AS $$
BEGIN
    RETURN QUERY
    SELECT Assignments.title AS assignment_title, Grades.score, Grades.grading_date
    FROM Grades
    JOIN Assignments ON Grades.assignment_id = Assignments.assignment_id
    WHERE Grades.student_id = in_user_id AND Assignments.class_id = in_class_id;
END;
$$ LANGUAGE plpgsql;

/* Create a function to update a user's password */
CREATE OR REPLACE FUNCTION UpdateUserPassword(
    in_user_id INT,
    in_new_password VARCHAR(255)
) RETURNS VOID AS $$
BEGIN
    UPDATE Users SET user_password = in_new_password WHERE user_id = in_user_id;
END;
$$ LANGUAGE plpgsql;

/* Create a function to resolve a security incident */
CREATE OR REPLACE FUNCTION ResolveSecurityIncident(
    in_security_id INT
) RETURNS VOID AS $$
BEGIN
    UPDATE Security_Incidents SET report_status = 'Resolved' WHERE security_id = in_security_id;
END;
$$ LANGUAGE plpgsql;

/* Commit the transaction */
COMMIT;

/* Begin a new transaction */
BEGIN;

/* Invoke the previously created functions with sample data */
SELECT InsertUser('John', 'Doe', 'john.doe@example.com', 'password123', 1);
SELECT RegisterForEvent(1, 2, '2023-11-15');
SELECT * FROM GetUserGradesForClass(3, 1);
SELECT UpdateUserPassword(4, 'newpassword456');
SELECT ResolveSecurityIncident(5);

/* Commit the transaction */
COMMIT;

/* Begin a new transaction */
BEGIN;

/* Create a function to send a message with an unread indicator */
CREATE OR REPLACE FUNCTION SendMessage(
    in_sender_id INT,
    in_receiver_id INT,
    in_message_content TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO Messages(sender_id, receiver_id, message_content, is_read)
    VALUES (in_sender_id, in_receiver_id, in_message_content, FALSE);
END;
$$ LANGUAGE plpgsql;

/* Create a function to assign a grade, checking for assignment existence and due date */
CREATE OR REPLACE FUNCTION AssignGrade(
    in_assignment_id INT,
    in_student_id INT,
    in_score DECIMAL(5,2)
) RETURNS VOID AS $$
DECLARE
    assignment_due_date DATE;
BEGIN
    /* Check if the assignment exists */
    SELECT due_date INTO assignment_due_date FROM Assignments WHERE assignment_id = in_assignment_id;
    IF assignment_due_date IS NULL THEN
        RAISE EXCEPTION 'Assignment does not exist.';
    END IF;

    /* Check if the assignment due date has passed */
    IF assignment_due_date < CURRENT_DATE THEN
        RAISE EXCEPTION 'Cannot assign grade for past-due assignment.';
    END IF;

    /* Assign the grade */
    INSERT INTO Grades(assignment_id, student_id, score)
    VALUES (in_assignment_id, in_student_id, in_score);
END;
$$ LANGUAGE plpgsql;

/* Create a function to report a security incident and notify the admin */
CREATE OR REPLACE FUNCTION ReportSecurityIncident(
    in_reporter_id INT,
    in_incident_details TEXT
) RETURNS VOID AS $$
DECLARE
    admin_email VARCHAR(100);
BEGIN
    /* Get admin email for notification */
    SELECT email_address INTO admin_email
    FROM Users
    WHERE role_id = (SELECT role_id FROM Roles WHERE role_name = 'Admin')
    LIMIT 1;

    /* Insert security incident */
    INSERT INTO Security_Incidents(reporter_id, incident_details)
    VALUES (in_reporter_id, in_incident_details);

    /* Notify admin via email (example) */
    PERFORM pg_notify('admin_notification_channel', 'Security incident reported');
END;
$$ LANGUAGE plpgsql;

/* Commit the transaction */
COMMIT;

/* Begin a new transaction */
BEGIN;

/* Invoke the newly created functions with sample data */
SELECT SendMessage(2, 3, 'Hello, how are you?'); /* Assuming user_id 2 is the sender and user_id 3 is the receiver */
SELECT AssignGrade(1, 4, 95.5); /* Assuming assignment_id 1 exists, student_id 4 exists, and the due date has not passed */
SELECT ReportSecurityIncident(6, 'Unauthorized access attempt'); /* Assuming user_id 6 reported a security incident */

/* Commit the transaction */
COMMIT;

/* Begin a new transaction */
BEGIN;

/* Create a trigger function to update the 'updated_at' field for Users on each update */
CREATE OR REPLACE FUNCTION update_users_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/* Create a trigger for Users that invokes the update_users_updated_at function before each update */
CREATE TRIGGER users_updated_at_trigger
BEFORE UPDATE ON Users
FOR EACH ROW
EXECUTE FUNCTION update_users_updated_at();

/* Create a trigger function to prevent future event registrations */
CREATE OR REPLACE FUNCTION prevent_future_registrations()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.registration_date > CURRENT_DATE THEN
        RAISE EXCEPTION 'Cannot register for future events.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/* Create a trigger for Event_Registrations that invokes the prevent_future_registrations function before each insert */
CREATE TRIGGER prevent_future_registrations_trigger
BEFORE INSERT ON Event_Registrations
FOR EACH ROW
EXECUTE FUNCTION prevent_future_registrations();

/* Create a trigger function to set the 'is_read' field to FALSE for new messages */
CREATE OR REPLACE FUNCTION set_unread_message()
RETURNS TRIGGER AS $$
BEGIN
    NEW.is_read = FALSE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/* Create a trigger for Messages that invokes the set_unread_message function before each insert */
CREATE TRIGGER set_unread_message_trigger
BEFORE INSERT ON Messages
FOR EACH ROW
EXECUTE FUNCTION set_unread_message();

/* Create a trigger function to prevent setting a past due date for assignments */
CREATE OR REPLACE FUNCTION prevent_past_due_date()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.due_date < CURRENT_DATE THEN
        RAISE EXCEPTION 'Due date cannot be in the past.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/* Create a trigger for Assignments that invokes the prevent_past_due_date function before each insert */
CREATE TRIGGER prevent_past_due_date_trigger
BEFORE INSERT ON Assignments
FOR EACH ROW
EXECUTE FUNCTION prevent_past_due_date();

/* Create a trigger function to update 'updated_at' for resolved security incidents */
CREATE OR REPLACE FUNCTION update_security_incident_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.report_status = 'Resolved' THEN
        NEW.updated_at = CURRENT_TIMESTAMP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/* Create a trigger for Security_Incidents that invokes the update_security_incident_status function before each update */
CREATE TRIGGER update_security_incident_status_trigger
BEFORE UPDATE ON Security_Incidents
FOR EACH ROW
EXECUTE FUNCTION update_security_incident_status();

/* Create a trigger function to prevent duplicate classes with the same name and teacher */
CREATE OR REPLACE FUNCTION prevent_duplicate_classes()
RETURNS TRIGGER AS $$
DECLARE
    existing_class_id INT;
BEGIN
    SELECT class_id INTO existing_class_id
    FROM Classes
    WHERE class_name = NEW.class_name AND teacher_id = NEW.teacher_id;

    IF existing_class_id IS NOT NULL THEN
        RAISE EXCEPTION 'Duplicate class name for the same teacher.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/* Create a trigger for Classes that invokes the prevent_duplicate_classes function before each insert */
CREATE TRIGGER prevent_duplicate_classes_trigger
BEFORE INSERT ON Classes
FOR EACH ROW
EXECUTE FUNCTION prevent_duplicate_classes();

/* Create a trigger function to validate the grade score range */
CREATE OR REPLACE FUNCTION validate_grade_score_range()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.score < 0 OR NEW.score > 100 THEN
        RAISE EXCEPTION 'Invalid grade score. Must be between 0 and 100.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/* Create a trigger for Grades that invokes the validate_grade_score_range function before each insert or update */
CREATE TRIGGER validate_grade_score_range_trigger
BEFORE INSERT OR UPDATE ON Grades
FOR EACH ROW
EXECUTE FUNCTION validate_grade_score_range();

/* Commit the transaction */
COMMIT;

/* Begin a new transaction */
BEGIN;

/* Sample queries using the defined triggers */
SELECT * FROM Users WHERE role_id = (SELECT role_id FROM Roles WHERE role_name = 'Student');

SELECT first_name, last_name, email_address FROM Users;

SELECT user_id FROM Event_Registrations
UNION
SELECT student_id FROM Grades;

SELECT organizer_id FROM Events
INTERSECT
SELECT reporter_id FROM Security_Incidents;

SELECT user_id FROM Users
EXCEPT
SELECT user_id FROM Event_Registrations;

SELECT Users.user_id, Events.organizer_id
FROM Users, Events
WHERE Users.user_id = Events.organizer_id;

SELECT Assignments.assignment_id, title, score
FROM Assignments
JOIN Grades ON Assignments.assignment_id = Grades.assignment_id;

/* Uncommented query - uncomment based on your requirements */
/*SELECT user_id AS participant_id, sender_id, receiver_id, message_content
FROM Messages;*/

/* Commit the transaction */
COMMIT;

/* Begin a new transaction */
BEGIN;

/* Select users with the role of 'Student' who have registered for events */
SELECT first_name, last_name, email_address
FROM Users
WHERE role_id = (SELECT role_id FROM Roles WHERE role_name = 'Student')
AND user_id IN (SELECT user_id FROM Event_Registrations);

/* Select class IDs where there are no students (with the role of 'Student') who have not enrolled in the class */
SELECT class_id
FROM Classes
WHERE NOT EXISTS (
    SELECT user_id
    FROM Users
    WHERE role_id = (SELECT role_id FROM Roles WHERE role_name = 'Student')
    EXCEPT
    SELECT class_id
    FROM Classes
    WHERE Classes.class_id = class_id
);

/* Select assignment IDs and their average scores */
SELECT assignment_id, AVG(score) AS average_score
FROM Grades
GROUP BY assignment_id;

/* Select the reporter ID and the count of security incidents reported, filtering by specific reporter IDs */
SELECT reporter_id, COUNT(security_id) AS incidents_reported
FROM Security_Incidents
GROUP BY reporter_id
HAVING reporter_id IN (SELECT reporter_id FROM Security_Incidents);

/* Select distinct user pairs based on user IDs and last names */
SELECT DISTINCT u1.user_id AS user1, u1.last_name, u2.user_id AS user2
FROM Users u1, Users u2
WHERE u1.user_id < u2.user_id AND u1.last_name = u2.last_name;

/* Select user details, role, and organizer rank based on event count */
SELECT user_id, role_id, first_name, last_name, email_address,
       RANK() OVER (ORDER BY COUNT(event_id) DESC) AS organizer_rank
FROM Users
LEFT JOIN Events ON Users.user_id = Events.organizer_id
GROUP BY user_id, role_id, first_name, last_name, email_address;

/* Commit the transaction */
COMMIT;

/*
    Selection (σ) and Projection (π):
        Query: SELECT * FROM Users WHERE role_id = (SELECT role_id FROM Roles WHERE role_name = 'Student');
        Relational Algebra: σ(role_id = (σ(role_name = 'Student')(Roles))) (Selection followed by Projection)

    Projection (π):
        Query: SELECT first_name, last_name, email_address FROM Users;
        Relational Algebra: π(first_name, last_name, email_address)(Users)

    Union (⋃) and Projection (π):
        Query: SELECT user_id FROM Event_Registrations UNION SELECT student_id FROM Grades;
        Relational Algebra: π(user_id)((σ(role_name = 'Student')(Users)) ⋃ (σ(role_name = 'Student')(Grades)))

    Intersection (∩):
        Query: SELECT organizer_id FROM Events INTERSECT SELECT reporter_id FROM Security_Incidents;
        Relational Algebra: π(organizer_id)(Events) ∩ π(reporter_id)(Security_Incidents)

    Set Difference (-) and Projection (π):
        Query: SELECT user_id FROM Users EXCEPT SELECT user_id FROM Event_Registrations;
        Relational Algebra: π(user_id)(Users) - π(user_id)(Event_Registrations)

    Equijoin (⨝):
        Query: SELECT Users.user_id, Events.organizer_id FROM Users, Events WHERE Users.user_id = Events.organizer_id;
        Relational Algebra: Users ⨝(user_id = organizer_id) Events

    Natural Join (⨝):
        Query: SELECT Assignments.assignment_id, title, score FROM Assignments JOIN Grades ON Assignments.assignment_id = Grades.assignment_id;
        Relational Algebra: Assignments ⨝(assignment_id = assignment_id) Grades

    Group By (γ), Aggregate Function (AVG), and Projection (π):
        Query: SELECT assignment_id, AVG(score) AS average_score FROM Grades GROUP BY assignment_id;
        Relational Algebra: π(assignment_id, AVG(score))(γ(assignment_id, AVG(score))(Grades))

    Group By (γ), Aggregate Function (COUNT), and Projection (π):
        Query: SELECT reporter_id, COUNT(security_id) AS incidents_reported FROM Security_Incidents GROUP BY reporter_id;
        Relational Algebra: π(reporter_id, COUNT(security_id))(γ(reporter_id, COUNT(security_id))(Security_Incidents))

    Distinct and Cartesian Product (×):

    Query: SELECT DISTINCT u1.user_id AS user1, u1.last_name, u2.user_id AS user2 FROM Users u1, Users u2 WHERE u1.user_id < u2.user_id AND u1.last_name = u2.last_name;
    Relational Algebra: π(user1, last_name, user2)((Users × Users) - π(user1, last_name, user2)((σ(user1 < user2 AND last_name = last_name)(Users × Users))))

    Window Function (RANK) and Projection (π):

    Query: SELECT user_id, role_id, first_name, last_name, email_address, RANK() OVER (ORDER BY COUNT(event_id) DESC) AS organizer_rank FROM Users LEFT JOIN Events ON Users.user_id = Events.organizer_id GROUP BY user_id, role_id, first_name, last_name, email_address;
    Relational Algebra: π(user_id, role_id, first_name, last_name, email_address, RANK() OVER (ORDER BY COUNT(event_id) DESC))(Users ⨝(user_id = organizer_id) Events)
*/