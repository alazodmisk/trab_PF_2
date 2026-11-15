import ambiente.{type Ambiente}
import cenario
import enigma
import gleam/list
import jogador.{type Jogador}

pub type Jogo {
    // Tipo jogo contendo jogador e andares. Contém: jogador e andares.
    Jogo(jogador: Jogador, andares: List(Ambiente))
}

pub type Acao {
    // Tipos de ações do jogo. Contém: Explorar, Interagir, Resolver e Ir.
    Explorar
    Interagir(objeto: String)
    Resolver(enigma: Int, resposta: String)
    Ir(andar: Int)
}

/// Estado inicial: guarda no 7º andar.
/// /// ANÁLISE: Faça uma função que cria um novo jogo com um jogador chamado "Guarda" no 7º andar e os andares do cenario.torre().
pub fn novo() -> Jogo {
    Jogo(jogador: jogador.novo("Guarda", 7), andares: cenario.torre())
}

///ANÁLISE: Faça uma função que recebe um jogo e retorna o ambiente atual do jogador. A função deve buscar o ambiente correspondente ao andar do jogador na lista de andares do jogo. Se o ambiente for encontrado, retorna Ok(ambiente); caso contrário, retorna Error(Nil).
/// TIPOS DE DADOS: A entrada é um *jogo* representado pelo tipo *Jogo*. A saída é um resultado que pode ser Ok(ambiente) ou Error(Nil), representado pelo tipo *Result(Ambiente, Nil)*.
/// ESPECIFICAÇÃO: Recebe um *jogo* e retorna o ambiente atual do jogador. A função deve buscar o ambiente correspondente ao andar do jogador na lista de andares do jogo. Se o ambiente for encontrado, retorna Ok(ambiente); caso contrário, retorna Error(Nil).
pub fn ambiente_atual(jogo: Jogo) -> Result(Ambiente, Nil) {
    ambiente.buscar(jogo.andares, jogo.jogador.localizacao)
}

///ANÁLISE: Faça uma função que recebe um jogo e um destino e verifica se o jogador pode ir para esse destino a partir do ambiente atual. A função deve retornar True se o jogador puder ir para o destino e False caso contrário.
/// TIPOS DE DADOS: A entrada é um *jogo* representado pelo tipo
/// Vai para outro andar, se a saída estiver aberta.
pub fn ir(jogo: Jogo, destino: Int) -> Jogo {
    case ambiente_atual(jogo) {
        Error(_) -> jogo
        Ok(atual) ->
            case ambiente.saida_aberta(atual, destino, jogo.jogador) {
                True -> Jogo(..jogo, jogador: jogador.mover(jogo.jogador, destino))
                False -> jogo
            }
    }
}

/// Interage com um objeto do andar atual.
/// ///ANALÍSE: Faça uma função que recebe um jogo e o nome de um objeto. A função deve buscar o objeto correspondente ao nome na lista de objetos do ambiente atual do jogador. Se o objeto for encontrado, aplica a interação do objeto no jogador e retorna o novo estado do jogo; caso contrário, retorna o jogo intacto.
/// TIPOS DE DADOS: A entrada é um *jogo* representado pelo tipo *Jogo* e o *nome* do objeto representado pelo tipo primitivo *String*. A saída é o novo estado do jogo, representado pelo tipo *Jogo*.
/// ESPECIFICAÇÃO: Recebe um *jogo* e o *nome* do objeto. A função deve buscar o objeto correspondente ao nome na lista de objetos do ambiente atual do jogador. Se o objeto for encontrado, aplica a interação do objeto no jogador e retorna o novo estado do jogo; caso contrário, retorna o jogo intacto.
pub fn interagir(jogo: Jogo, nome: String) -> Jogo {
    case ambiente_atual(jogo) {
        Error(_) -> jogo
        Ok(atual) ->
            case list.find(atual.objetos, fn(o) { o.nome == nome }) {
                Ok(obj) -> Jogo(..jogo, jogador: obj.interacao(jogo.jogador))
                Error(_) -> jogo
            }
    }
}

