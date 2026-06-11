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

function submitResults() {
    const form = document.createElement("form");
    form.method = "POST";
    form.action = "Result.php";

    const electionInput = document.createElement("input");
    electionInput.type  = "hidden";
    electionInput.name  = "election_id";
    electionInput.value = ELECTION_ID;
    form.appendChild(electionInput);

    const answersInput  = document.createElement("input");
    answersInput.type   = "hidden";
    answersInput.name   = "answers";
    answersInput.value  = JSON.stringify(
        QUESTIONS.map((q, i) => ({ question_id: q.id, answer: answers[i] }))
    );
    form.appendChild(answersInput);

    document.body.appendChild(form);
    form.submit();
}

function renderQuestion() {
    const question = QUESTIONS[currentIndex];

    elCurrentQuestion.textContent = currentIndex + 1;
    elQuestionText.textContent    = question.question;
    elCategory.style.display      = "none";

    const answered = answers.filter(a => a !== null).length;
    const percent  = Math.ceil((answered / QUESTIONS.length) * 100);
    elProgressFill.style.width    = percent + "%";
    elProgressPercent.textContent = percent + "%";

    answerButtons.forEach(btn => {
        btn.classList.toggle("selected", parseInt(btn.dataset.value) === answers[currentIndex]);
    });

    // Back button
    if (currentIndex > 0) {
        elBtnBack.classList.remove("disabled");
        elBtnBack.querySelector("img").src = "assets/icon-next-arrow.svg";
    } else {
        elBtnBack.classList.add("disabled");
        elBtnBack.querySelector("img").src = "assets/icon-next-arrow-disabled.svg";
    }

    // Next button: only when answered and not last question
    const hasAnswer = answers[currentIndex] !== null;
    const isLast    = currentIndex === QUESTIONS.length - 1;

    if (hasAnswer && !isLast) {
        elBtnNext.classList.remove("disabled");
        elBtnNext.querySelector("img").src = "assets/icon-next-arrow.svg";
    } else {
        elBtnNext.classList.add("disabled");
        elBtnNext.querySelector("img").src = "assets/icon-next-arrow-disabled.svg";
    }
}

answerButtons.forEach(btn => {
    btn.addEventListener("click", () => {
        answers[currentIndex] = parseInt(btn.dataset.value);
        renderQuestion();

        const isLast = currentIndex === QUESTIONS.length - 1;

        if (isLast) {
            // Small delay so the selected state is visible before redirect
            setTimeout(submitResults, 400);
        } else {
            setTimeout(() => {
                currentIndex++;
                renderQuestion();
            }, 300);
        }
    });
});

elBtnBack.addEventListener("click", () => {
    if (currentIndex > 0) {
        currentIndex--;
        renderQuestion();
    }
});

elBtnNext.addEventListener("click", () => {
    if (currentIndex < QUESTIONS.length - 1 && answers[currentIndex] !== null) {
        currentIndex++;
        renderQuestion();
    }
});

renderQuestion();