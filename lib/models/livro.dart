class Livro {
  final int id;
  final String titulo;
  final String autor;
  final String genero;
  final String descricao;
  final int corCapa;
  final String emailCriador;
  final String nomeCriador;
  final String? imagePath;

  const Livro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.genero,
    required this.descricao,
    required this.corCapa,
    required this.emailCriador,
    required this.nomeCriador,
    this.imagePath,
  });
}
