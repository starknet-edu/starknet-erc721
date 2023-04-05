# Tutorial ERC721 en Starknet

¡Bienvenidos! Este es un taller automatizado que explicará cómo implementar un token ERC721 en Starknet y personalizarlo para realizar funciones específicas. El estándar ERC721 se describe [aquí](https://docs.openzeppelin.com/contracts/3.x/api/token/erc721). Está dirigido a desarrolladores que: 

- Comprender la sintaxis de Cairo 
- Comprender el estándar de token ERC721 .

## Introducción

### Atención

No espere ningún tipo de beneficio al usar esto, aparte de aprender un montón de cosas interesantes sobre Starknet, el primer Validity Rollup de propósito general en Ethereum Mainnet. 

Starknet todavía está en Alfa. Esto significa que el desarrollo está en curso y que la pintura no está seca en todas partes. Las cosas mejorarán y, mientras tanto, ¡hacemos que las cosas funcionen con un poco de cinta adhesiva aquí y allá! 

### ¿Cómo funciona?

El objetivo de este tutorial es personalizar e implementar un contrato ERC721 en Starknet. Su progreso será verificado por un contrato de [evaluator contract](contracts/Evaluator.cairo), implementado en Starknet, que le otorgará puntos en forma de [ERC20 tokens](contracts/token/ERC20/TDERC20.cairo).

Cada ejercicio requerirá que agregue funcionalidad a su token ERC721. 

Para cada ejercicio, deberá escribir una nueva versión en su contrato, implementarlo y enviarlo al evaluador para su corrección. 

### ¿Dónde estoy? 

Este taller es el segundo de una serie destinada a enseñar cómo construir en StarkNet. Echa un vistazo a lo siguiente:
​
| Tema                                              | GitHub repo                                                                            |
| ----------------------------------------------    | -------------------------------------------------------------------------------------- |
| Aprenda a leer el código escrito en Cairo         | [Cairo 101](https://github.com/starknet-edu/starknet-cairo-101)                        |
| Implemente y personalice un ERC721 NFT (aquí)     | [StarkNet ERC721](https://github.com/starknet-edu/starknet-erc721)                     |
| Implemente y personalice un token ERC20           | [StarkNet ERC20](https://github.com/starknet-edu/starknet-erc20)                       |
| Cree una app multi capa                           | [StarkNet messaging bridge](https://github.com/starknet-edu/starknet-messaging-bridge) |
| Depure fácilmentes sus contratos escritor en Cairo| [StarkNet debug](https://github.com/starknet-edu/starknet-debug)                       |
| Diseña tu propio contrato de cuenta               | [StarkNet account abstraction](https://github.com/starknet-edu/starknet-accounts)      |


### Proporcionar comentarios y obtener ayuda 

Una vez que haya terminado de trabajar en este tutorial, ¡sus comentarios serán muy apreciados!

Complete [este formulario](https://forms.reform.app/starkware/untitled-form-4/kaes2e) para informarnos qué podemos hacer para mejorarlo. 

Y si tiene dificultades para seguir adelante, ¡háganoslo saber! Este taller está destinado a ser lo más accesible posible; queremos saber si no es el caso. 

¿Tienes alguna pregunta? Únase a nuestro servidor [Discord server](https://starknet.io/discord), regístrese y únase al canal #tutorials-support. ¿Está interesado en seguir talleres en línea sobre cómo aprender a desarrollar en Starknet? [Subscríbete aquí](http://eepurl.com/hFnpQ5)

### Contribuyendo 

Este proyecto se puede mejorar y evolucionará a medida que StarkNet madure. ¡Sus contribuciones son bienvenidas! Aquí hay cosas que puede hacer para ayudar: 

- Crea una sucursal con una traducción a tu idioma.
- Corrija los errores si encuentra algunos. 
- Agregue una explicación en los comentarios del ejercicio si cree que necesita más explicación.
- Agregue ejercicios que muestren su característica favorita de Cairo​.


## Preparándose para trabajar 

### Paso 1: Clonar el repositorio 

- Oficial:

```bash
git clone https://github.com/starknet-edu/starknet-erc721
cd starknet-erc721
```

### Paso 2: Configure su entorno 

Hay dos formas de configurar su entorno en Starknet: Una instalación local o usando un contenedor docker.

- Para usuarios de Mac y Linux, recomendamos either
- Para usuarios de Windows recomendamos docker 

Para obtener instrucciones de configuración de producción, escribimos [este artículo](https://medium.com/starknet-edu/the-ultimate-starknet-dev-environment-716724aef4a7).

#### Opción A: Configurar un entorno Python local 

Configure el entorno siguiendo [estas instrucciones](https://starknet.io/docs/quickstart.html#quickstart)
- Instalar [OpenZeppelin's cairo contracts](https://github.com/OpenZeppelin/cairo-contracts).

```bash
pip install openzeppelin-cairo-contracts
```

#### Opción B: Usar un entorno dockerizado

- Linux y macos

Para mac m1: 

```bash
alias cairo='docker run --rm -v "$PWD":"$PWD" -w "$PWD" shardlabs/cairo-cli:latest-arm'
```

Para amd procesadores

```bash
alias cairo='docker run --rm -v "$PWD":"$PWD" -w "$PWD" shardlabs/cairo-cli:latest'
```

- Windows

```bash
docker run --rm -it -v ${pwd}:/work --workdir /work shardlabs/cairo-cli:latest
```

#### Paso 3: Pruebe que puede compilar el proyecto contratos de compilación

```bash
starknet-compile contracts/Evaluator.cairo
```

## Trabajando en el tutorial 

### Flujo de trabajo 

Para hacer este tutorial tendrás que interactuar con el contrato [`Evaluator.cairo`](contracts/Evaluator.cairo). Para validar un ejercicio tendrás que:

- Leer el código del evaluador para averiguar qué se espera de su contrato.
- Personaliza el código de tu contrato.
- Despliéguelo en la red de prueba de Starknet. Esto se hace usando la CLI. 
- Registre su ejercicio para corrección, usando la función de `submit_exercise` en el evaluador. Esto se hace usando Voyager. 
- Llame a la función correspondiente en el contrato del evaluador para corregir su ejercicio y recibir sus puntos. Esto se hace usando Voyager. 

Por ejemplo para resolver el primer ejercicio el flujo de trabajo sería el siguiente: 


`deploy a smart contract that answers ex1` &rarr; `call submit_exercise on the evaluator providing your smart contract address` &rarr; `call ex1_test_erc721 on the evaluator contract`

**Su objetivo es reunir tantos puntos ERC721-101 como sea posible.** Tenga en cuenta : 

- La función de 'transferencia' de ERC721-101 ha sido deshabilitada para alentarlo a terminar el tutorial con una sola dirección Para recibir puntos, el evaluador debe alcanzar las llamadas a la función distribuir_punto. 
- Este repositorio contiene una interfaz `IExerciseSolution.cairo`. Su contrato ERC721 deberá ajustarse a esta interfaz para validar algunos ejercicios; es decir, su contrato debe implementar todas las funciones descritas en `IExerciseSolution.cairo`.

- **Realmente recomendamos que lea el contrato de [`Evaluator.cairo`](contracts/Evaluator.cairo) para comprender completamente lo que se espera de cada ejercicio**. En este archivo Léame se proporciona una descripción de alto nivel de lo que se espera de cada ejercicio. 

- El contrato de Evaluador a veces necesita realizar pagos para comprar sus tokens. ¡Asegúrate de que tenga suficientes toknes faucet para hacerlo! De lo contrario, debe obtener tokens faucet del contrato de tokens faucet y enviarlos al evaluador.

### Direcciones y contratos oficiales

| Contract code                                                        | Contract on voyager                                                                                                                                                           |
| -------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Points counter ERC20](contracts/token/ERC20/TDERC20.cairo)          | [0xa0b943234522049dcdbd36cf9d5e12a46be405d6b8757df2329e6536b40707](https://goerli.voyager.online/contract/0xa0b943234522049dcdbd36cf9d5e12a46be405d6b8757df2329e6536b40707) |
| [Evaluator](contracts/Evaluator.cairo)                               | [0x2d15a378e131b0a9dc323d0eae882bfe8ecc59de0eb206266ca236f823e0a15](https://goerli.voyager.online/contract/0x2d15a378e131b0a9dc323d0eae882bfe8ecc59de0eb206266ca236f823e0a15) |
| [Dummy ERC20 token](contracts/token/ERC20/dummy_token.cairo)         | [0x52ec5de9a76623f18e38c400f763013ff0b3ff8491431d7dc0391b3478bf1f3](https://goerli.voyager.online/contract/0x52ec5de9a76623f18e38c400f763013ff0b3ff8491431d7dc0391b3478bf1f3) |
| [Dummy ERC721 token](contracts/token/ERC721/TDERC721_metadata.cairo) | [0x4fc25c4aca3a8126f9b386f8908ffb7518bc6fefaa5c542cd538655827f8a21](https://goerli.voyager.online/contract/0x4fc25c4aca3a8126f9b386f8908ffb7518bc6fefaa5c542cd538655827f8a21)   |

​​

## Lista de tareas 

¡Hoy estamos creando un registro de animales! Los animales son criados por criadores. Pueden nacer, morir, reproducirse, venderse. Irás implementando estas características poco a poco. 

### Ejercicio 1: Implementación de un ERC721 

- Cree un contrato de token ERC721. Puedes usar [esta implementación](https://github.com/OpenZeppelin/cairo-contracts/blob/v0.2.1/src/openzeppelin/token/erc721/ERC721_Mintable_Burnable.cairo) como base.
- Despliéguelo en la red de prueba (verifique en el constructor los argumentos necesarios. También tenga en cuenta que los argumentos deben ser decimales). 

```bash
starknet-compile contracts/ERC721/ERC721.cairo --output artifacts/ERC721.json
starknet deploy --contract artifacts/ERC721.json --inputs arg1 arg2 arg3 --network alpha-goerli 
```

- Entrega el token n.° 1 al contrato del evaluador. 
- Llame a [`submit_exercise()`](contracts/Evaluator.cairo#L601) en el Evaluador para configurar el contrato que desea evaluar. (4 pts) 
- Llame a [`ex1_test_erc721()`](contracts/Evaluator.cairo#L146) en el Evaluador para recibir sus puntos. (2 pts)

--------------

### Ejercicio 2: Creación de atributos de token 

- Llame a [`ex2a_get_animal_rank()`](contracts/Evaluator.cairo#L245) para que le asignen una criatura aleatoria para crear. 
- Lea las características esperadas de su animal del Evaluador. 
- Cree las herramientas necesarias para registrar las características de los animales en su contrato y permita que el contrato del Evaluador las recupere a través de la función `get_animal_characteristics` en su contrato [marque esto](contracts/IExerciseSolution.cairo)
- Implementa tu nuevo contrato. 
- Cree el animal con las características deseadas y entregarlo al Evaluador.
- Llame [`submit_exercise()`](contracts/Evaluator.cairo#L601) en el Evaluador para configurar el contrato que desea evaluar.
- Llame a [`ex2b_test_declare_animal()`](contracts/Evaluator.cairo#L258) para recibir puntos. (2 pts)

-------------

### Ejercicio 3: Creación de NFT 

- Crear una función para permitir a los criadores crear nuevos animales con las características especificadas. 
- Implementa tu nuevo contrato. 
- Llame a [`submit_exercise()`](contracts/Evaluator.cairo#L601) en el Evaluador para configurar el contrato que desea evaluar. 
- Llame a [`ex3_declare_new_animal()`](contracts/Evaluator.cairo#L272) para obtener puntos. (2 puntos)

-------------

### Ejercicio 4 - Quema de NFT 

- Cree una función para permitir que los criadores declaren animales muertos (quemar el NFT).
- Implementa tu nuevo contrato. 
- Llame a [`submit_exercise()`](contracts/Evaluator.cairo#L601) en el Evaluador para configurar el contrato que desea evaluar. 
- Llame a [`ex4_declare_dead_animal()`](contracts/Evaluator.cairo#L323) para obtener puntos. (2 puntos) 

-----------

### Ejercicio 5 - Adición de permisos y pagos 

- Use el [dummy token faucet](contracts/token/ERC20/dummy_token.cairo) para obtener dummy token. 
- Usa [`ex5a_i_have_dtk()`](contracts/Evaluator.cairo#L406) para mostrar que lograste usar el faucet. (2 pts) 
- Cree una función para permitir el registro de criadores. 
- Esta función debería cobrarle al registrante una tarifa, pagada en tokens faucet. ([consulte `registration_price`](contracts/IExerciseSolution.cairo)) 
- Agregar permisos. Solo permitir que los criadores listados puedan crear animales. 
- Implementa tu nuevo contrato. 
- Llame a [`submit_exercise()`](contracts/Evaluator.cairo#L601) en el Evaluador para configurar el contrato que desea evaluar. 
- Llame a [`ex5b_register_breeder()`](contracts/Evaluator.cairo#L440) para probar que su función funciona. Si es necesario, envíe tokens faucet primero al Evaluador. (2 puntos)

---------------------

### Ejercicio 6 - Reclamación de un NFT

- Cree un NFT con metadatos en [este dummy ERC721 token](contracts/token/ERC721/TDERC721_metadata.cairo), utilizable [aquí](https://goerli.voyager.online/contract/0x4fc25c4aca3a8126f9b386f8908ffb7518bc6fefaa5c542cd538655827f8a21).
- Compruébalo en [Aspect](https://testnet.aspect.co/).
- Reclamar puntos en `ex6_claim_metadata_token`](contracts/Evaluator.cairo#L523). (2 puntos) 

------------------

### Ejercicio 7 - Adición de metadatos 

- Cree un nuevo contrato ERC721 que admita metadatos. Puedes usar como base [este contrato](contracts/token/ERC721/ERC721_metadata.cairo) 
- El URI del token base es la puerta de enlace IPFS elegida.
- Puede cargar sus NFT directamente en [este website](https://www.pinata.cloud/)
- ¡Tus tokens deberían ser visibles en [Aspect](https://testnet.aspect.co/) una vez creados! 
- Implementa tu nuevo contrato.
- Llame a [`submit_exercise()`](contracts/Evaluator.cairo#L601) en el Evaluador para configurar el contrato que desea evaluar. 
- Reclamar puntos en [`ex7_add_metadata`](contracts/Evaluator.cairo#L557) (2 puntos)

------------------

## ​Anexo - Herramientas útiles 

### Conversión de datos a y desde decimal 

Para convertir datos en felt, use el script [`utils.py`](utils.py).
Para abrir Python en modo interactivo después de ejecutar el script.

```bash
  python -i utils.py
  ```

  ```python
  >>> str_to_felt('ERC20-101')
  1278752977803006783537
  ```

Si da error pruebe:

```bash
  python3 -i utils.py
  ```

  ```python
  >>> str_to_felt('ERC20-101')
  1278752977803006783537
  ```

### Comprobando tu progreso y contando tus puntos 

Sus puntos se acreditarán en su billetera; aunque esto puede tomar algún tiempo. Si desea monitorear su conteo de puntos en tiempo real, ¡también puede ver su saldo en voyager!

- ​Vaya al contador [ERC20 counter](https://goerli.voyager.online/contract/0xa0b943234522049dcdbd36cf9d5e12a46be405d6b8757df2329e6536b40707#readContract) en voyager, en la pestaña "leer contrato"
- Ingrese su dirección en decimal en la función "balanceOf" 

También puede consultar su progreso general [aquí](https://starknet-tutorials.vercel.app).

### Estado de la transacción

¿Envió una transacción y se muestra como "no detectada" en voyager? Esto puede significar dos cosas: 

- Su transacción está pendiente y se incluirá en un bloque en breve. Entonces será visible en Voyager. 
- Su transacción no fue válida y NO se incluirá en un bloque (no existe una transacción fallida en Starknet). Puede (y debe) verificar el estado de su transacción con la siguiente URL [https://alpha4.starknet.io/feeder_gateway/get_transaction_receipt?transactionHash=](https://alpha4.starknet.io/feeder_gateway/get_transaction_receipt?transactionHash=), donde puede agregar el hash de su transacción.​
