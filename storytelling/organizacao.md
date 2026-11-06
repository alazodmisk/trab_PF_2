### TORRE DO LIXO ELETRÔNICO
O personagem era um guarda de segurança que dormiu enquanto trabalhava. Ao acordar, descobre que a torre de descarte de lixo eletrônico foi fechada e ele não consegue encontrar suas chaves e precisa ir embora.

Os valores que eu colocar aqui podem passar por mudanças:
- 7 andares
- 10 enigmas (3 salas com dois enigmas cada para resolver)
- 5 tipos de objetos (chaves, botões de ativação, papéis com anotações, pé de cabra, cabos de energia)

##### Andares
1. Garagem: A garagem é a sala de saída. É por aqui que os caminhões chegam descarregando o lixo eletrônico.
2. Triagem: Após os lixos serem deixados pelos caminhões, eles são levados até a sala de triagem, onde é feita a separação.
3. Armazém de ferramentas: Neste andar ficam guardadas as ferramentas dos funcionários.
4. Andar da sala de Baterias: Neste andar são armazenadas as baterias que foram descartadas e deixadas pelos caminhões.
5. Andar da sala de Placas eletrônicas: Neste andar são descartadas as placas eletrônicas deixadas pelos caminhões.
6. Andar da sala de computadores descartados: Neste andar são descartados os computadores usados deixados pelos caminhões.
7. Andar da sala de segurança: Neste andar é possível encontrar senhas e câmeras de segurança. **(Início do jogo)**

Andares X podem ter caminhos para outros andares que não sejam o X+1 nem o X-1, por exemplo, no andar 4 você pode ir diretamente para o segundo andar por meio do duto de ventilação.

##### Salas com dois enigmas
- Andar 5 (Placas eletrônicas): enigmas 3 e 4
- Andar 4 (Baterias): enigmas 5 e 6
- Andar 2 (Triagem): enigmas 8 e 9

## 2. Tabela dos andares com seus enigmas
 
| Andar | Nome | Enigmas | Objetos presentes | Para onde vai |
|---|---|---|---|---|
| 1 | Garagem | **10** | Portão (fechadura + 2 botões de ativação), papel da parede (ordem dos botões) | Saída do jogo (fim) ou 2º |
| 2 | Triagem | **8** e **9** | Painel da esteira, caixa de metal, caixa de plástico, caixa de vidro, chaveiro do guarda (cai na esteira) | 1º ou 3º |
| 3 | Armazém de ferramentas | **7** | Quadro de energia com alavanca (resolve o enigma 1), cabo de energia, armário trancado com cadeado de 3 dígitos (pé de cabra dentro) | 2º ou 4º |
| 4 | Baterias | **5** e **6** | Prateleira de baterias, painel de baterias (3 baterias + papel colado; botão azul dentro), cabo de energia solto, grade do duto de ventilação | 3º, 5º ou 2º (duto, só após o enigma 5) |
| 5 | Placas eletrônicas | **3** e **4** | Porta com teclado de 4 dígitos, caixa de placas lacrada (botão vermelho e papel dentro) | 4º ou 6º |
| 6 | Computadores descartados | **2** | Notebook com led piscando | 5º ou 7º |
| 7 | Segurança (início) | **1** | Papel com anotações do guarda, computador do colega | 6º ou 5º (duto) |
 
---
 
## 3. Enigmas corrigidos
 
### Enigma 1: Sem energia (apresentado no 7º, resolvido no 3º)
Os computadores da sala de segurança estão desligados e as tomadas, desativadas. Para ligar a energia, o jogador puxa a alavanca do quadro de energia do **armazém de ferramentas (3º andar)**. Para descer, há duas opções: escadas (6º andar) ou duto de ventilação (5º andar, só desce).
 
