USE stemwijzer;

-- USERS
INSERT INTO users (name, email, role) VALUES
('Jan Jansen', 'jan@example.com', 'user'),
('Emma de Vries', 'emma@example.com', 'user'),
('Noah Bakker', 'noah@example.com', 'user'),
('Lisa Visser', 'lisa@example.com', 'admin'),
('Milan Smit', 'milan@example.com', 'user');

-- ELECTIONS
INSERT INTO elections (name, date, description) VALUES
(
    'Tweede Kamerverkiezingen 2026',
    '2026-03-15 09:00:00',
    'Landelijke verkiezingen voor de Tweede Kamer.'
),
(
    'Gemeenteraadsverkiezingen Eindhoven 2026',
    '2026-05-20 09:00:00',
    'Gemeenteraadsverkiezingen voor Eindhoven.'
);

-- PARTIES
INSERT INTO parties (name, description) VALUES
(
    'Progressief Nederland',
    'Focus op klimaat, onderwijs en innovatie.'
),
(
    'Vrije Burgers Partij',
    'Focus op lagere belastingen en ondernemers.'
),
(
    'Groene Toekomst',
    'Milieu en duurzaamheid staan centraal.'
),
(
    'Sociaal Collectief',
    'Sterke nadruk op sociale zekerheid.'
);

-- QUESTIONNAIRES
INSERT INTO questionnaires (election_id, title) VALUES
(1, 'Stemwijzer Tweede Kamer 2026'),
(2, 'Stemwijzer Eindhoven 2026');

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
INSERT INTO election_parties (election_id, party_id, position) VALUES
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
(1, 1, 1),
(1, 2, -1),
(1, 3, 1),
(1, 4, -1),
(1, 5, 1),

-- Vrije Burgers Partij
(2, 1, -1),
(2, 2, 1),
(2, 3, -1),
(2, 4, 1),
(2, 5, -1),

-- Groene Toekomst
(3, 1, 1),
(3, 2, -1),
(3, 3, 0),
(3, 4, -1),
(3, 5, 1),

-- Sociaal Collectief
(4, 1, 1),
(4, 2, 0),
(4, 3, 1),
(4, 4, 0),
(4, 5, 1);

-- USER_ANSWERS
INSERT INTO user_answers (user_id, question_id, answer) VALUES
-- Jan
(1, 1, 1),
(1, 2, -1),
(1, 3, 1),
(1, 4, 0),
(1, 5, 1),

-- Emma
(2, 1, 1),
(2, 2, 0),
(2, 3, 1),
(2, 4, -1),
(2, 5, 1),

-- Noah
(3, 1, -1),
(3, 2, 1),
(3, 3, -1),
(3, 4, 1),
(3, 5, 0),

-- Lisa
(4, 1, 1),
(4, 2, -1),
(4, 3, 1),
(4, 4, -1),
(4, 5, 1),

-- Milan
(5, 1, 0),
(5, 2, 1),
(5, 3, 0),
(5, 4, 1),
(5, 5, -1);