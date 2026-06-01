const dropdownButton = document.getElementsByClassName('dropdown')[0];
const dropdownContent = document.getElementsByClassName('dropdown-content')[0];
const loginButton = document.getElementsByClassName('login')[0];
const registerButton = document.getElementsByClassName('register')[0];
const partiesButton = document.getElementsByClassName('parties')[0];

document.querySelectorAll(".dropdown-content button").forEach(btn => {
    btn.addEventListener("click", (e) => {
        e.stopPropagation();
        window.location.href = `?electionId=${btn.dataset.electionId}`;
    });
});

if (dropdownButton) {
    dropdownButton.addEventListener('click', (e) => {
        e.stopPropagation();
        const isOpen = dropdownContent.style.display === 'block';
        dropdownContent.style.display = isOpen ? 'none' : 'block';
    });
}

document.addEventListener('click', () => {
    if (dropdownContent) dropdownContent.style.display = 'none';
});

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