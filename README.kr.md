# ****ERC721 on StarkNet****

환영합니다! 이 워크샵에서는 StarkNet에 ERC721 토큰을 배포하고 특정 기능을 수행하도록 사용자 지정하는 방법에 대해 설명합니다. ERC721 표준은 [여기](https://docs.openzeppelin.com/contracts/3.x/api/token/erc721)에 설명되어 있습니다. 아래와 같은 조건을 가진 개발자들을 대상으로 합니다:

- 카이로 문법을 이해하는 개발자
- ERC721 토큰 표준을 이해하는 개발자

## 개요

### 면책조항

이더리움 메인넷의 첫 번째 범용 유효성 롤업인 StarkNet을 배우는 것 외에는 이것을 사용함으로써 얻을 수 있는 혜택을 기대하지 마세요.

StarkNet은 여전히 알파 버전입니다. 개발이 진행 중이고, 곳곳에 페인트가 마르지 않았다는 의미입니다. 지속적으로 나아질 것이며, 동시에 조금씩 박스 테이프로 수정해 나갈 겁니다!

### 진행방식

이 튜토리얼의 목표는 StarkNet에서 ERC721 컨트랙트를 사용자 정의하고 배포하는 것입니다. 진행 상황은 StarkNet에 배치된 [Evaluator 컨트랙트](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo)에 의해 확인되며, [ERC20 토큰](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/token/ERC20/TDERC20.cairo) 형태로 된 포인트를 부여합니다.

각 과제에서는 당신의 ERC721 토큰에 기능을 추가해야 합니다.

각 과제에 대하여, 당신의 컨트랙트에 새 버전을 작성하고, 배포한 후, 확인/수정하기 위해 Evaluator에게 제출해야 합니다.

### 여기가 어디죠?

이 워크샵은 StarkNet에 빌드하는 방법을 가르치는 것을 목표로 한 시리즈 중 두 번째 워크샵입니다. 

다음을 확인하세요:

| 주제 | GitHub repo |
| --- | --- |
| 카이로 코드 읽는 방법 배우기 | [Cairo 101](https://github.com/starknet-edu/starknet-cairo-101)  |
| ERC721 NFT 배포 및 사용자 지정하기 (당신은 여기 있습니다). | [StarkNet ERC721](https://github.com/starknet-edu/starknet-erc721) |
| ERC20 토큰 배포 및 사용자 지정하기 | [StarkNet ERC20](https://github.com/starknet-edu/starknet-erc20) |
| 교차 레이어 애플리케이션 구축하기 | [StarkNet messaging bridge](https://github.com/starknet-edu/starknet-messaging-bridge) |
| 카이로 컨트랙트 쉽게 오류 검출하기 | [StarkNet debug](https://github.com/starknet-edu/starknet-debug) |
| 자신만의 계정 컨트랙트 디자인하기 | [StarkNet account abstraction](https://github.com/starknet-edu/starknet-accounts) |

### 피드백 제공 및 도움 받기

이 튜토리얼을 완료하고 피드백을 주시면 감사하겠습니다.

[이 양식](https://forms.reform.app/starkware/untitled-form-4/kaes2e)을 작성하여 더 나은 서비스를 제공하기 위해 저희가 무엇을 할 수 있는지 알려주세요.

그리고 어려운 부분이 있다면, 꼭 저희에게 알려주세요! 이 워크샵은 가능한 한 쉽게 접근할 수 있도록 되어 있습니다. 

질문이 있으신가요? [Disord 서버](https://starknet.io/discord)에 가입하고 채널 #tutorials-support에 등록 및 가입하세요. 

StarkNet을 개발하는 방법에 대한 온라인 워크샵을 구독하는 것에 관심이 있나요? [여기서 구독](https://starkware.us12.list-manage.com/subscribe?u=b7a3c9f392572e89e8529da3c&id=6ed3eedc96)

### 기여

이 프로젝트는 더 나아질 수 있고 StarkNet이 고도화 될 겁니다. 당신의 기여를 환영해요! 당신이 줄 수 있는 도움은 아래와 같습니다:

- 여러분의 언어로 번역된 브랜치를 생성하세요.
- 버그를 발견하면 수정하세요.
- 더 많은 설명이 필요하다고 생각되면 연습의 코멘트에 설명을 추가하세요.
- 당신이 가장 좋아하는 카이로의 특징을 보여주는 과제를 추가하세요.

## 준비하기

### 1단계 - Repo를 복제합니다.

```jsx
git clone [https://github.com/starknet-edu/starknet-erc721](https://github.com/starknet-edu/starknet-erc721)
cd starknet-erc721
```

### 2단계 - 환경을 설정합니다.

StarkNet에서 환경을 설정하는 방법에는 로컬 설치 또는 docker container 사용 두 가지가 있습니다.

- Mac 및 Linux 사용자의 경우 둘 중 상관없이 사용이 가능합니다.
- Windows 사용자에게는 Docker를 권장합니다.

프로덕션 설정 방법에 대해서 [이 글](https://medium.com/starknet-edu/the-ultimate-starknet-dev-environment-716724aef4a7)을 작성했습니다.

**옵션 A - 로컬 파이썬 환경을 설정합니다.**

- [이 방법](https://starknet.io/docs/quickstart.html#quickstart) 에 따라 환경을 설정합니다.
- [OpenZeppelin의 카이로 컨트랙트](https://github.com/OpenZeppelin/cairo-contracts)를 설치합니다.

```jsx
pip install openzeppelin-cairo-contracts
```

**옵션 B - 도킹된 환경을 사용합니다.**

- Linux 및 macos

mac m1의 경우:

```jsx
alias cairo='docker run --rm -v "$PWD":"$PWD" -w "$PWD" shardlabs/cairo-cli:latest-arm’
```

amd 프로세서의 경우

```jsx
alias cairo='docker run --rm -v "$PWD":"$PWD" -w "$PWD" shardlabs/cairo-cli:latest’
```

- Windows

```jsx
docker run --rm -it -v ${pwd}:/work --workdir /work shardlabs/cairo-cli:latest
```

### 3단계 - 프로젝트를 편집할 수 있는지 테스트합니다.

```jsx
starknet-compile contracts/Evaluator.cairo
```

## 튜토리얼 작업

### 작업흐름

이 튜토리얼을 진행하려면 [`Evaluator.cairo`](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo) 컨트랙트를 이용해야 합니다. 과제의 유효성을 확인하려면 다음을 수행해야 합니다.

- Evaluator 코드를 읽고 컨트랙트에 필요한 사항을 파악합니다.
- 컨트랙트 코드를 사용자 지정합니다.
- 위에서 작업한 내용을 StarkNet의 테스트넷에 배포하세요. 이 작업은 CLI를 사용하면 됩니다.
- Evaluator에서 `submit_exercise` 기능을 사용하여 연습 과제를 수정하기 위해 등록합니다. 이 작업은 Voyager를 사용하면 됩니다.
- Evaluator 컨트랙트의 관련 기능을 호출하여 연습 과제를 수정하고 포인트를 받으십시오. 이 작업은 Voyager를 사용하면 됩니다.

예를 들어 첫 번째 연습 과제를 해결하기 위한 작업흐름은 다음과 같습니다.

`deploy a smart contract that answers ex1`
 → `call submit_exercise on the evaluator providing your smart contract address`
 → `call ex1_test_erc721 on the evaluator contract`

당신의 **목표는 가능한 한 많은 ERC721-101 포인트를 수집하는 것입니다.** 다음 사항에 유의하세요:

- ERC721-101의 '전송' 기능이 비활성화되어 주소가 하나만 있는 튜토리얼을 완료하도록 유도합니다.
- 포인트를 받기 위해서는 Evaluator가 `distribute_point` 함수의 호출에 도달해야 합니다.
- 이 저장소에는 `IEerciseSolution.cairo` 인터페이스가 포함되어 있습니다. ERC721 컨트랙트는 일부 과제를 검증하기 위해 이 인터페이스를 준수해야 합니다; 즉, `IEerciseSolution.cairo`에 설명된 모든 기능을 구현해야 합니다.
- **각 연습에 필요한 사항을 완전히 이해하려면 [`Evaluator.cairo`](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo) 컨트랙트를 읽어보시기 바랍니다.** 각 과제에 필요한 내용에 대한 상세한 설명이 이 리드미에 나와 있습니다.
- Evaluator 컨트랙트는 때때로 토큰을 구매하기 위해 지불을 해야 합니다. 그가 그렇게 할 만큼 충분한 더미 토큰을 가지고 있는지 확인하세요! 그렇지 않으면 더미 토큰 컨트랙트에서 더미 토큰을 가져와 Evaluator에게 보내야 합니다.

### 컨트랙트 코드 및 주소

| 컨트랙트 코드 | voyager에 있는 컨트랙트 |
| -------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Points counter ERC20](contracts/token/ERC20/TDERC20.cairo)          | [0xa0b943234522049dcdbd36cf9d5e12a46be405d6b8757df2329e6536b40707](https://goerli.voyager.online/contract/0xa0b943234522049dcdbd36cf9d5e12a46be405d6b8757df2329e6536b40707) |
| [Evaluator](contracts/Evaluator.cairo)                               | [0x2d15a378e131b0a9dc323d0eae882bfe8ecc59de0eb206266ca236f823e0a15](https://goerli.voyager.online/contract/0x2d15a378e131b0a9dc323d0eae882bfe8ecc59de0eb206266ca236f823e0a15) |
| [Dummy ERC20 token](contracts/token/ERC20/dummy_token.cairo)         | [0x52ec5de9a76623f18e38c400f763013ff0b3ff8491431d7dc0391b3478bf1f3](https://goerli.voyager.online/contract/0x52ec5de9a76623f18e38c400f763013ff0b3ff8491431d7dc0391b3478bf1f3) |
| [Dummy ERC721 token](contracts/token/ERC721/TDERC721_metadata.cairo) | [0x4fc25c4aca3a8126f9b386f8908ffb7518bc6fefaa5c542cd538655827f8a21](https://goerli.voyager.online/contract/0x4fc25c4aca3a8126f9b386f8908ffb7518bc6fefaa5c542cd538655827f8a21)   |

## 과제 리스트

오늘 우리는 동물 등록부를 만들고 있습니다! 동물들은 사육자들에 의해 길러집니다. 태어나고, 죽고, 번식하고, 팔릴 수 있습니다. 당신은 이러한 기능을 조금씩 구현하게 될 것입니다.

### 연습 1 - ERC721을 배포합니다.

- ERC721 토큰 컨트랙트를 만듭니다. [이 내용](https://github.com/OpenZeppelin/cairo-contracts/blob/v0.2.1/src/openzeppelin/token/erc721/ERC721_Mintable_Burnable.cairo)을 기반으로 사용할 수 있습니다.
- 테스트넷에 배포합니다 (생성자에 필요한 인수를 확인하기 위해서 constructor 코드를 확인해보세요. 또한 인수는 소수여야 합니다.)

```jsx
starknet-compile contracts/ERC721/ERC721.cairo --output artifacts/ERC721.json
starknet deploy --contract artifacts/ERC721.json --inputs arg1 arg2 arg3 --network alpha-goerli
```

- 토큰 #1을 Evaluator 컨트랙트에 부여합니다.
- Evaluator의 [`submit_exercise()`](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo#L601)를 호출하여 평가할 컨트랙트를 구성합니다 (4 pts).
- Evaluator의 [`ex1_test_erc721()`](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo#L146)를 호출하여 포인트를 받습니다 (2 pts).

### 연습 2 - 토큰 속성을 만듭니다.

- [`ex2a_get_animal_rank()`](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo#L245)를 호출하여 생성할 랜덤 생물을 할당받습니다.
- Evaluator로부터 동물의 예상 특성을 읽습니다.
- 당신의 컨트랙트에 동물 특성을 기록하는 데 필요한 도구를 만들고 당신의 컨트렉트를 통해 Evaluator 컨트랙트가 `get_animal_characteristics` 기능을 이용하여 그것을 검색할 수 있도록 합니다 ([이 항목을 확인하세요](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/IExerciseSolution.cairo)).
- 당신의 새 컨트랙트를 배포합니다.
- 원하는 특성을 가진 동물을 민트하여 Evaluator에게 줍니다.
- Evaluator의 [`submit_exercise()`](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo#L601)를 호출하여 평가하려는 컨트랙트를 구성합니다.
- [`ex2b_test_declare_animal()`](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo#L258)을 호출하여 포인트(2 pts)를 받습니다.

### 연습 3 - NFT를 민팅합니다.

- 사육자가 지정된 특성을 가진 새로운 동물을 민팅할 수 있는 기능을 만듭니다.
- 새 컨트랙트를 배포합니다.
- Evaluator의 [`submit_exercise()`](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo#L601)를 호출하여 평가하려는 컨트랙트를 구성합니다.
- [`ex3_declare_new_animal()`](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo#L272)을 호출하여 포인트(2 pts)를 얻습니다.

### 연습 4 - NFT를 없앱니다.

- 사육자가 죽은 동물을 신고할 수 있는 기능을 만듭니다 (NFT 태우기).
- 새 컨트랙트를 배포합니다.
- Evaluator의 [`submit_exercise()`](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo#L601)를 호출하여 평가하려는 컨트랙트를 구성합니다.
- [`ex4_declare_dead_animal()`](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo#L323)을 호출하여 포인트(2 pts)를 얻습니다.

### 연습 5 - 사용 권한 및 결제를 추가합니다.

- [더미 토큰 수도꼭지](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/token/ERC20/dummy_token.cairo)를 사용하여 더미 토큰을 가져옵니다.
- [`ex5a_i_have_dtk()`](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo#L406)를 사용하여 수도꼭지를 사용했음을 나타냅니다(2 pts).
- 사육사 등록을 허용하는 함수를 만듭니다.
- 이 기능은 등록자에게 더미 토큰으로 지불된 수수료를 청구해야 합니다 ([등록_가격 확인](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/IExerciseSolution.cairo)).
- 사용 권한을 추가합니다. 나열된 사육자만 동물을 만들 수 있어야 합니다.
- 새 컨트랙트를 배포합니다.
- Evaluator의 [`submit_exercise()`](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo#L601)를 호출하여 평가하려는 컨트랙트를 구성합니다.
- [`ex5b_register_breeder()`](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo#L440)를 호출하여 기능이 작동하는지 확인하세요. 필요한 경우 Evaluator에게 더미 토큰을 먼저 보냅니다 (2 pts).

### 연습 6 - NFT를 생성합니다.

- [이 더미 ERC721 토큰](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/token/ERC721/TDERC721_metadata.cairo)에 메타데이터가 있는 NFT를 민트합니다. [여기서](https://goerli.voyager.online/contract/0x4fc25c4aca3a8126f9b386f8908ffb7518bc6fefaa5c542cd538655827f8a21) 사용할 수 있습니다.
- [Aspect](https://testnet.aspect.co/)에서 확인합니다.
- [ex6_claim_metadata_token](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo#L523)에서 포인트를 주장하세요 (2 pts).

### 연습 7 - 메타데이터를 추가합니다.

- 메타데이터를 지원하는 새로운 ERC721 컨트랙트를 만듭니다. [이 컨트랙트](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/token/ERC721/ERC721_metadata.cairo)를 기준으로 사용할 수 있습니다.
- 기본 토큰 URI는 선택한 IPFS 게이트웨이입니다.
- [이 웹 사이트](https://www.pinata.cloud/)에 직접 NFT를 업로드할 수 있습니다.
- 토큰이 민트되어지면 [Aspec](https://testnet.aspect.co/)t에 표시 되어야 합니다!
- 새 계약을 배포합니다.
- Evaluator의 [`submit_exercise()`](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo#L601)를 호출하여 평가하려는 컨트랙트를 구성합니다.
- [ex7_add_metadata](https://github.com/starknet-edu/starknet-erc721/blob/main/contracts/Evaluator.cairo#L557)에서 포인트를 주장하세요 (2 pts).

## 부록 - 유용한 도구

### 데이터를 소수로/에서 변환

데이터를 felt로 변환하려면 터미널에서 이하 스크립트를 실행해서 [`utils.py`](https://github.com/starknet-edu/starknet-erc721/blob/main/utils.py) 스크립트를 사용하십시오. 

```jsx
python -i [utils.py](http://utils.py/)
```

```jsx
str_to_felt('ERC20-101')
1278752977803006783537
```

### 진행 상황 확인 & 포인트 집계

포인트는 설치된 지갑에 적립됩니다; 하지만 시간이 좀 걸릴 수 있습니다. 포인트 집계를 실시간으로 모니터링하고 싶다면, Voyager에서 밸런스도 볼 수 있습니다!

- Voyager의 "읽기 컨트랙트" 탭에 있는 [ERC20 counter](https://goerli.voyager.online/contract/0x5c6b1379f1d4c8a4f5db781a706b63a885f3f9570f7863629e99e2342ac344c#readContract)로 이동합니다.
- "balanceOf" 기능에 주소를 입력합니다.

또한 [여기](https://starknet-tutorials.vercel.app/)에서 전반적인 진행 상황을 확인할 수 있습니다.

### 거래현황

거래를 보냈는데 Voyager에 "탐지되지 않음"으로 표시되어 있나요? 이는 다음 두 가지를 의미합니다.

- 트랜잭션이 보류 중이며 곧 블록에 포함됩니다. 그러면 Voyager에서 볼 수 있습니다.
- 트랜잭션이 잘못되었으므로 블록에 포함되지 않습니다(StarkNet에는 실패한 트랜잭션이 없습니다). 다음 URL을 사용하여 트랜잭션 상태를 확인할 수 있습니다(그리고 확인해야 합니다). [https://alpha4.starknet.io/feeder_gateway/get_transaction_receipt?transactionHash=](https://alpha4.starknet.io/feeder_gateway/get_transaction_receipt?transactionHash=), 트랜잭션 해시를 추가할 수 있습니다.
