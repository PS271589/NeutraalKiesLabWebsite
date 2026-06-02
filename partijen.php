<?php
require_once "database-handler.php";
session_start();

$db = new DatabaseHandler();
$elections = $db->SelectElections();

$electionId = isset($_GET["electionId"]) ? (int)$_GET["electionId"] : null;

$selectedElection = null;

foreach ($elections as $election) {
    if ((int)$election["id"] === $electionId) {
        $selectedElection = $election;
        break;
    }
}

if (!$selectedElection && count($elections) > 0) {
    $selectedElection = $elections[0];
    $electionId = (int)$selectedElection["id"];
}

$parties = [];
if ($electionId) {
    $parties = $db->SelectPartiesByElection($electionId);
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Neutraal KiesLab - Partijen</title>
    <link rel="stylesheet" href="style/styles.css">
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css?family=Inter">
    <script src="scripts/parties.js" defer></script>
    <link rel="icon" type="image/svg" href="assets/logo-neutraal-kieslab-lichtblauw.svg">
</head>
<body>
    <nav>
        <a href="index.php">
            <img class="logo" src="assets/logo-met-text-rechts.svg" alt="Neutraal KiesLab Logo">
        </a>
        <div>
            <button class="parties">Partijen</button>
            <?php if (isset($_SESSION['user_id'])): ?>
                <button class="login">Welkom, <?= htmlspecialchars($_SESSION['name']) ?></button>
                <button class="register" onclick="window.location.href='logout.php'">Uitloggen</button>
            <?php else: ?>
                <button class="login" onclick="window.location.href='login.php'">Inloggen</button>
                <button class="register" onclick="window.location.href='register.php'">Registreren</button>
            <?php endif; ?>
        </div>
    </nav>
    <main>
        <section class="parties-hero">
            <h1>Politieke Partijen</h1>
            <p>Bekijk welke partijen deelnemen aan verschillende verkiezingen</p>
            <div class="search-container">
                <button class="dropdown">
                    <p class="dropdown-text">
                        <?= htmlspecialchars($selectedElection["name"] ?? "Selecteer verkiezing") ?>
                    </p>
                    <img src="assets/icon-dropdown.svg" alt="Dropdown arrow">
                </button>
                <div class="dropdown-content">
                    <?php foreach ($elections as $election): ?>
                        <button
                            data-election-id="<?= $election['id']; ?>"
                            class="<?= ($election['id'] == $electionId) ? 'active' : '' ?>"
                        >
                            <?= htmlspecialchars($election['name']); ?>
                        </button>
                    <?php endforeach; ?>
                </div>
            </div>
        </section>
        <section class="parties-list">
            <?php if ($parties && count($parties) > 0): ?>
                <?php foreach ($parties as $party): ?>
                    <div class="party-card">
                        <div class="party-logo"></div>
                        
                        <h2>
                            <?= htmlspecialchars($party["name"]) ?>
                        </h2>

                        <p>
                            <?= htmlspecialchars($party["description"] ?? "Geen beschrijving") ?>
                        </p>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                <p>Geen partijen gevonden voor deze verkiezing.</p>
            <?php endif; ?>
    </section>
    </main>
    <footer>
        <p>&copy; 2026 Neutraal KiesLab. Alle rechten voorbehouden.</p>
    </footer>
</body>
</html>