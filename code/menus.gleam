import ambiente.{type Ambiente}
import cenario
import enigma.{type Enigma}
import gleam/int
import gleam/io
import gleam/list
import jogador.{
  type Item, type Jogador, BotaoAtivacao, CaboEnergia, Chave, Papel, PeDeCabra,
}
import objeto.{type Objeto}


/// =================================================
/// JOGO
/// =================================================


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
/// ANÁLISE: Faça uma função que cria um novo jogo com um jogador chamado "Guarda" no 7º andar e os andares do cenario.torre().
pub fn novo() -> Jogo {
    Jogo(jogador: jogador.novo("Guarda", 7), andares: cenario.torre())
}

/// ANÁLISE: Faça uma função que recebe um jogo e retorna o ambiente atual do jogador. A função deve buscar o ambiente correspondente ao andar do jogador na lista de andares do jogo. Se o ambiente for encontrado, retorna Ok(ambiente); caso contrário, retorna Error(Nil).
/// TIPOS DE DADOS: A entrada é um *jogo* representado pelo tipo *Jogo*. A saída é um resultado que pode ser Ok(ambiente) ou Error(Nil), representado pelo tipo *Result(Ambiente, Nil)*.
/// ESPECIFICAÇÃO: Recebe um *jogo* e retorna o ambiente atual do jogador. A função deve buscar o ambiente correspondente ao andar do jogador na lista de andares do jogo. Se o ambiente for encontrado, retorna Ok(ambiente); caso contrário, retorna Error(Nil).
pub fn ambiente_atual(jogo: Jogo) -> Result(Ambiente, Nil) {
    ambiente.buscar(jogo.andares, jogo.jogador.localizacao)
}

