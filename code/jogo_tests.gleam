//// Testes (examples) do jogo Torre do Lixo Eletrônico.
////
//// Seções: jogador, objeto, enigma, ambiente, jogo (mundo mínimo de teste)
//// e cenário real (cada enigma e o caminho principal até a vitória).
////
//// Regra para não quebrar: nunca dê a uma variável o mesmo nome de um módulo
//// (jogador, objeto, enigma, ambiente, jogo), senão `ambiente.explorar(...)`
//// vira acesso a campo da variável e não compila.

import ambiente.{type Ambiente, Ambiente, sempre}
import enigma.{Enigma}
import gleam/list
import jogador.{
    type Flag, type Item, BotaoAtivacao, CaboEnergia, Chave, Coletado, EnergiaLigada,
    EnigmaResolvido, EsteiraLigada, Jogador, NotebookLigado, Papel, PeDeCabra,
    PortaPlacasAberta, Saida,
}
import objeto.{
    Objeto, ativando, consumindo, depois, exigindo, exigindo_flag, pegando, quando,
}
import sgleam/check


// Examples de jogador.gleam
pub fn novo_examples() {
    check.eq(jogador.novo("Joao", 1), Jogador("Joao", [], 1, []))
    check.eq(jogador.novo("Maria", 2), Jogador("Maria", [], 2, []))
}

pub fn pegar_examples() {
    let j = jogador.novo("Joao", 1)

    check.eq(jogador.pegar(j, Chave), Jogador("Joao", [Chave], 1, []))
    check.eq(jogador.pegar(jogador.pegar(j, Chave), PeDeCabra), Jogador("Joao", [PeDeCabra, Chave], 1, []))
    check.eq(jogador.pegar(j, Papel("Anotacao")), Jogador("Joao", [Papel("Anotacao")], 1, []))
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

    check.eq(jogador.consumir(j, Chave), Jogador("Joao", [PeDeCabra], 1, []))
    check.eq(jogador.consumir(j, CaboEnergia), j)
    check.eq(jogador.consumir(jogador.pegar(j, Chave), Chave), j)
}

pub fn remover_um_examples() {
    check.eq(jogador.remover_um([], Chave), [])
    check.eq(jogador.remover_um([Chave], Chave), [])
    check.eq(jogador.remover_um([Chave, PeDeCabra], Chave), [PeDeCabra])
    check.eq(jogador.remover_um([PeDeCabra, Chave], Chave), [PeDeCabra])
    check.eq(jogador.remover_um([Chave, Chave, PeDeCabra], Chave), [Chave, PeDeCabra])
    check.eq(jogador.remover_um([PeDeCabra, CaboEnergia], Chave), [PeDeCabra, CaboEnergia])
}

pub fn ativar_examples() {
    let j = jogador.novo("Joao", 1)

    check.eq(jogador.ativar(j, EnergiaLigada), Jogador("Joao", [], 1, [EnergiaLigada]))
    check.eq(jogador.ativar(jogador.ativar(j, EnergiaLigada), EnergiaLigada), Jogador("Joao", [], 1, [EnergiaLigada]))
    check.eq(jogador.ativar(jogador.ativar(j, EnergiaLigada), NotebookLigado), Jogador("Joao", [], 1, [NotebookLigado, EnergiaLigada]))
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
    check.eq(jogador.resolvido(jogador.ativar(j, EnigmaResolvido(2)), 2), True)
}

pub fn mover_examples() {
    let j = jogador.novo("Joao", 1)

    check.eq(jogador.mover(j, 2), Jogador("Joao", [], 2, []))
    check.eq(jogador.mover(j, 5), Jogador("Joao", [], 5, []))
    check.eq(jogador.mover(j, 1), j)
    check.eq(jogador.mover(jogador.pegar(j, Chave), 3), Jogador("Joao", [Chave], 3, []))
    check.eq(jogador.mover(jogador.ativar(j, EnergiaLigada), 4), Jogador("Joao", [], 4, [EnergiaLigada]))
}


