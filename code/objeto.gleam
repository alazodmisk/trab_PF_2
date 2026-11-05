import jogador.{type Flag, type Item, type Jogador}

pub type Objeto {
    Objeto(
        nome: String,
        descricao: String,
        interacao: fn(Jogador) -> Jogador,
        estado: String,
    )
}

/// Aplica o efeito só se a condição for verdadeira; senão devolve o jogador intacto.
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

/// Efeito: coloca o item no inventário, uma única vez (usa a flag Coletado).
pub fn pegando(id: String, item: Item) -> fn(Jogador) -> Jogador {
    quando(
        fn(j) { !jogador.flag_ativa(j, jogador.Coletado(id)) },
        fn(j) { j |> jogador.pegar(item) |> jogador.ativar(jogador.Coletado(id)) },
    )
}

/// Efeito: liga uma flag.
pub fn ativando(flag: Flag) -> fn(Jogador) -> Jogador {
    fn(j) { jogador.ativar(j, flag) }
}

/// Efeito: remove um item do inventário.
pub fn consumindo(item: Item) -> fn(Jogador) -> Jogador {
    fn(j) { jogador.consumir(j, item) }
}

/// Só aplica o efeito se o jogador tiver o item.
pub fn exigindo(item: Item, efeito: fn(Jogador) -> Jogador) -> fn(Jogador) -> Jogador {
    quando(fn(j) { jogador.tem(j, item) }, efeito)
}

/// Só aplica o efeito se a flag estiver ativa.
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

