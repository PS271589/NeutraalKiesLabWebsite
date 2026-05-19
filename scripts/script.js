const startButton = document.getElementsByClassName('start-button')[0];
const electionSelect = document.getElementsByClassName('election-select')[0];

startButton.addEventListener('click', () => {
    electionSelect.style.display = 'flex';
    startButton.style.display = 'none';
});