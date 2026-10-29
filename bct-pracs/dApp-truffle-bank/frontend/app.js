const BANK_ADDRESS = "PASTE_DEPLOYED_BANK_ADDRESS";
const BANK_ABI = [
    // only the four functions the page uses (same as the ABI in build/contracts/Bank.json)
    {
        type: "function",
        name: "deposit",
        stateMutability: "payable",
        inputs: [],
        outputs: [],
    },
    {
        type: "function",
        name: "withdraw",
        stateMutability: "nonpayable",
        inputs: [{ name: "amount", type: "uint256" }],
        outputs: [],
    },
    {
        type: "function",
        name: "transfer",
        stateMutability: "nonpayable",
        inputs: [
            { name: "receiver", type: "address" },
            { name: "amount", type: "uint256" },
        ],
        outputs: [],
    },
    {
        type: "function",
        name: "showBalance",
        stateMutability: "view",
        inputs: [],
        outputs: [{ name: "", type: "uint256" }],
    },
];

let web3, bank, user;
const $ = (id) => document.getElementById(id);
const wei = (id) => web3.utils.toWei($(id).value, "ether"); // ETH box -> wei

async function connect() {
    // connect MetaMask
    [user] = await ethereum.request({ method: "eth_requestAccounts" });
    web3 = new Web3(ethereum);
    bank = new web3.eth.Contract(BANK_ABI, BANK_ADDRESS);
    $("account").innerText = user;
    getBalance();
}
async function getBalance() {
    // show bank balance
    $("balance").innerText = web3.utils.fromWei(
        await bank.methods.showBalance().call({ from: user }),
        "ether",
    );
}
async function send(txn, status, value) {
    // send transaction, refresh, show status
    await txn.send({ from: user, value });
    await getBalance();
    $("status").innerText = status;
}

$("connectButton").onclick = connect;
$("refreshButton").onclick = getBalance;
$("depositButton").onclick = () =>
    send(bank.methods.deposit(), "Deposit successful!", wei("depositAmount"));
$("withdrawButton").onclick = () =>
    send(
        bank.methods.withdraw(wei("withdrawAmount")),
        "Withdrawal successful!",
    );
$("transferButton").onclick = () =>
    send(
        bank.methods.transfer($("receiver").value, wei("transferAmount")),
        "Transfer successful!",
    );
