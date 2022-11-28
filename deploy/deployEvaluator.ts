import {
  RANDOM_VAL_EV1,
  RANDOM_VAL_EV2,
  RANDOM_VAL_EV3,
} from "../config/randomVals";
import { PR, ADDRESS, PK } from "../config/config";
import { readFileSync, writeFile } from "fs";
import {
  defaultProvider,
  ec,
  Account,
  InvokeTransactionReceiptResponse,
} from "starknet";

import addresses from "../config/addresses.json";

const { getKeyPair } = ec;
async function main() {
  const compiledEvaluator = readFileSync(
    "./erc20/compiledContracts/compiled_Evaluator.json",
    "utf-8"
  );

  const starkPair = getKeyPair(PK);
  const acc = new Account(defaultProvider, ADDRESS, starkPair);

  // Deploy evaluator
  const declareEva = await acc.declare({
    classHash:
      "0x3b4fa0ab2432defc87da789ab09fe185dbfefd4ede710076d56478d77cd7907",
    contract: compiledEvaluator,
  });
  await acc.waitForTransaction(declareEva.transaction_hash);

  const deployEvaluator = await acc.deploy({
    classHash: declareEva.class_hash,
    salt: declareEva.transaction_hash,
    unique: false,
    constructorCalldata: [
      addresses.tutoken,
      PR,
      "3",
      addresses.meta,
      addresses.dtk,
    ],
  });
  await acc.waitForTransaction(deployEvaluator.transaction_hash);

  let evaReceipt = (await acc.getTransactionReceipt(
    deployEvaluator.transaction_hash
  )) as InvokeTransactionReceiptResponse;
  evaReceipt.events = evaReceipt.events ?? [];

  await acc.execute([
    {
      contractAddress: addresses.eva,
      entrypoint: "set_random_values",
      calldata: ["100", ...RANDOM_VAL_EV1, 0],
    },
    {
      contractAddress: addresses.eva,
      entrypoint: "set_random_values",
      calldata: ["100", ...RANDOM_VAL_EV2, 1],
    },
    {
      contractAddress: addresses.eva,
      entrypoint: "set_random_values",
      calldata: ["100", ...RANDOM_VAL_EV3, 2],
    },
    {
      contractAddress: addresses.eva,
      entrypoint: "finish_setup",
    },
    {
      contractAddress: PR,
      entrypoint: "set_exercise_or_admin",
      calldata: [addresses.eva, "1"],
    },
    {
      contractAddress: addresses.tutoken,
      entrypoint: "set_teachers",
      calldata: ["2", addresses.eva, ADDRESS],
    },
  ]);

  writeFile(
    "./config/addresses.json",
    JSON.stringify(addresses),
    function (err) {
      if (err) throw err;
    }
  );
}
main();
