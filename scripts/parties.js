const dropdownButton = document.getElementsByClassName('dropdown')[0];
const dropdownContent = document.getElementsByClassName('dropdown-content')[0];

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