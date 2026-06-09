const results = [
    {
        party: "PvdA",
        percentage: 80,
        color: "#070707"
    },

    {
        party: "SP",
        percentage: 70,
        color: "#070707"
    },

    {
        party: "GL",
        percentage: 60,
        color: "#070707"
    },

    {
        party: "D66",
        percentage: 50,
        color: "#070707"
    },

    {
        party: "PVV",
        percentage: 40,
        color: "#070707"
    },

    {
        party: "CDA",
        percentage: 30,
        color: "#070707"
    },

    {
        party: "VVD",
        percentage: 20,
        color: "#070707"
    }

];

results.sort((a, b) => b.percentage - a.percentage);

const bestParty =
    document.getElementById("bestParty");

const bestPercentage =
    document.getElementById("bestPercentage");

bestParty.textContent =
    results[0].party;

bestPercentage.textContent =
    results[0].percentage + "%";

const partyList =
    document.getElementById("partyList");

results.forEach((party, index) => {

    partyList.innerHTML += `

    <div class="party-row">

        <div class="party-top">

            <div class="party-info">

                <span class="rank">
                    ${index + 1}
                </span>

                <span>
                    ${party.party}
                </span>

            </div>

            <span>
                ${party.percentage}%
            </span>

        </div>

        <div class="progress">

            <div
                class="progress-fill"
                style="
                    width:${party.percentage}%;
                    background:${party.color};
                ">
            </div>

        </div>

    </div>

    `;
});