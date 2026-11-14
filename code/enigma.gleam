//imports
import gleam/string
import jogador.{type Jogador}

pub type Enigma {
    //Tipo enigma contendo identificador, descrição, solução, uma lista de pistas, um requisito
    //e um efeito.
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
/// ANÁLISE: Faça uma função que recebe um texto e o deixa na forma normalizada, isto é, sem espaços e tudo minúsculo,
/// TIPOS DE DADOS: A entrada é um texto representado pelo tipo primitivo *String*. A saída é o texto normalizado, representado
/// também pelo tipo primitivo *String*.
/// ESPECIFICAÇÃO: Recebe um *texto* e normaliza ele.
pub fn normalizar(texto: String) -> String {
    texto |> string.trim |> string.lowercase
}

/// Resposta certa + requisito cumprido + ainda não resolvido: aplica o efeito
/// e registra EnigmaResolvido(id). Caso contrário, devolve o jogador intacto.
/// ANÁLISE: Faça uma função que recebe um enigma, uma resposta e um jogador. Se a resposta estiver correta, o requisito do enigma for cumprido e o jogador ainda não tiver resolvido o enigma, aplica o efeito do enigma no jogador e registra que ele resolveu o enigma. Caso contrário, devolve o jogador intacto.
/// TIPOS DE DADOS: A entrada é um *enigma* representado pelo tipo *Enigma*, uma *resposta* representada pelo tipo primitivo *String* e um *jogador* representado pelo tipo *Jogador*. 
/// A saída é o jogador atualizado, representado pelo tipo *Jogador*.
/// ESPECIFICAÇÃO: Recebe um *enigma*, uma *resposta* e um *jogador*. Se a resposta estiver correta, o requisito do enigma for cumprido e o jogador ainda não tiver resolvido o enigma, aplica o efeito do enigma no jogador e registra que ele resolveu o enigma. Caso contrário, devolve o jogador intacto.
pub fn resolver_enigma(enigma: Enigma, resposta: String, j: Jogador) -> Jogador {
    let acertou = normalizar(resposta) == normalizar(enigma.solucao)
    case acertou && enigma.requisito(j) && !jogador.resolvido(j, enigma.id) {
        True -> j |> enigma.efeito |> jogador.ativar(jogador.EnigmaResolvido(enigma.id))
        False -> j
    }
}