// Examples de objeto.gleam
pub fn quando_examples() {
    let j = jogador.novo("Joao", 1)
    let efeito = quando(fn(x) { jogador.tem(x, Chave) }, fn(x) { jogador.ativar(x, EnergiaLigada) })

    check.eq(efeito(j), j)
    check.eq(efeito(jogador.pegar(j, Chave)), jogador.ativar(jogador.pegar(j, Chave), EnergiaLigada))
}

pub fn pegando_examples() {
    let j = jogador.novo("Joao", 1)
    let pegar_chave = pegando("chave_sala", Chave)

    check.eq(pegar_chave(j), Jogador("Joao", [Chave], 1, [Coletado("chave_sala")]))
    // Não coleta o mesmo objeto novamente
    check.eq(pegar_chave(pegar_chave(j)), pegar_chave(j))
    // Ids diferentes são objetos diferentes
    check.eq(
        pegando("outra_chave", Chave)(pegar_chave(j)).inventario,
        [Chave, Chave],
    )
}

pub fn ativando_examples() {
    let j = jogador.novo("Joao", 1)

    check.eq(ativando(EnergiaLigada)(j), Jogador("Joao", [], 1, [EnergiaLigada]))
    check.eq(ativando(NotebookLigado)(j), Jogador("Joao", [], 1, [NotebookLigado]))
    check.eq(ativando(EnergiaLigada)(ativando(NotebookLigado)(j)), Jogador("Joao", [], 1, [EnergiaLigada, NotebookLigado]))
}

pub fn consumindo_examples() {
    let j = jogador.pegar(jogador.pegar(jogador.novo("Joao", 1), Chave), CaboEnergia)

    check.eq(consumindo(Chave)(j), Jogador("Joao", [CaboEnergia], 1, []))
    check.eq(consumindo(CaboEnergia)(j), Jogador("Joao", [Chave], 1, []))
    // Consumir um item que o jogador não tem não altera nada
    // (NotebookLigado é uma Flag, não um Item: por isso dava erro de tipo)
    check.eq(consumindo(PeDeCabra)(j), j)
}

pub fn exigindo_examples() {
    let j = jogador.novo("Joao", 1)
    let efeito = exigindo(Chave, ativando(EnergiaLigada))

    check.eq(efeito(j), j)
    check.eq(efeito(jogador.pegar(j, Chave)), jogador.ativar(jogador.pegar(j, Chave), EnergiaLigada))
}

pub fn exigindo_flag_examples() {
    let j = jogador.novo("Joao", 1)
    let efeito = exigindo_flag(EnergiaLigada, ativando(NotebookLigado))

    check.eq(efeito(j), j)
    check.eq(efeito(jogador.ativar(j, EnergiaLigada)), Jogador("Joao", [], 1, [NotebookLigado, EnergiaLigada]))
}

// Examples de enigma.gleam
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
    let resolvido = jogador.ativar(j, EnergiaLigada) |> jogador.ativar(EnigmaResolvido(1))

    // OBS.: a variável NÃO pode se chamar `enigma` (esconderia o módulo enigma)
    let e_aberto = Enigma(
        id: 1,
        descricao: "Qual é a senha?",
        solucao: "computador",
        pistas: ["Começa com C"],
        requisito: fn(_) { True },
        efeito: fn(x) { jogador.ativar(x, EnergiaLigada) },
    )
    // Resposta correta e requisito cumprido
    check.eq(enigma.resolver_enigma(e_aberto, "computador", j), resolvido)
    // Resposta correta com espaços e letras maiúsculas
    check.eq(enigma.resolver_enigma(e_aberto, "  COMPUTADOR  ", j), resolvido)
    // Resposta incorreta
    check.eq(enigma.resolver_enigma(e_aberto, "notebook", j), j)
    // Resposta vazia
    check.eq(enigma.resolver_enigma(e_aberto, "", j), j)

    // Requisito não cumprido
    let e_bloqueado = Enigma(
        id: 2,
        descricao: "Qual é a senha?",
        solucao: "computador",
        pistas: [],
        requisito: fn(_) { False },
        efeito: fn(x) { jogador.ativar(x, EnergiaLigada) },
    )
    check.eq(enigma.resolver_enigma(e_bloqueado, "computador", j), j)

    // Enigma já resolvido: o efeito não é aplicado de novo
    let j_resolvido = jogador.ativar(j, EnigmaResolvido(1))
    check.eq(enigma.resolver_enigma(e_aberto, "computador", j_resolvido), j_resolvido)
}