- **Mecanismo:** objeto `alavanca` (andar 3).
- **Requisito:** nenhum.
- **Efeito:** `EnergiaLigada` + `EnigmaResolvido(1)`.
### Enigma 2: O notebook sem bateria (6º andar)
Entre os computadores descartados há um notebook com um led piscando: falta de bateria. Com o cabo de energia (3º andar) e a energia ligada, ele liga e revela o código **1540** e que o antigo usuário é o colega da sala de segurança.
 
- **Mecanismo:** objeto `notebook`.
- **Requisito:** `CaboEnergia` + `EnergiaLigada`.
- **Efeito:** consome o cabo; `NotebookLigado`; `EnigmaResolvido(2)`; o jogador recebe `Papel("Código 1540. Usuário: colega da sala de segurança")`.
### Enigma 3: A porta da sala de placas (5º andar)
A porta tem um teclado de 4 dígitos. A senha está no computador do colega (7º andar), que só funciona com a energia ligada e o notebook ligado (a pista do código 1540). O computador entrega dois papéis: *"Senha da porta das placas: 2486"* e *"O chaveiro do guarda é de metal."*
 
- **Mecanismo:** enigma com resposta digitada (porta com teclado).
- **Resposta:** `2486`.
- **Efeito:** `PortaPlacasAberta` + `EnigmaResolvido(3)`.
### Enigma 4: A caixa de placas lacrada (5º andar)
Dentro da sala de placas há uma caixa lacrada com lacre de metal. O pé de cabra abre. Dentro: uma placa com o **botão de ativação vermelho** e um papel: *"O portão da garagem só abre com a chave e com os dois botões de ativação."*
 
- **Mecanismo:** objeto `caixa de placas`.
- **Requisito:** `PeDeCabra` + `PortaPlacasAberta`.
- **Efeito:** recebe `BotaoAtivacao("vermelho")` e o papel; `EnigmaResolvido(4)`.
### Enigma 5: A grade do duto (4º andar)
O duto de ventilação que leva ao 2º andar está coberto por uma grade parafusada. O pé de cabra a arranca.
 
- **Mecanismo:** objeto `grade do duto`.
- **Requisito:** `PeDeCabra`.
- **Efeito:** `EnigmaResolvido(5)`, que abre a saída 4 → 2.
### Enigma 6: O painel de baterias (4º andar)
Um painel trancado guarda o botão de ativação azul. Para abri-lo, encaixam-se 3 baterias com carga 20%, 55% e 90%. Um papel colado no painel diz: *"Ligue da menos carregada para a mais carregada."*
 
- **Mecanismo:** enigma com resposta digitada.
- **Resposta:** `20 55 90`.
- **Efeito:** recebe `BotaoAtivacao("azul")`; `EnigmaResolvido(6)`.
- **Obs.:** o segundo cabo de energia fica solto ao lado da prateleira (objeto separado).
### Enigma 7: O armário de ferramentas (3º andar)
O armário trancado, com cadeado de 3 dígitos, guarda o pé de cabra. A pista é o papel do guarda (7º andar): *"Meu código do armário: onde eu trabalho, onde eu saio, onde eu guardo as ferramentas."* → 7 (segurança), 1 (garagem), 3 (armazém).
 
- **Mecanismo:** enigma com resposta digitada.
- **Resposta:** `713`.
- **Efeito:** recebe `PeDeCabra`; `EnigmaResolvido(7)`.
- **Atenção:** as descrições dos andares precisam informar o número ("Garagem, 1º andar"), senão a pista não é dedutível.
### Enigma 8: A esteira da triagem (2º andar)
O painel da esteira está sem energia e as chaves do guarda caíram nela. O cabo de energia do 4º andar, com a energia do prédio ligada, religa a esteira.
 
- **Mecanismo:** objeto `painel da esteira`.
- **Requisito:** `CaboEnergia` + `EnergiaLigada`.
- **Efeito:** consome o cabo; `EsteiraLigada`; `EnigmaResolvido(8)`.
### Enigma 9: Separando o lixo (2º andar)
Com a esteira ligada, o chaveiro do guarda desce junto com o lixo e precisa ir para a caixa certa (metal, plástico ou vidro). O papel do computador do colega diz que o chaveiro é de **metal**.
 
