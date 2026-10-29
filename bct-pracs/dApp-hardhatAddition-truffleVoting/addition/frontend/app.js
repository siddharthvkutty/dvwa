const CONTRACT_ADDRESS = "PASTE_DEPLOYED_ADDRESS";
const RPC_URL = "http://127.0.0.1:8545";
const ABI = ["function add(uint256 a, uint256 b) pure returns (uint256)"];

const contract = new ethers.Contract(
    CONTRACT_ADDRESS,
    ABI,
    new ethers.JsonRpcProvider(RPC_URL),
);
const $ = (id) => document.getElementById(id);

$("add").onclick = async () => {
    try {
        const r = await contract.add($("a").value, $("b").value);
        $("out").innerText = r.toString();
    } catch (e) {
        $("out").innerText = "Error: " + e.message;
    }
};
