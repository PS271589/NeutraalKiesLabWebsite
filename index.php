<?php
require_once "database-handler.php";
session_start();

$db = new DatabaseHandler();
$elections = $db->SelectElections();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Neutraal KiesLab - Home</title>
    <link rel="stylesheet" href="style/styles.css">
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css?family=Inter">
    <script src="scripts/homepage.js" defer></script>
    <link rel="icon" type="image/svg" href="assets/logo-neutraal-kieslab-lichtblauw.svg">
</head>
<body>
    <nav>
        <a href="index.php">
            <img class="logo" src="assets/logo-met-text-rechts.svg" alt="Neutraal KiesLab Logo">
        </a>
        <div>
            <button class="parties">Partijen</button>

            <?php if (isset($_SESSION["user_id"])): ?>
                <button class="logout" onclick="window.location.href='logout.php'">
                    Uitloggen
                </button>
            <?php else: ?>
                <button class="login">Inloggen</button>
                <button class="register">Registreren</button>
            <?php endif; ?>
        </div>
    </nav>
    <main>
        <section class="hero">
            <h1>Welkom bij Neutraal KiesLab</h1>
            <p>Ontdek welke politieke partij het beste bij jouw opvattingen past. Beantwoord onze vragen en krijg een objectief advies gebaseerd op jouw antwoorden.</p>
        </section>

        <section class="features">
            <div class="feature">
                <img src="assets/icon-check.svg" alt="Checkmark icon">
                <h2>Neutraal & Objectief</h2>
                <p>Onze stemwijzer is volledig onafhankelijk en geeft objectief advies op basis van jouw antwoorden.</p>
            </div>
            <div class="feature">
                <img src="assets/icon-plus.svg" alt="Plus icon">
                <h2>Snel & Eenvoudig</h2>
                <p>In slechts 5-10 minuten krijg je een duidelijk beeld van welke partij bij jou past.</p>
            </div>
            <div class="feature">
                <img src="assets/icon-agenda.svg" alt="Agenda icon">
                <h2>Bewaar je Resultaten</h2>
                <p>Maak een account aan om je resultaten te bewaren en later terug te kijken.</p>
            </div>
        </section>

        <section class="start">
            <button class="start-button">Start de Stemwijzer<img id="arrow" src="assets/arrow.svg" alt="Arrow icon"></button>
            <div class="election-select">
                <?php if ($elections): ?>
                    <?php foreach ($elections as $election): ?>
                        <button class="election-button">
                            <?= htmlspecialchars($election["name"]) ?>
                        </button>
                    <?php endforeach; ?>
                <?php else: ?>
                    <p>Geen verkiezingen gevonden</p>
                <?php endif; ?>
            </div>
            <p>Of <span><a href="register.php">maak een account aan</a></span> om je resultaten te bewaren</p>
        </section>
    </main>
    <footer>
        <p>&copy; 2026 Neutraal KiesLab. Alle rechten voorbehouden.</p>
    </footer>
</body>
</html>