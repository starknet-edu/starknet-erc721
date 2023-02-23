import subprocess, json
from utils import str_to_felt, felt_to_str

# Settings
network = "devnet"
account_addr = "0x33507ff2edf12c12c73d0b6d1d90de9fac12a355de1097ab305249612451919"
salt = 1234
tderc20_addr = "0x"
player_registry_addr = "0x"
dummytoken_addr = "0x"
tderc721_metadata_addr = "0x"
evaluator_addr = "0x"
pkey = ".pkey"
max_fee = "auto"

def run_command(cmd):
  out = subprocess.check_output(cmd.split(" "))
  return out.decode("utf-8")

def install():
  print("Installing OpenZeppelin/cairo-contracts...")
  run_command("protostar install OpenZeppelin/cairo-contracts@v0.6.0")
  return

# Build
def build(cairo_path):
  print("BUILDing...")
  run_command(f"protostar build --cairo-path {cairo_path}")
  return

# Test
def test():
  print("Testing...")
  run_command("protostar test")
  return

# Deploy TDERC20
def deploy_TDERC20(token_name_str, token_symbol_str):
  contract = "TDERC20"
  print("DECLARE " + contract)
  out = run_command(f"protostar -p {network} declare ./build/{contract}.json --account-address {account_addr} --private-key-path ./{pkey} --max-fee {max_fee} --wait-for-acceptance --json")

  print("DEPLOY " + contract)
  token_name = str_to_felt(token_name_str)
  token_symbol = str_to_felt(token_symbol_str)
  class_hash = json.loads(out)['class_hash']
  out = run_command(f"protostar -p {network} deploy {class_hash} --salt {salt} --account-address {account_addr} --private-key-path ./{pkey} --max-fee {max_fee} -i {token_name} {token_symbol} 0 0 {account_addr} {account_addr} --wait-for-acceptance --json")

  global tderc20_addr
  tderc20_addr = json.loads(out)['contract_address']
  print("tderc20_addr: " + tderc20_addr)
  return

# Deploy Players Registry
def deploy_players_registry():
  contract = "players_registry"
  print("DECLARE " + contract)
  out = run_command(f"protostar -p {network} declare ./build/{contract}.json --account-address {account_addr} --private-key-path ./{pkey} --max-fee {max_fee} --wait-for-acceptance --json")

  print("DEPLOY " + contract)
  class_hash = json.loads(out)['class_hash']
  out = run_command(f"protostar -p {network} deploy {class_hash} --salt {salt} --account-address {account_addr} --private-key-path ./{pkey} --max-fee {max_fee} -i {account_addr} --wait-for-acceptance --json")

  global player_registry_addr
  player_registry_addr = json.loads(out)['contract_address']
  print("player_registry_addr: " + player_registry_addr)
  return

# Deploy Dummy Token
def deploy_dummy_token(token_name_str, token_symbol_str):
  contract = "dummy_token"
  print("DECLARE " + contract)
  out = run_command(f"protostar -p {network} declare ./build/{contract}.json --account-address {account_addr} --private-key-path ./{pkey} --max-fee {max_fee} --wait-for-acceptance --json")

  print("DEPLOY " + contract)
  token_name = str_to_felt(token_name_str)
  token_symbol = str_to_felt(token_symbol_str)
  class_hash = json.loads(out)['class_hash']
  out = run_command(f"protostar -p {network} deploy {class_hash} --salt {salt} --account-address {account_addr} --private-key-path ./{pkey} --max-fee {max_fee} -i {token_name} {token_symbol} 100000000000000000000 0 {account_addr} --wait-for-acceptance --json")

  global dummytoken_addr
  dummytoken_addr = json.loads(out)['contract_address']
  print("dummytoken_addr: " + dummytoken_addr)
  return

# Deploy dummy ERC721
def deploy_erc721(token_name_str, token_symbol_str, token_metadata_urls, token_uri_suffix_str):
  contract = "TDERC721_metadata"
  print("DECLARE " + contract)
  out = run_command(f"protostar -p {network} declare ./build/{contract}.json --account-address {account_addr} --private-key-path ./{pkey} --max-fee {max_fee} --wait-for-acceptance --json")

  print("DEPLOY " + contract)
  token_name = str_to_felt(token_name_str)
  token_symbol = str_to_felt(token_symbol_str)
  new_token_metadata_urls = [str_to_felt(url) for url in token_metadata_urls]
  token_uri_suffix = str_to_felt(token_uri_suffix_str)

  class_hash = json.loads(out)['class_hash']
  out = run_command(f"protostar -p {network} deploy {class_hash} --salt {salt} --account-address {account_addr} --private-key-path ./{pkey} --max-fee {max_fee} -i {token_name} {token_symbol} {account_addr} 3 {new_token_metadata_urls[0]} {new_token_metadata_urls[1]} {new_token_metadata_urls[2]} {token_uri_suffix} --wait-for-acceptance --json")

  global tderc721_metadata_addr
  tderc721_metadata_addr = json.loads(out)['contract_address']
  print("tderc721_metadata_addr: " + tderc721_metadata_addr)
  return

