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

                    <img src="assets/icon-dropdown.svg" alt="Dropdown arrow">
                </button>
                <div class="dropdown-content">
                    <button>Gemeenteraadsverkiezingen</button>
                    <button>Provinciale Statenverkiezingen</button>
                    <button>Waterschapsverkiezingen</button>
                    <button>Tweede Kamerverkiezingen</button>
                </div>
            </div>
        </section>
        <section class="parties-list">
            <div class="party-card">
                <div class="party-logo"></div>
                <h2>Partij A</h2>
                <p>Korte beschrijving van Partij A.</p>
            </div>
    </main>
    <footer>
        <p>&copy; 2026 Neutraal KiesLab. Alle rechten voorbehouden.</p>
    </footer>
</body>
</html>