// Examples de ambiente.gleam
fn ambiente_teste() -> Ambiente {
    Ambiente(
        andar: 1,
        nome: "Laboratorio",
        descricao: "Um laboratorio abandonado.",
        objetos: [
            Objeto(
                nome: "Painel",
                descricao: "Um painel eletrico.",
                interacao: fn(x) { x },
                estado: "Desligado",
            ),
            Objeto(
                nome: "Porta",
                descricao: "Uma porta trancada.",
                interacao: fn(x) { x },
                estado: "Trancada",
            ),
        ],
        saidas: [
            Saida(destino: 2, requisito: sempre),
            Saida(destino: 3, requisito: fn(x) { jogador.tem(x, Chave) }),
        ],
        enigmas: [],
    )
}

pub fn sempre_examples() {
    let j = jogador.novo("Jorge", 1)

    check.eq(ambiente.sempre(j), True)
    check.eq(ambiente.sempre(jogador.pegar(j, Chave)), True)
}

pub fn buscar_examples() {
    let andares = [
        ambiente_teste(),
        Ambiente(
            andar: 2,
            nome: "Sala",
            descricao: "Uma sala escura.",
            objetos: [],
            saidas: [],
            enigmas: [],
        ),
    ]

    check.eq(
        case ambiente.buscar(andares, 1) {
            Ok(a) -> a.andar
            Error(Nil) -> -1
        },
        1,
    )
    check.eq(
        case ambiente.buscar(andares, 2) {
            Ok(a) -> a.andar
            Error(Nil) -> -1
        },
        2,
    )
    check.eq(
        case ambiente.buscar(andares, 3) {
            Ok(a) -> a.andar
            Error(Nil) -> -1
        },
        -1,
    )
    check.eq(
        case ambiente.buscar([], 1) {
            Ok(a) -> a.andar
            Error(Nil) -> -1
        },
        -1,
    )
}

pub fn saida_aberta_examples() {
    // OBS.: a variável NÃO pode se chamar `ambiente` (esconderia o módulo)
    let amb = ambiente_teste()
    let j = jogador.novo("Jorge", 1)
    let j_chave = jogador.pegar(j, Chave)

    check.eq(ambiente.saida_aberta(amb, 2, j), True)
    check.eq(ambiente.saida_aberta(amb, 3, j), False)
    check.eq(ambiente.saida_aberta(amb, 3, j_chave), True)
    check.eq(ambiente.saida_aberta(amb, 4, j), False)
}

pub fn explorar_examples() {
    let amb = ambiente_teste()
    let j = jogador.novo("Jorge", 1)
    let j_chave = jogador.pegar(j, Chave)

    check.eq(ambiente.explorar(amb, j), "Laboratorio: Um laboratorio abandonado.\nObjetos: Painel, Porta\nSaídas: 2")
    check.eq(ambiente.explorar(amb, j_chave), "Laboratorio: Um laboratorio abandonado.\nObjetos: Painel, Porta\nSaídas: 2, 3")
}


// Auxiliares dos testes de jogo.gleam
// (funções puras que montam situações; não são examples)

/// Move o jogador do jogo para outro andar, sem passar pelas regras.
fn em(j: Jogo, andar: Int) -> Jogo {
    Jogo(..j, jogador: jogador.mover(j.jogador, andar))
}

