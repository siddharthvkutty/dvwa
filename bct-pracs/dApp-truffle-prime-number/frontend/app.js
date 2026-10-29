const contractAddress = "PASTE_CONTRACT_ADDRESS_HERE";
const contractABI = [
    {
        // same as the isPrime entry in build/contracts/Prime.json
        type: "function",
        name: "isPrime",
        stateMutability: "pure",
        inputs: [{ internalType: "uint256", name: "num", type: "uint256" }],
        outputs: [{ internalType: "string", name: "", type: "string" }],
    },
];

async function checkPrime() {
    if (!window.ethereum) return alert("Please install MetaMask!");
    try {
        await ethereum.request({ method: "eth_requestAccounts" });
        const contract = new new Web3(ethereum).eth.Contract(
            contractABI,
            contractAddress,
        );
        const n = document.getElementById("n").value;
        if (n === "") return alert("Please enter a number.");
        document.getElementById("result").innerText = await contract.methods
            .isPrime(n)
            .call();
    } catch (e) {
        alert("Error: " + e.message);
    }
}
