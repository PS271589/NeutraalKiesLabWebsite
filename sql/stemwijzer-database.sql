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
    abbreviation VARCHAR(10) NOT NULL,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(600),
    color_hex VARCHAR(7) NOT NULL DEFAULT '#FF6B00'
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
    question VARCHAR(255) NOT NULL,
    weight INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category VARCHAR(100) DEFAULT NULL,
    description TEXT DEFAULT NULL
);

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
);

-- --------------------------------------------------------
-- USERS
-- --------------------------------------------------------

INSERT INTO users (name, email, birthdate, city, password, role, username) VALUES
('Jan Jansen',      'jan@example.com',   '1995-05-15', 'Amsterdam', '$2y$10$8J6rN3pR4qB5K7cM9xA8Se6xkP1mF7uQ9vD3hT2yW1zL4nR5sC8uG', 'user',  'janjansen'),
('Emma de Vries',   'emma@example.com',  '1998-10-22', 'Eindhoven', '$2y$10$8J6rN3pR4qB5K7cM9xA8Se6xkP1mF7uQ9vD3hT2yW1zL4nR5sC8uG', 'user',  'emmadevries'),
('Noah Bakker',     'noah@example.com',  '1992-03-08', 'Rotterdam', '$2y$10$8J6rN3pR4qB5K7cM9xA8Se6xkP1mF7uQ9vD3hT2yW1zL4nR5sC8uG', 'user',  'noahbakker'),
('Lisa Visser',     'lisa@example.com',  '1990-12-01', 'Utrecht',   '$2y$10$8J6rN3pR4qB5K7cM9xA8Se6xkP1mF7uQ9vD3hT2yW1zL4nR5sC8uG', 'admin', 'lisavisser'),
('Milan Smit',      'milan@example.com', '2000-07-30', 'Tilburg',   '$2y$10$8J6rN3pR4qB5K7cM9xA8Se6xkP1mF7uQ9vD3hT2yW1zL4nR5sC8uG', 'user',  'milansmit');

-- --------------------------------------------------------
-- ELECTIONS
-- --------------------------------------------------------

INSERT INTO elections (name, date, description) VALUES
('Tweede Kamerverkiezingen 2026',            '2026-03-15 09:00:00', 'Landelijke verkiezingen voor de Tweede Kamer.'),
('Gemeenteraadsverkiezingen Eindhoven 2026', '2026-05-20 09:00:00', 'Gemeenteraadsverkiezingen voor Eindhoven.');

-- --------------------------------------------------------
-- PARTIES
-- --------------------------------------------------------

INSERT INTO parties (abbreviation, name, description, color_hex) VALUES
('PN',  'Progressief Nederland',
 'Progressief Nederland gelooft in een eerlijke en duurzame samenleving voor iedereen. Wij zetten in op forse investeringen in hernieuwbare energie, hoogwaardig onderwijs en gelijke kansen van wieg tot werk. De overheid moet een actieve rol spelen in het terugdringen van ongelijkheid, het beschermen van het klimaat en het stimuleren van innovatie. Internationaal samenwerken is voor ons geen keuze maar een noodzaak.',
 '#E6B04D'),
('VBP', 'Vrije Burgers Partij',
 'De Vrije Burgers Partij staat voor een kleinere overheid, lagere lasten en meer ruimte voor de eigen keuze van de burger. Ondernemers vormen de motor van onze economie en verdienen minder regeldruk en meer vertrouwen. Wij willen belastingen structureel verlagen, de bureaucratie snoeien en burgers zelf laten beslissen over hun leven, zorg en pensioen. Vrijheid is onze kern, verantwoordelijkheid ons kompas.',
 '#F97316'),
('GT',  'Groene Toekomst',
 'Groene Toekomst plaatst milieu, natuur en duurzaamheid centraal in elk beleidsterrein. Wij pleiten voor een radicale transitie naar een circulaire economie, een eerlijk CO2-prijssysteem en stevige bescherming van biodiversiteit. Landbouw, industrie en mobiliteit moeten verduurzamen — niet als bedreiging maar als kans voor nieuwe banen en een gezonde leefomgeving voor volgende generaties.',
 '#22C55E'),
('SC',  'Sociaal Collectief',
 'Het Sociaal Collectief staat op voor mensen die het zelf niet redden. Wij willen een sterk sociaal vangnet, betaalbare huurwoningen in elke wijk en toegankelijke zorg zonder wachtlijsten. De kloof tussen arm en rijk moet kleiner: hogere minimumuitkeringen, gratis kinderopvang en een vermogensbelasting voor de allerrijksten. Solidariteit is geen zwakte — het is de basis van een beschaafde samenleving.',
 '#EF4444'),