/// Dá um item ao jogador, sem passar pelas regras.
fn com_item(j: Jogo, item: Item) -> Jogo {
    Jogo(..j, jogador: jogador.pegar(j.jogador, item))
}

/// Liga uma flag do jogador, sem passar pelas regras.
fn com_flag(j: Jogo, flag: Flag) -> Jogo {
    Jogo(..j, jogador: jogador.ativar(j.jogador, flag))
}

/// Andar em que o jogador está.
fn local(j: Jogo) -> Int {
    j.jogador.localizacao
}

/// Nome do andar atual ("" se o andar não existe).
fn nome_do_andar(j: Jogo) -> String {
    case jogo.ambiente_atual(j) {
        Ok(a) -> a.nome
        Error(Nil) -> ""
    }
}

/// Mundo mínimo para testar jogo.gleam, com 3 andares:
/// 1: gaveta (dá a chave) e enigma 1 (resposta "abc"); sai para 2 e, com a chave, para 3.
/// 2: painel (com a chave, liga o notebook); volta para 1.
/// 3: sala vazia; volta para 1.
fn jogo_teste() -> Jogo {
    Jogo(
        jogador: jogador.novo("Joao", 1),
        andares: [
            Ambiente(
                andar: 1,
                nome: "Sala 1",
                descricao: "A primeira sala.",
                objetos: [
                    Objeto(
                        nome: "gaveta",
                        descricao: "Uma gaveta com uma chave.",
                        interacao: pegando("gaveta", Chave),
                        estado: "fechada",
                    ),
                ],
                saidas: [
                    Saida(destino: 2, requisito: sempre),
                    Saida(destino: 3, requisito: fn(x) { jogador.tem(x, Chave) }),
                ],
                enigmas: [
                    Enigma(
                        id: 1,
                        descricao: "Qual a senha?",
                        solucao: "abc",
                        pistas: ["As três primeiras letras."],
                        requisito: sempre,
                        efeito: ativando(EnergiaLigada),
                    ),
                ],
            ),
            Ambiente(
                andar: 2,
                nome: "Sala 2",
                descricao: "A segunda sala.",
                objetos: [
                    Objeto(
                        nome: "painel",
                        descricao: "O painel liga o notebook.",
                        interacao: exigindo(Chave, ativando(NotebookLigado)),
                        estado: "desligado",
                    ),
                ],
                saidas: [Saida(destino: 1, requisito: sempre)],
                enigmas: [],
            ),
            Ambiente(
                andar: 3,
                nome: "Sala 3",
                descricao: "A terceira sala, vazia.",
                objetos: [],
                saidas: [Saida(destino: 1, requisito: sempre)],
                enigmas: [],
            ),
        ],
    )
}


// Examples de jogo.gleam (mundo mínimo)
pub fn novo_jogo_examples() {
    let j = jogo.novo()

    check.eq(j.jogador, jogador.novo("Guarda", 7))
    check.eq(list.length(j.andares), 7)
    check.eq(local(j), 7)
}

pub fn ambiente_atual_examples() {
    let j = jogo_teste()

    check.eq(nome_do_andar(j), "Sala 1")
    check.eq(nome_do_andar(em(j, 2)), "Sala 2")
    check.eq(nome_do_andar(em(j, 3)), "Sala 3")
    // Andar que não existe
    check.eq(nome_do_andar(em(j, 9)), "")
}

pub fn ir_examples() {
    let j = jogo_teste()

    check.eq(local(jogo.ir(j, 2)), 2)
    // Saída com requisito: sem a chave não vai, com a chave vai
    check.eq(local(jogo.ir(j, 3)), 1)
    check.eq(local(jogo.ir(com_item(j, Chave), 3)), 3)
    // Andar que não é saída do andar atual
    check.eq(local(jogo.ir(j, 5)), 1)
    // Ir para o próprio andar não é uma saída
    check.eq(local(jogo.ir(j, 1)), 1)
    // Ida e volta
    check.eq(local(jogo.ir(jogo.ir(j, 2), 1)), 1)
    // Andar inexistente: o jogador não se move
    check.eq(local(jogo.ir(em(j, 9), 1)), 9)
}

