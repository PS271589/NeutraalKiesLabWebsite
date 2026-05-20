<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Neutraal KiesLab - Register</title>
    <link rel="stylesheet" href="style/styles.css">
    <script src="scripts/register.js" defer></script>
</head>
<body>
    <div class="register-page">
        <button class="back-button">
            <img src="assets/icon-back-arrow.svg" alt="Back arrow">
            Terug naar Home
        </button>
        <div class="register-container">
            <img class="container-logo" src="assets/logo-met-text-rechts.svg" alt="Neutraal KiesLab Logo">
            <h1>Account aanmaken</h1>
            <p>Bewaar je resultaten en bekijk ze later terug</p>
            <form action="register.php" method="post">
                <label for="username">Naam</label>
                <input type="text" id="username" name="username" placeholder="Jouw naam" required><br>

                <label for="email">E-mailadres</label>
                <input type="email" id="email" name="email" placeholder="voorbeeld@email.nl" required><br>

                <label for="password">Wachtwoord:</label>
                <input type="password" id="password" name="password" placeholder="Minimaal 6 karakters" required><br>

                <label for="confirm_password">Bevestig wachtwoord:</label>
                <input type="password" id="confirm_password" name="confirm_password" placeholder="Herhaal je wachtwoord" required><br>

                <button type="submit" class="register-button">
                    <img src="assets/icon-register.svg" alt="Register icon">
                    Registreren
                </button>
            </form>
            <p>Al een account? <a href="login.php">Log hier in</a></p>
        </div>
    </div>
</body>
</html>