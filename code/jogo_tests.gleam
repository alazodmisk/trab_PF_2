
import sgleam/check
import ambiente.{Ambiente, sempre}
import cenario
import enigma.{Enigma}
import jogador.{
  Saida, CaboEnergia, Chave, EnergiaLigada, EnigmaResolvido,
  EsteiraLigada, NotebookLigado, Papel, PeDeCabra, PortaPlacasAberta,
}
import menus.{Jogo}
import objeto.{Objeto}


// =================================================
// JOGADOR.GLEAM
// =================================================

pub fn novo_examples() {
  let j = jogador.novo("Guarda", 7)

  check.eq(j.nome, "Guarda")
  check.eq(j.inventario, [])
  check.eq(j.localizacao, 7)
  check.eq(j.flags, [])

  check.eq(jogador.novo("Jogador", 1).localizacao, 1)
  check.eq(jogador.novo("Teste", 3).nome, "Teste")
}

pub fn pegar_examples() {
  let j = jogador.novo("Guarda", 7)

  check.eq(jogador.pegar(j, Chave).inventario, [Chave])
  check.eq(
    jogador.pegar(jogador.pegar(j, Chave), PeDeCabra).inventario,
    [PeDeCabra, Chave],
  )
  check.eq(jogador.pegar(j, CaboEnergia).inventario, [CaboEnergia])
}

pub fn tem_examples() {
  let j = jogador.pegar(jogador.novo("Guarda", 7), Chave)

  check.eq(jogador.tem(j, Chave), True)
  check.eq(jogador.tem(j, PeDeCabra), False)
  check.eq(jogador.tem(j, CaboEnergia), False)

  check.eq(
    jogador.tem(jogador.pegar(j, PeDeCabra), PeDeCabra),
    True,
  )
}

pub fn contem_examples() {
  // Testada indiretamente por meio de tem.
  let j = jogador.novo("Guarda", 7)

  check.eq(jogador.tem(j, Chave), False)
  check.eq(jogador.tem(jogador.pegar(j, Chave), Chave), True)
  check.eq(
    jogador.tem(jogador.pegar(j, Chave) |> jogador.pegar(PeDeCabra), Chave),
    True,
  )
}

pub fn consumir_examples() {
  let j = jogador.novo("Guarda", 7)
    |> jogador.pegar(Chave)
    |> jogador.pegar(PeDeCabra)

  check.eq(jogador.consumir(j, Chave).inventario, [PeDeCabra])
  check.eq(jogador.consumir(j, PeDeCabra).inventario, [Chave])
  check.eq(jogador.consumir(j, CaboEnergia).inventario, j.inventario)
  check.eq(jogador.consumir(jogador.novo("Guarda", 7), Chave).inventario, [])
}

pub fn remover_um_examples() {
  check.eq(jogador.remover_um([Chave, PeDeCabra], Chave), [PeDeCabra])
  check.eq(jogador.remover_um([Chave, PeDeCabra], PeDeCabra), [Chave])
  check.eq(jogador.remover_um([Chave, Chave, PeDeCabra], Chave), [Chave, PeDeCabra])
  check.eq(jogador.remover_um([Chave, PeDeCabra], CaboEnergia), [Chave, PeDeCabra])
  check.eq(jogador.remover_um([], Chave), [])
}

pub fn ativar_examples() {
  let j = jogador.novo("Guarda", 7)

  check.eq(
    jogador.ativar(j, EnergiaLigada).flags,
    [EnergiaLigada],
  )
  check.eq(
    jogador.ativar(j |> jogador.ativar(EnergiaLigada), EnergiaLigada).flags,
    [EnergiaLigada],
  )
  check.eq(
    jogador.ativar(j, EsteiraLigada).flags,
    [EsteiraLigada],
  )
}

pub fn flag_ativa_examples() {
  let j = jogador.novo("Guarda", 7)
    |> jogador.ativar(EnergiaLigada)
    |> jogador.ativar(NotebookLigado)

  check.eq(jogador.flag_ativa(j, EnergiaLigada), True)
  check.eq(jogador.flag_ativa(j, NotebookLigado), True)
  check.eq(jogador.flag_ativa(j, EsteiraLigada), False)
  check.eq(jogador.flag_ativa(j, PortaPlacasAberta), False)
}

