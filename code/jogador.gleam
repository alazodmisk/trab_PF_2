import gleam/int
import gleam/list
import gleam/string

// Item guarda o que o jogador carrega. Flag guarda o que o jogador 
// já fez ou mudou no mundo, como a alavanca puxada ou um enigma 
// resolvido. A separação existe porque “energia ligada” não é um 
// objeto no bolso.
pub type Item {
    Chave
    BotaoAtivacao(cor: String)
    Papel(texto: String)
    PeDeCabra
    CaboEnergia
}

pub type Flag {
    EnergiaLigada
    NotebookLigado
    PortaPlacasAberta
    EsteiraLigada
    EnigmaResolvido(Int)
}

pub type Jogador {
    Jogador(
        nome: String,
        inventario: List(Item),
        pontos_de_vida: Int,
        localizacao: Int,
        flags: List(Flag),
    )
}

pub fn novo(nome: String, andar: Int) -> Jogador {
    Jogador(
        nome: nome,
        inventario: [],
        pontos_de_vida: 3,
        localizacao: andar,
        flags: [],
    )
}

pub fn pegar(j: Jogador, item: Item) -> Jogador {
    Jogador(..j, inventario: [item, ..j.inventario])
}

pub fn tem(j: Jogador, item: Item) -> Bool {
    list.contains(j.inventario, item) //Provavelmente não pode usar esse tipo de função
}

pub fn consumir(j: Jogador, item: Item) -> Jogador {
    Jogador(..j, inventario: remover_um(j.inventario, item))
}

pub fn remover_um(itens: List(Item), item: Item) -> List(Item) {
    case itens {
        [] -> []
        [primeiro, ..resto] ->
        case primeiro == item {
            True -> resto
            False -> [primeiro, ..remover_um(resto, item)]
        }
    }
}

pub fn ativar(j: Jogador, flag: Flag) -> Jogador {
    case flag_ativa(j, flag) {
        True -> j
        False -> Jogador(..j, flags: [flag, ..j.flags])
    }
}

pub fn flag_ativa(j: Jogador, flag: Flag) -> Bool {
    list.contains(j.flags, flag) //Provavelmente não pode usar esse tipo de função
}

pub fn resolvido(j: Jogador, enigma: Int) -> Bool {
    flag_ativa(j, EnigmaResolvido(enigma))
}

pub fn mover(j: Jogador, andar: Int) -> Jogador {
    Jogador(..j, localizacao: andar)
}
