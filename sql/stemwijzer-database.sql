CREATE DATABASE stemwijzer;

USE stemwijzer;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE elections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    date TIMESTAMP NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE parties (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE questionnaires (
    id INT AUTO_INCREMENT PRIMARY KEY,
    election_id INT NOT NULL,
    title VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_questionnaires_election
        FOREIGN KEY (election_id)
        REFERENCES elections(id)
        ON DELETE CASCADE
);

CREATE TABLE questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    questionnaire_id INT NOT NULL,
    question VARCHAR(255) NOT NULL,
    weight INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_questions_questionnaire
        FOREIGN KEY (questionnaire_id)
        REFERENCES questionnaires(id)
        ON DELETE CASCADE
);

CREATE TABLE election_parties (
    election_id INT NOT NULL,
    party_id INT NOT NULL,
    position INT NOT NULL,

    PRIMARY KEY (election_id, party_id),

    CONSTRAINT fk_election_parties_election
        FOREIGN KEY (election_id)
        REFERENCES elections(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_election_parties_party
        FOREIGN KEY (party_id)
        REFERENCES parties(id)
        ON DELETE CASCADE
);

CREATE TABLE user_answers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    question_id INT NOT NULL,
    answer INT NOT NULL,

    UNIQUE (user_id, question_id),

    CONSTRAINT fk_user_answers_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_user_answers_question
        FOREIGN KEY (question_id)
        REFERENCES questions(id)
        ON DELETE CASCADE
);

CREATE TABLE party_answers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    party_id INT NOT NULL,
    question_id INT NOT NULL,
    answer INT NOT NULL,

    UNIQUE (party_id, question_id),

    CONSTRAINT fk_party_answers_party
        FOREIGN KEY (party_id)
        REFERENCES parties(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_party_answers_question
        FOREIGN KEY (question_id)
        REFERENCES questions(id)
        ON DELETE CASCADE
);

-- USERS 
INSERT INTO users (name, email, password, role) VALUES
(
    'Jan Jansen',
    'jan@example.com',
    '$2y$10$8J6rN3pR4qB5K7cM9xA8Se6xkP1mF7uQ9vD3hT2yW1zL4nR5sC8uG',
    'user'
),
(
    'Emma de Vries',
    'emma@example.com',
    '$2y$10$8J6rN3pR4qB5K7cM9xA8Se6xkP1mF7uQ9vD3hT2yW1zL4nR5sC8uG',
    'user'
),
(
    'Noah Bakker',
    'noah@example.com',
    '$2y$10$8J6rN3pR4qB5K7cM9xA8Se6xkP1mF7uQ9vD3hT2yW1zL4nR5sC8uG',
    'user'
),
(
    'Lisa Visser',
    'lisa@example.com',
    '$2y$10$8J6rN3pR4qB5K7cM9xA8Se6xkP1mF7uQ9vD3hT2yW1zL4nR5sC8uG',
    'admin'
),
(
    'Milan Smit',
    'milan@example.com',
    '$2y$10$8J6rN3pR4qB5K7cM9xA8Se6xkP1mF7uQ9vD3hT2yW1zL4nR5sC8uG',
    'user'
);

-- ELECTIONS 
INSERT INTO elections (name, date, description) VALUES 
( 'Tweede Kamerverkiezingen 2026', '2026-03-15 09:00:00', 'Landelijke verkiezingen voor de Tweede Kamer.' ), 
( 'Gemeenteraadsverkiezingen Eindhoven 2026', '2026-05-20 09:00:00', 'Gemeenteraadsverkiezingen voor Eindhoven.' ); 

-- PARTIES 
INSERT INTO parties (name, description) VALUES 
( 'Progressief Nederland', 'Focus op klimaat, onderwijs en innovatie.' ), 
( 'Vrije Burgers Partij', 'Focus op lagere belastingen en ondernemers.' ), 
( 'Groene Toekomst', 'Milieu en duurzaamheid staan centraal.' ), 
( 'Sociaal Collectief', 'Sterke nadruk op sociale zekerheid.' ); 

-- QUESTIONNAIRES 
INSERT INTO questionnaires (election_id, title) VALUES 
(1, 'Stemwijzer Tweede Kamer 2026'), (2, 'Stemwijzer Eindhoven 2026'); 

-- QUESTIONS 
INSERT INTO questions (questionnaire_id, question, weight) VALUES 
(1, 'De overheid moet meer investeren in duurzame energie.', 2), 
(1, 'De maximumsnelheid op snelwegen moet omhoog.', 1), 
(1, 'Studiefinanciering moet worden verhoogd.', 2), 
(1, 'Er moeten strengere immigratieregels komen.', 3), 
(1, 'Openbaar vervoer moet goedkoper worden.', 2), 
(2, 'Eindhoven moet meer fietspaden aanleggen.', 2), 
(2, 'Er moeten meer betaalbare woningen komen.', 3), 
(2, 'De binnenstad moet autoluw worden.', 2), 
(2, 'De gemeente moet meer investeren in cultuur.', 1), 
(2, 'Nachtbussen moeten vaker rijden.', 1); 

-- ELECTION_PARTIES 
INSERT INTO election_parties 
(election_id, party_id, position) VALUES 
(1, 1, 1), 
(1, 2, 2), 
(1, 3, 3), 
(1, 4, 4), 
(2, 1, 1), 
(2, 3, 2), 
(2, 4, 3); 

-- PARTY_ANSWERS 
INSERT INTO party_answers (party_id, question_id, answer) VALUES 
-- Progressief Nederland 
(1, 1, 2), 
(1, 2, 0), 
(1, 3, 2), 
(1, 4, 0), 
(1, 5, 2), 
-- Vrije Burgers Partij 
(2, 1, 0), 
(2, 2, 2), 
(2, 3, 0), 
(2, 4, 2), 
(2, 5, 0), 
-- Groene Toekomst 
(3, 1, 2), 
(3, 2, 0), 
(3, 3, 1), 
(3, 4, 0), 
(3, 5, 2), 
-- Sociaal Collectief 
(4, 1, 2), 
(4, 2, 1), 
(4, 3, 2), 
(4, 4, 1), 
(4, 5, 2); 
-- USER_ANSWERS 
INSERT INTO user_answers (user_id, question_id, answer) VALUES 
-- Jan 
(1, 1, 2), 
(1, 2, 0), 
(1, 3, 2), 
(1, 4, 1), 
(1, 5, 2), 
-- Emma 
(2, 1, 2), 
(2, 2, 1), 
(2, 3, 2), 
(2, 4, 0), 
(2, 5, 2), 
-- Noah 
(3, 1, 0), 
(3, 2, 2), 
(3, 3, 0), 
(3, 4, 2), 
(3, 5, 1), 
-- Lisa 
(4, 1, 2), 
(4, 2, 0), 
(4, 3, 2), 
(4, 4, 0), 
(4, 5, 2), 
-- Milan 
(5, 1, 1), 
(5, 2, 2), 
(5, 3, 1), 
(5, 4, 2), 
(5, 5, 0);

ALTER TABLE parties
ADD COLUMN abbreviation VARCHAR(10) NOT NULL,
ADD COLUMN color_hex VARCHAR(7) NOT NULL DEFAULT '#FF6B00';