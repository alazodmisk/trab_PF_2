import jogadorpub 

type Objeto {
  Objeto(
    nome: String,
    descricao: String,
    interacao: fn(Jogador) -> Jogador,
    estado: String,
  )
}

pub fn pegando(item) {
  todo
}

pub fn ativando(flag) {
  todo
}

pub fn exigindo(item, efeito) {
  todo
}

pub fn depois(f, g) {
  todo
  /// Não sei se isso vai ser realmente necessário
  /// Basicamente serve para: Realizar duas funções de 
  /// interações após uma ação do personagem.
}