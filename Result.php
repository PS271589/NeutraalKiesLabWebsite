<?php
require_once "database-handler.php";
session_start();

// Validate POST data, or fall back to session cache
if (isset($_POST["election_id"], $_POST["answers"])) {
    $electionId  = (int)$_POST["election_id"];
    $answersJson = $_POST["answers"];

    // Cache in session so login redirect can restore them
    $_SESSION["pending_election_id"] = $electionId;
    $_SESSION["pending_answers"]     = $answersJson;
} elseif (isset($_SESSION["pending_election_id"], $_SESSION["pending_answers"])) {
    $electionId  = (int)$_SESSION["pending_election_id"];
    $answersJson = $_SESSION["pending_answers"];
} else {
    header("Location: index.php");
    exit;
}

if (!$electionId || !$answersJson) {
    header("Location: index.php");
    exit;
}

$userAnswers = json_decode($answersJson, true);
if (!$userAnswers) {
    header("Location: index.php");
    exit;
}

// Index user answers by question_id for easy lookup
$userAnswerMap = [];
foreach ($userAnswers as $a) {
    $userAnswerMap[(int)$a["question_id"]] = (int)$a["answer"];
}

// Fetch party answers from DB
$db      = new DatabaseHandler();
$isSaved = false;

if (isset($_SESSION["user_id"])) {
    $isSaved = $db->SaveUserAnswers((int)$_SESSION["user_id"], $userAnswers);
    // Clear the cache after saving
    unset($_SESSION["pending_election_id"], $_SESSION["pending_answers"]);
}

$partyRows   = $db->SelectPartyAnswersByElection($electionId);

if (!$partyRows) {
    header("Location: index.php");
    exit;
}

// Group by party and calculate weighted match score
// answer values: 0 = oneens, 1 = neutraal, 2 = eens
// max points per question = weight * 2 (both fully agree)
// match points: fully agree = weight*2, one neutral = weight*1, both neutral = weight*1, disagree = 0
$parties = [];
foreach ($partyRows as $row) {
    $partyId   = (int)$row["party_id"];
    $partyName = $row["party_name"];
    $qId       = (int)$row["question_id"];
    $partyAns  = (int)$row["answer"];
    $weight    = (int)$row["weight"];

    if (!isset($parties[$partyId])) {
        $parties[$partyId] = [
            "name"      => $partyName,
            "color_hex" => $row["color_hex"],
            "score"     => 0,
            "max_score" => 0,
        ];
    }

    $parties[$partyId]["max_score"] += $weight * 2;

    if (!isset($userAnswerMap[$qId])) continue;

    $userAns = $userAnswerMap[$qId];

    // Score: difference between answers (0-2), inverted to agreement
    $diff  = abs($userAns - $partyAns); // 0, 1, or 2
    $match = (2 - $diff) * $weight;     // max weight*2, min 0

    $parties[$partyId]["score"] += $match;
}

// Calculate percentage and sort descending
foreach ($parties as &$p) {
    $p["percentage"] = $p["max_score"] > 0
        ? (int)round(($p["score"] / $p["max_score"]) * 100)
        : 0;
}
unset($p);

usort($parties, fn($a, $b) => $b["percentage"] - $a["percentage"]);

$best    = $parties[0];
$others  = array_slice($parties, 1, 4); // next 4 = top 5 total

?>
<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Neutraal KiesLab Resultaten</title>
    <link rel="stylesheet" href="style/Result.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Inter">
</head>
<body>
    <nav>
        <a href="index.php">
            <img class="logo" src="assets/logo-met-text-rechts.svg" alt="Neutraal KiesLab Logo">
        </a>
    </nav>

    <main class="results-container">

        <?php if (!isset($_SESSION["user_id"])): ?>

        <h1>Jouw Resultaten</h1>
        <p class="subtitle">Log in om jouw resultaten te bekijken</p>

        <div class="buttons">
            <button class="save-btn" onclick="window.location.href='login.php'">Inloggen</button>
            <button class="retry-btn" onclick="window.location.href='index.php'">Opnieuw doen</button>
        </div>

        <?php else: ?>

        <h1>Jouw Resultaten</h1>
        <p class="subtitle">Op basis van jouw antwoorden hebben we de volgende matches gevonden</p>

        <section class="best-match">
            <p class="match-label">Jouw beste match</p>
            <h2><?= htmlspecialchars($best["name"]) ?></h2>
            <div class="match-score">
                <span><?= $best["percentage"] ?>%</span>
                <small>overeenstemming</small>
            </div>
        </section>

        <section class="all-parties">
            <h3>Alle partijen</h3>
            <div id="partyList">
                <?php
                $allTop = array_merge([$best], $others);
                foreach ($allTop as $i => $party):
                    $color = htmlspecialchars($party["color_hex"] ?? "#d0ebff");
                ?>
                <div class="party-row">
                    <div class="party-top">
                        <div class="party-info">
                            <span class="rank"><?= $i + 1 ?></span>
                            <span><?= htmlspecialchars($party["name"]) ?></span>
                        </div>
                        <span><?= $party["percentage"] ?>%</span>
                    </div>
                    <div class="progress">
                        <div class="progress-fill" style="width: <?= $party["percentage"] ?>%; background: <?= $color ?>;"></div>
                    </div>
                </div>
                <?php endforeach; ?>
            </div>
        </section>

        <div class="buttons">
            <button class="save-btn" onclick="window.location.href='dashboard.php'">
                <?= $isSaved ? "Bekijk opgeslagen resultaten" : "Opslaan mislukt" ?>
            </button>
            <button class="retry-btn" onclick="window.location.href='index.php'">Opnieuw doen</button>
        </div>

        <div class="notice">
            <strong>Belangrijk:</strong>
            Deze stemwijzer geeft een indicatie op basis van jouw antwoorden. Lees altijd de verkiezingsprogramma's zelf
            en stem op de partij die het beste bij jou past.
        </div>

        <?php endif; ?>

    </main>
</body>
</html>
