const answers = new Array(QUESTIONS.length).fill(null);
let currentIndex = 0;

const elCurrentQuestion = document.getElementById("current-question");
const elTotalQuestions  = document.getElementById("total-questions");
const elProgressPercent = document.getElementById("progress-percent");
const elProgressFill    = document.getElementById("progress-fill");
const elCategory        = document.getElementById("question-category");
const elQuestionText    = document.getElementById("question-text");
const elBtnBack         = document.getElementById("btn-back");
const elBtnNext         = document.getElementById("btn-next");
const answerButtons     = document.querySelectorAll(".antwoord-btn");

function renderQuestion() {
    const question = QUESTIONS[currentIndex];

    elCurrentQuestion.textContent = currentIndex + 1;
    elQuestionText.textContent    = question.question;

    // The DB has no category column; hide the pill if there's nothing to show
    elCategory.style.display = "none";

    // Progress: based on how many questions have been answered
    const answered = answers.filter(a => a !== null).length;
    const percent  = Math.ceil((answered / QUESTIONS.length) * 100);
    elProgressFill.style.width  = percent + "%";
    elProgressPercent.textContent = percent + "%";

    // Highlight the previously selected answer for this question (if any)
    answerButtons.forEach(btn => {
        btn.classList.toggle("selected", parseInt(btn.dataset.value) === answers[currentIndex]);
    });

    // Back button: enabled when not on the first question
    if (currentIndex > 0) {
        elBtnBack.classList.remove("disabled");
        elBtnBack.querySelector("img").src = "assets/icon-next-arrow.svg";
    } else {
        elBtnBack.classList.add("disabled");
        elBtnBack.querySelector("img").src = "assets/icon-next-arrow-disabled.svg";
    }

    // Next button: enabled when the current question has been answered
    // and it's not the last question
    const hasAnswer    = answers[currentIndex] !== null;
    const isLast       = currentIndex === QUESTIONS.length - 1;

    if (hasAnswer && !isLast) {
        elBtnNext.classList.remove("disabled");
        elBtnNext.querySelector("img").src = "assets/icon-next-arrow.svg";
    } else {
        elBtnNext.classList.add("disabled");
        elBtnNext.querySelector("img").src = "assets/icon-next-arrow-disabled.svg";
    }
}

// Answer buttons
answerButtons.forEach(btn => {
    btn.addEventListener("click", () => {
        answers[currentIndex] = parseInt(btn.dataset.value);
        renderQuestion();

        // Auto-advance to the next question after a short delay,
        // unless we're on the last question
        if (currentIndex < QUESTIONS.length - 1) {
            setTimeout(() => {
                currentIndex++;
                renderQuestion();
            }, 300);
        }
    });
});

// Back button
elBtnBack.addEventListener("click", () => {
    if (currentIndex > 0) {
        currentIndex--;
        renderQuestion();
    }
});

// Next button
elBtnNext.addEventListener("click", () => {
    if (currentIndex < QUESTIONS.length - 1 && answers[currentIndex] !== null) {
        currentIndex++;
        renderQuestion();
    }
});

// Initial render
renderQuestion();