pub fn interagir_examples() {
    let j = jogo_teste()

    // Pega a chave (e marca a gaveta como coletada)
    check.eq(
        jogo.interagir(j, "gaveta").jogador,
        Jogador("Joao", [Chave], 1, [Coletado("gaveta")]),
    )
    // Interagir de novo não duplica a chave
    check.eq(
        jogo.interagir(jogo.interagir(j, "gaveta"), "gaveta").jogador,
        jogo.interagir(j, "gaveta").jogador,
    )
    // Objeto que não existe
    check.eq(jogo.interagir(j, "mesa").jogador, j.jogador)
    // Objeto que está em outro andar
    check.eq(jogo.interagir(j, "painel").jogador, j.jogador)
    // Andar inexistente
    check.eq(jogo.interagir(em(j, 9), "gaveta").jogador, em(j, 9).jogador)

    // O painel exige a chave
    let no_painel = em(j, 2)
    check.eq(jogo.interagir(no_painel, "painel").jogador, no_painel.jogador)
    check.eq(
        jogador.flag_ativa(
            jogo.interagir(com_item(no_painel, Chave), "painel").jogador,
            NotebookLigado,
        ),
        True,
    )
}

pub fn resolver_examples() {
    let j = jogo_teste()
    let certo = jogo.resolver(j, 1, "abc").jogador

    check.eq(jogador.flag_ativa(certo, EnergiaLigada), True)
    check.eq(jogador.resolvido(certo, 1), True)
    // Maiúsculas e espaços não importam
    check.eq(jogo.resolver(j, 1, " ABC ").jogador, certo)
    // Resposta errada
    check.eq(jogo.resolver(j, 1, "xyz").jogador, j.jogador)
    // Enigma que não existe
    check.eq(jogo.resolver(j, 99, "abc").jogador, j.jogador)
    // Enigma de outro andar
    check.eq(jogo.resolver(em(j, 2), 1, "abc").jogador, em(j, 2).jogador)
    // Já resolvido: resolver de novo não muda nada
    check.eq(jogo.resolver(jogo.resolver(j, 1, "abc"), 1, "abc").jogador, certo)
}

pub fn aplicar_examples() {
    let j = jogo_teste()

    check.eq(jogo.aplicar(j, Explorar).jogador, j.jogador)
    check.eq(local(jogo.aplicar(j, Ir(2))), 2)
    check.eq(jogo.aplicar(j, Interagir("gaveta")).jogador, jogo.interagir(j, "gaveta").jogador)
    check.eq(jogo.aplicar(j, Resolver(1, "abc")).jogador, jogo.resolver(j, 1, "abc").jogador)
}

pub fn executar_examples() {
    let j = jogo_teste()

    // Lista vazia: nada muda
    check.eq(jogo.executar(j, []).jogador, j.jogador)
    // Várias ações em ordem
    check.eq(
        jogo.executar(j, [Resolver(1, "abc"), Interagir("gaveta"), Ir(3)]).jogador,
        Jogador("Joao", [Chave], 3, [Coletado("gaveta"), EnigmaResolvido(1), EnergiaLigada]),
    )
    // A ordem importa: sem a chave ainda, Ir(3) falha
    check.eq(
        local(jogo.executar(j, [Ir(3), Interagir("gaveta")])),
        1,
    )
}

pub fn venceu_examples() {
    check.eq(jogo.venceu(jogo.novo()), False)
    check.eq(jogo.venceu(com_flag(jogo.novo(), EnigmaResolvido(9))), False)
    check.eq(jogo.venceu(com_flag(jogo.novo(), EnigmaResolvido(10))), True)
}


