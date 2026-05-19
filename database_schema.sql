CREATE TABLE student (
    student_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    email VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    password VARCHAR(200) NOT NULL,
    created_by VARCHAR(50) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dob DATE,
    smart_card_id VARCHAR(50),
    phone VARCHAR(20),
    hostel VARCHAR(100),
    PRIMARY KEY (student_id)
);

CREATE TABLE admin (
    admin_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    email VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    password VARCHAR(200) NOT NULL,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (admin_id)
);
 
CREATE TABLE counselor (
    counselor_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(200) NOT NULL,
    specialization VARCHAR(100),   -- anxiety, depression, academic stress etc.
    status VARCHAR(20) DEFAULT 'ACTIVE',  
    -- ACTIVE | INACTIVE | SUSPENDED
    
    created_by VARCHAR(50) NOT NULL,   -- which admin created this counselor
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (counselor_id)
);

CREATE TABLE HOSTEL (
    ID INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    HOSTEL_NAME VARCHAR(200),
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE faculty (
    faculty_id INT GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(200) NOT NULL,
    specialization VARCHAR(100),   -- psychiatry, clinical psychology, trauma etc.
    status VARCHAR(20) DEFAULT 'ACTIVE',  -- ACTIVE | INACTIVE | SUSPENDED
    created_by VARCHAR(50) NOT NULL,   -- admin who added this faculty
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (faculty_id)
);

CREATE TABLE appointment (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INT NOT NULL,
    counselor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    time_slot VARCHAR(50) NOT NULL,
    preferred_mode VARCHAR(50),
    chief_concern VARCHAR(100),
    status VARCHAR(30) DEFAULT 'SCHEDULED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    meeting_link VARCHAR(500),
    CONSTRAINT fk_student
        FOREIGN KEY (student_id)
        REFERENCES student(student_id),
    CONSTRAINT fk_counselor
        FOREIGN KEY (counselor_id)
        REFERENCES counselor(counselor_id),
    CONSTRAINT unique_booking
        UNIQUE (counselor_id, appointment_date, time_slot)
);

ALTER TABLE appointment DROP CONSTRAINT unique_booking;

ALTER TABLE STUDENT ADD block_until DATE;

UPDATE student
SET block_until = NULL
WHERE student_id = 101;
delete from appointment where 


CREATE TABLE WORKSHOP ( 
workshop_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
title VARCHAR(150) NOT NULL, 
workshop_date DATE NOT NULL, 
workshop_time VARCHAR(20) NOT NULL, 
venue VARCHAR(150) NOT NULL, 
posted_by_role VARCHAR(30) CHECK (posted_by_role IN ('FACULTY', 'COUNSELLOR')) NOT NULL, 
posted_by_id INT NOT NULL, 
status VARCHAR(30) DEFAULT 'ACTIVE', 
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
template_image BLOB
);

UPDATE WORKSHOP 
SET status='INACTIVE' 
WHERE status='ACTIVE'
AND workshop_date < CURRENT_DATE
OR (workshop_date = CURRENT_DATE AND CAST(workshop_time AS TIME) < CURRENT_TIME)

CREATE TABLE FEEDBACK (
    feedback_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT NOT NULL,              -- student_id OR counselor_id OR faculty_id
    user_role VARCHAR(20) NOT NULL,    -- STUDENT | COUNSELOR | FACULTY
    user_name VARCHAR(100) NOT NULL,
    user_email VARCHAR(100) NOT NULL,
    message VARCHAR(1000) NOT NULL,    -- actual feedback
    IS_VISIBLE INT DEFAULT 1,
    rating INT CHECK (rating BETWEEN 1 AND 5),   -- optional star rating
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE counselor_timetable (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    counselor_id INT NOT NULL,
    day VARCHAR(10) NOT NULL,
    time_slot VARCHAR(20) NOT NULL,

    CONSTRAINT fk_counselor_tt
      FOREIGN KEY (counselor_id)
      REFERENCES counselor(counselor_id)
);

CREATE TABLE SESSION_NOTES (
    note_id INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    appointment_id INT NOT NULL UNIQUE,
    counselor_id INT,

    problematic_behavior VARCHAR(2000),
targeted_Behavior VARCHAR(2000),
    intervention VARCHAR(2000),
    response VARCHAR(2000),
    plan VARCHAR(2000),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (note_id)
);

CREATE TABLE referred_cases (
    referral_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    appointment_id INT NOT NULL,
    student_id INT NOT NULL,
    counselor_id INT NOT NULL,
    faculty_id INT NOT NULL,
    chief_concern VARCHAR(100),
   
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (appointment_id)
        REFERENCES appointment(id),

    FOREIGN KEY (student_id)
        REFERENCES student(student_id),

    FOREIGN KEY (counselor_id)
        REFERENCES counselor(counselor_id),

    FOREIGN KEY (faculty_id)
        REFERENCES faculty(faculty_id)

);

ALTER TABLE appointment ADD student_joined BOOLEAN DEFAULT FALSE;
ALTER TABLE appointment ADD counselor_joined BOOLEAN DEFAULT FALSE; 


ALTER TABLE appointment ADD meeting_start_time TIMESTAMP;
