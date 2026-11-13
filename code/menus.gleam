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
pub fn novo() -> Jogo {
    Jogo(jogador: jogador.novo("Guarda", 7), andares: cenario.torre())
}

pub fn ambiente_atual(jogo: Jogo) -> Result(Ambiente, Nil) {
    ambiente.buscar(jogo.andares, jogo.jogador.localizacao)
}

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
pub fn venceu(jogo: Jogo) -> Bool {
    jogador.resolvido(jogo.jogador, 10)
}

// Funções auxiliares (texto e busca; nada aqui altera o jogo)

/// Texto de um item do inventário (pattern matching sobre Item).
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
fn descrever(j: Jogo) -> Nil {
  case ambiente_atual(j) {
    Ok(a) -> io.println(ambiente.explorar(a, j.jogador))
    Error(_) -> io.println("Você está perdido.")
  }
}

/// Procura um objeto pelo nome no andar atual.
fn achar_objeto(j: Jogo, nome: String) -> Result(Objeto, Nil) {
  case ambiente_atual(j) {
    Ok(a) -> list.find(a.objetos, fn(o) { o.nome == nome })
    Error(_) -> Error(Nil)
  }
}

/// Imprime um enigma: situação, descrição e pistas.
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