import ambiente.{type Ambiente, Ambiente, sempre}
import jogador.{
  type Jogador, BotaoAtivacao, CaboEnergia, Chave, EnergiaLigada, EnigmaResolvido,
  EsteiraLigada, NotebookLigado, Papel, PeDeCabra, PortaPlacasAberta, Saida,
}
import enigma.{type Enigma, Enigma}
import gleam/list
import objeto.{
  Objeto, ativando, consumindo, depois, exigindo, exigindo_flag, pegando,
}

/// Aqui, cada andar da torre é um ambiente. Cada ambiente tem uma lista de objetos, uma lista de saídas e uma lista de enigmas. O jogador pode interagir com os objetos, ir para outros andares pelas saídas e resolver enigmas.
/// Cada andar tem sua resolução de enigmas, que podem ser objetos ou respostas digitadas. O jogador precisa cumprir requisitos para acessar saídas e resolver enigmas. A torre é composta por 7 andares, cada um com suas características e desafios. 
/// Cada função tem suas soluções individuais, que podem ser objetos ou respostas digitadas. O jogador precisa cumprir requisitos para acessar saídas e resolver enigmas. A torre é composta por 7 andares, cada um com suas características e desafios.
// ---------------------------------------------------------------------------
// Funções auxiliares (só deste arquivo)
// ---------------------------------------------------------------------------

/// Interação que não faz nada (objeto só para olhar).
fn nada(j: Jogador) -> Jogador {
  j
}

/// Junta vários efeitos em um só, aplicados na ordem da lista.
/// É o mesmo que encadear `depois(a, depois(b, c))`, só que mais legível.
/// ANÁLISE: Faça uma função que recebe uma lista de efeitos e retorna um efeito que aplica todos os efeitos da lista em sequência.
/// TIPOS DE DADOS: A entrada é uma *lista de efeitos* representada pelo tipo *List(fn(Jogador) -> Jogador)*. A saída é um efeito que aplica todos os efeitos da lista em sequência, representado pelo tipo *fn(Jogador) -> Jogador*.
/// ESPECIFICAÇÃO: Recebe uma *lista de efeitos* e retorna um efeito que aplica todos os efeitos da lista em sequência. O efeito resultante aplica cada efeito da lista na ordem em que aparecem, passando o jogador atualizado de um efeito para o próximo.
fn em_sequencia(
  efeitos: List(fn(Jogador) -> Jogador),
) -> fn(Jogador) -> Jogador {
  fn(j) { list.fold(efeitos, j, fn(acumulado, efeito) { efeito(acumulado) }) }
}

// ---------------------------------------------------------------------------
// A torre: lista com os 7 andares
// ---------------------------------------------------------------------------

/// Os 7 andares da torre. O jogo busca o andar pelo número (ambiente.buscar).
/// // ANÁLISE: Faça uma função que retorna uma lista com os 7 andares da torre, cada um representado pelo tipo *Ambiente*.
/// // TIPOS DE DADOS: A saída é uma *lista de andares* representada pelo tipo *List(Ambiente)*.
/// // ESPECIFICAÇÃO: Retorna uma *lista com os 7 andares da torre*, cada um representado pelo tipo *Ambiente*. A lista contém os andares na ordem em que aparecem na torre, do 1º ao 7º andar.
pub fn torre() -> List(Ambiente) {
  [
    garagem(),
    triagem(),
    armazem(),
    baterias(),
    placas(),
    computadores(),
    seguranca(),
  ]
}

// ---------------------------------------------------------------------------
// Andar 1: Garagem (enigma 10)
// ---------------------------------------------------------------------------
/// ANÁLISE: Faça uma função que cria o enigma 10, que é o portão da garagem. O enigma precisa da chave e dos dois botões de ativação, nesta ordem de resposta.
/// TIPOS DE DADOS: A saída é um *enigma* representado pelo tipo *Enigma*.
/// ESPECIFICAÇÃO: Cria o enigma 10, que é o portão da garagem. O enigma precisa da chave e dos dois botões de ativação, nesta ordem de resposta. O enigma contém um identificador, uma descrição, uma solução, uma lista de pistas, um requisito e um efeito.
/// Enigma 10: o portão. Precisa da chave e dos dois botões, nesta ordem de resposta.
fn enigma10() -> Enigma {
  Enigma(
    id: 10,
    descricao: "O portão tem uma fechadura e dois botões de ativação. Qual a ordem para acioná-los?",
    solucao: "vermelho azul",
    pistas: [
      "Leia o papel colado na parede da garagem.",
      "Você precisa estar com a chave e com os dois botões de ativação.",
    ],
    requisito: fn(j) {
      jogador.tem(j, Chave)
      && jogador.tem(j, BotaoAtivacao("vermelho"))
      && jogador.tem(j, BotaoAtivacao("azul"))
    },
    efeito: nada,
  )
}

