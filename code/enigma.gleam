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