('CDV', 'Christen Democratisch Verbond',
 'Het Christen Democratisch Verbond verbindt christelijke waarden met daadkrachtig bestuur. Wij geloven in de kracht van gemeenschap, het belang van het gezin en de noodzaak van veiligheid op straat en aan de grenzen. Bestuurlijke stabiliteit, zorgvuldig begrotingsbeleid en respect voor tradities vormen onze leidraad. Wij bouwen aan een samenleving waarin iedereen zijn verantwoordelijkheid neemt.',
 '#2563EB'),
('LD',  'Liberaal Democraten',
 'De Liberaal Democraten combineren persoonlijke vrijheid met een sterk geloof in onderwijs, rechtsstaat en Europese samenwerking. Wij willen een moderne overheid die investeert in kennis, digitalisering en een eerlijk migratie­beleid. Burgers verdienen transparantie, inspraak en een politiek dat feiten boven sentiment stelt. Europa is onze kracht: alleen samen kunnen we mondiale uitdagingen het hoofd bieden.',
 '#06B6D4'),
('NB',  'Nationaal Belang',
 'Nationaal Belang stelt de Nederlandse burger voorop. Wij pleiten voor strikte controle over onze grenzen, een forse reductie van de instroom van asielzoekers en het terugwinnen van nationale soevereiniteit van Brussel. De veiligheid op straat moet verbeteren door meer politie en hogere straffen. Nederlandse belangen komen eerst — in economie, cultuur en beleid.',
 '#1F2937'),
('DNP', 'Dieren & Natuur Partij',
 'De Dieren & Natuur Partij geeft een stem aan wie zichzelf niet kan verdedigen: dieren, natuur en toekomstige generaties. Wij willen een einde aan de bio-industrie, sterke bescherming van wilde natuur en een landbouwtransitie naar dierwaardige en ecologische systemen. Klimaatrechtvaardigheid betekent ook dat de sterkste schouders de zwaarste lasten dragen — mondiaal en nationaal.',
 '#84CC16');

-- --------------------------------------------------------
-- QUESTIONNAIRES
-- --------------------------------------------------------

INSERT INTO questionnaires (election_id, title) VALUES
(1, 'Stemwijzer Tweede Kamer 2026'),
(2, 'Stemwijzer Eindhoven 2026');

-- --------------------------------------------------------
-- QUESTIONS
-- Vraag 1-15: Tweede Kamer | Vraag 16-30: Eindhoven
-- --------------------------------------------------------

