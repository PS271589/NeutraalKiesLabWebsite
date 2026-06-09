//homepage buttons
const startButton = document.getElementsByClassName('start-button')[0];
const electionSelect = document.getElementsByClassName('election-select')[0];
const loginButton = document.getElementsByClassName('login')[0];
const registerButton = document.getElementsByClassName('register')[0];
const partiesButton = document.getElementsByClassName('parties')[0];

if (partiesButton) {
    partiesButton.addEventListener('click', () => {
        window.location.href = 'partijen.php';
    });
}

if (loginButton) {
    loginButton.addEventListener('click', () => {
        window.location.href = 'login.php';
    });
}

if (registerButton) {
    registerButton.addEventListener('click', () => {
        window.location.href = 'register.php';
    });
}

if (startButton) {
    startButton.addEventListener('click', () => {
        if (electionSelect) electionSelect.style.display = 'flex';
        startButton.style.display = 'none';
    });
}