/// ANÁLISE: Faça uma função que cria o ambiente da garagem, que é o 1º andar da torre. O ambiente contém o portão da garagem e um papel colado na parede com a ordem de acionamento dos botões.
/// TIPOS DE DADOS: A saída é um *ambiente* representado pelo tipo *Ambiente*.
/// ESPECIFICAÇÃO: Cria o ambiente da garagem, que é o 1º andar da torre. O ambiente contém o portão da garagem e um papel colado na parede com a ordem de acionamento dos botões. O ambiente contém um identificador, um nome, uma descrição, uma lista de objetos, uma lista de saídas e uma lista de
/// 1º andar: a saída da torre.
pub fn garagem() -> Ambiente {
  Ambiente(
    andar: 1,
    nome: "Garagem",
    descricao: "1º andar. É por aqui que os caminhões chegam. O portão da garagem está fechado.",
    objetos: [
      Objeto(
        nome: "portao",
        descricao: "O portão tem uma fechadura e dois botões de ativação.",
        interacao: nada,
        estado: "fechado",
      ),
      Objeto(
        nome: "papel da parede",
        descricao: "Você lê o papel na parede: 'Acione na ordem: vermelho primeiro, azul depois.'",
        interacao: pegando(
          "papel-parede",
          Papel("Acione na ordem: vermelho primeiro, azul depois."),
        ),
        estado: "colado",
      ),
    ],
    saidas: [Saida(2, sempre)],
    enigmas: [enigma10()],
  )
}

// ---------------------------------------------------------------------------
// Andar 2: Triagem (enigmas 8 e 9)
// ---------------------------------------------------------------------------

/// Enigma 9: o chaveiro do guarda é de metal, então vai na caixa de metal.
fn enigma9() -> Enigma {
  Enigma(
    id: 9,
    descricao: "As chaves do guarda caíram junto com o lixo. Em qual caixa o chaveiro deve ser colocado (metal, plastico ou vidro)?",
    solucao: "metal",
    pistas: [
      "O chaveiro do guarda é feito de que material?",
      "O computador do colega, no 7º andar, tem uma anotação sobre isso.",
    ],
    requisito: fn(j) { jogador.flag_ativa(j, EsteiraLigada) },
    efeito: pegando("chave-garagem", Chave),
  )
}

/// 2º andar: a esteira de separação.
pub fn triagem() -> Ambiente {
  Ambiente(
    andar: 2,
    nome: "Triagem",
    descricao: "2º andar. O lixo deixado pelos caminhões é separado aqui. A esteira está parada e as chaves do guarda caíram nela.",
    objetos: [
      // Enigma 8: religar a esteira com o cabo de energia
      Objeto(
        nome: "painel da esteira",
        descricao: "Você liga o cabo no painel. A esteira volta a funcionar e as caixas de separação ficam acessíveis.",
        interacao: exigindo_flag(
          EnergiaLigada,
          exigindo(
            CaboEnergia,
            em_sequencia([
              consumindo(CaboEnergia),
              ativando(EsteiraLigada),
              ativando(EnigmaResolvido(8)),
            ]),
          ),
        ),
        estado: "sem energia",
      ),
      Objeto(
        nome: "caixa de metal",
        descricao: "Uma caixa para objetos de metal.",
        interacao: nada,
        estado: "vazia",
      ),
      Objeto(
        nome: "caixa de plastico",
        descricao: "Uma caixa para objetos de plástico.",
        interacao: nada,
        estado: "vazia",
      ),
      Objeto(
        nome: "caixa de vidro",
        descricao: "Uma caixa para objetos de vidro.",
        interacao: nada,
        estado: "vazia",
      ),
    ],
    saidas: [Saida(1, sempre), Saida(3, sempre)],
    enigmas: [enigma9()],
  )
}

// ---------------------------------------------------------------------------
// Andar 3: Armazém de ferramentas (enigma 7, e a alavanca do enigma 1)
// ---------------------------------------------------------------------------

