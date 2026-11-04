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