- **Mecanismo:** enigma com resposta digitada.
- **Requisito:** `EsteiraLigada`.
- **Resposta:** `metal`.
- **Efeito:** recebe `Chave` (chaves da garagem e do guarda); `EnigmaResolvido(9)`.
### Enigma 10: O portão da garagem (1º andar)
O portão tem uma fechadura e dois botões de ativação. O papel da parede diz: *"Acione na ordem: vermelho primeiro, azul depois."*
 
- **Mecanismo:** enigma com resposta digitada.
- **Requisito:** `Chave` + `BotaoAtivacao("vermelho")` + `BotaoAtivacao("azul")`.
- **Resposta:** `vermelho azul`.
- **Efeito:** `EnigmaResolvido(10)`: o guarda escapa e o jogo termina.
- **Erro (opcional):** ordem errada custa 1 ponto de vida.
---
 
## 4. Dependências entre enigmas
 
| Enigma | Precisa de | Pista vem de |
|---|---|---|
| 1 | nada | descrição do andar 7 |
| 2 | cabo (3º andar), enigma 1 | descrição do notebook |
| 3 | senha 2486 | computador do colega (precisa dos enigmas 1 e 2) |
| 4 | pé de cabra (enigma 7), enigma 3 | descrição da caixa |
| 5 | pé de cabra (enigma 7) | descrição da grade |
| 6 | nada | papel colado no painel |
| 7 | nada | papel do guarda (7º andar) |
| 8 | cabo (4º andar), enigma 1 | descrição do painel |
| 9 | enigma 8 | papel do computador do colega |
| 10 | chave (9), botão vermelho (4), botão azul (6) | papel da caixa + papel da parede |
 
### Caminho principal (confirmado: o jogo é resolvível)
 
1. 7º: pegar o papel do guarda → descer (escadas ou duto) até o 3º.
2. 3º: alavanca (**1**) → pegar o cabo → armário `713` (**7**) → pé de cabra.
3. 6º: notebook com o cabo (**2**) → código 1540.
4. 7º: computador do colega → senha 2486 e "chaveiro é de metal".
5. 5º (duto): porta `2486` (**3**) → caixa com pé de cabra (**4**) → botão vermelho.
6. 4º: grade (**5**) → painel `20 55 90` (**6**) → botão azul → pegar o 2º cabo.
7. Duto até o 2º: esteira com o cabo (**8**) → caixa `metal` (**9**) → chave.
8. 1º: portão `vermelho azul` (**10**) → fim.


# Torre do Lixo Eletrônico: organização do projeto

Trabalho Prático 2 de Programação Funcional (UEM, Ciência da Computação), tema 09. Simulador de escape room em Gleam, executado com o **SGleam**, 100% no terminal (sem interface gráfica).

A história, os andares, os enigmas e o caminho de resolução estão em `organizacao.md`. Este documento trata só da **estrutura do código**.

---

## 1. Premissas

- Execução pelo SGleam (`./sgleam arquivo.gleam` ou REPL), sem `gleam.toml` e sem `main` de projeto.
- Sem entrada dinâmica (`read()`): o jogador digita chamadas de função no REPL.
- Lógica **pura**: toda ação recebe um estado e devolve um **novo** estado.
- Só o módulo `menus.gleam` usa `io.println`.
- Interface visual (`sgleam/image`, `sgleam/world`) fica fora do escopo.

> **A verificar no início** (a página do SGleam não detalha): como ele resolve `import` entre arquivos. Teste com `a.gleam` (função pública) e `b.gleam` (`import a`) rodando `./sgleam b.gleam`. Se não funcionar, consulte `./sgleam --help`, o material de aula ou o professor.

---

## 2. Estrutura de arquivos

