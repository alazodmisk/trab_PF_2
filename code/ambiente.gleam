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
    verifica_saida(ambiente.saidas, destino, j)
}

fn verifica_saida(saidas: List(Saida), destino: Int, j: Jogador) -> Bool {
    case saidas {
        [] -> False
        [Saida(destino_saida, requisito), ..resto] ->
            case destino_saida == destino && requisito(j) {
                True -> True
                False -> verifica_saida(resto, destino, j)
            }
    }
}

/// Texto da exploração (função pura; quem imprime é o menus.gleam).
pub fn explorar(ambiente: Ambiente, j: Jogador) -> String {
    let objetos = nomes_objetos(ambiente.objetos)
    let saidas = saidas_disponiveis(ambiente.saidas, j)

    string.join(
        [
            ambiente.nome <> ": " <> ambiente.descricao,
            "Objetos: " <> string.join(objetos, ", "),
            "Saídas: " <> string.join(saidas, ", "),
        ],
        "\n",
    )
}

fn nomes_objetos(objetos: List(Objeto)) -> List(String) {
    case objetos {
        [] -> []
        [primeiro, ..resto] ->
            [primeiro.nome, ..nomes_objetos(resto)]
    }
}

fn saidas_disponiveis(saidas: List(Saida), j: Jogador) -> List(String) {
    case saidas {
        [] -> []
        [Saida(destino, requisito), ..resto] ->
            case requisito(j) {
                True -> [
                    int.to_string(destino),
                    ..saidas_disponiveis(resto, j)
                ]
                False -> saidas_disponiveis(resto, j)
            }
    }
}