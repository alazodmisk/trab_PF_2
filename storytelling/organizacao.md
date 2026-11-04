# Guia completo: Trabalho Prático 2 de Programação Funcional

**Tema 09: A Torre do Lixo Eletrônico** · Gleam / SGleam · UEM, Ciência da Computação · Prof. Wagner Igarashi

> Este guia tem 3 partes: **(A)** o que o trabalho é e o que o professor cobra, **(B)** onde o seu projeto está hoje (com base no `trab_PF_2.zip`), **(C)** o passo a passo completo até a entrega.

---

## PARTE A: O que você está fazendo

### A.1 Em uma frase

Você está programando, em **Gleam** (rodando no **SGleam**, no terminal), um **jogo de escape room de texto** cuja história é a "Torre do Lixo Eletrônico": um guarda de segurança dorme no trabalho, acorda com a torre trancada, sem as chaves, e precisa descer 7 andares resolvendo 10 enigmas até abrir o portão da garagem.

### A.2 O ponto real do trabalho

O jogo é só o pretexto. A disciplina é de **Programação Funcional**, então o que o professor avalia é se você usou o estilo funcional:

| Conceito | O que significa na prática | Onde aparece no seu jogo |
|---|---|---|
| **Tipos algébricos** | `type` com variantes (`Chave`, `PeDeCabra`...) e registros | `Item`, `Flag`, `Jogador`, `Objeto`, `Enigma`, `Ambiente`, `Acao`, `Jogo` |
| **Pattern matching** | `case` que decide pela forma do dado | `aplicar` (sobre `Acao`), `buscar`, `remover_um`, `resolver_enigma` |
| **Recursão** | função que chama a si mesma, no lugar de `for`/`while` | `buscar` andar por número, `remover_um`, (opcional) `tem` |
| **Composição de funções** | juntar funções pequenas em uma maior | `depois(f, g)`, pipes `\|>` |
| **Funções de ordem superior** | funções que recebem/devolvem funções | `interacao: fn(Jogador) -> Jogador`, `efeito`, `requisito`, `exigindo`, `list.fold`, `list.map` |
| **Pureza** | nada é modificado; toda ação devolve um **estado novo** | tudo, exceto `menus.gleam` |

### A.3 Regras do enunciado que você NÃO pode esquecer

1. **Módulos separados:** `ambiente.gleam`, `objeto.gleam`, `enigma.gleam`, `jogador.gleam`, `jogo.gleam` e **`menus.gleam`** (no seu zip está `menu.gleam`, precisa renomear).
2. **Lógica pura:** funções de regra devolvem novo estado e nunca alteram o anterior.
3. **`io.println` só na camada de apresentação** (`menus.gleam`).
4. **Menus por funções nomeadas** (`m1()`, `m2()`, `m3()`, `exit()`), sem `read()`.
5. **Mecânicas obrigatórias:** explorar ambientes, interagir com objetos, resolver enigmas.
6. **História própria:** início, progressão e uma razão clara para sair; enigmas ligados ao cenário; pistas suficientes para dedução; caminho até a saída testado.
7. **Interface visual (SGleam image/world) é opcional.** Você decidiu ficar 100% no terminal, o que é permitido.
8. **Avaliação:** (a) implementação: correção, completude, uso dos conceitos, documentação, organização; a análise automatizada pode olhar **linhas de código, documentação e testes unitários**; (b) apresentação oral.
9. **Equipe:** 1 a 3 pessoas; todos contribuem com código, documentação e testes.
10. **Tema:** a escolha precisa ser **informada e confirmada pelo professor** (confirme que o tema 09 está aprovado para você).

### A.4 O que entregar

- Arquivos-fonte `.gleam` + **slides em PDF** + arquivos acessórios.
- Compactar, subir no **Google Drive** e enviar o link para **wigarashi@uem.br**.
- **Assunto:** `Trabalho 2 de Programação Funcional, Semestre, 2026` (troque "Semestre" pelo semestre da turma, ou pergunte ao professor como ele quer).
- **Corpo:** nome completo e RA de cada integrante.
- **Apresentação oral:** 10 a 15 minutos.

> O enunciado não informa a data limite. Confirme com o professor.

---

## PARTE B: Onde você está hoje

### B.1 Estado dos arquivos do zip