```
jogador.gleam     tipos e operações do jogador
objeto.gleam      tipo Objeto e fábricas de efeitos
enigma.gleam      tipo Enigma e resolução
ambiente.gleam    tipo Ambiente e busca de andar
cenario.gleam     dados da história (os 7 andares)
jogo.gleam        estado do jogo, ações e regras
menus.gleam       apresentação (io.println) e m1(), m2()...
jogo_test.gleam   testes (sgleam/check)
```

### Ordem de dependência (sem ciclos)

```
jogador
   ├── objeto ──┐
   └── enigma ──┴── ambiente ── cenario ── jogo ── menus
```

Cada módulo só importa os que aparecem antes dele. Os imports ficam sem prefixo, por exemplo `import jogador.{type Jogador}`.

---

## 3. Responsabilidade de cada módulo

### `jogador.gleam`

Não depende de ninguém. Define o estado do jogador e operações simples sobre ele.

```gleam
pub type Item {
  Chave
  BotaoAtivacao(cor: String)
  Papel(texto: String)
  PeDeCabra
  CaboEnergia
}

pub type Flag {
  EnergiaLigada
  NotebookLigado
  PortaPlacasAberta
  EsteiraLigada
  EnigmaResolvido(Int)
}

pub type Jogador {
  Jogador(
    nome: String,
    inventario: List(Item),
    pontos_de_vida: Int,
    localizacao: Int,
    flags: List(Flag),
  )
}
```

Funções: `pegar`, `tem`, `ativar`, `flag_ativa`, `mover`. Todas devolvem um `Jogador` novo (`Jogador(..j, campo: valor)`).

Os 5 tipos de objetos do jogo (chaves, botões de ativação, papéis com anotações, pé de cabra, cabos de energia) viram variantes de `Item`, para o pattern matching trabalhar por nós.

### `objeto.gleam`

Depende de `jogador`. Tipo `Objeto` conforme o enunciado e **fábricas de efeitos** (funções de ordem superior):

```gleam
pub type Objeto {
  Objeto(
    nome: String,
    descricao: String,
    interacao: fn(Jogador) -> Jogador,
    estado: String,
  )
}
```

| Função | Papel |
|---|---|
| `pegando(item)` | efeito que coloca o item no inventário |
| `ativando(flag)` | efeito que liga uma flag (ex.: `EnergiaLigada`) |
| `exigindo(item, efeito)` | só aplica o efeito se o jogador tiver o item |
| `depois(f, g)` | composição de dois efeitos |

### `enigma.gleam`

Depende de `jogador`.

```gleam
pub type Enigma {
  Enigma(
    id: Int,
    descricao: String,
    solucao: String,
    pistas: List(String),
    requisito: fn(Jogador) -> Bool,
    efeito: fn(Jogador) -> Jogador,
  )
}
```

`resolver_enigma(enigma, resposta, jogador)`: se o requisito falha ou a resposta está errada, devolve o jogador intacto; se acerta, aplica `efeito` e registra `EnigmaResolvido(id)`.

O `requisito` modela itens necessários (ex.: enigma 4 exige `PeDeCabra`).

### `ambiente.gleam`

Depende de `objeto` e `enigma`.

```gleam
pub type Ambiente {
  Ambiente(
    andar: Int,
    nome: String,
    descricao: String,
    objetos: List(Objeto),
    saidas: List(Int),
    enigmas: List(Enigma),
  )
}
```

`saidas` é lista de andares. Os atalhos (duto 7→5 e 4→2) são só números a mais na lista. Se preferir seguir o enunciado à risca, use `List(String)`.

Funções:

- `buscar(andares, numero) -> Result(Ambiente, Nil)`, **recursiva**.
- `explorar(ambiente, jogador) -> String`, **pura**, só devolve texto.

### `cenario.gleam`

Só **dados**: a função `torre() -> List(Ambiente)` e uma função por andar (`garagem()`, `triagem()`, ..., `seguranca()`). Aqui ficam os 10 enigmas, os objetos e as saídas da tabela do `organizacao.md`. Assim as regras ficam genéricas e dá para mudar a história sem mexer nelas.

