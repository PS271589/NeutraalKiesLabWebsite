<?php
require_once "database-handler.php";
session_start();

$db = new DatabaseHandler();

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $email = $_POST["email"] ?? "";
    $password = $_POST["password"] ?? "";

    $user = $db->SelectUserByEmail($email);

    if ($user && password_verify($password, $user["password"])) {
    $_SESSION["user_id"] = $user["id"];
    $_SESSION["user_name"] = $user["name"];

    header("Location: index.php");
    exit();
}
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Neutraal KiesLab - Login</title>
    <link rel="stylesheet" href="style/styles.css">
    <script src="scripts/login.js" defer></script>
    <link rel="icon" type="image/svg" href="assets/logo-neutraal-kieslab-lichtblauw.svg">
</head>
<body>
    <div class="register-page">
        <button class="back-button">
            <img src="assets/icon-back-arrow.svg" alt="Back arrow">
            Terug naar Home
        </button>
        <div class="register-container">
            <img class="container-logo" src="assets/logo-met-text-rechts.svg" alt="Neutraal KiesLab Logo">
            <h1>Welkom terug</h1>
            <p>Log in om je opgeslagen resultaten te bekijken</p>
            <form action="login.php" method="post">
                <label for="email">E-mailadres</label>
                <input type="email" id="email" name="email" placeholder="voorbeeld@email.nl" required><br>

                <label for="password">Wachtwoord</label>
                <input type="password" id="password" name="password" placeholder="••••••••" required><br>

                <button type="submit" class="login-button">
                    <img src="assets/icon-login.svg" alt="Login icon">
                    Inloggen
                </button>
            </form>
            <p>Nog geen account? <a href="register.php">Registreer je hier</a></p>
        </div>
    </div>
</body>
</html>