| Arquivo | Estado | O que falta |
|---|---|---|
| `jogador.gleam` | ✅ **Pronto** (9 funções: `novo`, `pegar`, `tem`, `consumir`, `remover_um`, `ativar`, `flag_ativa`, `resolvido`, `mover`) | Pequenos ajustes (ver B.3), comentários de documentação |
| `objeto.gleam` | ⚠️ **Quebrado** | `import jogadorpub` (linha grudada), `type Objeto` sem `pub`, 4 funções com `todo` |
| `enigma.gleam` | ❌ Só `todo` | Tipo `Enigma` e `resolver_enigma` |
| `ambiente.gleam` | ❌ Só `todo` | Tipo `Ambiente`, `buscar`, `explorar` |
| `cenario.gleam` | ❌ Só `import ambiente` | Os 7 andares, objetos e 10 enigmas |
| `jogo.gleam` | ❌ Só `import cenario` | Estado, `Acao`, `aplicar`, `executar`, `ir`, `interagir`, `resolver`, `venceu` |
| `menu.gleam` | ❌ Nome errado + `todo` | Renomear para `menus.gleam`; `m1`, `m2`, `m3`, `exit`, `display_main_menu` |
| `jogo_test.gleam` | ❌ Não existe | Testes |
| Slides PDF | ❌ | Fazer |

O **design** (história, andares, tabela, 10 enigmas, caminho de resolução e arquitetura) já está bem fechado em `storytelling/organizacao.md`. O trabalho que falta é **implementar** e **testar**.

### B.2 Verificação do seu design (o jogo é resolvível?)

Conferi o caminho principal do seu `organizacao.md` contra os requisitos de cada enigma e **ele fecha**: nenhum item fica faltando, os dois cabos de energia são necessários (um é consumido no notebook, o outro na esteira) e todo enigma tem pista dedutível. As 10 etapas de enigma batem com "3 salas com 2 enigmas".

### B.3 Pontos de atenção (resolva antes de codar)

| # | Problema | Por que importa | Sugestão |
|---|---|---|---|
| 1 | **Saída condicional:** o duto 4→2 só existe depois do enigma 5, mas `saidas: List(Int)` é fixa | Sem isso o jogador atravessaria o duto sem arrancar a grade | Criar `type Saida { Saida(destino: Int, requisito: fn(Jogador) -> Bool) }` e usar `List(Saida)` |
| 2 | **Pegar objeto duas vezes duplica o item** (`pegando` não é idempotente) | O jogador pegaria 5 cabos de energia | Nova flag `Coletado(String)`; `pegando(id, item)` só pega se a flag não estiver ativa |
| 3 | **Dica do portão duplicada:** o papel da caixa (andar 5) e o papel da parede (andar 1) dizem a mesma ordem dos botões | Duas fontes para a mesma informação | Deixar um dos dois como a pista "oficial" e o outro como confirmação, ou manter só um |
| 4 | **"Papel do computador do colega" (enigma 9)** diz que o chaveiro é de metal, mas não está na tabela do andar 7 | Falta de onde a pista vem | Fazer o computador do colega entregar **dois** papéis: senha 2486 e "chaveiro é de metal" |
| 5 | **Revelar o código 1540 (enigma 2)**: `interacao` só devolve `Jogador`, não texto | O jogador precisa *ver* o código | Entregar a informação como item `Papel("Código 1540...")`; ele lê no inventário (`m2`) |
| 6 | **Mensagem pós-interação:** o menu não sabe o que aconteceu | Experiência de jogo pobre | Comparar o jogador antes/depois; se mudou, imprimir a `descricao` do objeto; se não, "nada acontece" |
| 7 | **`pontos_de_vida` nunca é usado** | Campo do enunciado sem função | Opcional: errar a ordem dos botões no portão custa 1 PV (3 PV no total); 0 PV = fim de jogo. Ou deixe o campo sem uso |
| 8 | **`estado: String` do `Objeto`** não consegue mudar (a interação só devolve `Jogador`) | Campo morto | Usar só como rótulo fixo ("trancado", "livre"), ou calcular o texto a partir das flags |
| 9 | **Duto 5→7?** A tabela do andar 5 diz "4° ou 6°" | É duto de mão única | Decida e mantenha: duto só **desce** (7→5 e 4→2) |
| 10 | **`list.contains` com comentário "provavelmente não pode"** | O enunciado não proíbe a biblioteca (o próprio exemplo usa `list.map`) | Pode usar. Se quiser mostrar mais recursão, escreva `tem` recursivo (código na Fase 1) |
| 11 | **Nome do arquivo e imports:** `menu.gleam` vs `menus.gleam` | Entrega fora do padrão | Renomear |

---

## PARTE C: Passo a passo completo

### Fase 0: Preparação (30 min)