/// Tenta resolver um enigma do andar atual.
/// ///ANÁLISE: Faça uma função que recebe um jogo, o id de um enigma e uma resposta. A função deve buscar o enigma correspondente ao id na lista de enigmas do ambiente atual do jogador. Se o enigma for encontrado, aplica a função resolver_enigma do módulo enigma no jogador e retorna o novo estado do jogo; caso contrário, retorna o jogo intacto.
/// TIPOS DE DADOS: A entrada é um *jogo* representado pelo tipo *Jogo*, o *id* do enigma representado pelo tipo primitivo *Int* e a *resposta* representada pelo tipo primitivo *String*. A saída é o novo estado do jogo, representado pelo tipo *Jogo*.
/// ESPECIFICAÇÃO: Recebe um *jogo*, o *id* do enigma e uma *resposta*. A função deve buscar o enigma correspondente ao id na lista de enigmas do ambiente atual do jogador. Se o enigma for encontrado, aplica a função resolver_enigma do módulo enigma no jogador e retorna o novo estado do jogo; caso contrário, retorna o jogo intacto.
pub fn resolver(jogo: Jogo, id: Int, resposta: String) -> Jogo {
    case ambiente_atual(jogo) {
        Error(_) -> jogo
        Ok(atual) ->
            case list.find(atual.enigmas, fn(e) { e.id == id }) {
                Ok(e) ->
                    Jogo(..jogo, jogador: enigma.resolver_enigma(e, resposta, jogo.jogador))
                Error(_) -> jogo
            }
    }
}

/// Aplica uma ação e devolve o novo estado.
/// //ANÁLISE: Faça uma função que recebe um jogo e uma ação. A função deve aplicar a ação no jogo e retornar o novo estado do jogo. As ações podem ser Explorar, Interagir, Resolver ou Ir. Para cada ação, a função deve chamar a função correspondente (explorar, interagir, resolver ou ir) e retornar o novo estado do jogo.
/// TIPOS DE DADOS: A entrada é um *jogo* representado pelo tipo *Jogo* e uma *ação* representada pelo tipo *Acao*. A saída é o novo estado do jogo, representado pelo tipo *Jogo*.
/// ESPECIFICAÇÃO: Recebe um *jogo* e uma *ação*. A função deve aplicar a ação no jogo e retornar o novo estado do jogo. As ações podem ser Explorar, Interagir, Resolver ou Ir. Para cada ação, a função deve chamar a função correspondente (explorar, interagir, resolver ou ir) e retornar o novo estado do jogo.
pub fn aplicar(jogo: Jogo, acao: Acao) -> Jogo {
    case acao {
        Explorar -> jogo
        Interagir(nome) -> interagir(jogo, nome)
        Resolver(id, resposta) -> resolver(jogo, id, resposta)
        Ir(andar) -> ir(jogo, andar)
    }
}

/// Executa uma lista de ações em sequência.
/// //ANÁLISE: Faça uma função que recebe um jogo e uma lista de ações. A função deve aplicar cada ação na lista em sequência, atualizando o estado do jogo a cada ação, e retornar o estado final do jogo após todas as ações terem sido aplicadas.
/// TIPOS DE DADOS: A entrada é um *jogo* representado pelo tipo *Jogo* e uma *lista de ações* representada pelo tipo *List(Acao)*. A saída é o novo estado do jogo, representado pelo tipo *Jogo*.
/// ESPECIFICAÇÃO: Recebe um *jogo* e uma *lista de ações*. A função deve aplicar cada ação na lista em sequência, atualizando o estado do jogo a cada ação, e retornar o estado final do jogo após todas as ações terem sido aplicadas.
pub fn executar(jogo: Jogo, acoes: List(Acao)) -> Jogo {
    list.fold(acoes, jogo, aplicar)
}

/// O jogador venceu quando o enigma 10 está resolvido.
/// ///ANÁLISE: Faça uma função que recebe um jogo e verifica se o jogador venceu. A função deve verificar se o enigma com id 10 está resolvido no jogador. Se estiver resolvido, retorna True; caso contrário, retorna False.
/// TIPOS DE DADOS: A entrada é um *jogo* representado pelo tipo *Jogo*. A saída é um valor booleano representado pelo tipo primitivo *Bool*.
/// ESPECIFICAÇÃO: Recebe um *jogo* e verifica se o jogador venceu. A função deve verificar se o enigma com id 10 está resolvido no jogador. Se estiver resolvido, retorna True; caso contrário, retorna False.
pub fn venceu(jogo: Jogo) -> Bool {
    jogador.resolvido(jogo.jogador, 10)
}