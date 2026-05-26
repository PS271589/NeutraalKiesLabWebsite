const dropdownButton = document.getElementsByClassName('dropdown')[0];
const dropdownContent = document.getElementsByClassName('dropdown-content')[0];
const loginButton = document.getElementsByClassName('login')[0];
const registerButton = document.getElementsByClassName('register')[0];
const partiesButton = document.getElementsByClassName('parties')[0];

dropdownButton.addEventListener('click', (e) => {
    e.stopPropagation();

    dropdownContent.style.display =
        dropdownContent.style.display === 'block'
            ? 'none'
            : 'block';
});

document.addEventListener('click', (e) => {
    const clickedInsideDropdown =
        dropdownButton.contains(e.target) ||
        dropdownContent.contains(e.target);

    if (!clickedInsideDropdown) {
        dropdownContent.style.display = 'none';
    }
});

dropdownContent.addEventListener('click', () => {
    dropdownContent.style.display = 'none';
});

partiesButton.addEventListener('click', () => {
    window.location.href = 'partijen.php';
});

loginButton.addEventListener('click', () => {
    window.location.href = 'login.php';
});

registerButton.addEventListener('click', () => {
    window.location.href = 'register.php';
});