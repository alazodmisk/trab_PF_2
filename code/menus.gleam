import ambiente
import enigma.{type Enigma}
import gleam/int
import gleam/io
import gleam/list
import jogador.{type Item, BotaoAtivacao, CaboEnergia, Chave, Papel, PeDeCabra}
import jogo.{type Jogo}
import objeto.{type Objeto}

// ---------------------------------------------------------------------------
// Funções auxiliares (texto e busca; nada aqui altera o jogo)
// ---------------------------------------------------------------------------

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
  case jogo.ambiente_atual(j) {
    Ok(a) -> io.println(ambiente.explorar(a, j.jogador))
    Error(_) -> io.println("Você está perdido.")
  }
}

/// Procura um objeto pelo nome no andar atual.
fn achar_objeto(j: Jogo, nome: String) -> Result(Objeto, Nil) {
  case jogo.ambiente_atual(j) {
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
  case jogo.venceu(j) {
    True ->
      io.println(
        "O portão se abre. O guarda escapa da Torre do Lixo Eletrônico. FIM!",
      )
    False -> Nil
  }
}

// ---------------------------------------------------------------------------
// Menu principal
// ---------------------------------------------------------------------------

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
}

/// Começa uma partida: conta a história e devolve o estado inicial.
pub fn iniciar() -> Jogo {
  io.println("TORRE DO LIXO ELETRÔNICO")
  io.println(
    "Você é um guarda de segurança e dormiu durante o trabalho. Ao acordar, a torre de descarte está fechada e você não encontra as suas chaves. Encontre-as e saia pelo portão da garagem.",
  )
  display_main_menu()
  let j = jogo.novo()
  descrever(j)
  j
}

/// m1: explora o ambiente atual.
pub fn m1(j: Jogo) -> Jogo {
  descrever(j)
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
  j
}

/// m3: examina os enigmas do andar atual.
pub fn m3(j: Jogo) -> Jogo {
  case jogo.ambiente_atual(j) {
    Error(_) -> io.println("Você está perdido.")
    Ok(a) ->
      case a.enigmas {
        [] -> io.println("Não há enigmas para resolver neste andar.")
        enigmas -> list.each(enigmas, fn(e) { mostrar_enigma(e, j) })
      }
  }
  j
}

/// Encerra a simulação.
pub fn exit() {
  io.println("Simulação encerrada.")
}

// ---------------------------------------------------------------------------
// Atalhos de ação: chamam a lógica pura de jogo.gleam e contam o resultado
// ---------------------------------------------------------------------------

/// Vai para outro andar, se a saída estiver aberta.
pub fn ir(j: Jogo, andar: Int) -> Jogo {
  let novo = jogo.ir(j, andar)
  case novo.jogador.localizacao == j.jogador.localizacao {
    True ->
      io.println(
        "Você não consegue ir para o " <> int.to_string(andar) <> "º andar daqui.",
      )
    False -> {
      io.println("Você foi para o " <> int.to_string(andar) <> "º andar.")
      descrever(novo)
    }
  }
  novo
}

/// Interage com um objeto do andar atual.
pub fn interagir(j: Jogo, nome: String) -> Jogo {
  case achar_objeto(j, nome) {
    Error(_) -> {
      io.println("Não há \"" <> nome <> "\" por aqui.")
      j
    }
    Ok(obj) -> {
      let novo = jogo.interagir(j, nome)
      // Se o jogador não mudou, a interação não teve efeito
      case novo.jogador == j.jogador {
        True -> io.println("Nada acontece.")
        False -> io.println(obj.descricao)
      }
      novo
    }
  }
}

/// Tenta resolver um enigma do andar atual.
pub fn resolver(j: Jogo, id: Int, resposta: String) -> Jogo {
  let novo = jogo.resolver(j, id, resposta)
  case novo.jogador == j.jogador {
    True ->
      io.println(
        "Não funcionou. Confira a resposta, o seu inventário e se você está no andar certo.",
      )
    False -> io.println("Enigma " <> int.to_string(id) <> " resolvido!")
  }
  checar_vitoria(novo)
  novo
}
