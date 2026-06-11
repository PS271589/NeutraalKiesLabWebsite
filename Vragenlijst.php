<?php
require_once "database-handler.php";

$electionId = isset($_GET["election_id"]) ? (int)$_GET["election_id"] : 0;

$db = new DatabaseHandler();
$questions = $db->SelectQuestionsByElection($electionId);

if (!$questions || count($questions) === 0) {
    header("Location: index.php");
    exit;
}

$questionsJson = json_encode($questions);
?>
<!DOCTYPE html>
<html lang="nl">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Neutraal KiesLab Vragenlijst</title>
    <link rel="stylesheet" href="style/Vragenlijst.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Inter">
</head>

<body>

    <nav>
        <a href="index.php">
            <img class="logo" src="assets/logo-met-text-rechts.svg" alt="Neutraal KiesLab Logo">
        </a>
    </nav>

    <section class="progress-container">
        <div class="text-container">
            <div class="progress-vragen">
                <p>Vraag <span id="current-question">0</span> van <span id="total-questions"><?= count($questions) ?></span></p>
            </div>
            <div class="progress-procent">
                <p id="progress-percent">0%</p>
            </div>
        </div>
        <div class="progress-bar">
            <div class="progress-fill" id="progress-fill"></div>
        </div>
    </section>

    <main class="question-section">
        <div class="category" id="question-category">
            &nbsp;
        </div>
        <h1 class="question" id="question-text">
            Laden...
        </h1>
        <div class="antwoorden">
            <button class="antwoord-btn" data-value="0">Oneens</button>
            <button class="antwoord-btn" data-value="1">Neutraal</button>
            <button class="antwoord-btn" data-value="2">Eens</button>
        </div>
    </main>

    <footer class="footer-nav">
        <button class="footer-btn disabled" id="btn-back">
            <img src="assets/icon-next-arrow-disabled.svg" alt="Pijl naar links" id="icon-back">
            Terug
        </button>
        <button class="footer-btn disabled" id="btn-next">
            Volgende
            <img src="assets/icon-next-arrow-disabled.svg" alt="Pijl naar rechts" class="rotated" id="icon-next">
        </button>
    </footer>

    <script>
        const QUESTIONS = <?= $questionsJson ?>;
    </script>
    <script src="script/Vragenlijst.js"></script>
</body>

</html>