pub fn resolvido_examples() {
  let j = jogador.novo("Guarda", 7)
    |> jogador.ativar(EnigmaResolvido(1))
    |> jogador.ativar(EnigmaResolvido(5))

  check.eq(jogador.resolvido(j, 1), True)
  check.eq(jogador.resolvido(j, 5), True)
  check.eq(jogador.resolvido(j, 2), False)
  check.eq(jogador.resolvido(j, 10), False)
}

pub fn mover_examples() {
  let j = jogador.novo("Guarda", 7)

  check.eq(jogador.mover(j, 3).localizacao, 3)
  check.eq(jogador.mover(j, 1).localizacao, 1)
  check.eq(jogador.mover(j, 7).localizacao, 7)
  check.eq(jogador.mover(j, 4).nome, "Guarda")
}


// =================================================
// OBJETO.GLEAM
// =================================================

pub fn quando_examples() {
  let j = jogador.novo("Guarda", 7)

  let efeito = objeto.quando(
    fn(j) { j.localizacao == 7 },
    fn(j) { jogador.mover(j, 3) },
  )

  check.eq(efeito(j).localizacao, 3)
  check.eq(efeito(jogador.mover(j, 2)).localizacao, 2)
}

pub fn pegando_examples() {
  let j = jogador.novo("Guarda", 7)
  let efeito = objeto.pegando("chave", Chave)

  check.eq(efeito(j).inventario, [Chave])
  check.eq(efeito(j).flags, [jogador.Coletado("chave")])

  // Não deve coletar o mesmo item novamente.
  check.eq(efeito(efeito(j)).inventario, [Chave])

  // Identificadores diferentes permitem coletar novamente.
  check.eq(
    objeto.pegando("outra-chave", Chave)(efeito(j)).inventario,
    [Chave, Chave],
  )
}

pub fn ativando_examples() {
  let j = jogador.novo("Guarda", 7)

  check.eq(objeto.ativando(EnergiaLigada)(j).flags, [EnergiaLigada])
  check.eq(objeto.ativando(EsteiraLigada)(j).flags, [EsteiraLigada])
  check.eq(
    objeto.ativando(EnergiaLigada)(
      objeto.ativando(EnergiaLigada)(j),
    ).flags,
    [EnergiaLigada],
  )
}

pub fn consumindo_examples() {
  let j = jogador.novo("Guarda", 7)
    |> jogador.pegar(Chave)
    |> jogador.pegar(CaboEnergia)

  check.eq(objeto.consumindo(Chave)(j).inventario, [CaboEnergia])
  check.eq(objeto.consumindo(CaboEnergia)(j).inventario, [Chave])
  check.eq(objeto.consumindo(PeDeCabra)(j).inventario, j.inventario)
}

pub fn exigindo_examples() {
  let j = jogador.novo("Guarda", 7)
  let efeito = objeto.exigindo(
    Chave,
    fn(j) { jogador.mover(j, 1) },
  )

  check.eq(efeito(j).localizacao, 7)
  check.eq(efeito(jogador.pegar(j, Chave)).localizacao, 1)
}

pub fn exigindo_flag_examples() {
  let j = jogador.novo("Guarda", 7)
  let efeito = objeto.exigindo_flag(
    EnergiaLigada,
    fn(j) { jogador.mover(j, 3) },
  )

  check.eq(efeito(j).localizacao, 7)
  check.eq(
    efeito(jogador.ativar(j, EnergiaLigada)).localizacao,
    3,
  )
}


// =================================================
// ENIGMA.GLEAM
// =================================================

pub fn normalizar_examples() {
  check.eq(enigma.normalizar("METAL"), "metal")
  check.eq(enigma.normalizar("  Metal  "), "metal")
  check.eq(enigma.normalizar("  VERMELHO AZUL  "), "vermelho azul")
  check.eq(enigma.normalizar("713"), "713")
  check.eq(enigma.normalizar(""), "")
}

