const contractAddress = "PASTE_CONTRACT_ADDRESS_HERE";
const contractABI = [
    {
        type: "function",
        name: "add",
        stateMutability: "pure",
        inputs: [
            { internalType: "uint256", name: "a", type: "uint256" },
            { internalType: "uint256", name: "b", type: "uint256" },
        ],
        outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
    },
];

async function addition() {
    try {
        await window.ethereum.request({ method: "eth_requestAccounts" }); // connect MetaMask
        const contract = new new Web3(window.ethereum).eth.Contract(
            contractABI,
            contractAddress,
        );
        const n1 = document.getElementById("n1").value,
            n2 = document.getElementById("n2").value;
        if (n1 === "" || n2 === "") return alert("Please enter both numbers.");
        document.getElementById("result").innerText = await contract.methods
            .add(n1, n2)
            .call();
    } catch (error) {
        alert("Error: " + error.message);
    }
}
