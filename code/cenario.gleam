import ambiente.{type Ambiente, Ambiente, Saida, sempre}
import enigma.{Enigma}
import jogador.{Papel}
import objeto.{Objeto, pegando}

/// pub type Ambiente {
///     Ambiente(
///         andar: Int,
///         nome: String,
///         descricao: String,
///         objetos: List(Objeto),
///         saidas: List(Saida),
///         enigmas: List(Enigma),
///     )
/// }
/// 
/// pub type Objeto {
///     Objeto(
///         nome: String,
///         descricao: String,
///         interacao: fn(Jogador) -> Jogador,
///         estado: String,
///     )
/// }
/// Anotação só para eu lembrar tudo que eu tenho que colocar

pub fn seguranca() -> Ambiente {
    Ambiente(
        andar: 7,
        nome: "Sala de segurança",
        descricao: "Monitores apagados. Você acordou de um cochilo e a torre está trancada.",
        objetos: [
            Objeto(
                "papel do guarda",
                "Anotação sua: 'Meu código do armário: onde eu trabalho, onde eu saio, onde eu guardo as ferramentas.'",
                pegando("papel-guarda", Papel("Meu código do armário: onde eu trabalho, onde eu saio, onde eu guardo as ferramentas.")),
                "livre",
            ),
            Objeto(
                // computador do colega: ver Fase 7
            )
        ],
        saidas: [Saida(6, sempre), Saida(5, sempre)],   // 5 = duto de ventilação
        enigmas: [],
    )
}

pub fn sala_computadores() -> Ambiente {
    Ambiente(
        andar: 6,
        nome: "Sala de computadores",
        descricao: "Um amontoado de computadores e notebooks descartados.",
        objetos: [
            Objeto(
                "Notebook funcional",
                "Um notebook aparentemente funcional que precisa de um pouco de carga de bateria"
                // consumindo() + ativando() -> tenho que ver como fazer isso, talvez transformar em uma lista
            )
        ]
    )
}

pub fn torre() -> List(Ambiente) {
    [seguranca()]   // vai crescendo nas fases seguintes
}