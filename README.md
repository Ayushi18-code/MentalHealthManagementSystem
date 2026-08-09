# Mental Health Management System

A web-based Mental Health Management System developed to provide students with
accessible mental health support and online counseling services.

## 📌 Project Overview

ManSparsh is a role-based web application that allows students to access
mental health resources, book counseling appointments, attend workshops,
request emergency assistance, and communicate with counselors.

The system also provides separate modules for counselors, faculty, and
administrators to manage appointments, workshops, referrals, and users.

## 🚀 Features

- Student registration and login
- Role-based authentication
- Student profile management
- Online counseling appointment booking
- Appointment history and status tracking
- Counselor timetable management
- Workshops and mental health resources
- Emergency assistance module
- Counselor session notes
- Referral of cases from counselor to faculty
- Feedback and rating system
- Faculty and counselor management
- Admin management module
- Rule-based chatbot integration using Botpress
- Session-based authentication and logout
- Password security using BCrypt

## 👥 User Roles

The system contains four major roles:

1. Student
2. Counselor
3. Faculty
4. Administrator

Each role has access to different functionalities according to its
responsibilities.

## 🛠️ Technologies Used

### Frontend
- HTML
- CSS
- JavaScript
- JSP

### Backend
- Java
- JavaServer Pages (JSP)
- JDBC

### Database
- Apache Derby
- SQL

### Server
- GlassFish Server

### Tools
- NetBeans IDE
- Git
- GitHub

### Other Technologies
- Botpress – Chatbot Integration
- jBCrypt – Password Hashing
- JavaMail – Email/OTP functionality

## 🗄️ Database

The application uses **Apache Derby** as the relational database.

The database schema is provided in:

`database_schema.sql`

The schema contains tables for students, administrators, counselors,
faculty, appointments, workshops, feedback, counselor timetables,
session notes, and referred cases.

## 🏗️ System Architecture

The application follows a web-based architecture:

User
↓
HTML / CSS / JavaScript / JSP
↓
Java + JDBC
↓
Apache Derby Database

The application is hosted and executed using GlassFish Server.

## 🔐 Security Features

- Role-based access control
- Session-based authentication
- Password hashing using BCrypt
- OTP/email-based verification
- Login session validation
- Cache prevention for authenticated pages
- PreparedStatement used for database queries

## 🤖 Chatbot Integration

A rule-based mental health support chatbot is integrated using Botpress.

The chatbot provides basic guidance and directs users toward appropriate
resources such as counseling appointments and mental health support options.

## 📂 Project Structure

```text
MentalHealthManagementSystem/
│
├── src/
│   └── Java source files
│
├── web/
│   ├── JSP pages
│   ├── CSS
│   ├── JavaScript
│   └── Images
│
├── nbproject/
│   └── NetBeans project configuration
│
├── database_schema.sql
├── build.xml
├── README.md
└── .gitignore
