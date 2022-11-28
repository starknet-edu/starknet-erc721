import {
  RANDOM_VAL_EV1,
  RANDOM_VAL_EV2,
  RANDOM_VAL_EV3,
} from "../config/randomVals";
import { PR, ADDRESS, PK } from "./../config/config";
import { readFileSync, writeFile } from "fs";
import {
  ec,
  Account,
  Provider,
  InvokeTransactionReceiptResponse,
} from "starknet";
const { getKeyPair } = ec;

async function main() {
  // Load contracts
  const compiledTutoken = readFileSync("build/TDERC20.json", "utf-8");
  const compiledDTK = readFileSync("build/dummy_token.json", "utf-8");
  const compiledMetadata = readFileSync(
    "build/TDERC721_metadata.json",
    "utf-8"
  );
  const compiledEvaluator = readFileSync("build/Evaluator.json", "utf-8");

  const provider = new Provider({
    sequencer: { baseUrl: "https://alpha4-2.starknet.io" },
  });
  // Get key pair and load account
  const starkPair = getKeyPair(PK);
  // To deploy on other network change the provider
  const acc = new Account(provider, ADDRESS, starkPair);

  // Deploy tutorial token
  const declareTutoken = await acc.declare({
    classHash:
      "0x1b2779de83e0fc7271929d19b1d09fbf23c2da0d10fa058d5ab8a8e1667d11c",
    contract: compiledTutoken,
  });
  await acc.waitForTransaction(declareTutoken.transaction_hash);

  const deployTutoken = await acc.deploy({
    classHash: declareTutoken.class_hash,
    salt: declareTutoken.transaction_hash,
    unique: false,
    constructorCalldata: [
      "327360763727160756219953",
      "327360763727160756219953",
      "0",
      "0",
      ADDRESS,
      ADDRESS,
    ],
  });

  await acc.waitForTransaction(deployTutoken.transaction_hash);
  let tutokenReceipt = (await acc.getTransactionReceipt(
    deployTutoken.transaction_hash
  )) as InvokeTransactionReceiptResponse;
  tutokenReceipt.events = tutokenReceipt.events ?? [];

  const addresses: any = { tutoken: tutokenReceipt.events[1].data[0] };

  // Deploy dummy token

  const declareDtk = await acc.declare({
    classHash:
      "0x2c2f4dd613f6171cef8aaca72903df92702781bbeaebbdba1edcca0e46b0f89",
    contract: compiledDTK,
  });
  await acc.waitForTransaction(declareDtk.transaction_hash);

  const deployDtk = await acc.deploy({
    classHash: declareDtk.class_hash,
    salt: declareDtk.transaction_hash,
    unique: false,
    constructorCalldata: [
      "90997221901889128397906381721202537008",
      "293471990320",
      "100000000000000000000",
      "0",
      ADDRESS,
    ],
  });

  await acc.waitForTransaction(deployDtk.transaction_hash);
  let dtkReceipt = (await acc.getTransactionReceipt(
    deployDtk.transaction_hash
  )) as InvokeTransactionReceiptResponse;
  dtkReceipt.events = dtkReceipt.events ?? [];

  addresses.dtk = dtkReceipt.events[1].data[0];

  // Deploy metadata
  const declareMeta = await acc.declare({
    classHash:
      "0x7284f12128428b8017fcf87db73d03e192d74b3f7058b06b15e32aff87c97eb",
    contract: compiledMetadata,
  });
  await acc.waitForTransaction(declareMeta.transaction_hash);

  const deployMeta = await acc.deploy({
    classHash: declareMeta.class_hash,
    salt: declareMeta.transaction_hash,
    unique: false,
    constructorCalldata: [
      "6072054417219596849", // TDERC721
      "6072054417219596849", // TDERC721
      ADDRESS, // First teacher address
      "3", // array size
      "184555836509371486644298270517380613565396767415278678887948391494588524912", // https://gateway.pinata.cloud/ip
      "181013377130045435659890581909640190867353010602592517226438742938315085926", // fs/QmWUB2TAYFrj1Uhvrgo69NDsycXf
      "2194400143691614193218323824727442803459257903", // bfznNURj1zVbzNTVZv/
      "199354445678", // .json
    ],
  });

  await acc.waitForTransaction(deployMeta.transaction_hash);
  let metaReceipt = (await acc.getTransactionReceipt(
    deployMeta.transaction_hash
  )) as InvokeTransactionReceiptResponse;
  metaReceipt.events = metaReceipt.events ?? [];

  addresses.meta = dtkReceipt.events[1].data[0];

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

  addresses.eva = evaReceipt.events[0].data[0];
  console.log(addresses);
  // Save addresses
  writeFile(
    "./config/addresses.json",
    JSON.stringify(addresses),
    function (err) {
      if (err) throw err;
    }
  );

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
}
main();