pub fn resolver_enigma_examples() {
  let j = jogador.novo("Guarda", 7)

  let e = Enigma(
    id: 1,
    descricao: "Teste",
    solucao: "metal",
    pistas: [],
    requisito: sempre,
    efeito: fn(j) { jogador.mover(j, 1) },
  )

  // Resposta correta.
  let correto = enigma.resolver_enigma(e, "metal", j)
  check.eq(correto.localizacao, 1)
  check.eq(jogador.resolvido(correto, 1), True)

  // Resposta incorreta.
  check.eq(enigma.resolver_enigma(e, "plastico", j), j)

  // Resposta correta com espaços e letras maiúsculas.
  check.eq(
    enigma.resolver_enigma(e, "  METAL  ", j).localizacao,
    1,
  )

  // Requisito não cumprido.
  let bloqueado = Enigma(
    ..e,
    id: 2,
    requisito: fn(_j) { False },
  )
  check.eq(enigma.resolver_enigma(bloqueado, "metal", j), j)

  // Enigma já resolvido.
  let repetido = j |> jogador.ativar(EnigmaResolvido(1))
  check.eq(enigma.resolver_enigma(e, "metal", repetido), repetido)
}


// =================================================
// AMBIENTE.GLEAM
// =================================================

pub fn sempre_examples() {
  check.eq(sempre(jogador.novo("Guarda", 7)), True)
  check.eq(sempre(jogador.novo("Teste", 1)), True)
}

pub fn buscar_examples() {
  let a1 = cenario.garagem()
  let a2 = cenario.triagem()
  let andares = [a1, a2]

  check.eq(ambiente.buscar(andares, 1), Ok(a1))
  check.eq(ambiente.buscar(andares, 2), Ok(a2))
  check.eq(ambiente.buscar(andares, 3), Error(Nil))
  check.eq(ambiente.buscar([], 1), Error(Nil))
}

pub fn saida_aberta_examples() {
  let a = Ambiente(
    andar: 1,
    nome: "Teste",
    descricao: "Ambiente de teste",
    objetos: [],
    saidas: [
      Saida(2, sempre),
      Saida(3, fn(j) { jogador.flag_ativa(j, EnergiaLigada) }),
    ],
    enigmas: [],
  )

  let j = jogador.novo("Guarda", 1)

  check.eq(ambiente.saida_aberta(a, 2, j), True)
  check.eq(ambiente.saida_aberta(a, 3, j), False)
  check.eq(
    ambiente.saida_aberta(
      a,
      3,
      jogador.ativar(j, EnergiaLigada),
    ),
    True,
  )
  check.eq(ambiente.saida_aberta(a, 4, j), False)
}

pub fn explorar_examples() {
  let a = Ambiente(
    andar: 1,
    nome: "Garagem",
    descricao: "Ambiente de teste.",
    objetos: [
      Objeto("portao", "Um portão.", fn(j) { j }, "fechado"),
      Objeto("chave", "Uma chave.", fn(j) { j }, "no chao"),
    ],
    saidas: [
      Saida(2, sempre),
      Saida(3, fn(j) { jogador.flag_ativa(j, EnergiaLigada) }),
    ],
    enigmas: [],
  )

  let j = jogador.novo("Guarda", 1)

  check.eq(
    ambiente.explorar(a, j),
    "Garagem: Ambiente de teste.\nObjetos: portao, chave\nSaídas: 2",
  )

  check.eq(
    ambiente.explorar(a, jogador.ativar(j, EnergiaLigada)),
    "Garagem: Ambiente de teste.\nObjetos: portao, chave\nSaídas: 2, 3",
  )

  check.eq(
    ambiente.explorar(
      Ambiente(1, "Vazio", "Sem objetos.", [], [], []),
      j,
    ),
    "Vazio: Sem objetos.\nObjetos: \nSaídas: ",
  )
}


// =================================================
// CENARIO.GLEAM
// =================================================

pub fn torre_examples() {
  check.eq(cenario.garagem().andar, 1)
  check.eq(cenario.triagem().andar, 2)
  check.eq(cenario.armazem().andar, 3)
  check.eq(cenario.baterias().andar, 4)
  check.eq(cenario.placas().andar, 5)
  check.eq(cenario.computadores().andar, 6)
  check.eq(cenario.seguranca().andar, 7)
}

