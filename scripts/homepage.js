//homepage buttons
const startButton = document.querySelector('.start-button');
const electionSelect = document.querySelector('.election-select');
const loginButton = document.querySelector('.login');
const registerButton = document.querySelector('.register');
const partiesButton = document.querySelector('.parties');

partiesButton.addEventListener('click', () => {
    window.location.href = 'partijen.html';
});

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