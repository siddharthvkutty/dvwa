const ADDRESS = "PASTE_DEPLOYED_ADDRESS";
const ABI = [
    {
        type: "function",
        name: "candidateCount",
        stateMutability: "view",
        inputs: [],
        outputs: [{ type: "uint256" }],
    },
    {
        type: "function",
        name: "addCandidate",
        stateMutability: "nonpayable",
        inputs: [{ name: "_name", type: "string" }],
        outputs: [],
    },
    {
        type: "function",
        name: "vote",
        stateMutability: "nonpayable",
        inputs: [{ name: "_id", type: "uint256" }],
        outputs: [],
    },
    {
        type: "function",
        name: "getCandidate",
        stateMutability: "view",
        inputs: [{ name: "_id", type: "uint256" }],
        outputs: [{ type: "uint256" }, { type: "string" }, { type: "uint256" }],
    },
];

let contract, user;
const $ = (id) => document.getElementById(id);

async function load() {
    // list candidates with vote counts
    const n = Number(await contract.methods.candidateCount().call());
    $("list").innerHTML = "";
    for (let i = 1; i <= n; i++) {
        const c = await contract.methods.getCandidate(i).call();
        const li = document.createElement("li");
        li.innerHTML = `${c[1]} – ${c[2]} votes `;
        const b = document.createElement("button");
        b.textContent = "Vote";
        b.onclick = () => run(contract.methods.vote(i), "Vote cast!");
        li.appendChild(b);
        $("list").appendChild(li);
    }
}
async function run(txn, ok) {
    // send tx, report, reload
    try {
        await txn.send({ from: user });
        $("status").innerText = ok;
        await load();
    } catch (e) {
        $("status").innerText = "Error: " + e.message;
    }
}
$("addBtn").onclick = () =>
    run(contract.methods.addCandidate($("name").value), "Candidate added!");

(async () => {
    [user] = await ethereum.request({ method: "eth_requestAccounts" });
    contract = new new Web3(ethereum).eth.Contract(ABI, ADDRESS);
    load();
})();
