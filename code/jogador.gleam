//imports
import gleam/int
import gleam/list

// Item guarda o que o jogador carrega. Flag guarda o que o jogador 
// já fez ou mudou no mundo, como a alavanca puxada ou um enigma 
// resolvido. A separação existe porque “energia ligada” não é um 
// objeto no bolso.
pub type Item {
    //Tipos de itens do jogo. Contém: Chave, Botão de ativação, Papel, Pé de cabra e Cabo de energia.
    Chave
    BotaoAtivacao(cor: String)
    Papel(texto: String)
    PeDeCabra
    CaboEnergia
}

pub type Flag {
    //Tipos de flags do jogo. Contém: Energia ligada, notebook ligado, porta das placas aberta, esteira ligada, enigma resolvido e item coletado.
    //Basicamente estados que as coisas podem assumir.
    EnergiaLigada
    NotebookLigado
    PortaPlacasAberta
    EsteiraLigada
    EnigmaResolvido(Int)
    Coletado(String)
}

pub type Jogador {
    //Tipo jogador contendo nome, inventário, localização e flags.
    Jogador(
        nome: String,
        inventario: List(Item),
        localizacao: Int,
        flags: List(Flag),
    )
}

///ANÁLISE: Faça uma função que cria um novo jogador com um nome e um andar inicial, sem itens no inventário e sem flags ativadas.
/// TIPOS DE DADOS: A entrada é um *nome* representado pelo tipo primitivo *String* e um *andar* representado pelo tipo primitivo *Int*. A saída é um *jogador* representado pelo tipo *Jogador*.
/// ESPECIFICAÇÃO: Recebe um *nome* e um *andar* e cria um novo jogador com esses valores.
pub fn novo(nome: String, andar: Int) -> Jogador {
    Jogador(
        nome: nome,
        inventario: [],
        localizacao: andar,
        flags: [],
    )
}

pub type Saida { 
    //Tipo saída contendo destino e requisito. Contém: destino e requisito.
    Saida(destino: Int, requisito: fn(Jogador) -> Bool) 
}

///ANÁLISE: Faça uma função que recebe um jogador e um item e adiciona o item ao inventário do jogador.
/// TIPOS DE DADOS: A entrada é um *jogador* representado pelo tipo *Jogador* e um *item* representado pelo tipo *Item*. A saída é o jogador atualizado, representado pelo tipo *Jogador*.
/// ESPECIFICAÇÃO: Recebe um *jogador* e um *item* e adiciona o item ao inventário do jogador.
pub fn pegar(j: Jogador, item: Item) -> Jogador {
    Jogador(..j, inventario: [item, ..j.inventario])
}

/// ANÁLISE: Faça uma função que recebe um jogador e um item e verifica se o item está no inventário do jogador.
/// TIPOS DE DADOS: A entrada é um *jogador* representado pelo tipo *Jogador* e um *item* representado pelo tipo *Item*. A saída é um valor booleano.
/// ESPECIFICAÇÃO: Recebe um *jogador* e um *item* e verifica se o item está no inventário do jogador. Produz *True* se o item estiver no inventário e *False* caso contrário.
pub fn tem(j: Jogador, item: Item) -> Bool {
    contem(j.inventario, item)
}

/// ANÁLISE: Faça uma função que recebe uma lista de itens e um item e verifica se o item está na lista.
/// TIPOS DE DADOS: A entrada é uma *lista de itens* representada pelo tipo *List(Item)* e um *item* representado pelo tipo *Item*. A saída é um valor booleano.
/// ESPECIFICAÇÃO: Recebe uma *lista de itens* e um *item* e verifica se o item está na lista. Produz *True* se o item estiver na lista e *False* caso contrário.
fn contem(itens: List(Item), item: Item) -> Bool {
    case itens {
        [] -> False
        [primeiro, ..resto] -> primeiro == item || contem(resto, item)
    }
}

