import * as fs from "fs/promises";
import * as path from "path";

const writeAbi = async () => {
  const folders = [
    "CyberAccountFactory.sol/CyberAccountFactory.json",
    "CyberEngine.sol/CyberEngine.json",
    "Content.sol/Content.json",
    "Essence.sol/Essence.json",
    "MiddlewareManager.sol/MiddlewareManager.json",
    "Soul.sol/Soul.json",
    "Subscribe.sol/Subscribe.json",
    "W3st.sol/W3st.json",
    "PermissionMw.sol/PermissionMw.json",
    "TokenReceiver.sol/TokenReceiver.json",
    "CyberVault.sol/CyberVault.json",
    "CyberVaultV2.sol/CyberVaultV2.json",
    "CyberVaultV3.sol/CyberVaultV3.json",
    "ECDSAValidator.sol/ECDSAValidator.json",
    "LaunchTokenPool.sol/LaunchTokenPool.json",
    "CyberStakingPool.sol/CyberStakingPool.json",
    "GasBridge.sol/GasBridge.json",
    "CyberNewEraGate.sol/CyberNewEraGate.json",
    "CyberNewEra.sol/CyberNewEra.json",
    "CyberNFTGate.sol/CyberNFTGate.json",
    "CyberProjectNFTV2.sol/CyberProjectNFTV2.json",
    "CyberRelayGate.sol/CyberRelayGate.json",
    "CyberNFT.sol/CyberNFT.json",
    "CyberNFTV2.sol/CyberNFTV2.json",
    "CyberMintNFTRelayHook.sol/CyberMintNFTRelayHook.json",
    "CyberIDPermissionedRelayHook.sol/CyberIDPermissionedRelayHook.json",
    "RafTokenReceiver.sol/RafTokenReceiver.json",
  ];
  const ps = folders.map(async (file) => {
    const f = await fs.readFile(path.join("./out", file), "utf8");
    const json = JSON.parse(f);
    const fileName = path.parse(file).name;
    return fs.writeFile(
      path.join("docs/abi", `${fileName}.json`),
      JSON.stringify(json.abi)
    );
  });
  await Promise.all(ps);
};

const main = async () => {
  await writeAbi();
};

main()
  .then(() => {})
  .catch((err) => {
    console.error(err);
  });