/// ANÁLISE: Faça uma função que recebe um jogo e um destino e verifica se o jogador pode ir para esse destino a partir do ambiente atual. A função deve retornar True se o jogador puder ir para o destino e False caso contrário.
/// TIPOS DE DADOS: A entrada é um *jogo* representado pelo tipo
/// Vai para outro andar, se a saída estiver aberta.
pub fn tentar_ir(jogo: Jogo, destino: Int) -> Jogo {
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
/// ANALÍSE: Faça uma função que recebe um jogo e o nome de um objeto. A função deve buscar o objeto correspondente ao nome na lista de objetos do ambiente atual do jogador. Se o objeto for encontrado, aplica a interação do objeto no jogador e retorna o novo estado do jogo; caso contrário, retorna o jogo intacto.
/// TIPOS DE DADOS: A entrada é um *jogo* representado pelo tipo *Jogo* e o *nome* do objeto representado pelo tipo primitivo *String*. A saída é o novo estado do jogo, representado pelo tipo *Jogo*.
/// ESPECIFICAÇÃO: Recebe um *jogo* e o *nome* do objeto. A função deve buscar o objeto correspondente ao nome na lista de objetos do ambiente atual do jogador. Se o objeto for encontrado, aplica a interação do objeto no jogador e retorna o novo estado do jogo; caso contrário, retorna o jogo intacto.
pub fn tentar_interagir(jogo: Jogo, nome: String) -> Jogo {
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
/// ANÁLISE: Faça uma função que recebe um jogo, o id de um enigma e uma resposta. A função deve buscar o enigma correspondente ao id na lista de enigmas do ambiente atual do jogador. Se o enigma for encontrado, aplica a função resolver_enigma do módulo enigma no jogador e retorna o novo estado do jogo; caso contrário, retorna o jogo intacto.
/// TIPOS DE DADOS: A entrada é um *jogo* representado pelo tipo *Jogo*, o *id* do enigma representado pelo tipo primitivo *Int* e a *resposta* representada pelo tipo primitivo *String*. A saída é o novo estado do jogo, representado pelo tipo *Jogo*.
/// ESPECIFICAÇÃO: Recebe um *jogo*, o *id* do enigma e uma *resposta*. A função deve buscar o enigma correspondente ao id na lista de enigmas do ambiente atual do jogador. Se o enigma for encontrado, aplica a função resolver_enigma do módulo enigma no jogador e retorna o novo estado do jogo; caso contrário, retorna o jogo intacto.
pub fn tentar_resolver(jogo: Jogo, id: Int, resposta: String) -> Jogo {
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

/// O jogador venceu quando o enigma 10 está resolvido.
/// ///ANÁLISE: Faça uma função que recebe um jogo e verifica se o jogador venceu. A função deve verificar se o enigma com id 10 está resolvido no jogador. Se estiver resolvido, retorna True; caso contrário, retorna False.
/// TIPOS DE DADOS: A entrada é um *jogo* representado pelo tipo *Jogo*. A saída é um valor booleano representado pelo tipo primitivo *Bool*.
/// ESPECIFICAÇÃO: Recebe um *jogo* e verifica se o jogador venceu. A função deve verificar se o enigma com id 10 está resolvido no jogador. Se estiver resolvido, retorna True; caso contrário, retorna False.
pub fn venceu(jogo: Jogo) -> Bool {
    jogador.resolvido(jogo.jogador, 10)
}

// Funções auxiliares (texto e busca; nada aqui altera o jogo)

/// Texto de um item do inventário (pattern matching sobre Item).
/// ANÁLISE: Faça uma função que recebe um item e retorna uma string representando o nome do item. A função deve usar pattern matching para identificar o tipo de item e retornar a string correspondente.
/// TIPOS DE DADOS: A entrada é um *item* representado pelo tipo *Item*. A saída é uma *string* representando o nome do item, de acordo com o tipo de item.
/// ESPECIFICAÇÃO: Recebe um *item* e retorna uma *string* representando o nome do item. 
fn item_texto(item: Item) -> String {
  case item {
    Chave -> "Chave da garagem"
    BotaoAtivacao(cor) -> "Botão de ativação " <> cor
    Papel(texto) -> "Papel: \"" <> texto <> "\""
    PeDeCabra -> "Pé de cabra"
    CaboEnergia -> "Cabo de energia"
  }
}

/// Imprime a descrição do andar atual (nome, objetos e saídas).
/// ANÁLISE: Faça uma função que recebe um jogo e imprime a descrição do ambiente atual do jogador, incluindo o nome do ambiente, os objetos presentes e as saídas disponíveis. A função deve buscar o ambiente atual do jogador e formatar a saída de forma legível.
/// TIPOS DE DADOS: A entrada é um *jogo* representado pelo tipo *Jogo*. A saída é do tipo *Nil*, pois a função apenas imprime informações na tela.
/// ESPECIFICAÇÃO: Recebe um *jogo* e imprime a descrição do ambiente atual do jogador, incluindo o nome do ambiente, os objetos presentes e as saídas disponíveis. 
fn descrever(j: Jogo) -> Nil {
  case ambiente_atual(j) {
    Ok(a) -> io.println(ambiente.explorar(a, j.jogador))
    Error(_) -> io.println("Você está perdido.")
  }
}

/// Procura um objeto pelo nome no andar atual.
/// ANALÍSE: Faça uma função que recebe um jogo e o nome de um objeto. A função deve buscar o objeto correspondente ao nome na lista de objetos do ambiente atual do jogador. Se o objeto for encontrado, retorna Ok(objeto); caso contrário, retorna Error(Nil).
/// TIPOS DE DADOS: A entrada é um *jogo* representado pelo tipo *Jogo* e o *nome* do objeto representado pelo tipo primitivo *String*.
/// A saída é um resultado que pode ser Ok(objeto) ou Error(Nil), representado pelo tipo *Result(Objeto, Nil)*.
/// ESPECIFICAÇÃO: Recebe um *jogo* e o *nome* do objeto. A função deve buscar o objeto correspondente ao nome na lista de objetos do ambiente atual do jogador. Se o objeto for encontrado, retorna Ok(objeto); caso contrário, retorna Error(Nil).
fn achar_objeto(j: Jogo, nome: String) -> Result(Objeto, Nil) {
  case ambiente_atual(j) {
    Ok(a) -> list.find(a.objetos, fn(o) { o.nome == nome })
    Error(_) -> Error(Nil)
  }
}

/// Imprime um enigma: situação, descrição e pistas.
/// ANÁLISE: Faça uma função que recebe um enigma e um jogo. A função deve verificar se o enigma foi resolvido pelo jogador no jogo. Se o enigma foi resolvido, imprime "resolvido"; caso contrário, imprime "em aberto". Em seguida, imprime a descrição do enigma e todas as suas pistas. 
/// TIPOS DE DADOS: A entrada é um *enigma* representado pelo tipo *Enigma* e um *jogo* representado pelo tipo *Jogo*. A saída é do tipo *Nil*, pois a função apenas imprime informações na tela. 
/// ESPECIFICAÇÃO: Recebe um *enigma* e um *jogo*. A função deve verificar se o enigma foi resolvido pelo jogador no jogo. 
fn mostrar_enigma(e: Enigma, j: Jogo) -> Nil {
  let situacao = case jogador.resolvido(j.jogador, e.id) {
    True -> "resolvido"
    False -> "em aberto"
  }
  io.println(
    "Enigma " <> int.to_string(e.id) <> " (" <> situacao <> "): " <> e.descricao,
  )
  list.each(e.pistas, fn(pista) { io.println("  Pista: " <> pista) })
}

/// Imprime a mensagem final se o jogador venceu.
/// ANÁLISE: Faça uma função que recebe um jogo e verifica se o jogador venceu. A função deve verificar se o enigma com id 10 está resolvido no jogador. Se estiver resolvido, imprime a mensagem de vitória; caso contrário, não faz nada.
/// TIPOS DE DADOS: A entrada é um *jogo* representado pelo tipo *Jogo*. A saída é do tipo *Nil*, pois a função apenas imprime informações na tela.
/// ESPECIFICAÇÃO: Recebe um *jogo* e verifica se o jogador venceu. A função deve verificar se o enigma com id 10 está resolvido no jogador. Se estiver resolvido, imprime a mensagem de vitória; caso contrário, não faz nada.
fn checar_vitoria(j: Jogo) -> Nil {
  case venceu(j) {
    True ->
      io.println(
        "O portão se abre. O guarda escapa da Torre do Lixo Eletrônico. FIM!",
      )
    False -> Nil
  }
}

/// =================================================
/// MENU
/// =================================================

/// Mostra os comandos disponíveis.
pub fn display_main_menu() {
  io.println("--- MENU PRINCIPAL ---")
  io.println("m1(j): Explorar ambiente")
  io.println("m2(j): Consultar inventário")
  io.println("m3(j): Examinar enigmas")
  io.println("ir(j, andar): Ir para outro andar")
  io.println("interagir(j, \"objeto\"): Interagir com um objeto")
  io.println("resolver(j, id, \"resposta\"): Resolver um enigma")
  io.println("exit(): Encerrar simulação")
  io.println("\n")
}

/// Começa uma partida: conta a história e devolve o estado inicial.
pub fn main() -> Jogo {
  io.println("TORRE DO LIXO ELETRÔNICO")
  io.println(
    "Você é um guarda de segurança e dormiu durante o trabalho. Ao acordar, a torre de descarte está fechada e você não encontra as suas chaves. Encontre-as e saia pelo portão da garagem.",
  )
  display_main_menu()
  let j = novo()
  descrever(j)
  io.println("\n")
  j
}

/// m1: explora o ambiente atual.
pub fn m1(j: Jogo) -> Jogo {
  descrever(j)
  io.println("\n")
  j
}

/// m2: mostra o inventário (os itens mais antigos primeiro).
pub fn m2(j: Jogo) -> Jogo {
  case j.jogador.inventario {
    [] -> io.println("Seu inventário está vazio.")
    itens -> {
      io.println("--- INVENTÁRIO ---")
      list.each(list.reverse(itens), fn(item) {
        io.println("- " <> item_texto(item))
      })
    }
  }
  io.println("\n")
  j
}

/// m3: examina os enigmas do andar atual.
pub fn m3(j: Jogo) -> Jogo {
  case ambiente_atual(j) {
    Error(_) -> io.println("Você está perdido.")
    Ok(a) ->
      case a.enigmas {
        [] -> io.println("Não há enigmas para resolver neste andar.")
        enigmas -> list.each(enigmas, fn(e) { mostrar_enigma(e, j) })
      }
  }
  io.println("\n")
  j
}

/// Encerra a simulação.
pub fn exit() {
  io.println("Simulação encerrada.")
}

// ---------------------------------------------------------------------------
// Atalhos de ação: chamam a lógica pura (tentar_*) e contam o resultado
// ---------------------------------------------------------------------------

/// Vai para outro andar, se a saída estiver aberta.
pub fn ir(j: Jogo, andar: Int) -> Jogo {
  let proximo = tentar_ir(j, andar)
  case proximo.jogador.localizacao == j.jogador.localizacao {
    True ->
      io.println(
        "Você não consegue ir para o " <> int.to_string(andar) <> "º andar daqui.",
      )
    False -> {
      io.println("Você foi para o " <> int.to_string(andar) <> "º andar.")
      descrever(proximo)
    }
  }
  io.println("\n")
  proximo
}

/// Interage com um objeto do andar atual.
pub fn interagir(j: Jogo, nome: String) -> Jogo {
  case achar_objeto(j, nome) {
    Error(_) -> {
      io.println("Não há \"" <> nome <> "\" por aqui.")
      j
    }
    Ok(obj) -> {
      let proximo = tentar_interagir(j, nome)
      // Se o jogador não mudou, a interação não teve efeito
      case proximo.jogador == j.jogador {
        True -> io.println("Nada acontece.")
        False -> io.println(obj.descricao)
      }
      io.println("\n")
      proximo
    }
  }
}

/// Tenta resolver um enigma do andar atual.
pub fn resolver(j: Jogo, id: Int, resposta: String) -> Jogo {
  let proximo = tentar_resolver(j, id, resposta)
  case proximo.jogador == j.jogador {
    True ->
      io.println(
        "Não funcionou. Confira a resposta, o seu inventário e se você está no andar certo.",
      )
    False -> io.println("Enigma " <> int.to_string(id) <> " resolvido!")
  }
  checar_vitoria(proximo)
  io.println("\n")
  proximo
}


// Demonstração: Rode a seguinte função para ver o jogo rodar sozinho
/// Demonstração: joga o caminho principal inteiro, imprimindo cada passo.
pub fn demonstracao() -> Nil {
  let _fim =
    main()
    |> interagir("papel do guarda")
    |> ir(6)
    |> ir(5)
    |> ir(4)
    |> ir(3)
    |> interagir("alavanca")
    |> interagir("cabo de energia")
    |> resolver(7, "713")
    |> ir(4)
    |> ir(5)
    |> ir(6)
    |> interagir("notebook")
    |> ir(7)
    |> interagir("computador do colega")
    |> ir(5)
    |> resolver(3, "2486")
    |> interagir("caixa de placas")
    |> ir(4)
    |> interagir("grade do duto")
    |> resolver(6, "20 55 90")
    |> interagir("cabo de energia")
    |> ir(2)
    |> interagir("painel da esteira")
    |> resolver(9, "metal")
    |> ir(1)
    |> resolver(10, "vermelho azul")
  Nil
}