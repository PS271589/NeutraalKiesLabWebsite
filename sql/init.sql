CREATE DATABASE stemwijzer;

USE stemwijzer;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
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