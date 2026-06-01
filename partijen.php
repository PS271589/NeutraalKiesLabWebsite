<?php
require_once "database-handler.php";

$db = new DatabaseHandler();
$elections = $db->SelectElections();

$electionId = $_GET["electionId"] ?? null;

$selectedElection = null;

if (!$electionId && count($elections) > 0) {
    $selectedElection = $elections[0];
    $electionId = $selectedElection["id"];
} else {
    foreach ($elections as $election) {
        if ($election["id"] == $electionId) {
            $selectedElection = $election;
            break;
        }
    }
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
    <title>Neutraal KiesLab - Home</title>
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
            <button class="login">Inloggen</button>
            <button class="register">Registreren</button>
        </div>
    </nav>
    <main>
        <section class="parties-hero">
            <h1>Politieke Partijen</h1>
            <p>Bekijk welke partijen deelnemen aan verschillende verkiezingen</p>
            <div class="search-container">
                <p>Selecteer verkiezing:</p>
                <button class="dropdown">
                    <?= htmlspecialchars($selectedElection["name"] ?? "Selecteer verkiezing") ?>
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