- [ ] Confirmar com o professor: tema 09 aprovado, data de entrega, formato do assunto do e-mail, se o SGleam é o ambiente esperado.
- [ ] **Testar imports entre arquivos no SGleam:** criar `a.gleam` (com `pub fn f() { 1 }`) e `b.gleam` (com `import a`, `pub fn g() { a.f() }`) e rodar `./sgleam b.gleam`. Se não funcionar, ver `./sgleam --help` ou o material de aula.
- [ ] Testar se o REPL aceita redefinir `let j = ...` e como usar `sgleam/check` (nomes `check.eq` e sufixo `_examples`).
- [ ] Decidir os itens da tabela B.3 (principalmente 1, 2, 5 e 6).
- [ ] Combinar a divisão de trabalho, se houver mais de uma pessoa.

### Fase 1: Corrigir e fechar o `jogador.gleam` (30 min)

Acrescente a flag de coleta e (opcionalmente) vida:

```gleam
pub type Flag {
    EnergiaLigada
    NotebookLigado
    PortaPlacasAberta
    EsteiraLigada
    Coletado(String)      // novo: id do objeto já pego
    EnigmaResolvido(Int)
}

/// Tira 1 ponto de vida do jogador.
pub fn perder_vida(j: Jogador) -> Jogador {
    Jogador(..j, pontos_de_vida: j.pontos_de_vida - 1)
}

/// Indica se o jogador ainda tem vida.
pub fn vivo(j: Jogador) -> Bool {
    j.pontos_de_vida > 0
}
```

Versão recursiva opcional de `tem` (mais recursão para mostrar na apresentação):

```gleam
/// Verifica se o item está no inventário.
pub fn tem(j: Jogador, item: Item) -> Bool {
    contem(j.inventario, item)
}

fn contem(itens: List(Item), item: Item) -> Bool {
    case itens {
        [] -> False
        [primeiro, ..resto] -> primeiro == item || contem(resto, item)
    }
}
```

- [ ] Adicionar `Coletado(String)` ao tipo `Flag`.
- [ ] Decidir sobre `perder_vida`/`vivo` (item 7 da B.3).
- [ ] Escrever comentário `///` em **todas** as funções públicas (a análise automatizada olha documentação).

### Fase 2: `objeto.gleam` (1 h)

Corrija o import quebrado e torne o tipo público. Generalize as fábricas com uma função de ordem superior `quando`:

```gleam
import jogador.{type Flag, type Item, type Jogador}

pub type Objeto {
    Objeto(
        nome: String,
        descricao: String,
        interacao: fn(Jogador) -> Jogador,
        estado: String,
    )
}

/// Aplica o efeito só se a condição for verdadeira; senão devolve o jogador intacto.
pub fn quando(
    condicao: fn(Jogador) -> Bool,
    efeito: fn(Jogador) -> Jogador,
) -> fn(Jogador) -> Jogador {
    fn(j) {
        case condicao(j) {
            True -> efeito(j)
            False -> j
        }
    }
}

/// Efeito: coloca o item no inventário, uma única vez (usa a flag Coletado).
pub fn pegando(id: String, item: Item) -> fn(Jogador) -> Jogador {
    quando(
        fn(j) { !jogador.flag_ativa(j, jogador.Coletado(id)) },
        fn(j) { j |> jogador.pegar(item) |> jogador.ativar(jogador.Coletado(id)) },
    )
}

/// Efeito: liga uma flag.
pub fn ativando(flag: Flag) -> fn(Jogador) -> Jogador {
    fn(j) { jogador.ativar(j, flag) }
}

/// Efeito: remove um item do inventário.
pub fn consumindo(item: Item) -> fn(Jogador) -> Jogador {
    fn(j) { jogador.consumir(j, item) }
}

/// Só aplica o efeito se o jogador tiver o item.
pub fn exigindo(item: Item, efeito: fn(Jogador) -> Jogador) -> fn(Jogador) -> Jogador {
    quando(fn(j) { jogador.tem(j, item) }, efeito)
}

/// Só aplica o efeito se a flag estiver ativa.
pub fn exigindo_flag(flag: Flag, efeito: fn(Jogador) -> Jogador) -> fn(Jogador) -> Jogador {
    quando(fn(j) { jogador.flag_ativa(j, flag) }, efeito)
}

/// Composição: aplica f e depois g.
pub fn depois(
    f: fn(Jogador) -> Jogador,
    g: fn(Jogador) -> Jogador,
) -> fn(Jogador) -> Jogador {
    fn(j) { g(f(j)) }
}
```

