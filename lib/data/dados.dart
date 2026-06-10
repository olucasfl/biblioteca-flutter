import '../models/avaliacao.dart';
import '../models/livro.dart';
import '../models/usuario.dart';

class Dados {
  static final List<Usuario> usuarios = [];
  static final List<Livro> livros = [];
  static final List<Avaliacao> avaliacoes = [];
  static final Map<String, Set<int>> favoritosPorEmail = {};
  static int _proximoId = 1;

  static int novoId() => _proximoId++;

  static int gerarCorCapa(String titulo) {
    const cores = [
      0xFF1565C0, 0xFF2E7D32, 0xFF4A148C, 0xFF6A1B9A,
      0xFFE65100, 0xFFBF360C, 0xFFF57F17, 0xFF880E4F,
      0xFF33691E, 0xFF006064, 0xFF01579B, 0xFF37474F,
    ];
    return cores[titulo.hashCode.abs() % cores.length];
  }

  static bool isFavorito(String email, int livroId) {
    return favoritosPorEmail[email]?.contains(livroId) ?? false;
  }

  static void toggleFavorito(String email, int livroId) {
    favoritosPorEmail.putIfAbsent(email, () => {});
    if (favoritosPorEmail[email]!.contains(livroId)) {
      favoritosPorEmail[email]!.remove(livroId);
    } else {
      favoritosPorEmail[email]!.add(livroId);
    }
  }

  static List<Livro> favoritosDeUsuario(String email) {
    final ids = favoritosPorEmail[email] ?? {};
    return livros.where((l) => ids.contains(l.id)).toList();
  }

  static double mediaNotas(int livroId) {
    final notas = avaliacoes
        .where((a) => a.livroId == livroId)
        .map((a) => a.nota)
        .toList();
    if (notas.isEmpty) return 0.0;
    return notas.reduce((a, b) => a + b) / notas.length;
  }

  static int totalAvaliacoes(int livroId) {
    return avaliacoes.where((a) => a.livroId == livroId).length;
  }

  static List<Avaliacao> avaliacoesDeLivro(int livroId) {
    return avaliacoes
        .where((a) => a.livroId == livroId)
        .toList()
      ..sort((a, b) => b.data.compareTo(a.data));
  }

  static Avaliacao? avaliacaoDoUsuario(String email, int livroId) {
    return avaliacoes
        .where((a) => a.emailUsuario == email && a.livroId == livroId)
        .firstOrNull;
  }

  static void salvarAvaliacao(Avaliacao nova) {
    avaliacoes.removeWhere(
      (a) => a.emailUsuario == nova.emailUsuario && a.livroId == nova.livroId,
    );
    avaliacoes.add(nova);
  }

  static List<Livro> livrosDoCriador(String email) {
    return livros.where((l) => l.emailCriador == email).toList();
  }

  static List<Avaliacao> avaliacoesDoUsuario(String email) {
    return avaliacoes
        .where((a) => a.emailUsuario == email)
        .toList()
      ..sort((a, b) => b.data.compareTo(a.data));
  }

  static void deletarLivro(int id) {
    livros.removeWhere((l) => l.id == id);
    avaliacoes.removeWhere((a) => a.livroId == id);
    for (final ids in favoritosPorEmail.values) {
      ids.remove(id);
    }
  }
 }
