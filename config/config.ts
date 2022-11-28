import * as dotenv from "dotenv";

dotenv.config({ path: `${__dirname}/.env` });
export const PK = process.env.PK?.toLowerCase() || "";
export const ADDRESS = process.env.ADDRESS?.toLowerCase() || "";
export const PR = process.env.PR?.toLowerCase() || "";