> O comentário "não sei se `depois` é necessário": **é**, e é a sua prova de **composição de funções**. Ex.: o notebook precisa consumir o cabo **e** ligar a flag **e** entregar o papel com o código.

- [ ] Escrever o arquivo e rodar no SGleam para ver se compila.
- [ ] Testar no REPL: `let f = pegando("cabo-3", CaboEnergia)` e aplicar duas vezes em `jogador.novo("Guarda", 7)` (deve ter 1 cabo).

### Fase 3: `enigma.gleam` (1 h)

```gleam
import gleam/string
import jogador.{type Jogador}

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

/// Deixa a resposta em minúsculas e sem espaços nas pontas.
pub fn normalizar(texto: String) -> String {
    texto |> string.trim |> string.lowercase
}

/// Resposta certa + requisito cumprido + ainda não resolvido: aplica o efeito
/// e registra EnigmaResolvido(id). Caso contrário, devolve o jogador intacto.
pub fn resolver_enigma(enigma: Enigma, resposta: String, j: Jogador) -> Jogador {
    let acertou = normalizar(resposta) == normalizar(enigma.solucao)
    case acertou && enigma.requisito(j) && !jogador.resolvido(j, enigma.id) {
        True -> j |> enigma.efeito |> jogador.ativar(jogador.EnigmaResolvido(enigma.id))
        False -> j
    }
}
```

- [ ] Escrever e compilar.
- [ ] Testar com um enigma de teste (resposta certa muda, errada não muda).

### Fase 4: `ambiente.gleam` (1 h)

```gleam
import enigma.{type Enigma}
import gleam/int
import gleam/list
import gleam/string
import jogador.{type Jogador}
import objeto.{type Objeto}

/// Uma saída para outro andar; só está aberta se o requisito for cumprido.
pub type Saida {
    Saida(destino: Int, requisito: fn(Jogador) -> Bool)
}

pub type Ambiente {
    Ambiente(
        andar: Int,
        nome: String,
        descricao: String,
        objetos: List(Objeto),
        saidas: List(Saida),
        enigmas: List(Enigma),
    )
}

/// Requisito para saídas sempre abertas.
pub fn sempre(_j: Jogador) -> Bool {
    True
}

/// Busca recursiva do andar pelo número.
pub fn buscar(andares: List(Ambiente), numero: Int) -> Result(Ambiente, Nil) {
    case andares {
        [] -> Error(Nil)
        [primeiro, ..resto] ->
            case primeiro.andar == numero {
                True -> Ok(primeiro)
                False -> buscar(resto, numero)
            }
    }
}

/// O jogador pode ir para esse destino a partir deste ambiente?
pub fn saida_aberta(ambiente: Ambiente, destino: Int, j: Jogador) -> Bool {
    list.any(ambiente.saidas, fn(s) { s.destino == destino && s.requisito(j) })
}

/// Texto da exploração (função pura; quem imprime é o menus.gleam).
pub fn explorar(ambiente: Ambiente, j: Jogador) -> String {
    let objetos = list.map(ambiente.objetos, fn(o) { o.nome })
    let saidas =
        ambiente.saidas
        |> list.filter(fn(s) { s.requisito(j) })
        |> list.map(fn(s) { int.to_string(s.destino) })
    string.join(
        [
            ambiente.nome <> ": " <> ambiente.descricao,
            "Objetos: " <> string.join(objetos, ", "),
            "Saídas: " <> string.join(saidas, ", "),
        ],
        "\n",
    )
}
```

- [ ] Escrever e compilar.
- [ ] Testar `buscar` com lista vazia (deve dar `Error(Nil)`) e com um andar.

### Fase 5: `cenario.gleam`, começando só pelo andar 7 (1 h)

O `cenario` só tem **dados**. Comece com um andar para validar a arquitetura:

```gleam
import ambiente.{type Ambiente, Ambiente, Saida, sempre}
import enigma.{Enigma}
import jogador.{Papel}
import objeto.{Objeto, pegando}

pub fn seguranca() -> Ambiente {
    Ambiente(
        andar: 7,
        nome: "Sala de segurança",
        descricao: "Monitores apagados. Você acordou de um cochilo e a torre está trancada.",
        objetos: [
            Objeto(
                "papel do guarda",
                "Anotação sua: 'Meu código do armário: onde eu trabalho, onde eu saio, onde eu guardo as ferramentas.'",
                pegando("papel-guarda", Papel("Meu código do armário: onde eu trabalho, onde eu saio, onde eu guardo as ferramentas.")),
                "livre",
            ),
            // computador do colega: ver Fase 7
        ],
        saidas: [Saida(6, sempre), Saida(5, sempre)],   // 5 = duto de ventilação
        enigmas: [],
    )
}

pub fn torre() -> List(Ambiente) {
    [seguranca()]   // vai crescendo nas fases seguintes
}
```