### `jogo.gleam`

Junta tudo: estado, ações e regras.

```gleam
pub type Jogo {
  Jogo(jogador: Jogador, andares: List(Ambiente))
}

pub type Acao {
  Explorar
  Interagir(objeto: String)
  Resolver(enigma: Int, resposta: String)
  Ir(andar: Int)
}
```

| Função | Papel |
|---|---|
| `novo() -> Jogo` | estado inicial (jogador no 7° andar) |
| `aplicar(jogo, acao) -> Jogo` | `case` sobre `Acao`, devolve novo estado |
| `executar(jogo, acoes) -> Jogo` | `list.fold(acoes, jogo, aplicar)` |
| `ir(jogo, andar)` | valida se o andar está em `saidas` do atual |
| `interagir(jogo, nome)` | `list.find` do objeto no ambiente atual |
| `resolver(jogo, id, resposta)` | localiza o enigma e chama `resolver_enigma` |
| `venceu(jogo) -> Bool` | `EnigmaResolvido(10)` presente nas flags |

### `menus.gleam`

Única camada com `io`. Funções do menu recebem e devolvem o `Jogo`, imprimindo o texto antes:

```gleam
pub fn m1(j: Jogo) -> Jogo   // explorar ambiente
pub fn m2(j: Jogo) -> Jogo   // consultar inventário
pub fn m3(j: Jogo) -> Jogo   // examinar enigmas
```

Mais `exit()`, `display_main_menu()` e os atalhos de ação (`ir`, `interagir`, `resolver`). O enunciado permite adaptar `m1()`, `m2()` etc.

---

## 4. Como o jogador joga (REPL)

O estado passa de uma chamada para a próxima com `let`:

```
> let j = novo()
> let j1 = m1(j)
> let j2 = ir(j1, 6)
> let j3 = interagir(j2, "notebook")
```

Ou com pipe:

```
> let j = novo() |> ir(6) |> interagir("notebook")
```

**Para testar no SGleam:** se o REPL aceita redefinir `let j` com o mesmo nome (senão use `j1`, `j2`...) e se o `smain` permite um laço que lê comandos do terminal.

---

## 5. Exibição no terminal

No REPL, o valor de uma expressão aparece com aspas e `\n` escapados. Por isso:

- funções puras devolvem `String`;
- só `menus.gleam` chama `io.println`, que imprime o texto formatado.

Isso também mantém a separação entre lógica e apresentação exigida no enunciado.

---

## 6. Testes

Usar `sgleam/check` (conferir os nomes `check.eq` e o sufixo `_examples` nos exemplos da disciplina).

1. **Por enigma:** resposta certa muda o estado; resposta errada não muda.
2. **Por requisito:** sem pé de cabra, a caixa de placas não abre.
3. **Por movimento:** ir para um andar que não está em `saidas` não muda a localização.
4. **Ponta a ponta:** o caminho principal do `organizacao.md` como lista de `Acao`, executada com `executar` e conferida com `venceu`.

---

## 7. Mapeamento com o enunciado

| Requisito | Onde aparece |
|---|---|
| Tipos algébricos | `Item`, `Flag`, `Acao`, `Jogador`, `Objeto`, `Enigma`, `Ambiente`, `Jogo` |
| Pattern matching | `aplicar` (sobre `Acao`), `case` em `resolver_enigma`, `buscar` |
| Recursão | `ambiente.buscar`, listas de andares/objetos |
| Composição de funções | `depois`, pipes (`\|>`) nas ações |
| Funções de ordem superior | `interacao`, `efeito`, `requisito`, `exigindo`, `list.fold`, `list.map` |
| Pureza | tudo em `jogador`, `objeto`, `enigma`, `ambiente`, `jogo` |
| Camada de apresentação | `menus.gleam` |
| Testes unitários | `jogo_test.gleam` |

---

