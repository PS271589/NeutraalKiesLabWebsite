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
        <a href="Vragenlijst.html">
            <img class="logo" src="assets/logo-met-text-rechts.svg" alt="Neutraal KiesLab Logo">
        </a>
    </nav>

    <section class="progress-container">

        <div class="progress-vragen">
            <p>Vraag 0 van 20</p>
        </div>
        <div class="progress-procent">
            <p>0%</p>
        </div>

        <div class="progress-bar">
            <div class="progress-fill"></div>
        </div>

    </section>

    <main class="question-section">

        <div class="category">
            Hier komt de categorie te staan
        </div>

        <h1 class="question">
            Hier komt de vraag te staan
        </h1>

        <div class="antwoorden">

            <button class="antwoord-btn">
                Oneens
            </button>

            <button class="antwoord-btn">
                Neutraal
            </button>

            <button class="antwoord-btn">
                Eens
            </button>
        </div>

    </main>

    <footer class="footer-nav">

        <button class="footer-btn">
            ← Terug
        </button>
        <button class="footer-btn">
            Volgende →
        </button>
    </footer>
    <script src="script/Vragenlijst.js"></script>
</body>

</html>