- [ ] Rodar `torre()` no REPL e conferir.

### Fase 6: `jogo.gleam` (1,5 h)

```gleam
import ambiente.{type Ambiente}
import cenario
import enigma
import gleam/list
import jogador.{type Jogador}

pub type Jogo {
    Jogo(jogador: Jogador, andares: List(Ambiente))
}

pub type Acao {
    Explorar
    Interagir(objeto: String)
    Resolver(enigma: Int, resposta: String)
    Ir(andar: Int)
}

/// Estado inicial: guarda no 7º andar.
pub fn novo() -> Jogo {
    Jogo(jogador: jogador.novo("Guarda", 7), andares: cenario.torre())
}

pub fn ambiente_atual(jogo: Jogo) -> Result(Ambiente, Nil) {
    ambiente.buscar(jogo.andares, jogo.jogador.localizacao)
}

/// Vai para outro andar, se a saída estiver aberta.
pub fn ir(jogo: Jogo, destino: Int) -> Jogo {
    case ambiente_atual(jogo) {
        Error(_) -> jogo
        Ok(atual) ->
            case ambiente.saida_aberta(atual, destino, jogo.jogador) {
                True -> Jogo(..jogo, jogador: jogador.mover(jogo.jogador, destino))
                False -> jogo
            }
    }
}

/// Interage com um objeto do andar atual.
pub fn interagir(jogo: Jogo, nome: String) -> Jogo {
    case ambiente_atual(jogo) {
        Error(_) -> jogo
        Ok(atual) ->
            case list.find(atual.objetos, fn(o) { o.nome == nome }) {
                Ok(obj) -> Jogo(..jogo, jogador: obj.interacao(jogo.jogador))
                Error(_) -> jogo
            }
    }
}

/// Tenta resolver um enigma do andar atual.
pub fn resolver(jogo: Jogo, id: Int, resposta: String) -> Jogo {
    case ambiente_atual(jogo) {
        Error(_) -> jogo
        Ok(atual) ->
            case list.find(atual.enigmas, fn(e) { e.id == id }) {
                Ok(e) ->
                    Jogo(..jogo, jogador: enigma.resolver_enigma(e, resposta, jogo.jogador))
                Error(_) -> jogo
            }
    }
}

/// Aplica uma ação e devolve o novo estado.
pub fn aplicar(jogo: Jogo, acao: Acao) -> Jogo {
    case acao {
        Explorar -> jogo
        Interagir(nome) -> interagir(jogo, nome)
        Resolver(id, resposta) -> resolver(jogo, id, resposta)
        Ir(andar) -> ir(jogo, andar)
    }
}

/// Executa uma lista de ações em sequência.
pub fn executar(jogo: Jogo, acoes: List(Acao)) -> Jogo {
    list.fold(acoes, jogo, aplicar)
}

/// O jogador venceu quando o enigma 10 está resolvido.
pub fn venceu(jogo: Jogo) -> Bool {
    jogador.resolvido(jogo.jogador, 10)
}
```

- [ ] Escrever e compilar.
- [ ] No REPL: `novo() |> ir(6)` muda o andar; `novo() |> ir(3)` **não** muda (sem saída direta).
- [ ] Primeiro teste em `jogo_test.gleam` (ver Fase 9).

### Fase 7: Os 7 andares completos e os 10 enigmas (3 a 4 h)

Esta é a parte mais longa. **Mecanismo recomendado** (decisão que simplifica): 5 puzzles são **interações com objetos** (`interagir`) e 5 são **enigmas com resposta digitada** (`resolver`).

#### Tabela de implementação dos 10 enigmas

