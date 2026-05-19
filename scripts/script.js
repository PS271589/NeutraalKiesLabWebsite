//homepage buttons
const startButton = document.getElementsByClassName('start-button')[0];
const electionSelect = document.getElementsByClassName('election-select')[0];
const loginButton = document.getElementsByClassName('login')[0];
const registerButton = document.getElementsByClassName('register')[0];

loginButton.addEventListener('click', () => {
    window.location.href = 'login.php';
});

registerButton.addEventListener('click', () => {
    window.location.href = 'register.php';
});

startButton.addEventListener('click', () => {
    electionSelect.style.display = 'flex';
    startButton.style.display = 'none';
});