INSERT INTO questions (question, weight, category, description) VALUES
-- Tweede Kamer (1-15)
('De overheid moet meer investeren in duurzame energie.',                         2, 'Klimaat',    'Investeren in duurzame energiebronnen om de CO2-uitstoot te verminderen.'),
('De maximumsnelheid op snelwegen moet omhoog.',                                  1, 'Mobiliteit', 'Het verhogen van de snelheid op snelwegen voor betere doorstroming.'),
('Studiefinanciering moet worden verhoogd.',                                       2, 'Onderwijs',  'Verhogen van de maandelijkse toelage voor studenten ter ondersteuning van hun studie.'),
('Er moeten strengere immigratieregels komen.',                                    3, 'Samenleving','Strengere toelatingseisen voor nieuwkomers om integratie te waarborgen.'),
('Openbaar vervoer moet goedkoper worden.',                                        2, 'Mobiliteit', 'Betaalbaar openbaar vervoer door middel van gerichte subsidies.'),
('De belasting op hoge inkomens moet omhoog.',                                    2, 'Financiën',  'Hogere marginale belasting voor de hoogste inkomensgroepen.'),
('Nederland moet meer geld uitgeven aan defensie.',                                2, 'Defensie',   'Verhoging van het defensiebudget om aan NAVO-normen te voldoen.'),
('Er moet een landelijk minimumloon van minstens 16 euro per uur komen.',         3, 'Arbeidsmarkt','Wettelijk minimumloon verhogen voor een eerlijk bestaansminimum.'),
('Kernenergie moet een grotere rol krijgen in de energievoorziening.',            2, 'Energie',    'Inzet van kerncentrales als stabiele en CO2-arme energiebron.'),
('Zorgverzekeringen moeten volledig publiek worden geregeld.',                    3, 'Zorg',       'Nationalisering van de zorgverzekeringsmarkt voor gelijke toegang.'),
('Nederland moet meer vluchtelingen opnemen.',                                    2, 'Samenleving','Verruiming van de opvangcapaciteit voor asielzoekers en vluchtelingen.'),
('Er moet strenger worden opgetreden tegen zware criminaliteit.',                 2, 'Veiligheid', 'Zwaardere straffen en meer capaciteit bij politie en justitie.'),
('De overheid moet huren sterker reguleren.',                                     3, 'Wonen',      'Huurprijsbeheersing en aanpak van excessen op de woningmarkt.'),
('Boeren moeten minder stikstof uitstoten, ook als dat krimp betekent.',         3, 'Milieu',     'Maatregelen in de landbouw en industrie om de stikstofuitstoot te beperken.'),
('Nederland moet nauwer samenwerken binnen de Europese Unie.',                   2, 'Politiek',   'Versterken van de bestuurlijke samenwerking binnen de EU.'),
-- Eindhoven (16-30)
('Eindhoven moet meer fietspaden aanleggen.',                                     2, 'Mobiliteit', 'Uitbreiding van veilige fietspaden in Eindhoven voor forenzen.'),
('Er moeten meer betaalbare woningen komen.',                                     3, 'Wonen',      'Prioriteit geven aan de bouw van sociale en betaalbare huurwoningen.'),
('De binnenstad moet autoluw worden.',                                            2, 'Mobiliteit', 'Het weren van doorgaand autoverkeer uit het stadshart voor een leefbaarder centrum.'),
('De gemeente moet meer investeren in cultuur.',                                  1, 'Cultuur',    'Investering in lokale kunst- en cultuurfaciliteiten voor alle inwoners.'),
('Nachtbussen moeten vaker rijden.',                                              1, 'Mobiliteit', 'Uitbreiding van de dienstregeling voor nachtbussen in het weekend.'),
('De gemeente moet hogere parkeertarieven invoeren in het centrum.',             2, 'Mobiliteit', 'Eerlijk parkeerbeleid om het centrum toegankelijk te houden voor bezoekers.'),
('Er moeten meer groene parken en bomen in woonwijken komen.',                   2, 'Milieu',     'Aanplant van nieuwe bomen en realisatie van parken in woonwijken.'),
('Eindhoven moet extra investeren in veiligheid op straat.',                     2, 'Veiligheid', 'Extra inzet van verlichting en toezicht op straat voor een veilige buurt.'),
('Er moet meer geld naar ondersteuning voor minima.',                            3, 'Sociale Zaken','Financiële ondersteuning en minimaregelingen voor kwetsbare groepen.'),
('Nieuwe hoogbouw rond stationsgebieden moet worden toegestaan.',                2, 'Wonen',      'Inzet op slimme hoogbouw rondom stationsgebieden voor efficiënt ruimtegebruik.'),
('De gemeente moet evenementen vaker toestaan, ook bij geluidsoverlast.',        1, 'Algemeen',   'Ruimhartiger vergunningenbeleid voor evenementen in de stad.'),
('Scholen moeten meer steun krijgen voor taalachterstanden.',                    2, 'Onderwijs',  'Extra programma\'s voor taalonderwijs op scholen met achterstanden.'),
('Bedrijventerreinen moeten ruimte houden voor technologiebedrijven.',           2, 'Economie',   'Bescherming van bedrijventerreinen voor de tech- en maakindustrie.'),
('De gemeente moet strenger handhaven op afval en vervuiling.',                  1, 'Afvalbeheer','Handhaving en verbetering van de afvalverwerking in de gehele gemeente.'),
('Burgerpanels moeten meer invloed krijgen op gemeentelijke besluiten.',         2, 'Politiek',   'Vergroten van burgerparticipatie bij besluitvorming over de stad.');

-- --------------------------------------------------------
-- QUESTIONNAIRE_QUESTIONS
-- Questionnaire 1 (TK) → vragen 1-15 | Questionnaire 2 (EHV) → vragen 16-30
-- --------------------------------------------------------

INSERT INTO questionnaire_questions (questionnaire_id, question_id) VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,14),(1,15),
(2,16),(2,17),(2,18),(2,19),(2,20),(2,21),(2,22),(2,23),(2,24),(2,25),(2,26),(2,27),(2,28),(2,29),(2,30);

-- --------------------------------------------------------
-- ELECTION_PARTIES
-- --------------------------------------------------------

INSERT INTO election_parties (election_id, party_id, position) VALUES
(1,1,1),(1,2,2),(1,3,3),(1,4,4),(1,5,5),(1,6,6),(1,7,7),(1,8,8),
(2,1,1),(2,2,2),(2,3,3),(2,4,4),(2,5,5),(2,6,6),(2,7,7),(2,8,8);