| # | Andar | Mecanismo | Requisito | Resposta | Efeito |
|---|---|---|---|---|---|
| 1 | 3 | Objeto `alavanca` | nenhum | | `EnergiaLigada` + `EnigmaResolvido(1)` |
| 2 | 6 | Objeto `notebook` | `CaboEnergia` | | consome o cabo, `NotebookLigado`, `EnigmaResolvido(2)`, recebe `Papel("Código 1540. Dono: colega da sala de segurança")` |
| 3 | 5 | **Enigma** (porta com teclado) | nenhum | `2486` | `PortaPlacasAberta` |
| 4 | 5 | Objeto `caixa de placas` | `PeDeCabra` + `PortaPlacasAberta` | | recebe `BotaoAtivacao("vermelho")` + `Papel("O portão só abre com a chave e os dois botões, vermelho primeiro, azul depois.")`, `EnigmaResolvido(4)` |
| 5 | 4 | Objeto `grade do duto` | `PeDeCabra` | | `EnigmaResolvido(5)` (abre a `Saida(2, ...)` do andar 4) |
| 6 | 4 | **Enigma** (painel de baterias) | nenhum | `20 55 90` | recebe `BotaoAtivacao("azul")` |
| 7 | 3 | **Enigma** (armário) | nenhum | `713` | recebe `PeDeCabra` |
| 8 | 2 | Objeto `painel da esteira` | `CaboEnergia` | | consome o cabo, `EsteiraLigada`, `EnigmaResolvido(8)` |
| 9 | 2 | **Enigma** (caixas de separação) | `EsteiraLigada` | `metal` | recebe `Chave` |
| 10 | 1 | **Enigma** (portão) | `Chave` + botão vermelho + botão azul | `vermelho azul` | fim de jogo (`venceu`) |

> No enigma 10, se quiser usar vida: resposta errada (por exemplo, `azul vermelho`) = `perder_vida`.

#### Objetos por andar (nomes sugeridos, sem acento, minúsculos)

| Andar | Objetos | Saídas |
|---|---|---|
| 1 Garagem | `portao`, `papel da parede` | saída do jogo (via enigma 10) ou 2 |
| 2 Triagem | `painel da esteira`, `caixa de metal`, `caixa de plastico`, `caixa de vidro` | 1 ou 3 |
| 3 Armazém | `alavanca` (quadro de energia), `cabo de energia`, `armario` | 2 ou 4 |
| 4 Baterias | `prateleira de baterias`, `cabo de energia`, `grade do duto`, `painel de baterias` | 3, 5 ou **2 (só se `EnigmaResolvido(5)`)** |
| 5 Placas | `porta com teclado`, `caixa de placas` | 4 ou 6 |
| 6 Computadores | `notebook` | 5 ou 7 |
| 7 Segurança | `papel do guarda`, `computador do colega` | 6 ou 5 (duto) |

Exemplos de objetos (use `depois`, `exigindo`, `pegando`, `ativando`):

```gleam
// Enigma 1: alavanca
Objeto("alavanca", "Você puxa a alavanca. A energia volta.",
    depois(ativando(EnergiaLigada), ativando(EnigmaResolvido(1))), "desligada")

// Enigma 2: notebook (consome o cabo, liga e entrega o papel)
Objeto("notebook", "O notebook liga e mostra um código.",
    exigindo(CaboEnergia,
        depois(consumindo(CaboEnergia),
        depois(ativando(NotebookLigado),
        depois(ativando(EnigmaResolvido(2)),
               pegando("papel-codigo", Papel("Código 1540. Dono: colega da sala de segurança")))))),
    "sem bateria")

// Computador do colega (andar 7): precisa de energia e do notebook ligado
Objeto("computador do colega", "Você entra no computador.",
    exigindo_flag(EnergiaLigada,
        exigindo_flag(NotebookLigado,
            depois(pegando("papel-senha", Papel("Senha da porta das placas: 2486")),
                   pegando("papel-chaveiro", Papel("O chaveiro do guarda é de metal."))))),
    "desligado")
```

Saída condicional do andar 4 (duto):

```gleam
Saida(2, fn(j) { jogador.resolvido(j, 5) })
```

Pistas do painel de baterias (enigma 6): baterias com 20%, 55% e 90% e o papel colado "Ligue da menos carregada para a mais carregada". A solução `20 55 90` precisa estar dedutível pela descrição.

Passos:
- [ ] Implementar `garagem()`, `triagem()`, `armazem()`, `baterias()`, `placas()`, `computadores()`, `seguranca()` (uma por vez, compilando).
- [ ] Preencher `torre()` com os 7 andares.
- [ ] Escrever `descricao` e `pistas` que façam o jogador *deduzir* as respostas (exigência do enunciado).
- [ ] Rodar o caminho principal na mão no REPL para ver se está completo.

### Fase 8: `menus.gleam` (1 h)

Renomear `menu.gleam` para `menus.gleam`. É o **único** módulo com `io.println`.