// Examples do cenário real (jogo.novo(): os 7 andares da torre)
pub fn torre_examples() {
    let andares = jogo.novo().andares

    check.eq(list.map(andares, fn(a) { a.andar }), [1, 2, 3, 4, 5, 6, 7])
    // Enigmas de resposta digitada, andar por andar
    check.eq(
        list.map(andares, fn(a) { list.map(a.enigmas, fn(e) { e.id }) }),
        [[10], [9], [7], [6], [3], [], []],
    )
}

pub fn saidas_da_torre_examples() {
    let j = jogo.novo()

    // Do 7º: escada (6) e duto (5), mas não direto para o 4
    check.eq(local(jogo.ir(j, 6)), 6)
    check.eq(local(jogo.ir(j, 5)), 5)
    check.eq(local(jogo.ir(j, 4)), 7)
    // O duto só desce: do 5º não dá para voltar ao 7º
    check.eq(local(jogo.ir(em(j, 5), 7)), 5)
    // O duto do 4º para o 2º só abre depois do enigma 5
    check.eq(local(jogo.ir(em(j, 4), 2)), 4)
    check.eq(local(jogo.ir(com_flag(em(j, 4), EnigmaResolvido(5)), 2)), 2)
    // ...e não sobe: do 2º não se vai ao 4º
    check.eq(local(jogo.ir(com_flag(em(j, 2), EnigmaResolvido(5)), 4)), 2)
}

pub fn alavanca_examples() {
    let j = jogo.novo()
    let puxada = jogo.interagir(em(j, 3), "alavanca").jogador

    // Enigma 1
    check.eq(jogador.flag_ativa(puxada, EnergiaLigada), True)
    check.eq(jogador.resolvido(puxada, 1), True)
    // No 7º andar não há alavanca
    check.eq(jogo.interagir(j, "alavanca").jogador, j.jogador)
}

pub fn cabos_examples() {
    let j = jogo.novo()
    let do_terceiro = jogo.interagir(em(j, 3), "cabo de energia")

    check.eq(do_terceiro.jogador.inventario, [CaboEnergia])
    // Pegar o mesmo cabo de novo não duplica
    check.eq(jogo.interagir(do_terceiro, "cabo de energia").jogador.inventario, [CaboEnergia])
    // O cabo do 4º andar é outro cabo
    check.eq(
        jogo.interagir(em(do_terceiro, 4), "cabo de energia").jogador.inventario,
        [CaboEnergia, CaboEnergia],
    )
}

pub fn notebook_examples() {
    // Enigma 2
    let no_6 = em(jogo.novo(), 6)
    let com_energia = com_flag(no_6, EnergiaLigada)
    let com_cabo = com_item(no_6, CaboEnergia)

    check.eq(jogo.interagir(no_6, "notebook").jogador, no_6.jogador)
    // Só o cabo: as tomadas ainda estão sem energia
    check.eq(jogo.interagir(com_cabo, "notebook").jogador, com_cabo.jogador)
    // Só a energia: falta o cabo
    check.eq(jogo.interagir(com_energia, "notebook").jogador, com_energia.jogador)

    let ligado = jogo.interagir(com_item(com_energia, CaboEnergia), "notebook").jogador
    check.eq(jogador.flag_ativa(ligado, NotebookLigado), True)
    check.eq(jogador.resolvido(ligado, 2), True)
    // O cabo foi usado; sobra só o papel com o código
    check.eq(jogador.tem(ligado, CaboEnergia), False)
    check.eq(list.length(ligado.inventario), 1)
}

pub fn computador_do_colega_examples() {
    let no_7 = jogo.novo()
    let so_energia = com_flag(no_7, EnergiaLigada)
    let pronto = com_flag(so_energia, NotebookLigado)

    check.eq(jogo.interagir(no_7, "computador do colega").jogador, no_7.jogador)
    // Falta ligar o notebook (descobrir o código)
    check.eq(jogo.interagir(so_energia, "computador do colega").jogador, so_energia.jogador)
    // Com tudo: recebe a senha e a anotação do chaveiro
    check.eq(list.length(jogo.interagir(pronto, "computador do colega").jogador.inventario), 2)
    // Interagir de novo não duplica os papéis
    check.eq(
        list.length(
            jogo.interagir(jogo.interagir(pronto, "computador do colega"), "computador do colega").jogador.inventario,
        ),
        2,
    )
}