/// Enigma 7: o armário trancado (cadeado de 3 dígitos) guarda o pé de cabra.
fn enigma7() -> Enigma {
  Enigma(
    id: 7,
    descricao: "O armário de ferramentas está trancado com um cadeado de 3 dígitos.",
    solucao: "713",
    pistas: [
      "O guarda anotou o código do armário em algum lugar da sala de segurança.",
      "Pense em três andares: onde ele trabalha, por onde ele sai e onde guarda as ferramentas.",
    ],
    requisito: sempre,
    efeito: pegando("pe-de-cabra", PeDeCabra),
  )
}

/// 3º andar: ferramentas, o quadro de energia e o armário.
pub fn armazem() -> Ambiente {
  Ambiente(
    andar: 3,
    nome: "Armazém de ferramentas",
    descricao: "3º andar. Aqui ficam guardadas as ferramentas dos funcionários. Há um quadro de energia na parede.",
    objetos: [
      // Enigma 1: puxar a alavanca religa a energia do prédio
      Objeto(
        nome: "alavanca",
        descricao: "Você puxa a alavanca do quadro de energia. As luzes voltam e as tomadas funcionam.",
        interacao: em_sequencia([
          ativando(EnergiaLigada),
          ativando(EnigmaResolvido(1)),
        ]),
        estado: "desligada",
      ),
      Objeto(
        nome: "cabo de energia",
        descricao: "Você pega um cabo de energia.",
        interacao: pegando("cabo-3", CaboEnergia),
        estado: "no chao",
      ),
      Objeto(
        nome: "armario",
        descricao: "Um armário de ferramentas trancado com um cadeado de 3 dígitos.",
        interacao: nada,
        estado: "trancado",
      ),
    ],
    saidas: [Saida(2, sempre), Saida(4, sempre)],
    enigmas: [enigma7()],
  )
}

// ---------------------------------------------------------------------------
// Andar 4: Baterias (enigmas 5 e 6)
// ---------------------------------------------------------------------------

/// Enigma 6: encaixar as baterias da menos para a mais carregada.
fn enigma6() -> Enigma {
  Enigma(
    id: 6,
    descricao: "Um painel trancado tem 3 soquetes. As baterias mostram 20%, 55% e 90%. Em que ordem de carga você as encaixa?",
    solucao: "20 55 90",
    pistas: ["Um papel colado no painel diz: 'Ligue da menos carregada para a mais carregada.'"],
    requisito: sempre,
    efeito: pegando("botao-azul", BotaoAtivacao("azul")),
  )
}

/// 4º andar: baterias descartadas e o duto de ventilação.
pub fn baterias() -> Ambiente {
  Ambiente(
    andar: 4,
    nome: "Sala de baterias",
    descricao: "4º andar. Baterias descartadas pelos caminhões ficam armazenadas aqui. Uma grade parafusada cobre um duto de ventilação.",
    objetos: [
      Objeto(
        nome: "prateleira de baterias",
        descricao: "Baterias descartadas de vários tamanhos.",
        interacao: nada,
        estado: "cheia",
      ),
      Objeto(
        nome: "cabo de energia",
        descricao: "Você pega um cabo de energia jogado ao lado da prateleira.",
        interacao: pegando("cabo-4", CaboEnergia),
        estado: "no chao",
      ),
      // Enigma 5: arrancar a grade com o pé de cabra
      Objeto(
        nome: "grade do duto",
        descricao: "Você arranca a grade com o pé de cabra. O duto que leva ao 2º andar está livre.",
        interacao: exigindo(PeDeCabra, ativando(EnigmaResolvido(5))),
        estado: "parafusada",
      ),
      Objeto(
        nome: "painel de baterias",
        descricao: "Um painel trancado com 3 soquetes. As baterias mostram 20%, 55% e 90%. Um papel colado diz: 'Ligue da menos carregada para a mais carregada.'",
        interacao: nada,
        estado: "trancado",
      ),
    ],
    saidas: [
      Saida(3, sempre),
      Saida(5, sempre),
      // O duto para o 2º andar só abre depois do enigma 5
      Saida(2, fn(j) { jogador.resolvido(j, 5) }),
    ],
    enigmas: [enigma6()],
  )
}

// ---------------------------------------------------------------------------
// Andar 5: Placas eletrônicas (enigmas 3 e 4)
// ---------------------------------------------------------------------------

/// Enigma 3: a porta da sala de placas tem um teclado de 4 dígitos.
fn enigma3() -> Enigma {
  Enigma(
    id: 3,
    descricao: "A porta da sala de placas está trancada por um teclado numérico de 4 dígitos.",
    solucao: "2486",
    pistas: [
      "A senha está guardada no computador do seu colega, na sala de segurança.",
      "O computador só funciona com a energia ligada e depois de você descobrir o código do notebook.",
    ],
    requisito: sempre,
    efeito: ativando(PortaPlacasAberta),
  )
}