```gleam
import ambiente
import gleam/io
import gleam/list
import gleam/string
import jogador
import jogo.{type Jogo}

pub fn display_main_menu() {
    io.println("--- MENU PRINCIPAL ---")
    io.println("m1(j): Explorar ambiente")
    io.println("m2(j): Consultar inventário")
    io.println("m3(j): Examinar enigmas")
    io.println("exit(): Encerrar simulação")
}

/// Explora o ambiente atual e devolve o jogo inalterado.
pub fn m1(j: Jogo) -> Jogo {
    case jogo.ambiente_atual(j) {
        Ok(a) -> io.println(ambiente.explorar(a, j.jogador))
        Error(_) -> io.println("Você está perdido.")
    }
    j
}

// m2: imprimir os itens do inventário (inclusive o texto dos Papel)
// m3: imprimir descricao e pistas dos enigmas do andar atual
// ir / interagir / resolver: atalhos que chamam jogo.* e imprimem o resultado
```

> **Cuidado:** o enunciado sugere `type MainMenu { Explorar ... }` e o seu `jogo.gleam` tem `Acao.Explorar`. Duas variantes com o mesmo nome importadas sem prefixo **dão conflito**. Renomeie (`OpExplorar`, por exemplo) ou use `jogo.Explorar` qualificado.

- [ ] `display_main_menu`, `m1`, `m2`, `m3`, `exit`.
- [ ] Atalhos `ir`, `interagir`, `resolver` que imprimem feedback (antes/depois do jogador: se mudou, imprime a `descricao` do objeto; se não, "nada acontece").
- [ ] Mensagem de vitória quando `venceu`.

### Fase 9: Testes (1,5 h)

Crie `jogo_test.gleam` (confirme a sintaxe de `sgleam/check` no material de aula):

```gleam
import jogador
import jogo.{Interagir, Ir, Resolver}
import sgleam/check

pub fn mover_examples() {
    let j = jogo.novo() |> jogo.ir(6)
    check.eq(j.jogador.localizacao, 6)
}

pub fn mover_invalido_examples() {
    let j = jogo.novo() |> jogo.ir(3)
    check.eq(j.jogador.localizacao, 7)
}

pub fn pegar_uma_vez_examples() {
    let j =
        jogo.novo()
        |> jogo.executar([Ir(6), Ir(5), Ir(4), Ir(3), Interagir("cabo de energia"), Interagir("cabo de energia")])
    check.eq(jogador.tem(j.jogador, jogador.CaboEnergia), True)
}

pub fn resposta_errada_examples() {
    let j = jogo.novo() |> jogo.executar([Ir(6), Ir(5), Ir(4), Ir(3), Resolver(7, "000")])
    check.eq(jogador.resolvido(j.jogador, 7), False)
}
```

> Compare **campos simples** (`localizacao`, `resolvido`...), não `Jogo` ou `Ambiente` inteiros: eles contêm funções e `==` sobre função não é confiável.

Conjunto mínimo de testes:
- [ ] **Por enigma:** certo muda o estado; errado não muda (10 enigmas, ao menos os 5 com resposta).
- [ ] **Por requisito:** sem `PeDeCabra` a caixa de placas não abre; sem `CaboEnergia` o notebook não liga; sem `EnigmaResolvido(5)` o duto 4→2 está fechado.
- [ ] **Por movimento:** andar fora das saídas não muda a localização.
- [ ] **Idempotência:** pegar duas vezes = 1 item.
- [ ] **Ponta a ponta:** caminho principal completo e `venceu` verdadeiro.

Caminho principal como lista de `Acao` (use exatamente os nomes de objetos do `cenario`):

```gleam
pub fn caminho_principal() -> List(Acao) {
    [
        Interagir("papel do guarda"),
        Ir(6), Ir(5), Ir(4), Ir(3),
        Interagir("alavanca"),                // enigma 1
        Interagir("cabo de energia"),
        Resolver(7, "713"),                   // enigma 7 (pé de cabra)
        Ir(4), Ir(5), Ir(6),
        Interagir("notebook"),                // enigma 2
        Ir(7),
        Interagir("computador do colega"),    // senha 2486
        Ir(5),                                // duto
        Resolver(3, "2486"),                  // enigma 3
        Interagir("caixa de placas"),         // enigma 4 (botão vermelho)
        Ir(4),
        Interagir("grade do duto"),           // enigma 5
        Resolver(6, "20 55 90"),              // enigma 6 (botão azul)
        Interagir("cabo de energia"),         // segundo cabo
        Ir(2),                                // duto
        Interagir("painel da esteira"),       // enigma 8
        Resolver(9, "metal"),                 // enigma 9 (chave)
        Ir(1),
        Resolver(10, "vermelho azul"),        // enigma 10
    ]
}
```