pub fn nada_examples() {
  // Testada indiretamente pelas interações com objetos sem efeito.
  let j = jogador.novo("Guarda", 7)
  let portao = cenario.garagem().objetos

  case portao {
    [primeiro, ..] -> check.eq(primeiro.interacao(j), j)
    [] -> check.eq(True, False)
  }
}

pub fn em_sequencia_examples() {
  // Testada indiretamente pelas interações que encadeiam efeitos.
  let j = jogador.novo("Guarda", 7)
  let andar3 = cenario.armazem()

  case andar3.objetos {
    [alavanca, ..] -> {
      let resultado = alavanca.interacao(j)
      check.eq(jogador.flag_ativa(resultado, EnergiaLigada), True)
      check.eq(jogador.resolvido(resultado, 1), True)
    }
    [] -> check.eq(True, False)
  }
}


// =================================================
// MENUS.GLEAM
// =================================================

pub fn novo_jogo_examples() {
  let j = menus.novo()

  check.eq(j.jogador.nome, "Guarda")
  check.eq(j.jogador.localizacao, 7)
  check.eq(j.jogador.inventario, [])
  check.eq(jogador.resolvido(j.jogador, 1), False)
}


pub fn ambiente_atual_examples() {
  let j = menus.novo()

  // Ambiente inicial: 7º andar.
  case menus.ambiente_atual(j) {
    Ok(a) -> {
      check.eq(a.andar, 7)
      check.eq(a.nome, "Sala de segurança")
    }
    Error(_) -> check.eq(True, False)
  }

  // Jogador no 1º andar.
  let jogo_garagem = Jogo(
    jogador: jogador.mover(j.jogador, 1),
    andares: j.andares,
  )

  case menus.ambiente_atual(jogo_garagem) {
    Ok(a) -> {
      check.eq(a.andar, 1)
      check.eq(a.nome, "Garagem")
    }
    Error(_) -> check.eq(True, False)
  }

  // Andar inexistente.
  let jogo_invalido = Jogo(
    jogador: jogador.mover(j.jogador, 99),
    andares: j.andares,
  )

  check.eq(menus.ambiente_atual(jogo_invalido), Error(Nil))
}


pub fn tentar_ir_examples() {
  let j = menus.novo()

  check.eq(menus.tentar_ir(j, 6).jogador.localizacao, 6)
  check.eq(menus.tentar_ir(j, 5).jogador.localizacao, 5)

  // Não existe saída direta do 7º para o 1º andar.
  check.eq(menus.tentar_ir(j, 1), j)
}

pub fn tentar_interagir_examples() {
  let j = menus.novo()

  let resultado = menus.tentar_interagir(j, "papel do guarda")

  check.eq(jogador.tem(resultado.jogador, Papel(
    "Meu código do armário: onde eu trabalho, onde eu saio, onde eu guardo as ferramentas.",
  )), True)

  // Objeto inexistente.
  check.eq(menus.tentar_interagir(j, "objeto inexistente"), j)
}

pub fn tentar_resolver_examples() {
  let j = menus.novo()

  // Não há enigmas disponíveis no 7º andar.
  check.eq(menus.tentar_resolver(j, 1, "713"), j)

  // Ir até o 3º andar, onde está o enigma 7.
  let andar3 = menus.tentar_ir(
    menus.tentar_ir(
      menus.tentar_ir(j, 6),
      5,
    ),
    4,
  )
    |> menus.tentar_ir(3)

  let resultado = menus.tentar_resolver(andar3, 7, "713")

  check.eq(jogador.tem(resultado.jogador, PeDeCabra), True)
  check.eq(jogador.resolvido(resultado.jogador, 7), True)
}

pub fn venceu_examples() {
  let j = menus.novo()

  check.eq(menus.venceu(j), False)

  let vencedor = Jogo(
    jogador: jogador.ativar(j.jogador, EnigmaResolvido(10)),
    andares: j.andares,
  )

  check.eq(menus.venceu(vencedor), True)
}
