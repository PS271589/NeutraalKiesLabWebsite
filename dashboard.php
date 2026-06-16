<?php
require_once "database-handler.php";
session_start();

$userId = $_SESSION["user_id"] ?? null;

if (!$userId) {
    header("Location: login.php");
    exit;
}

$db = new DatabaseHandler();
$results = $db->SelectDashboardResultsByUser((int)$userId);
if ($results === false) {
    $results = [];
}

function formatResultDate($date)
{
    $timestamp = strtotime($date);
    if (!$timestamp) {
        return "Datum onbekend";
    }

    $months = [
        1 => "januari",
        2 => "februari",
        3 => "maart",
        4 => "april",
        5 => "mei",
        6 => "juni",
        7 => "juli",
        8 => "augustus",
        9 => "september",
        10 => "oktober",
        11 => "november",
        12 => "december"
    ];

    return date("j", $timestamp) . " " .
        $months[(int)date("n", $timestamp)] . " " .
        date("Y \\o\\m H:i", $timestamp);
}
?>

<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Neutraal KiesLab - Resultaten</title>

    <link rel="stylesheet" href="style/styles.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Inter">
    <link rel="icon" type="image/svg" href="assets/logo-neutraal-kieslab-lichtblauw.svg">
</head>
<body>

<nav>
    <a href="index.php">
        <img class="logo" src="assets/logo-met-text-rechts.svg" alt="Logo">
    </a>

    <div>
        <button class="parties" onclick="window.location.href='partijen.php'">Partijen</button>
        <button class="logout" onclick="window.location.href='logout.php'">
            Uitloggen
        </button>
    </div>
</nav>

<main class="results-page">

    <div class="results-header">
        <h1>Welkom, <?php echo htmlspecialchars($_SESSION["user_name"] ?? "Gebruiker"); ?></h1>
        <p>Hier vind je al je opgeslagen stemwijzer resultaten</p>
    </div>

    <?php if (count($results) === 0): ?>

        <div class="result-card">
            <h2>Nog geen opgeslagen resultaten</h2>
            <p class="result-date">
                Maak eerst een stemwijzer, dan verschijnt je uitslag hier automatisch zodra je antwoorden in de database staan.
            </p>
        </div>

    <?php endif; ?>

    <?php foreach ($results as $result): ?>

        <div class="result-card">

            <h2>Beste match: <?php echo htmlspecialchars($result["matches"][0]["name"]); ?></h2>
            <p><?php echo htmlspecialchars($result["election_name"]); ?></p>

            <p class="result-date">
                <img src="assets/icon-date.svg" alt="Date icon"> <?php echo formatResultDate($result["date"]); ?>
            </p>

            <h3>Top 3 matches:</h3>

            <?php foreach ($result["matches"] as $index => $match): ?>

                <div class="match-row">
                    <span><?php echo htmlspecialchars($match["name"]); ?></span>
                    <span><?php echo (int)$match["score"]; ?>%</span>
                </div>

                <div class="progress-bar">
                    <div
                        class="progress-fill"
                        style="width: <?php echo (int) $match['score']; ?>%; background-color: <?php echo htmlspecialchars($match['color_hex'] ?? '#cccccc'); ?>;"
                    ></div>
                </div>

            <?php endforeach; ?>

        </div>

    <?php endforeach; ?>

    <button class="start-button" onclick="window.location.href='index.php'">
        Opnieuw doen
    </button>

</main>

<footer>
    <p>&copy; 2026 Neutraal KiesLab. Alle rechten voorbehouden.</p>
</footer>

</body>
</html>