## 8. Ordem de implementação

1. `jogador.gleam` e `objeto.gleam`, com 2 ou 3 objetos de teste, e checar se os imports entre arquivos funcionam no SGleam.
2. `enigma.gleam` e `ambiente.gleam`.
3. `cenario.gleam` com 1 andar (o 7°).
4. `jogo.gleam` (`aplicar`, `executar`) e o primeiro teste.
5. Os 7 andares completos e os 10 enigmas.
6. `menus.gleam`.
7. Teste de ponta a ponta com o caminho principal.
8. Slides (PDF) e revisão de documentação.

---

## 9. Entrega

- Arquivos-fonte `.gleam` + slides em PDF + arquivos acessórios.
- Compactar, compartilhar por Google Drive e enviar o link para `wigarashi@uem.br`.
- Assunto: *Trabalho 2 de Programação Funcional, Semestre, 2026*.
- Corpo: nome completo e RA de cada integrante.
- Apresentação oral de 10 a 15 minutos.
# Funções por arquivo — trab_PF_2

Este levantamento considera os arquivos `.gleam` presentes na pasta `code/` do ZIP enviado. É importante separar **funções já implementadas** de **funções apenas planejadas** em `storytelling/organizacao.md`.

## 1. Funções encontradas no código atual

| Arquivo | Função | Visibilidade | Parâmetros | Retorno | Responsabilidade |
|---|---|---|---|---|---|
| `jogador.gleam` | `novo` | Pública (`pub`) | `nome: String`, `andar: Int` | `Jogador` | Cria um jogador com inventário e flags vazios, 3 pontos de vida e localização inicial informada. |
| `jogador.gleam` | `pegar` | Pública (`pub`) | `j: Jogador`, `item: Item` | `Jogador` | Adiciona um item ao inventário do jogador. |
| `jogador.gleam` | `tem` | Pública (`pub`) | `j: Jogador`, `item: Item` | `Bool` | Verifica se o jogador possui determinado item no inventário. |
| `jogador.gleam` | `consumir` | Pública (`pub`) | `j: Jogador`, `item: Item` | `Jogador` | Remove uma ocorrência do item do inventário. |
| `jogador.gleam` | `remover_um` | Privada | `itens: List(Item)`, `item: Item` | `List(Item)` | Função recursiva auxiliar que remove a primeira ocorrência do item encontrado. |
| `jogador.gleam` | `ativar` | Pública (`pub`) | `j: Jogador`, `flag: Flag` | `Jogador` | Ativa uma flag, evitando adicioná-la novamente caso já esteja ativa. |
| `jogador.gleam` | `flag_ativa` | Pública (`pub`) | `j: Jogador`, `flag: Flag` | `Bool` | Verifica se determinada flag já está registrada no jogador. |
| `jogador.gleam` | `resolvido` | Pública (`pub`) | `j: Jogador`, `enigma: Int` | `Bool` | Verifica se o jogador possui a flag `EnigmaResolvido(enigma)`. |
| `jogador.gleam` | `mover` | Pública (`pub`) | `j: Jogador`, `andar: Int` | `Jogador` | Atualiza a localização do jogador para o andar informado. |

## 2. Situação dos demais arquivos

| Arquivo | Funções implementadas atualmente | Observação |
|---|---|---|
| `objeto.gleam` | Nenhuma | Contém apenas a definição planejada do tipo `Objeto`. A linha inicial está incorreta/concatenada (`import jogadorpub type Objeto`) e precisa ser corrigida. |
| `enigma.gleam` | Nenhuma | Contém somente `import jogador`. |
| `ambiente.gleam` | Nenhuma | Contém somente os imports de `objeto` e `enigma`. |
| `cenario.gleam` | Nenhuma | Contém somente `import ambiente`. |
| `jogo.gleam` | Nenhuma | Contém somente `import cenario`. |
| `menu.gleam` | Nenhuma | Contém somente `import jogo`. |

