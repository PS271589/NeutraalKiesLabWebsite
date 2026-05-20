const dropdownButton = document.querySelector('.dropdown');
const dropdownContent = document.querySelector('.dropdown-content');

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