# Deploy Evaluator
def deploy_evaluator():
  contract = "Evaluator"
  print("DECLARE " + contract)
  out = run_command(f"protostar -p {network} declare ./build/{contract}.json --account-address {account_addr} --private-key-path ./{pkey} --max-fee {max_fee} --wait-for-acceptance --json")

  print("DEPLOY " + contract)
  class_hash = json.loads(out)['class_hash']
  out = run_command(f"protostar -p {network} deploy {class_hash} --salt {salt} --account-address {account_addr} --private-key-path ./{pkey} --max-fee {max_fee} -i {tderc20_addr} {player_registry_addr} 3 {tderc721_metadata_addr} {dummytoken_addr} --wait-for-acceptance --json")

  global evaluator_addr
  evaluator_addr = json.loads(out)['contract_address']
  print("evaluator_addr: " + evaluator_addr)
  return

# Evaluator set_random_values
def evaluator_set_random_values(list_length, list, column):
  contract = "Evaluator"
  print("Invoke set_random_values on " + contract + " for column " + str(column))
  list_string = ' '.join(str(e) for e in list)
  run_command(f"protostar -p {network} invoke --contract-address {evaluator_addr} --function set_random_values --account-address {account_addr} --inputs {list_length} {list_string} {column} --private-key-path ./{pkey} --max-fee {max_fee} --wait-for-acceptance --json")
  return

# Evaluator finish setup
def evaluator_finish_setup():
  contract = "Evaluator"
  print("Invoke finish setup on " + contract)
  run_command(f"protostar -p {network} invoke --contract-address {evaluator_addr} --function finish_setup --account-address {account_addr} --private-key-path ./{pkey} --max-fee {max_fee} --wait-for-acceptance --json")
  return

# Set Evaluator as admin in ERC20
def set_evaluator_admin():
  print("set admin and teacher for Evaluator")
  run_command(f"protostar -p {network} invoke --contract-address {tderc20_addr} --function set_teacher --account-address {account_addr} --inputs {evaluator_addr} 1 --max-fee {max_fee} --private-key-path ./{pkey} --wait-for-acceptance --json")
  run_command(f"protostar -p {network} invoke --contract-address {player_registry_addr} --function set_exercise_or_admin --account-address {account_addr} --inputs {evaluator_addr} 1 --max-fee {max_fee} --private-key-path ./{pkey} --wait-for-acceptance --json")
  return

def print_all_contracts():
  print(f"Yo starknet fans, all contracts deployed successfully on {network}!")
  print("=================================================================================")
  print("tderc20_addr: ", tderc20_addr)
  print("player_registry_addr: ", player_registry_addr)
  print("dummytoken_addr: ", dummytoken_addr)
  print("tderc721_metadata_addr: ", tderc721_metadata_addr)
  print("evaluator_addr: ", evaluator_addr)
  print("=================================================================================")
  return

def deploy_all():
  # install()
  build('./lib/cairo_contracts/src')
  # test()
  deploy_TDERC20("ERC721-101", "ERC721-101")
  deploy_players_registry()
  deploy_dummy_token("DummyToken", "DTK")
  deploy_erc721("TDERC721", "TDERC721", ['https://gateway.pinata.cloud/ip', 'fs/QmWUB2TAYFrj1Uhvrgo69NDsycXf', 'bfznNURj1zVbzNTVZv/'], '.json')
  deploy_evaluator()
  evaluator_set_random_values(100, [2,7,4,8,7,6,1,7,6,5,4,8,8,5,6,3,8,2,8,6,5,7,3,1,8,6,7,3,6,8,1,7,3,8,2,3,4,5,2,5,7,3,3,4,4,4,5,8,1,7,1,5,7,1,3,2,5,7,8,8,7,1,8,4,1,6,2,1,6,6,4,7,2,1,2,3,5,1,3,8,6,5,5,2,7,8,4,6,4,5,4,6,1,6,4,5,3,5,8,3], 0)
  evaluator_set_random_values(100, [1,1,2,1,1,1,2,2,2,2,1,2,2,2,2,1,2,1,1,1,1,2,2,2,2,2,2,2,2,1,2,1,1,2,1,2,2,1,2,1,1,1,2,2,2,2,2,1,1,2,2,2,2,2,2,1,2,1,1,1,1,2,1,2,2,1,2,1,2,2,2,2,2,1,2,2,2,2,1,1,1,2,1,2,2,1,1,2,1,2,2,1,2,2,1,1,1,2,2,2],1)
  evaluator_set_random_values(100, [4,2,4,2,2,1,2,4,3,4,4,2,3,1,1,3,4,4,1,1,4,4,2,1,1,2,1,4,3,1,2,3,3,1,4,2,4,3,4,2,4,3,3,3,4,3,1,4,2,3,3,2,1,2,3,2,3,2,2,3,3,3,1,3,3,4,3,4,4,4,3,4,4,4,1,4,4,1,3,1,1,3,2,3,2,2,4,2,3,1,3,1,1,2,2,2,2,4,4,2],2)
  evaluator_finish_setup()
  set_evaluator_admin()
  print_all_contracts()

deploy_all()