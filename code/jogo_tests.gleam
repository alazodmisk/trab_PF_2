import jogador.{
    Jogador, Chave, PeDeCabra, CaboEnergia, Papel, EnergiaLigada,
    NotebookLigado, EsteiraLigada, EnigmaResolvido,
}
import sgleam/check


/// Examples de jogador.gleam
pub fn novo_examples() {
    check.eq(jogador.novo("Joao", 1),Jogador("Joao", [], 1, []))
    check.eq(jogador.novo("Maria", 2),Jogador("Maria", [], 2, []))
}

pub fn pegar_examples() {
    let j = jogador.novo("Joao", 1)

    check.eq(jogador.pegar(j, Chave), Jogador("Joao", [Chave], 1, []))
    check.eq(jogador.pegar(jogador.pegar(j, Chave), PeDeCabra),Jogador("Joao", [PeDeCabra, Chave], 1, []))
    check.eq(jogador.pegar(j, Papel("Anotacao")),Jogador("Joao", [Papel("Anotacao")], 1, []))
}

pub fn tem_examples() {
    let j = jogador.pegar(jogador.pegar(jogador.novo("Joao", 1), Chave), PeDeCabra)

    check.eq(jogador.tem(j, Chave), True)
    check.eq(jogador.tem(j, PeDeCabra), True)
    check.eq(jogador.tem(j, CaboEnergia), False)
    check.eq(jogador.tem(jogador.novo("Maria", 2), Chave), False)
}

pub fn consumir_examples() {
    let j = jogador.pegar(jogador.pegar(jogador.novo("Joao", 1), Chave), PeDeCabra)

    check.eq(jogador.consumir(j, Chave),Jogador("Joao", [PeDeCabra], 1, []))
    check.eq(jogador.consumir(j, CaboEnergia),j)
    check.eq(jogador.consumir(jogador.pegar(j, Chave), Chave),j)
}

pub fn remover_um_examples() {
    check.eq(jogador.remover_um([], Chave), [])
    check.eq(jogador.remover_um([Chave], Chave), [])
    check.eq(jogador.remover_um([Chave, PeDeCabra], Chave), [PeDeCabra])
    check.eq(jogador.remover_um([PeDeCabra, Chave], Chave), [PeDeCabra])
    check.eq(jogador.remover_um([Chave, Chave, PeDeCabra], Chave),[Chave, PeDeCabra])
    check.eq(jogador.remover_um([PeDeCabra, CaboEnergia], Chave),[PeDeCabra, CaboEnergia])
}

pub fn ativar_examples() {
    let j = jogador.novo("Joao", 1)

    check.eq(jogador.ativar(j, EnergiaLigada),Jogador("Joao", [], 1, [EnergiaLigada]))
    check.eq(jogador.ativar(jogador.ativar(j, EnergiaLigada), EnergiaLigada),Jogador("Joao", [], 1, [EnergiaLigada]))
    check.eq(jogador.ativar(jogador.ativar(j, EnergiaLigada), NotebookLigado),Jogador("Joao", [], 1, [NotebookLigado, EnergiaLigada]))
}

pub fn flag_ativa_examples() {
    let j = jogador.ativar(jogador.ativar(jogador.novo("Joao", 1), EnergiaLigada), NotebookLigado)

    check.eq(jogador.flag_ativa(j, EnergiaLigada), True)
    check.eq(jogador.flag_ativa(j, NotebookLigado), True)
    check.eq(jogador.flag_ativa(j, EsteiraLigada), False)
    check.eq(jogador.flag_ativa(jogador.novo("Maria", 2), EnergiaLigada), False)
}

pub fn resolvido_examples() {
    let j = jogador.ativar(jogador.novo("Joao", 1), EnigmaResolvido(1))

    check.eq(jogador.resolvido(j, 1), True)
    check.eq(jogador.resolvido(j, 2), False)
    check.eq(jogador.resolvido(jogador.novo("Maria", 2), 1), False)
    check.eq(jogador.resolvido(jogador.ativar(j, EnigmaResolvido(2)), 2),True)
}

pub fn mover_examples() {
    let j = jogador.novo("Joao", 1)

    check.eq(jogador.mover(j, 2), Jogador("Joao", [], 2, []))
    check.eq(jogador.mover(j, 5), Jogador("Joao", [], 5, []))
    check.eq(jogador.mover(j, 1), j)
    check.eq(jogador.mover(jogador.pegar(j, Chave), 3),Jogador("Joao", [Chave], 3, []))
    check.eq(jogador.mover(jogador.ativar(j, EnergiaLigada), 4),Jogador("Joao", [], 4, [EnergiaLigada]))
}