## 3. Funções previstas no planejamento (`storytelling/organizacao.md`)

Estas funções aparecem no documento de organização, mas **ainda não estão implementadas nos arquivos `.gleam` do ZIP**.

| Arquivo previsto | Função | Responsabilidade planejada |
|---|---|---|
| `objeto.gleam` | `pegando(item)` | Produzir uma função de interação que adiciona o item ao inventário. |
| `objeto.gleam` | `ativando(flag)` | Produzir uma função de interação que ativa uma flag do jogador. |
| `objeto.gleam` | `exigindo(item, efeito)` | Produzir uma interação que só executa o efeito se o jogador possuir o item exigido. |
| `objeto.gleam` | `depois(f, g)` | Compor dois efeitos, executando um e depois o outro. |
| `enigma.gleam` | `resolver_enigma(enigma, resposta, jogador)` | Verificar requisito e resposta; aplicar o efeito e registrar o enigma como resolvido quando correto. |
| `ambiente.gleam` | `buscar(andares, numero)` | Buscar recursivamente um ambiente pelo número do andar, retornando `Result(Ambiente, Nil)`. |
| `ambiente.gleam` | `explorar(ambiente, jogador)` | Produzir uma descrição textual do ambiente para o jogador. |
| `cenario.gleam` | `torre()` | Construir e devolver a lista dos sete andares. |
| `cenario.gleam` | `garagem()` | Construir o ambiente do primeiro andar. |
| `cenario.gleam` | `triagem()` | Construir o ambiente do segundo andar. |
| `cenario.gleam` | `armazem()` | Construir o ambiente do terceiro andar. |
| `cenario.gleam` | `baterias()` | Construir o ambiente do quarto andar. |
| `cenario.gleam` | `placas()` | Construir o ambiente do quinto andar. |
| `cenario.gleam` | `computadores()` | Construir o ambiente do sexto andar. |
| `cenario.gleam` | `seguranca()` | Construir o ambiente do sétimo andar. |
| `jogo.gleam` | `novo()` | Criar o estado inicial do jogo. |
| `jogo.gleam` | `aplicar(jogo, acao)` | Aplicar uma ação ao estado do jogo. |
| `jogo.gleam` | `executar(jogo, acoes)` | Executar uma sequência de ações. |
| `jogo.gleam` | `ir(jogo, andar)` | Validar e realizar a movimentação para outro andar. |
| `jogo.gleam` | `interagir(jogo, nome)` | Localizar um objeto no ambiente atual e executar sua interação. |
| `jogo.gleam` | `resolver(jogo, id, resposta)` | Localizar e tentar resolver um enigma. |
| `jogo.gleam` | `venceu(jogo)` | Verificar se a condição de vitória foi alcançada. |
| `menus.gleam` (o ZIP contém `menu.gleam`) | `m1(j)` | Exibir informações/explorar o ambiente. |
| `menus.gleam` (o ZIP contém `menu.gleam`) | `m2(j)` | Consultar o inventário. |
| `menus.gleam` (o ZIP contém `menu.gleam`) | `m3(j)` | Examinar os enigmas. |
| `menus.gleam` (o ZIP contém `menu.gleam`) | `exit()` | Encerrar a execução/menu. |
| `menus.gleam` (o ZIP contém `menu.gleam`) | `display_main_menu()` | Exibir o menu principal. |

## 4. Observações

- `jogador.gleam` é o único arquivo que contém funções implementadas no ZIP analisado.
- `objeto.gleam` ainda não contém as fábricas de efeitos descritas no planejamento.
- O planejamento usa o nome `menus.gleam`, mas o arquivo enviado chama-se `menu.gleam`; convém padronizar o nome e os imports.
- O documento de planejamento cita `consumir` e `mover` como operações do jogador? Na versão atual do código elas existem; `consumir` não aparece na lista resumida do planejamento.
- Os nomes das funções de `cenario.gleam` são uma proposta de organização. Confirmem os nomes finais antes de implementar.