/// 5º andar: placas eletrônicas descartadas.
pub fn placas() -> Ambiente {
  Ambiente(
    andar: 5,
    nome: "Sala de placas eletrônicas",
    descricao: "5º andar. As placas eletrônicas deixadas pelos caminhões são descartadas aqui.",
    objetos: [
      Objeto(
        nome: "porta com teclado",
        descricao: "A porta da sala de placas tem um teclado numérico de 4 dígitos.",
        interacao: nada,
        estado: "trancada",
      ),
      // Enigma 4: abrir a caixa lacrada com o pé de cabra
      Objeto(
        nome: "caixa de placas",
        descricao: "Você abre o lacre com o pé de cabra. Dentro há uma placa com um botão de ativação vermelho e um papel.",
        interacao: exigindo_flag(
          PortaPlacasAberta,
          exigindo(
            PeDeCabra,
            em_sequencia([
              pegando("botao-vermelho", BotaoAtivacao("vermelho")),
              pegando(
                "papel-caixa",
                Papel(
                  "O portão da garagem só abre com a chave e com os dois botões de ativação.",
                ),
              ),
              ativando(EnigmaResolvido(4)),
            ]),
          ),
        ),
        estado: "lacrada",
      ),
    ],
    saidas: [Saida(4, sempre), Saida(6, sempre)],
    enigmas: [enigma3()],
  )
}

// ---------------------------------------------------------------------------
// Andar 6: Computadores descartados (enigma 2)
// ---------------------------------------------------------------------------

/// 6º andar: o notebook. O enigma 2 é um objeto, não precisa de resposta digitada.
pub fn computadores() -> Ambiente {
  Ambiente(
    andar: 6,
    nome: "Sala de computadores descartados",
    descricao: "6º andar. Computadores usados deixados pelos caminhões. Entre eles há um notebook com um led piscando: falta de bateria.",
    objetos: [
      Objeto(
        nome: "notebook",
        descricao: "O notebook liga e mostra o código 1540. O antigo usuário era o seu colega da sala de segurança.",
        interacao: exigindo_flag(
          EnergiaLigada,
          exigindo(
            CaboEnergia,
            em_sequencia([
              consumindo(CaboEnergia),
              ativando(NotebookLigado),
              ativando(EnigmaResolvido(2)),
              pegando(
                "papel-codigo",
                Papel("Código 1540. Usuário: colega da sala de segurança."),
              ),
            ]),
          ),
        ),
        estado: "sem bateria",
      ),
    ],
    saidas: [Saida(5, sempre), Saida(7, sempre)],
    enigmas: [],
  )
}

// ---------------------------------------------------------------------------
// Andar 7: Segurança (início do jogo; apresenta o enigma 1)
// ---------------------------------------------------------------------------

/// 7º andar: onde o guarda acorda. O enigma 1 é a alavanca do 3º andar.
pub fn seguranca() -> Ambiente {
  Ambiente(
    andar: 7,
    nome: "Sala de segurança",
    descricao: "7º andar. Você acordou de um cochilo e a torre está fechada. Os computadores estão desligados e nenhuma tomada funciona. O quadro de energia deve estar no armazém de ferramentas, no 3º andar.",
    objetos: [
      Objeto(
        nome: "papel do guarda",
        descricao: "Anotação sua: 'Meu código do armário: onde eu trabalho, onde eu saio, onde eu guardo as ferramentas.'",
        interacao: pegando(
          "papel-guarda",
          Papel(
            "Meu código do armário: onde eu trabalho, onde eu saio, onde eu guardo as ferramentas.",
          ),
        ),
        estado: "na mesa",
      ),
      // Só funciona com a energia ligada (enigma 1) e o notebook ligado (enigma 2)
      Objeto(
        nome: "computador do colega",
        descricao: "O computador do seu colega liga e mostra duas anotações.",
        interacao: exigindo_flag(
          EnergiaLigada,
          exigindo_flag(
            NotebookLigado,
            em_sequencia([
              pegando(
                "papel-senha",
                Papel("Senha da porta da sala de placas: 2486."),
              ),
              pegando("papel-chaveiro", Papel("O chaveiro do guarda é de metal.")),
            ]),
          ),
        ),
        estado: "desligado",
      ),
    ],
    // 6 = escada, 5 = duto de ventilação (só desce)
    saidas: [Saida(6, sempre), Saida(5, sempre)],
    enigmas: [],
  )
}