-- --------------------------------------------------------
-- PARTY_ANSWERS
-- Antwoorden: 0 = oneens, 1 = neutraal, 2 = eens
-- --------------------------------------------------------

-- Partij 1: Progressief Nederland (PN)
INSERT INTO party_answers (party_id, question_id, answer) VALUES
(1,1,2),(1,2,0),(1,3,2),(1,4,0),(1,5,2),(1,6,2),(1,7,1),(1,8,2),(1,9,1),(1,10,1),
(1,11,2),(1,12,1),(1,13,2),(1,14,2),(1,15,2),
(1,16,2),(1,17,2),(1,18,2),(1,19,2),(1,20,2),(1,21,1),(1,22,2),(1,23,1),(1,24,2),(1,25,2),(1,26,1),(1,27,2),(1,28,2),(1,29,1),(1,30,2);

-- Partij 2: Vrije Burgers Partij (VBP)
INSERT INTO party_answers (party_id, question_id, answer) VALUES
(2,1,0),(2,2,2),(2,3,0),(2,4,2),(2,5,0),(2,6,0),(2,7,2),(2,8,0),(2,9,2),(2,10,0),
(2,11,0),(2,12,2),(2,13,0),(2,14,0),(2,15,1),
(2,16,1),(2,17,1),(2,18,0),(2,19,0),(2,20,1),(2,21,0),(2,22,0),(2,23,2),(2,24,0),(2,25,2),(2,26,2),(2,27,0),(2,28,2),(2,29,1),(2,30,0);

-- Partij 3: Groene Toekomst (GT)
INSERT INTO party_answers (party_id, question_id, answer) VALUES
(3,1,2),(3,2,0),(3,3,1),(3,4,0),(3,5,2),(3,6,2),(3,7,0),(3,8,2),(3,9,1),(3,10,1),
(3,11,2),(3,12,1),(3,13,2),(3,14,2),(3,15,2),
(3,16,2),(3,17,2),(3,18,2),(3,19,2),(3,20,1),(3,21,2),(3,22,2),(3,23,1),(3,24,2),(3,25,1),(3,26,0),(3,27,2),(3,28,1),(3,29,2),(3,30,2);

-- Partij 4: Sociaal Collectief (SC)
INSERT INTO party_answers (party_id, question_id, answer) VALUES
(4,1,2),(4,2,1),(4,3,2),(4,4,1),(4,5,2),(4,6,2),(4,7,1),(4,8,2),(4,9,0),(4,10,2),
(4,11,1),(4,12,1),(4,13,2),(4,14,1),(4,15,1),
(4,16,2),(4,17,2),(4,18,1),(4,19,2),(4,20,2),(4,21,1),(4,22,2),(4,23,1),(4,24,2),(4,25,2),(4,26,1),(4,27,2),(4,28,1),(4,29,2),(4,30,2);

-- Partij 5: Christen Democratisch Verbond (CDV)
INSERT INTO party_answers (party_id, question_id, answer) VALUES
(5,1,1),(5,2,1),(5,3,1),(5,4,1),(5,5,1),(5,6,1),(5,7,2),(5,8,1),(5,9,2),(5,10,1),
(5,11,1),(5,12,2),(5,13,1),(5,14,1),(5,15,2),
(5,16,1),(5,17,2),(5,18,1),(5,19,1),(5,20,1),(5,21,1),(5,22,1),(5,23,2),(5,24,1),(5,25,2),(5,26,1),(5,27,1),(5,28,2),(5,29,2),(5,30,1);

-- Partij 6: Liberaal Democraten (LD)
INSERT INTO party_answers (party_id, question_id, answer) VALUES
(6,1,2),(6,2,1),(6,3,2),(6,4,0),(6,5,2),(6,6,1),(6,7,1),(6,8,1),(6,9,2),(6,10,0),
(6,11,2),(6,12,1),(6,13,1),(6,14,1),(6,15,2),
(6,16,2),(6,17,1),(6,18,2),(6,19,2),(6,20,2),(6,21,1),(6,22,2),(6,23,1),(6,24,1),(6,25,2),(6,26,2),(6,27,2),(6,28,2),(6,29,1),(6,30,2);

