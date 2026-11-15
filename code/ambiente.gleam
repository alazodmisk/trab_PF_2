import enigma.{type Enigma}
import gleam/int
import gleam/list
import gleam/string
import jogador.{type Jogador, type Saida}
import objeto.{type Objeto}

/// Uma saída para outro andar; só está aberta se o requisito for cumprido.
pub type Ambiente {
    /// Tipo ambiente contendo andar, nome, descrição, uma lista de objetos, uma lista de saídas e uma lista de enigmas.
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
/// ANÁLISE: Faça uma função que recebe uma lista de andares e um número de andar e busca recursivamente o ambiente correspondente ao número de andar na lista. Se o ambiente for encontrado, retorna Ok(ambiente); caso contrário, retorna Error(Nil).
/// TIPOS DE DADOS: A entrada é uma *lista de andares* representada pelo tipo *List(Ambiente)* e um *número de andar* representado pelo tipo primitivo *Int*. A saída é um resultado que pode ser Ok(ambiente) ou Error(Nil), representado pelo tipo *Result(Ambiente, Nil)*.
/// ESPECIFICAÇÃO: Recebe uma *lista de andares* e um *número de andar* e busca recursivamente o ambiente correspondente ao número de andar na lista. Se o ambiente for encontrado, retorna Ok(ambiente); caso contrário, retorna Error(Nil).
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

/// ANALÍSE: Faça uma função que recebe um ambiente, um destino e um jogador e verifica se o jogador pode ir para esse destino a partir do ambiente. A função deve retornar True se o jogador puder ir para o destino e False caso contrário.
/// TIPOS DE DADOS: A entrada é um *ambiente* representado pelo tipo *Ambiente*, um *destino* representado pelo tipo primitivo *Int* e um *jogador* representado pelo tipo *Jogador*. A saída é um valor booleano representado pelo tipo primitivo *Bool*.
/// ESPECIFICAÇÃO: Recebe um *ambiente*, um *destino* e um *jogador* e verifica se o jogador pode ir para esse destino a partir do ambiente. A função deve retornar True se o jogador puder ir para o destino e False caso contrário.
/// O jogador pode ir para esse destino a partir deste ambiente?
pub fn saida_aberta(ambiente: Ambiente, destino: Int, j: Jogador) -> Bool {
    list.any(ambiente.saidas, fn(s) { s.destino == destino && s.requisito(j) })
}


/// ANALISE: Faça uma função que recebe um ambiente e um jogador e retorna uma string representando o texto da exploração do ambiente, incluindo o nome, a descrição, os objetos presentes e as saídas disponíveis. A função deve filtrar as saídas disponíveis com base nos requisitos do jogador e formatar a saída de forma legível.
/// TIPOS DE DADOS: A entrada é um *ambiente* representado pelo tipo *Ambiente* e um *jogador* representado pelo tipo *Jogador*. A saída é uma *string* representando o texto da exploração do ambiente, incluindo o nome, a descrição, os objetos presentes e as saídas disponíveis.
/// ESPECIFICAÇÃO: Recebe um *ambiente* e um *jogador* e retorna uma *string* representando o texto da exploração do ambiente, incluindo o nome, a descrição, os objetos presentes e as saídas disponíveis. A função deve filtrar as saídas disponíveis com base nos requisitos do jogador e formatar a saída de forma legível. 
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