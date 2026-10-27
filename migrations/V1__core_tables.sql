-- V1: Core table and sample rows for the lab.
CREATE TABLE students (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE
);

INSERT INTO students (name, email) VALUES
    ('Ama K.', 'ama@example.com'),
    ('Kojo A.', 'kojo@example.com'),
    ('Esi B.', 'esi@example.com');