### Fase 10: Documentação e limpeza (1 h)

- [ ] `///` em todas as funções públicas e tipos.
- [ ] Remover os `todo` e comentários de dúvida ("Provavelmente não pode...", "Não sei se...").
- [ ] Remover imports não usados (o compilador avisa).
- [ ] Nomes de arquivo conforme o enunciado (`menus.gleam`).
- [ ] Um `README.md` curto: como rodar no SGleam e exemplo de partida no REPL.
- [ ] Atualizar `organizacao.md` com o que mudou no design (`Saida`, `Coletado`, `quando`...).

### Fase 11: Slides (2 h)

PDF final com 10 a 15 min de fala. Roteiro (do enunciado):

1. **Capa:** UEM · Ciência da Computação · Programação Funcional · Prof. Wagner Igarashi · título · tema 09 · autores · data.
2. **Objetivo:** história, andares, motivação do jogador e condição de saída (portão da garagem).
3. **Conceitos:** onde aparecem tipos algébricos, pattern matching, recursividade, composição e ordem superior (use a tabela A.2 com trechos de código reais).
4. **Demonstração:** executar o caminho principal no REPL: ver um objeto (`interagir`), um enigma (`resolver`), e o final. Ensaie e tenha um plano B (prints) se o SGleam falhar.
5. **Conclusões:** resultados, dificuldades (imutabilidade, estado sem variáveis, imports), melhorias (interface visual com `sgleam/world`).
6. **Referências:** apenas o que você **realmente** usou (material de aula, documentação de Gleam, SGleam, contexto de lixo eletrônico).

- [ ] Fazer os slides e exportar em **PDF**.
- [ ] Ensaiar com cronômetro (10 a 15 min).

### Fase 12: Entrega

- [ ] Montar a pasta final: `.gleam` + testes + README + slides PDF + `organizacao.md`.
- [ ] **Não incluir a pasta `.git`** no compactado.
- [ ] Compactar (`.zip`), subir no Google Drive, **abrir o link em aba anônima** para conferir a permissão.
- [ ] Enviar e-mail para **wigarashi@uem.br**:
  - **Assunto:** `Trabalho 2 de Programação Funcional, <semestre>, 2026`
  - **Corpo:** nome completo e RA de cada integrante + link.

---

## Armadilhas comuns de Gleam neste projeto

1. **`==` com funções:** `Objeto`, `Enigma`, `Saida`, `Ambiente` e `Jogo` têm campos `fn`. Compare por `nome`/`id`/campos simples. `Jogador`, `Item` e `Flag` **não** têm funções e podem ser comparados.
2. **Ciclo de imports:** proibido. Respeite a ordem `jogador → objeto/enigma → ambiente → cenario → jogo → menus`.
3. **Variantes com mesmo nome:** `Explorar` em `Acao` e em `MainMenu` conflitam se importadas sem prefixo.
4. **Imutabilidade:** nada de "mudar o jogador"; sempre `Jogador(..j, campo: novo)` e devolver o novo.
5. **Pipe `|>`:** `x |> f(y)` vira `f(x, y)`; o valor entra como **primeiro** argumento.
6. **Texto:** `<>` concatena; no REPL o `\n` aparece escapado, por isso só `menus.gleam` imprime.
7. **`Papel(texto)` e `contains`:** `tem(j, Papel("..."))` exige o texto **exato**. Se precisar, escreva um `tem_papel`.
8. **Respostas digitadas:** use `normalizar` (trim + lowercase) e evite acentos nas respostas esperadas.
9. **`todo`:** compila com aviso, mas quebra em tempo de execução. Não pode sobrar nenhum na entrega.

---

## Checklist final

- [ ] 6 módulos exigidos existem com os nomes certos (`menus.gleam` incluso)
- [ ] Tipos algébricos, pattern matching, recursão, composição e ordem superior **identificáveis** no código
- [ ] Lógica pura; `io.println` só em `menus.gleam`
- [ ] 7 andares, 10 enigmas, 5 tipos de objeto funcionando
- [ ] Caminho principal testado de ponta a ponta (`venceu` verdadeiro)
- [ ] Testes unitários (`jogo_test.gleam`) passando
- [ ] Documentação `///` em tudo que é público; sem `todo`
- [ ] Slides PDF prontos e ensaiados (10 a 15 min)
- [ ] Zip sem `.git`, link do Drive aberto para o professor
- [ ] E-mail enviado com assunto correto e nome + RA de todos