CREATE DATABASE IF NOT EXISTS stemwijzer;
USE stemwijzer;

-- --------------------------------------------------------
-- TABELLEN
-- --------------------------------------------------------

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    birthdate DATE DEFAULT NULL,
    city VARCHAR(100) DEFAULT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    username VARCHAR(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE elections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active TINYINT(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE parties (
    id INT AUTO_INCREMENT PRIMARY KEY,
    abbreviation VARCHAR(10) NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(600),
    color_hex VARCHAR(7) NOT NULL DEFAULT '#FF6B00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE questionnaires (
    id INT AUTO_INCREMENT PRIMARY KEY,
    election_id INT NOT NULL,
    title VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_questionnaires_election
        FOREIGN KEY (election_id)
        REFERENCES elections(id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question VARCHAR(255) NOT NULL,
    weight INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category VARCHAR(100) DEFAULT NULL,
    description TEXT DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE questionnaire_questions (
    questionnaire_id INT NOT NULL,
    question_id INT NOT NULL,

    PRIMARY KEY (questionnaire_id, question_id),

    CONSTRAINT fk_qq_questionnaire
        FOREIGN KEY (questionnaire_id)
        REFERENCES questionnaires(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_qq_question
        FOREIGN KEY (question_id)
        REFERENCES questions(id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE party_answers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    party_id INT NOT NULL,
    question_id INT NOT NULL,
    answer INT NOT NULL,
    explanation TEXT DEFAULT NULL,

    UNIQUE (party_id, question_id),

    CONSTRAINT fk_party_answers_party
        FOREIGN KEY (party_id)
        REFERENCES parties(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_party_answers_question
        FOREIGN KEY (question_id)
        REFERENCES questions(id)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- DATA INVOEREN
-- --------------------------------------------------------

-- USERS
INSERT INTO users (id, name, email, birthdate, city, password, role, username) VALUES
(1, 'Jan Jansen',      'jan@example.com',   '1995-05-15', 'Amsterdam', '$2y$10$8J6rN3pR4qB5K7cM9xA8Se6xkP1mF7uQ9vD3hT2yW1zL4nR5sC8uG', 'user',  'janjansen'),
(2, 'Emma de Vries',   'emma@example.com',  '1998-10-22', 'Eindhoven', '$2y$10$8J6rN3pR4qB5K7cM9xA8Se6xkP1mF7uQ9vD3hT2yW1zL4nR5sC8uG', 'user',  'emmadevries'),
(3, 'Noah Bakker',     'noah@example.com',  '1992-03-08', 'Rotterdam', '$2y$10$8J6rN3pR4qB5K7cM9xA8Se6xkP1mF7uQ9vD3hT2yW1zL4nR5sC8uG', 'user',  'noahbakker'),
(4, 'Lisa Visser',     'lisa@example.com',  '1990-12-01', 'Utrecht',   '$2y$10$8J6rN3pR4qB5K7cM9xA8Se6xkP1mF7uQ9vD3hT2yW1zL4nR5sC8uG', 'admin', 'lisavisser'),
(5, 'Milan Smit',      'milan@example.com', '2000-07-30', 'Tilburg',   '$2y$10$8J6rN3pR4qB5K7cM9xA8Se6xkP1mF7uQ9vD3hT2yW1zL4nR5sC8uG', 'user',  'milansmit');

-- ELECTIONS
INSERT INTO elections (id, name, date, description, created_at, is_active) VALUES
(1, 'Tweede Kamerverkiezingen 2026', '2026-06-16 09:24:11', 'Landelijke verkiezingen voor de Tweede Kamer.', '2026-06-12 08:46:22', 1),
(2, 'Gemeenteraadsverkiezingen Eindhoven 2026', '2026-06-16 09:24:11', 'Gemeenteraadsverkiezingen voor Eindhoven.', '2026-06-12 08:46:22', 0);

-- PARTIES
INSERT INTO parties (id, abbreviation, name, description, color_hex) VALUES
(1, 'PN',  'Progressief Nederland', 'Progressief Nederland gelooft in een eerlijke en duurzame samenleving voor iedereen. Wij zetten in op forse investeringen in hernieuwbare energie, hoogwaardig onderwijs en gelijke kansen van wieg tot werk.', '#E6B04D'),
(2, 'VBP', 'Vrije Burgers Partij', 'De Vrije Burgers Partij staat voor een kleinere overheid, lagere lasten en meer ruimte voor de eigen keuze van de burger. Ondernemers vormen de motor van onze economie.', '#F97316'),
(3, 'GT',  'Groene Toekomst', 'Groene Toekomst plaatst milieu, natuur en duurzaamheid centraal in elk beleidsterrein. Wij pleiten voor een radicale transitie naar een circulaire economie.', '#22C55E'),
(4, 'SC',  'Sociaal Collectief', 'Het Sociaal Collectief staat op voor mensen die het zelf niet redden. Wij willen een sterk sociaal vangnet, betaalbare huurwoningen in elke wijk en toegankelijke zorg.', '#EF4444'),
(5, 'CDV', 'Christen Democratisch Verbond', 'Het Christen Democratisch Verbond verbindt christelijke waarden met daadkrachtig bestuur. Wij geloven in de kracht van gemeenschap, het belang van het gezin.', '#2563EB'),
(6, 'LD',  'Liberaal Democraten', 'De Liberaal Democraten combineren persoonlijke vrijheid met een sterk geloof in onderwijs, rechtsstaat en Europese samenwerking.', '#06B6D4'),
(7, 'NB',  'Nationaal Belang', 'Nationaal Belang stelt de Nederlandse burger voorop. Wij pleiten voor strikte controle over onze grenzen en een forse reductie van de instroom van asielzoekers.', '#1F2937'),
(8, 'DNP', 'Dieren & Natuur Partij', 'De Dieren & Natuur Partij geeft een stem aan wie zichzelf niet kan verdedigen: dieren, natuur en toekomstige generaties. Wij willen een einde aan de bio-industrie.', '#84CC16');

-- QUESTIONNAIRES
INSERT INTO questionnaires (id, election_id, title, created_at) VALUES
(1, 1, 'Stemwijzer Tweede Kamer 2026', '2026-06-12 08:46:22'),
(2, 2, 'Stemwijzer Eindhoven 2026', '2026-06-12 08:46:22');

-- QUESTIONS
INSERT INTO questions (id, question, weight, created_at, category, description) VALUES
(1, 'De overheid moet meer investeren in duurzame energie.', 2, '2026-06-12 08:46:22', 'Klimaat', 'Investeren in duurzame energiebronnen om de CO2-uitstoot te verminderen.'),
(2, 'De maximumsnelheid op snelwegen moet omhoog.', 1, '2026-06-12 08:46:22', 'Mobiliteit', 'Het verhogen van de snelheid op snelwegen voor betere doorstroming.'),
(3, 'Studiefinanciering moet worden verhoogd.', 2, '2026-06-12 08:46:22', 'Onderwijs', 'Verhogen van de maandelijkse toelage voor studenten ter ondersteuning van hun studie.'),
(4, 'Er moeten strengere immigratieregels komen.', 3, '2026-06-12 08:46:22', 'Samenleving', 'Strengere toelatingseisen voor nieuwkomers om integratie te waarborgen.'),
(5, 'Openbaar vervoer moet goedkoper worden.', 2, '2026-06-12 08:46:22', 'Mobiliteit', 'Betaalbaar openbaar vervoer door middel van gerichte subsidies.'),
(6, 'De belasting op hoge inkomens moet omhoog.', 2, '2026-06-12 08:46:22', 'Financiën', 'Hogere marginale belasting voor de hoogste inkomensgroepen.'),
(7, 'Nederland moet meer geld uitgeven aan defensie.', 2, '2026-06-12 08:46:22', 'Defensie', 'Verhoging van het defensiebudget om aan NAVO-normen te voldoen.'),
(8, 'Er moet een landelijk minimumloon van minstens 16 euro per uur komen.', 3, '2026-06-12 08:46:22', 'Arbeidsmarkt', 'Wettelijk minimumloon verhogen voor een eerlijk bestaansminimum.'),
(9, 'Kernenergie moet een grotere rol krijgen in de energievoorziening.', 2, '2026-06-12 08:46:22', 'Energie', 'Inzet van kerncentrales als stabiele en CO2-arme energiebron.'),
(10, 'Zorgverzekeringen moeten volledig publiek worden geregeld.', 3, '2026-06-12 08:46:22', 'Zorg', 'Nationalisering van de zorgverzekeringsmarkt voor gelijke toegang.'),
(11, 'Nederland moet meer vluchtelingen opnemen.', 2, '2026-06-12 08:46:22', 'Samenleving', 'Verruiming van de opvangcapaciteit voor asielzoekers ien vluchtelingen.'),
(12, 'Er moet strenger worden opgetreden tegen zware criminaliteit.', 2, '2026-06-12 08:46:22', 'Veiligheid', 'Zwaardere straffen en meer capaciteit bij politie en justitie.'),
(13, 'De overheid moet huren sterker reguleren.', 3, '2026-06-12 08:46:22', 'Wonen', 'Huurprijsbeheersing en aanpak van excessen op de woningmarkt.'),
(14, 'Boeren moeten minder stikstof uitstoten, ook als dat krimp betekent.', 3, '2026-06-12 08:46:22', 'Milieu', 'Maatregelen in de landbouw en industrie om de stikstofuitstoot te beperken.'),
(15, 'Nederland moet nauwer samenwerken binnen de Europese Unie.', 2, '2026-06-12 08:46:22', 'Politiek', 'Versterken van de Amerikaanse en Europese samenwerking binnen de EU.'),
(16, 'Eindhoven moet meer fietspaden aanleggen.', 2, '2026-06-12 08:46:22', 'Mobiliteit', 'Uitbreiding van veilige fietspaden in Eindhoven voor forenzen.'),
(17, 'Er moeten meer betaalbare woningen komen.', 3, '2026-06-12 08:46:22', 'Wonen', 'Prioriteit geven aan de bouw van sociale en betaalbare huurwoningen.'),
(18, 'De binnenstad moet autoluw worden.', 2, '2026-06-12 08:46:22', 'Mobiliteit', 'Het weren van doorgaand autoverkeer uit het stadshart voor een leefbaarder centrum.'),
(19, 'De gemeente moet meer investeren in cultuur.', 1, '2026-06-12 08:46:22', 'Cultuur', 'Investering in lokale kunst- en cultuurfaciliteiten voor alle inwoners.'),
(20, 'Nachtbussen moeten vaker rijden.', 1, '2026-06-12 08:46:22', 'Mobiliteit', 'Uitbreiding van de dienstregeling voor nachtbussen in het weekend.'),
(21, 'De gemeente moet hogere parkeertarieven invoeren in het centrum.', 2, '2026-06-12 08:46:22', 'Mobiliteit', 'Eerlijk parkeerbeleid om het centrum toegankelijk te houden voor bezoekers.'),
(22, 'Er moeten meer groene parken en bomen in woonwijken komen.', 2, '2026-06-12 08:46:22', 'Milieu', 'Aanplant van nieuwe bomen en realisatie van parken in woonwijken.'),
(23, 'Eindhoven moet extra investeren in veiligheid op straat.', 2, '2026-06-12 08:46:22', 'Veiligheid', 'Extra inzet van verlichting en toezicht op straat voor een veilige buurt.'),
(24, 'Er moet meer geld naar ondersteuning voor minima.', 3, '2026-06-12 08:46:22', 'Sociale Zaken', 'Financiële ondersteuning en minimaregelingen voor kwetsbare groepen.'),
(25, 'Nieuwe hoogbouw rond stationsgebieden moet worden toegestaan.', 2, '2026-06-12 08:46:22', 'Wonen', 'Inzet op slimme hoogbouw rondom stationsgebieden voor efficiënt ruimtegebruik.'),
(26, 'De gemeente moet evenementen vaker toestaan, ook bij geluidsoverlast.', 1, '2026-06-12 08:46:22', 'Algemeen', 'Ruimhartiger vergunningenbeleid voor evenementen in de stad.'),
(27, 'Scholen moeten meer steun krijgen voor taalachterstanden.', 2, '2026-06-12 08:46:22', 'Onderwijs', 'Extra programma\'s voor taalonderwijs op scholen met achterstanden.'),
(28, 'Bedrijventerreinen moeten ruimte houden voor technologiebedrijven.', 2, '2026-06-12 08:46:22', 'Economie', 'Bescherming van bedrijventerreinen voor de tech- en maakindustrie.'),
(29, 'De gemeente moet strenger handhaven op afval en vervuiling.', 1, '2026-06-12 08:46:22', 'Afvalbeheer', 'Handhaving en verbetering van de afvalverwerking in de gehele gemeente.'),
(30, 'Burgerpanels moeten meer invloed krijgen op gemeentelijke besluiten.', 2, '2026-06-12 08:46:22', 'Politiek', 'Vergroten van burgerparticipatie bij besluitvorming over de stad.');

-- QUESTIONNAIRE_QUESTIONS
INSERT INTO questionnaire_questions (questionnaire_id, question_id) VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,14),(1,15),
(2,16),(2,17),(2,18),(2,19),(2,20),(2,21),(2,22),(2,23),(2,24),(2,25),(2,26),(2,27),(2,28),(2,29),(2,30);

-- ELECTION_PARTIES
INSERT INTO election_parties (election_id, party_id, position) VALUES
(1,1,1),(1,2,2),(1,3,3),(1,4,4),(1,5,5),(1,6,6),(1,7,7),(1,8,8),
(2,1,1),(2,2,2),(2,3,3),(2,4,4),(2,5,5),(2,6,6),(2,7,7),(2,8,8);

-- PARTY_ANSWERS
INSERT INTO party_answers (id, party_id, question_id, answer, explanation) VALUES
(1, 1, 1, 2, ''), (2, 1, 2, 0, ''), (3, 1, 3, 2, ''), (4, 1, 4, 0, ''), (5, 1, 5, 2, ''),
(6, 2, 1, 0, NULL), (7, 2, 2, 2, NULL), (8, 2, 3, 0, NULL), (9, 2, 4, 2, NULL), (10, 2, 5, 0, NULL),
(11, 3, 1, 2, NULL), (12, 3, 2, 0, NULL), (13, 3, 3, 1, NULL), (14, 3, 4, 0, NULL), (15, 3, 5, 2, NULL),
(16, 4, 1, 2, NULL), (17, 4, 2, 1, NULL), (18, 4, 3, 2, NULL), (19, 4, 4, 1, NULL), (20, 4, 5, 2, NULL),
(21, 8, 1, 2, NULL), (22, 7, 1, 0, NULL), (23, 6, 1, 2, NULL), (24, 5, 1, 1, NULL),
(25, 8, 2, 0, NULL), (26, 7, 2, 2, NULL), (27, 6, 2, 1, NULL), (28, 5, 2, 1, NULL),
(29, 8, 3, 1, NULL), (30, 7, 3, 0, NULL), (31, 6, 3, 2, NULL), (32, 5, 3, 1, NULL),
(33, 8, 4, 0, NULL), (34, 7, 4, 2, NULL), (35, 6, 4, 0, NULL), (36, 5, 4, 1, NULL),
(37, 8, 5, 2, NULL), (38, 7, 5, 0, NULL), (39, 6, 5, 2, NULL), (40, 5, 5, 1, NULL),
(41, 8, 11, 2, NULL), (42, 7, 11, 0, NULL), (43, 6, 11, 2, NULL), (44, 5, 11, 1, NULL), (45, 4, 11, 1, NULL), (46, 3, 11, 2, NULL), (47, 2, 11, 0, NULL), (48, 1, 11, 2, ''),
(49, 8, 12, 0, NULL), (50, 7, 12, 2, NULL), (51, 6, 12, 1, NULL), (52, 5, 12, 2, NULL), (53, 4, 12, 1, NULL), (54, 3, 12, 1, NULL), (55, 2, 12, 2, NULL), (56, 1, 12, 1, ''),
(57, 8, 13, 2, NULL), (58, 7, 13, 0, NULL), (59, 6, 13, 1, NULL), (60, 5, 13, 1, NULL), (61, 4, 13, 2, NULL), (62, 3, 13, 2, NULL), (63, 2, 13, 0, NULL), (64, 1, 13, 2, ''),
(65, 8, 14, 2, NULL), (66, 7, 14, 0, NULL), (67, 6, 14, 1, NULL), (68, 5, 14, 1, NULL), (69, 4, 14, 1, NULL), (70, 3, 14, 2, NULL), (71, 2, 14, 0, NULL), (72, 1, 14, 2, ''),
(73, 8, 15, 2, NULL), (74, 7, 15, 0, NULL), (75, 6, 15, 2, NULL), (76, 5, 15, 2, NULL), (77, 4, 15, 1, NULL), (78, 3, 15, 2, NULL), (79, 2, 15, 1, NULL), (80, 1, 15, 2, ''),
(81, 8, 6, 2, NULL), (82, 7, 6, 0, NULL), (83, 6, 6, 1, NULL), (84, 5, 6, 1, NULL), (85, 4, 6, 2, NULL), (86, 3, 6, 2, NULL), (87, 2, 6, 0, NULL), (88, 1, 6, 2, ''),
(89, 8, 7, 0, NULL), (90, 7, 7, 2, NULL), (91, 6, 7, 1, NULL), (92, 5, 7, 2, NULL), (93, 4, 7, 1, NULL), (94, 3, 7, 0, NULL), (95, 2, 7, 2, NULL), (96, 1, 7, 1, ''),
(97, 8, 8, 1, NULL), (98, 7, 8, 0, NULL), (99, 6, 8, 1, NULL), (100, 5, 8, 1, NULL), (101, 4, 8, 2, NULL), (102, 3, 8, 2, NULL), (103, 2, 8, 0, NULL), (104, 1, 8, 2, ''),
(105, 8, 9, 0, NULL), (106, 7, 9, 2, NULL), (107, 6, 9, 2, NULL), (108, 5, 9, 2, NULL), (109, 4, 9, 0, NULL), (110, 3, 9, 1, NULL), (111, 2, 9, 2, NULL), (112, 1, 9, 1, ''),
(113, 8, 10, 1, NULL), (114, 7, 10, 0, NULL), (115, 6, 10, 0, NULL), (116, 5, 10, 1, NULL), (117, 4, 10, 2, NULL), (118, 3, 10, 1, NULL), (119, 2, 10, 0, NULL), (120, 1, 10, 1, ''),
(129, 8, 17, 2, NULL), (130, 7, 17, 1, NULL), (131, 6, 17, 1, NULL), (132, 5, 17, 2, NULL), (133, 4, 17, 2, NULL), (134, 3, 17, 2, NULL), (135, 2, 17, 1, NULL), (136, 1, 17, 2, ''),
(161, 8, 21, 2, NULL), (162, 7, 21, 0, NULL), (163, 6, 21, 1, NULL), (164, 5, 21, 1, NULL), (165, 4, 21, 1, NULL), (166, 3, 21, 2, NULL), (167, 2, 21, 0, NULL), (168, 1, 21, 1, ''),
(169, 8, 22, 2, NULL), (170, 7, 22, 0, NULL), (171, 6, 22, 2, NULL), (172, 5, 22, 1, NULL), (173, 4, 22, 2, NULL), (174, 3, 22, 2, NULL), (175, 2, 22, 0, NULL), (176, 1, 22, 2, ''),
(177, 8, 23, 0, NULL), (178, 7, 23, 2, NULL), (179, 6, 23, 1, NULL), (180, 5, 23, 2, NULL), (181, 4, 23, 1, NULL), (182, 3, 23, 1, NULL), (183, 2, 23, 2, NULL), (184, 1, 23, 1, ''),
(185, 8, 24, 1, NULL), (186, 7, 24, 0, NULL), (187, 6, 24, 1, NULL), (188, 5, 24, 1, NULL), (189, 4, 24, 2, NULL), (190, 3, 24, 2, NULL), (191, 2, 24, 0, NULL), (192, 1, 24, 2, ''),
(193, 8, 25, 0, NULL), (194, 7, 25, 1, NULL), (195, 6, 25, 2, NULL), (196, 5, 25, 2, NULL), (197, 4, 25, 2, NULL), (198, 3, 25, 1, NULL), (199, 2, 25, 2, NULL), (200, 1, 25, 2, ''),
(201, 8, 26, 0, NULL), (202, 7, 26, 1, NULL), (203, 6, 26, 2, NULL), (204, 5, 26, 1, NULL), (205, 4, 26, 1, NULL), (206, 3, 26, 0, NULL), (207, 2, 26, 2, NULL), (208, 1, 26, 1, ''),
(209, 8, 27, 1, NULL), (210, 7, 27, 0, NULL), (211, 6, 27, 2, NULL), (212, 5, 27, 1, NULL), (213, 4, 27, 2, NULL), (214, 3, 27, 2, NULL), (215, 2, 27, 0, NULL), (216, 1, 27, 2, ''),
(217, 8, 28, 0, NULL), (218, 7, 28, 1, NULL), (219, 6, 28, 2, NULL), (220, 5, 28, 2, NULL), (221, 4, 28, 1, NULL), (222, 3, 28, 1, NULL), (223, 2, 28, 2, NULL), (224, 1, 28, 2, ''),
(225, 8, 29, 2, NULL), (226, 7, 29, 2, NULL), (227, 6, 29, 1, NULL), (228, 5, 29, 2, NULL), (229, 4, 29, 2, NULL), (230, 3, 29, 2, NULL), (231, 2, 29, 1, NULL), (232, 1, 29, 1, ''),
(233, 8, 30, 2, NULL), (234, 7, 30, 0, NULL), (235, 6, 30, 2, NULL), (236, 5, 30, 1, NULL), (237, 4, 30, 2, NULL), (238, 3, 30, 2, NULL), (239, 2, 30, 0, NULL), (240, 1, 30, 2, '');

-- Ontbrekende specifieke partij-antwoorden voor de Eindhovense vragen (16, 18, 19, 20) handmatig overgezet uit bestand 1:
INSERT INTO party_answers (party_id, question_id, answer) VALUES
(1,16,2),(1,18,2),(1,19,2),(1,20,2),(2,16,1),(2,18,0),(2,19,0),(2,20,1),
(3,16,2),(3,18,2),(3,19,2),(3,20,1),(4,16,2),(4,18,1),(4,19,2),(4,20,2),
(5,16,1),(5,18,1),(5,19,1),(5,20,1),(6,16,2),(6,18,2),(6,19,2),(6,20,2),
(7,16,0),(7,18,0),(7,19,0),(7,20,0),(8,16,2),(8,18,2),(8,19,1),(8,20,1);

-- USER_ANSWERS
INSERT INTO user_answers (user_id, question_id, answer) VALUES
(1,1,2),(1,2,0),(1,3,2),(1,4,1),(1,5,2),(1,6,2),(1,7,1),(1,8,2),(1,9,1),(1,10,1),(1,11,1),(1,12,2),(1,13,2),(1,14,2),(1,15,2),(1,16,2),(1,17,2),(1,18,1),(1,19,2),(1,20,1),(1,21,1),(1,22,2),(1,23,1),(1,24,2),(1,25,2),(1,26,1),(1,27,2),(1,28,2),(1,29,1),(1,30,2),
(2,1,2),(2,2,1),(2,3,2),(2,4,0),(2,5,2),(2,6,2),(2,7,1),(2,8,2),(2,9,1),(2,10,2),(2,11,2),(2,12,1),(2,13,2),(2,14,2),(2,15,2),(2,16,2),(2,17,2),(2,18,2),(2,19,2),(2,20,2),(2,21,2),(2,22,2),(2,23,1),(2,24,2),(2,25,1),(2,26,1),(2,27,2),(2,28,1),(2,29,2),(2,30,2),
(3,1,0),(3,2,2),(3,3,0),(3,4,2),(3,5,1),(3,6,0),(3,7,2),(3,8,0),(3,9,2),(3,10,0),(3,11,0),(3,12,2),(3,13,0),(3,14,0),(3,15,0),(3,16,1),(3,17,1),(3,18,0),(3,19,0),(3,20,1),(3,21,0),(3,22,1),(3,23,2),(3,24,0),(3,25,2),(3,26,2),(3,27,0),(3,28,2),(3,29,2),(3,30,0),
(4,1,2),(4,2,0),(4,3,2),(4,4,0),(4,5,2),(4,6,2),(4,7,0),(4,8,2),(4,9,0),(4,10,1),(4,11,2),(4,12,1),(4,13,2),(4,14,2),(4,15,2),(4,16,2),(4,17,2),(4,18,2),(4,19,1),(4,20,1),(4,21,2),(4,22,2),(4,23,1),(4,24,1),(4,25,1),(4,26,0),(4,27,1),(4,28,1),(4,29,2),(4,30,2),
(5,1,1),(5,2,2),(5,3,1),(5,4,2),(5,5,0),(5,6,1),(5,7,2),(5,8,1),(5,9,2),(5,10,0),(5,11,0),(5,12,2),(5,13,1),(5,14,0),(5,15,1),(5,16,1),(5,17,2),(5,18,0),(5,19,1),(5,20,2),(5,21,0),(5,22,1),(5,23,2),(5,24,1),(5,25,2),(5,26,2),(5,27,1),(5,28,2),(5,29,2),(5,30,1);

COMMIT;