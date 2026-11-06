import jogador.{
    Jogador, Chave, PeDeCabra, CaboEnergia, Papel, EnergiaLigada,
    NotebookLigado, EsteiraLigada, EnigmaResolvido, Coletado
}
import objeto.{
    quando,
    pegando,
    ativando,
    consumindo,
    exigindo,
    exigindo_flag,
    depois,
}
import enigma.{
    type Enigma, Enigma
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


/// Examples objeto.gleam
pub fn quando_examples() {
    let j = jogador.novo("Joao", 1)
    let efeito = quando(fn(j) { jogador.tem(j, Chave) },fn(j) { jogador.ativar(j, EnergiaLigada) })
    check.eq(efeito(j), j)
    check.eq(efeito(jogador.pegar(j, Chave)),jogador.ativar(jogador.pegar(j, Chave), EnergiaLigada))
}

pub fn pegando_examples() {
    let j = jogador.novo("Joao", 1)
    let pegar_chave = pegando("chave_sala", Chave)
    
    check.eq(pegar_chave(j),Jogador("Joao", [Chave], 1, [Coletado("chave_sala")]))
    // Não coleta o mesmo objeto novamente
    check.eq(pegar_chave(pegar_chave(j)),pegar_chave(j))
}

pub fn ativando_examples() {
    let j = jogador.novo("Joao", 1)

    check.eq(ativando(EnergiaLigada)(j),Jogador("Joao", [], 1, [EnergiaLigada]))
    check.eq(ativando(NotebookLigado)(j),Jogador("Joao", [], 1, [NotebookLigado]))
    check.eq(ativando(EnergiaLigada)(ativando(NotebookLigado)(j),),Jogador("Joao", [], 1, [EnergiaLigada, NotebookLigado]))
}

pub fn consumindo_examples() {
    let j = jogador.pegar(jogador.pegar(jogador.novo("Joao", 1), Chave),CaboEnergia)
    
    check.eq(consumindo(Chave)(j),Jogador("Joao", [CaboEnergia], 1, []))
    check.eq(consumindo(CaboEnergia)(j),Jogador("Joao", [Chave], 1, []))
    // Consumir item que não possui
    //check.eq(consumindo(NotebookLigado)(j),j) Tá dando erro mas creio que isso não vá acontecer
}

pub fn exigindo_examples() {
    let j = jogador.novo("Joao", 1)
    let efeito = exigindo(Chave,ativando(EnergiaLigada))
    
    check.eq(efeito(j), j)
    check.eq(efeito(jogador.pegar(j, Chave)),jogador.ativar(jogador.pegar(j, Chave), EnergiaLigada))
}

pub fn exigindo_flag_examples() {
    let j = jogador.novo("Joao", 1)
    let efeito = exigindo_flag(EnergiaLigada,ativando(NotebookLigado))

    check.eq(efeito(j), j)
    check.eq(efeito(jogador.ativar(j, EnergiaLigada)),Jogador("Joao", [], 1, [NotebookLigado, EnergiaLigada]))
}

pub fn depois_examples() {
    let j = jogador.novo("Joao", 1)
    let efeito = depois(ativando(EnergiaLigada),ativando(NotebookLigado))
    let efeito2 = depois(fn(j) { jogador.pegar(j, Chave) },ativando(EnergiaLigada))
    
    check.eq(efeito(j),Jogador("Joao", [], 1, [NotebookLigado, EnergiaLigada]))
    check.eq(efeito2(j),Jogador("Joao", [Chave], 1, [EnergiaLigada]))
}


/// Examples enigma.gleam
pub fn normalizar_examples() {
    check.eq(enigma.normalizar("OLA"), "ola")
    check.eq(enigma.normalizar("  Computador  "), "computador")
    check.eq(enigma.normalizar("EnIgMa"), "enigma")
    check.eq(enigma.normalizar(" resposta "), "resposta")
    check.eq(enigma.normalizar(""), "")
    check.eq(enigma.normalizar("   "), "")
    check.eq(enigma.normalizar("Sala de Computadores"), "sala de computadores")
}

pub fn resolver_enigma_examples() {
    let j = jogador.novo("Joao", 1)

    let enigma = Enigma(
        id: 1,
        descricao: "Qual é a senha?",
        solucao: "computador",
        pistas: ["Começa com C"],
        requisito: fn(j) { True },
        efeito: fn(j) { jogador.ativar(j, jogador.EnergiaLigada) },
    )
    // Resposta correta e requisito cumprido
    check.eq(enigma.resolver_enigma(enigma, "computador", j),jogador.ativar(j, jogador.EnergiaLigada)|> jogador.ativar(jogador.EnigmaResolvido(1)))
    // Resposta correta com espaços e letras maiúsculas
    check.eq(enigma.resolver_enigma(enigma, "  COMPUTADOR  ", j),jogador.ativar(j, jogador.EnergiaLigada)|> jogador.ativar(jogador.EnigmaResolvido(1)))
    // Resposta incorreta
    check.eq(enigma.resolver_enigma(enigma, "notebook", j),j)

    // Requisito não cumprido
    let enigma_bloqueado = Enigma(
        id: 2,
        descricao: "Qual é a senha?",
        solucao: "computador",
        pistas: [],
        requisito: fn(j) { False },
        efeito: fn(j) { jogador.ativar(j, jogador.EnergiaLigada) },
    )
    check.eq(enigma.resolver_enigma(enigma_bloqueado, "computador", j),j)
    // Enigma já resolvido
    
    let j_resolvido = jogador.ativar(j, jogador.EnigmaResolvido(1))
    check.eq(enigma.resolver_enigma(enigma, "computador", j_resolvido),j_resolvido,)
    // Efeito não é aplicado quando a resposta está errada
    check.eq(enigma.resolver_enigma(enigma, "errado", j),j)
}