pub fn porta_das_placas_examples() {
    // Enigma 3
    let no_5 = em(jogo.novo(), 5)
    let no_6 = em(jogo.novo(), 6)

    check.eq(jogador.flag_ativa(jogo.resolver(no_5, 3, "2486").jogador, PortaPlacasAberta), True)
    check.eq(jogador.flag_ativa(jogo.resolver(no_5, 3, " 2486 ").jogador, PortaPlacasAberta), True)
    check.eq(jogo.resolver(no_5, 3, "2468").jogador, no_5.jogador)
    // O teclado está no 5º andar
    check.eq(jogo.resolver(no_6, 3, "2486").jogador, no_6.jogador)
}

pub fn caixa_de_placas_examples() {
    // Enigma 4
    let no_5 = em(jogo.novo(), 5)
    let so_porta = com_flag(no_5, PortaPlacasAberta)
    let so_pe_de_cabra = com_item(no_5, PeDeCabra)

    // Sem o pé de cabra
    check.eq(jogo.interagir(so_porta, "caixa de placas").jogador, so_porta.jogador)
    // Com a porta ainda trancada
    check.eq(jogo.interagir(so_pe_de_cabra, "caixa de placas").jogador, so_pe_de_cabra.jogador)

    let aberta = jogo.interagir(com_item(so_porta, PeDeCabra), "caixa de placas").jogador
    check.eq(jogador.tem(aberta, BotaoAtivacao("vermelho")), True)
    check.eq(jogador.resolvido(aberta, 4), True)
}

pub fn grade_do_duto_examples() {
    // Enigma 5
    let no_4 = em(jogo.novo(), 4)
    let arrancada = jogo.interagir(com_item(no_4, PeDeCabra), "grade do duto")

    check.eq(jogo.interagir(no_4, "grade do duto").jogador, no_4.jogador)
    check.eq(jogador.resolvido(arrancada.jogador, 5), True)
    // O duto só abre depois de arrancar a grade
    check.eq(local(jogo.ir(no_4, 2)), 4)
    check.eq(local(jogo.ir(arrancada, 2)), 2)
}

pub fn painel_de_baterias_examples() {
    // Enigma 6
    let no_4 = em(jogo.novo(), 4)

    check.eq(jogador.tem(jogo.resolver(no_4, 6, "20 55 90").jogador, BotaoAtivacao("azul")), True)
    check.eq(jogo.resolver(no_4, 6, "90 55 20").jogador, no_4.jogador)
    check.eq(jogo.resolver(no_4, 6, "20 90 55").jogador, no_4.jogador)
}

pub fn armario_examples() {
    // Enigma 7
    let no_3 = em(jogo.novo(), 3)

    check.eq(jogador.tem(jogo.resolver(no_3, 7, "713").jogador, PeDeCabra), True)
    check.eq(jogo.resolver(no_3, 7, "137").jogador, no_3.jogador)
    // O armário está no 3º andar
    check.eq(jogo.resolver(jogo.novo(), 7, "713").jogador, jogo.novo().jogador)
}

pub fn esteira_examples() {
    // Enigma 8
    let no_2 = em(jogo.novo(), 2)
    let so_cabo = com_item(no_2, CaboEnergia)
    let so_energia = com_flag(no_2, EnergiaLigada)

    check.eq(jogo.interagir(so_cabo, "painel da esteira").jogador, so_cabo.jogador)
    check.eq(jogo.interagir(so_energia, "painel da esteira").jogador, so_energia.jogador)

    let ligada = jogo.interagir(com_flag(so_cabo, EnergiaLigada), "painel da esteira").jogador
    check.eq(jogador.flag_ativa(ligada, EsteiraLigada), True)
    check.eq(jogador.resolvido(ligada, 8), True)
    check.eq(jogador.tem(ligada, CaboEnergia), False)
}

