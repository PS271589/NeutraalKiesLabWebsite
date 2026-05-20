<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Neutraal KiesLab - Register</title>
    <link rel="stylesheet" href="style/styles.css">
</head>
<body>
    <div class="register-container">
        <h1>Account aanmaken</h1>
        <p>Bewaar je resultaten en bekijk ze later terug</p>
        <form action="register.php" method="post">
            <label for="username">Naam</label>
            <input type="text" id="username" name="username" required><br>

            <label for="email">E-mailadres</label>
            <input type="email" id="email" name="email" required><br>

            <label for="password">Wachtwoord:</label>
            <input type="password" id="password" name="password" required><br>

            <label for="confirm_password">Bevestig wachtwoord:</label>
            <input type="password" id="confirm_password" name="confirm_password" required><br>

            <input type="submit" value="Register">
        </form>
        <p>Al een account? <a href="login.php">Log hier in</a></p>
    </div>
</body>
</html>