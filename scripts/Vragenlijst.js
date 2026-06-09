const questions = [

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 1"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 2"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 3"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 4"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 5"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 6"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 7"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 8"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 9"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 10"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 11"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 12"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 13"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 14"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 15"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 16"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 17"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 18"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 19"
    },

    {
        category: "Hier komt categorie",
        question: "Hier komt vraag 20"
    }

];

let currentQuestion = 0;

const category = document.querySelector(".category");
const question = document.querySelector(".question");
const vraagText = document.querySelector(".progress-vragen p");
const procentText = document.querySelector(".progress-procent p");
const progressFill = document.querySelector(".progress-fill");
const antwoordBtns = document.querySelectorAll(".antwoord-btn");
const footerButtons = document.querySelectorAll(".footer-btn");

const terugBtn = footerButtons[0];
const volgendeBtn = footerButtons[1];

function updateQuestion() {
    category.textContent = questions[currentQuestion].category;
    question.textContent = questions[currentQuestion].question;
    vraagText.textContent = `Vraag ${currentQuestion + 1} van ${questions.length}`;

    const percentage = Math.round(((currentQuestion + 1) / questions.length) * 100);
    procentText.textContent = `${percentage}%`;
    progressFill.style.width = `${percentage}%`;

    if (currentQuestion === questions.length - 1) {
        volgendeBtn.textContent = "Bekijk resultaat";
    } else {
        volgendeBtn.textContent = "Volgende →";
    }
}

function nextQuestion() {
    if (currentQuestion < questions.length - 1) {
        currentQuestion++;
        updateQuestion();
    } else {
        window.location.href = "../Result/Result.html";
    }
}

antwoordBtns.forEach(button => {
    button.addEventListener("click", () => {
        nextQuestion();
    });
});

volgendeBtn.addEventListener("click", () => {
    nextQuestion();
});

terugBtn.addEventListener("click", () => {
    if (currentQuestion > 0) {
        currentQuestion--;
        updateQuestion();
    }
});

updateQuestion();