import { idOS } from "@idos-network/idos-sdk";
import { ethers } from "ethers";

const [originalCredentialId, granteeSignPk, granteeEncryptionPk] =
  ["original_credential_id", "grantee_sign_pk", "grantee_encryption_pk"]
    .map(name => document.querySelector(`[name=${name}]`).value);

const idos = await idOS.init({ container: "#idos-container" });

const provider = new ethers.BrowserProvider(window.ethereum);
await provider.send("wallet_switchEthereumChain", [{ chainId: idOS.evm.defaultChainId }]);
await provider.send("eth_requestAccounts", []);

const signer = await provider.getSigner();
await idos.setSigner("EVM", signer)

const { grant } = await idos.grants.create(
  "credentials",
  originalCredentialId,
  granteeSignPk,
  0,
  granteeEncryptionPk,
);

console.log(grant);

document.querySelector("[name=duplicate_credential_id]").value = grant.dataId;
document.querySelector("input[name=authorize]").disabled = false;