/// ANÁLISE: Faça uma função que recebe um jogador e um item e remove o item do inventário do jogador.
/// TIPOS DE DADOS: A entrada é um *jogador* representado pelo tipo *Jogador* e um *item* representado pelo tipo *Item*. A saída é o jogador atualizado, representado pelo tipo *Jogador*.
/// ESPECIFICAÇÃO: Recebe um *jogador* e um *item* e remove o item do inventário do jogador. Se o item não estiver no inventário, o jogador permanece inalterado.
pub fn consumir(j: Jogador, item: Item) -> Jogador {
    Jogador(..j, inventario: remover_um(j.inventario, item))
}

/// ANÁLISE: Faça uma função que recebe uma lista de itens e um item e remove a primeira ocorrência do item da lista.
/// TIPOS DE DADOS: A entrada é uma *lista de itens* representada pelo tipo *List(Item)* e um *item* representado pelo tipo *Item*. A saída é uma nova lista de itens, representada pelo tipo *List(Item)*, sem a primeira ocorrência do item.
/// ESPECIFICAÇÃO: Recebe uma *lista de itens* e um *item* e remove a primeira ocorrência do item da lista. Se o item não estiver na lista, a lista permanece inalterada.   
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

/// ANÁLISE: Faça uma função que recebe um jogador e uma flag e ativa a flag no jogador.
/// TIPOS DE DADOS: A entrada é um *jogador* representado pelo tipo *Jogador* e uma *flag* representada pelo tipo *Flag*. A saída é o jogador atualizado, representado pelo tipo *Jogador*.
/// ESPECIFICAÇÃO: Recebe um *jogador* e uma *flag* e ativa a flag no jogador. Se a flag já estiver ativa, o jogador permanece inalterado.
pub fn ativar(j: Jogador, flag: Flag) -> Jogador {
    case flag_ativa(j, flag) {
        True -> j
        False -> Jogador(..j, flags: [flag, ..j.flags])
    }
}

/// ANÁLISE: Faça uma função que recebe um jogador e uma flag e verifica se a flag está ativa no jogador.
/// TIPOS DE DADOS: A entrada é um *jogador* representado pelo tipo *Jogador* e uma *flag* representada pelo tipo *Flag*. A saída é um valor booleano.
/// ESPECIFICAÇÃO: Recebe um *jogador* e uma *flag* e verifica se a flag está ativa no jogador. Produz *True* se a flag estiver ativa e *False* caso contrário.
pub fn flag_ativa(j: Jogador, flag: Flag) -> Bool {
    list.contains(j.flags, flag) 
}

/// ANÁLISE: Faça uma função que recebe um jogador e um enigma e verifica se o jogador já resolveu o enigma.
/// TIPOS DE DADOS: A entrada é um *jogador* representado pelo tipo *Jogador* e um *enigma* representado pelo tipo primitivo *Int*.
/// A saída é um valor booleano.
/// ESPECIFICAÇÃO: Recebe um *jogador* e um *enigma* e verifica se o jogador já resolveu o enigma. Produz *True* se o jogador já tiver resolvido o enigma e *False* caso contrário.
pub fn resolvido(j: Jogador, enigma: Int) -> Bool {
    flag_ativa(j, EnigmaResolvido(enigma))
}

/// ANÁLISE: Faça uma função que recebe um jogador e um andar e move o jogador para o andar especificado.
/// TIPOS DE DADOS: A entrada é um *jogador* representado pelo tipo *Jogador* e um *andar* representado pelo tipo primitivo *Int*. A saída é o jogador atualizado, representado pelo tipo *Jogador*.
/// ESPECIFICAÇÃO: Recebe um *jogador* e um *andar* e move o jogador para o andar especificado. O jogador permanece inalterado se o andar não for válido.
pub fn mover(j: Jogador, andar: Int) -> Jogador {
    Jogador(..j, localizacao: andar)
}