-- Partij 7: Nationaal Belang (NB)
INSERT INTO party_answers (party_id, question_id, answer) VALUES
(7,1,0),(7,2,2),(7,3,0),(7,4,2),(7,5,0),(7,6,0),(7,7,2),(7,8,0),(7,9,2),(7,10,0),
(7,11,0),(7,12,2),(7,13,0),(7,14,0),(7,15,0),
(7,16,0),(7,17,1),(7,18,0),(7,19,0),(7,20,0),(7,21,0),(7,22,0),(7,23,2),(7,24,0),(7,25,1),(7,26,1),(7,27,0),(7,28,1),(7,29,2),(7,30,0);

-- Partij 8: Dieren & Natuur Partij (DNP)
INSERT INTO party_answers (party_id, question_id, answer) VALUES
(8,1,2),(8,2,0),(8,3,1),(8,4,0),(8,5,2),(8,6,2),(8,7,0),(8,8,1),(8,9,0),(8,10,1),
(8,11,2),(8,12,0),(8,13,2),(8,14,2),(8,15,2),
(8,16,2),(8,17,2),(8,18,2),(8,19,1),(8,20,1),(8,21,2),(8,22,2),(8,23,0),(8,24,1),(8,25,0),(8,26,0),(8,27,1),(8,28,0),(8,29,2),(8,30,2);

-- --------------------------------------------------------
-- USER_ANSWERS
-- Antwoorden: 0 = oneens, 1 = neutraal, 2 = eens
-- --------------------------------------------------------

-- Gebruiker 1: Jan Jansen
INSERT INTO user_answers (user_id, question_id, answer) VALUES
(1,1,2),(1,2,0),(1,3,2),(1,4,1),(1,5,2),(1,6,2),(1,7,1),(1,8,2),(1,9,1),(1,10,1),
(1,11,1),(1,12,2),(1,13,2),(1,14,2),(1,15,2),
(1,16,2),(1,17,2),(1,18,1),(1,19,2),(1,20,1),(1,21,1),(1,22,2),(1,23,1),(1,24,2),(1,25,2),(1,26,1),(1,27,2),(1,28,2),(1,29,1),(1,30,2);

-- Gebruiker 2: Emma de Vries
INSERT INTO user_answers (user_id, question_id, answer) VALUES
(2,1,2),(2,2,1),(2,3,2),(2,4,0),(2,5,2),(2,6,2),(2,7,1),(2,8,2),(2,9,1),(2,10,2),
(2,11,2),(2,12,1),(2,13,2),(2,14,2),(2,15,2),
(2,16,2),(2,17,2),(2,18,2),(2,19,2),(2,20,2),(2,21,2),(2,22,2),(2,23,1),(2,24,2),(2,25,1),(2,26,1),(2,27,2),(2,28,1),(2,29,2),(2,30,2);

-- Gebruiker 3: Noah Bakker
INSERT INTO user_answers (user_id, question_id, answer) VALUES
(3,1,0),(3,2,2),(3,3,0),(3,4,2),(3,5,1),(3,6,0),(3,7,2),(3,8,0),(3,9,2),(3,10,0),
(3,11,0),(3,12,2),(3,13,0),(3,14,0),(3,15,0),
(3,16,1),(3,17,1),(3,18,0),(3,19,0),(3,20,1),(3,21,0),(3,22,1),(3,23,2),(3,24,0),(3,25,2),(3,26,2),(3,27,0),(3,28,2),(3,29,2),(3,30,0);

-- Gebruiker 4: Lisa Visser (admin)
INSERT INTO user_answers (user_id, question_id, answer) VALUES
(4,1,2),(4,2,0),(4,3,2),(4,4,0),(4,5,2),(4,6,2),(4,7,0),(4,8,2),(4,9,0),(4,10,1),
(4,11,2),(4,12,1),(4,13,2),(4,14,2),(4,15,2),
(4,16,2),(4,17,2),(4,18,2),(4,19,1),(4,20,1),(4,21,2),(4,22,2),(4,23,1),(4,24,1),(4,25,1),(4,26,0),(4,27,1),(4,28,1),(4,29,2),(4,30,2);

-- Gebruiker 5: Milan Smit
INSERT INTO user_answers (user_id, question_id, answer) VALUES
(5,1,1),(5,2,2),(5,3,1),(5,4,2),(5,5,0),(5,6,1),(5,7,2),(5,8,1),(5,9,2),(5,10,0),
(5,11,0),(5,12,2),(5,13,1),(5,14,0),(5,15,1),
(5,16,1),(5,17,2),(5,18,0),(5,19,1),(5,20,2),(5,21,0),(5,22,1),(5,23,2),(5,24,1),(5,25,2),(5,26,2),(5,27,1),(5,28,2),(5,29,2),(5,30,1);