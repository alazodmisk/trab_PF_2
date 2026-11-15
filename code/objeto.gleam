import jogador.{type Flag, type Item, type Jogador}

pub type Objeto {
    //Tipo objeto contendo nome, descrição, interação e estado. Contém: nome, descrição, interação e estado.
    Objeto(
        nome: String,
        descricao: String,
        interacao: fn(Jogador) -> Jogador,
        estado: String,
    )
}

///// Aplica o efeito só se a condição for verdadeira; senão devolve o jogador intacto.
//// ANÁLISE: Faça uma função que recebe uma condição e um efeito, ambos representados por funções que recebem um jogador e retornam um jogador. A função deve aplicar o efeito ao jogador apenas se a condição for verdadeira; caso contrário, deve devolver o jogador intacto.
//// TIPOS DE DADOS: A entrada é uma *condição* representada por uma função que recebe um *jogador* e retorna um valor booleano, e um *efeito* representado por uma função que recebe um *jogador* e retorna um *jogador*. A saída é o jogador atualizado, representado pelo tipo *Jogador*.
//// ESPECIFICAÇÃO: Recebe uma *condição* e um *efeito, ambos representados por funções que recebem um *jogador* e retornam um *jogador. A função deve aplicar o efeito ao jogador apenas se a condição for verdadeira; caso contrário, deve devolver o jogador intacto.
pub fn quando(
    condicao: fn(Jogador) -> Bool,
    efeito: fn(Jogador) -> Jogador,
) -> fn(Jogador) -> Jogador {
    fn(j) {
        case condicao(j) {
            True -> efeito(j)
            False -> j
        }
    }
}

/// 
/// Efeito: coloca o item no inventário, uma única vez (usa a flag Coletado).
/// //// ANÁLISE: Faça uma função que recebe um identificador e um item, e retorna uma função que recebe um jogador. A função resultante deve verificar se o jogador já coletou o item com base na flag Coletado. Se o jogador ainda não tiver coletado o item, adiciona o item ao inventário do jogador e ativa a flag Coletado; caso contrário, devolve o jogador intacto.
/// //// TIPOS DE DADOS: A entrada é um *identificador* representado pelo tipo primitivo *String* e um *item* representado pelo tipo *Item*. A saída é uma função que recebe um *jogador* e retorna um *jogador* atualizado.
/// //// ESPECIFICAÇÃO: Recebe um *identificador* e um *item*, e retorna uma função que recebe um *jogador*. A função resultante deve verificar se o jogador já coletou o item com base na flag Coletado. 
pub fn pegando(id: String, item: Item) -> fn(Jogador) -> Jogador {
    quando(
        fn(j) { !jogador.flag_ativa(j, jogador.Coletado(id)) },
        fn(j) { j |> jogador.pegar(item) |> jogador.ativar(jogador.Coletado(id)) },
    )
}

/// Efeito: liga uma flag.
/// /// ANÁLISE: Faça uma função que recebe uma flag e retorna uma função que recebe um jogador. A função resultante deve ativar a flag no jogador.
/// /// TIPOS DE DADOS: A entrada é uma *flag* representada pelo tipo *Flag*. A saída é uma função que recebe um *jogador* e retorna um *jogador* atualizado.
/// /// ESPECIFICAÇÃO: Recebe uma *flag* e retorna uma função que recebe um *jogador*.
pub fn ativando(flag: Flag) -> fn(Jogador) -> Jogador {
    fn(j) { jogador.ativar(j, flag) }
}

/// Efeito: remove um item do inventário.
/// /// ANÁLISE: Faça uma função que recebe um item e retorna uma função que recebe um jogador. A função resultante deve remover o item do inventário do jogador.
/// /// TIPOS DE DADOS: A entrada é um *item* representado pelo tipo *Item*. A saída é uma função que recebe um *jogador* e retorna um *jogador* atualizado.
/// /// ESPECIFICAÇÃO: Recebe um *item* e retorna uma função que recebe um *jogador*. 
pub fn removendo(item: Item) -> fn(Jogador) ->
pub fn consumindo(item: Item) -> fn(Jogador) -> Jogador {
    fn(j) { jogador.consumir(j, item) }
}

/// Só aplica o efeito se o jogador tiver o item.
/// /// ANÁLISE: Faça uma função que recebe um item e um efeito, ambos representados por funções que recebem um jogador e retornam um jogador. A função deve aplicar o efeito ao jogador apenas se o jogador tiver o item; caso contrário, deve devolver o jogador intacto.
/// /// TIPOS DE DADOS: A entrada é um *item* representado pelo tipo *Item* e um *efeito* representado por uma função que recebe um *jogador* e retorna um *jogador*. A saída é uma função que recebe um *jogador* e retorna um *jogador* atualizado.
/// /// ESPECIFICAÇÃO: Recebe um *item* e um *efeito, ambos representados por funções que recebem um *jogador* e retornam um *jogador. 
pub fn exigindo(item: Item, efeito: fn(Jogador) -> Jogador) -> fn(Jogador) -> Jogador {
    quando(fn(j) { jogador.tem(j, item) }, efeito)
}

/// Só aplica o efeito se a flag estiver ativa.
/// /// ANÁLISE: Faça uma função que recebe uma flag e um efeito, ambos representados por funções que recebem um jogador e retornam um jogador. A função deve aplicar o efeito ao jogador apenas se a flag estiver ativa; caso contrário, deve devolver o jogador intacto.
/// /// TIPOS DE DADOS: A entrada é uma *flag* representada pelo tipo *Flag* e um *efeito* representado por uma função que recebe um *jogador* e retorna um *jogador*. A saída é uma função que recebe um *jogador* e retorna um *jogador* atualizado.
/// /// ESPECIFICAÇÃO: Recebe uma *flag* e um *efeito, ambos representados por funções que recebem um *jogador* e retornam um *jogador.
pub fn exigindo_flag(flag: Flag, efeito: fn(Jogador) -> Jogador) -> fn(Jogador) -> Jogador {
    quando(fn(j) { jogador.flag_ativa(j, flag) }, efeito)
}

/// Composição: aplica f e depois g.
pub fn depois(
    f: fn(Jogador) -> Jogador,
    g: fn(Jogador) -> Jogador,
) -> fn(Jogador) -> Jogador {
    fn(j) { g(f(j)) }
}

