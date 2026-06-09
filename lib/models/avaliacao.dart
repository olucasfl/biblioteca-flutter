class Avaliacao {
  final int livroId;
  final String emailUsuario;
  final String nomeUsuario;
  final double nota;
  final String comentario;
  final DateTime data;

  const Avaliacao({
    required this.livroId,
    required this.emailUsuario,
    required this.nomeUsuario,
    required this.nota,
    required this.comentario,
    required this.data,
  });
}