pub fn caixas_de_separacao_examples() {
    // Enigma 9
    let no_2 = em(jogo.novo(), 2)
    let esteira_ligada = com_flag(no_2, EsteiraLigada)

    // Com a esteira parada não dá para separar
    check.eq(jogo.resolver(no_2, 9, "metal").jogador, no_2.jogador)
    check.eq(jogador.tem(jogo.resolver(esteira_ligada, 9, "metal").jogador, Chave), True)
    check.eq(jogo.resolver(esteira_ligada, 9, "vidro").jogador, esteira_ligada.jogador)
    check.eq(jogo.resolver(esteira_ligada, 9, "plastico").jogador, esteira_ligada.jogador)
}

pub fn portao_examples() {
    // Enigma 10
    let no_1 = em(jogo.novo(), 1)
    let completo =
        no_1
        |> com_item(Chave)
        |> com_item(BotaoAtivacao("vermelho"))
        |> com_item(BotaoAtivacao("azul"))
    let sem_chave =
        no_1
        |> com_item(BotaoAtivacao("vermelho"))
        |> com_item(BotaoAtivacao("azul"))
    let sem_azul =
        no_1
        |> com_item(Chave)
        |> com_item(BotaoAtivacao("vermelho"))

    check.eq(jogo.venceu(jogo.resolver(completo, 10, "vermelho azul")), True)
    // Ordem errada
    check.eq(jogo.venceu(jogo.resolver(completo, 10, "azul vermelho")), False)
    // Falta a chave ou um dos botões
    check.eq(jogo.venceu(jogo.resolver(sem_chave, 10, "vermelho azul")), False)
    check.eq(jogo.venceu(jogo.resolver(sem_azul, 10, "vermelho azul")), False)
    // Sem nada
    check.eq(jogo.venceu(jogo.resolver(no_1, 10, "vermelho azul")), False)
}

/// Caminho principal do organizacao.md, do 7º andar até a vitória.
fn caminho_principal() -> List(Acao) {
    [
        Interagir("papel do guarda"),
        Ir(6), Ir(5), Ir(4), Ir(3),
        Interagir("alavanca"),                // enigma 1
        Interagir("cabo de energia"),
        Resolver(7, "713"),                   // enigma 7 (pé de cabra)
        Ir(4), Ir(5), Ir(6),
        Interagir("notebook"),                // enigma 2
        Ir(7),
        Interagir("computador do colega"),    // senha 2486
        Ir(5),                                // duto
        Resolver(3, "2486"),                  // enigma 3
        Interagir("caixa de placas"),         // enigma 4 (botão vermelho)
        Ir(4),
        Interagir("grade do duto"),           // enigma 5
        Resolver(6, "20 55 90"),              // enigma 6 (botão azul)
        Interagir("cabo de energia"),         // segundo cabo
        Ir(2),                                // duto
        Interagir("painel da esteira"),       // enigma 8
        Resolver(9, "metal"),                 // enigma 9 (chave)
        Ir(1),
        Resolver(10, "vermelho azul"),        // enigma 10
    ]
}

pub fn caminho_principal_examples() {
    let caminho = caminho_principal()
    let fim = jogo.executar(jogo.novo(), caminho)

    check.eq(jogo.venceu(fim), True)
    check.eq(local(fim), 1)
    // Todos os 10 enigmas ficaram resolvidos
    check.eq(
        list.all([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], fn(n) { jogador.resolvido(fim.jogador, n) }),
        True,
    )
    // Sem a última ação (o portão) ainda não venceu
    check.eq(jogo.venceu(jogo.executar(jogo.novo(), list.take(caminho, list.length(caminho) - 1))), False)
    // Sem nenhuma ação também não
    check.eq(jogo.venceu(jogo.executar(jogo.novo(), [])), False)
}
