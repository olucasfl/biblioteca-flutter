import 'package:flutter/material.dart';
import '../data/dados.dart';
import '../models/avaliacao.dart';
import '../models/livro.dart';
import '../widgets/estrelas.dart';
import 'criar_livro_screen.dart';
import 'detalhe_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String nomeUsuario;
  final String emailUsuario;

  const HomeScreen({
    super.key,
    required this.nomeUsuario,
    required this.emailUsuario,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;
  final _buscaController = TextEditingController();
  String _busca = '';

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  List<Livro> get _livrosFiltrados {
    if (_busca.isEmpty) return List.from(Dados.livros);
    final q = _busca.toLowerCase();
    return Dados.livros
        .where((l) =>
            l.titulo.toLowerCase().contains(q) ||
            l.autor.toLowerCase().contains(q))
        .toList();
  }

  void _abrirDetalhe(Livro livro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalheScreen(
          livro: livro,
          emailUsuario: widget.emailUsuario,
          nomeUsuario: widget.nomeUsuario,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void _abrirCriarLivro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CriarLivroScreen(
          emailUsuario: widget.emailUsuario,
          nomeUsuario: widget.nomeUsuario,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  Widget _capa(Livro livro,
      {double width = 56, double height = 80, double fontSize = 26}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Color(livro.corCapa),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        livro.titulo[0],
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _cardLivro(Livro livro) {
    final media = Dados.mediaNotas(livro.id);
    final total = Dados.totalAvaliacoes(livro.id);
    final favorito = Dados.isFavorito(widget.emailUsuario, livro.id);
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () => _abrirDetalhe(livro),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _capa(livro),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      livro.titulo,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      livro.autor,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Estrelas(valor: media, tamanho: 15),
                        const SizedBox(width: 4),
                        Text(
                          total > 0
                              ? '${media.toStringAsFixed(1)} ($total)'
                              : 'Sem avaliações',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        livro.genero,
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  favorito ? Icons.favorite : Icons.favorite_border,
                  color: favorito ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  Dados.toggleFavorito(widget.emailUsuario, livro.id);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _telaInicio() {
    final livros = _livrosFiltrados;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _buscaController,
            decoration: InputDecoration(
              hintText: 'Buscar por título ou autor...',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              isDense: true,
              suffixIcon: _busca.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _buscaController.clear();
                        setState(() => _busca = '');
                      },
                    )
                  : null,
            ),
            onChanged: (v) => setState(() => _busca = v),
          ),
        ),
        Expanded(
          child: livros.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu_book_outlined,
                          size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        Dados.livros.isEmpty
                            ? 'Nenhum livro ainda.\nSeja o primeiro a adicionar!'
                            : 'Nenhum resultado para "$_busca".',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: livros.length,
                  itemBuilder: (_, i) => _cardLivro(livros[i]),
                ),
        ),
      ],
    );
  }

  Widget _telaFavoritos() {
    final favoritos = Dados.favoritosDeUsuario(widget.emailUsuario);
    if (favoritos.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border,
                size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              'Nenhum favorito ainda.\nToque no coração em qualquer livro!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: favoritos.length,
      itemBuilder: (_, i) => _cardLivro(favoritos[i]),
    );
  }

  Widget _estatistica(String label, String valor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(valor,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _cardAvaliacaoResumo(Avaliacao a) {
    final livro =
        Dados.livros.where((l) => l.id == a.livroId).firstOrNull;
    if (livro == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _abrirDetalhe(livro),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _capa(livro, width: 40, height: 56, fontSize: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      livro.titulo,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Estrelas(valor: a.nota, tamanho: 14),
                    if (a.comentario.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        a.comentario,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardLivroComExcluir(Livro livro) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _capa(livro, width: 40, height: 56, fontSize: 20),
        title: Text(
          livro.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(livro.autor),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _confirmarExclusao(livro),
        ),
        onTap: () => _abrirDetalhe(livro),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja encerrar a sessão?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  void _confirmarExclusao(Livro livro) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir livro'),
        content: Text(
          'Deseja excluir "${livro.titulo}"? Todas as avaliações também serão removidas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Dados.deletarLivro(livro.id);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  Widget _telaPerfil() {
    final meus = Dados.livrosDoCriador(widget.emailUsuario);
    final minhas = Dados.avaliacoesDoUsuario(widget.emailUsuario);
    final totalFavs =
        Dados.favoritosDeUsuario(widget.emailUsuario).length;
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: cs.primary,
                  child: Text(
                    widget.nomeUsuario[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.nomeUsuario,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.emailUsuario,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _estatistica('Livros', meus.length.toString()),
                    Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.shade200),
                    _estatistica(
                        'Avaliações', minhas.length.toString()),
                    Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.shade200),
                    _estatistica('Favoritos', totalFavs.toString()),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (meus.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            'Meus livros',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...meus.map((l) => _cardLivroComExcluir(l)),
        ],
        if (minhas.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text(
            'Minhas avaliações',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...minhas.map((a) => _cardAvaliacaoResumo(a)),
        ],
        if (meus.isEmpty && minhas.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Adicione livros e avaliações\npara que apareçam aqui.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const titulos = ['Início', 'Favoritos', 'Perfil'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.primaryContainer,
        title: Text(titulos[_tabIndex]),
        actions: [
          if (_tabIndex == 0)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Novo livro',
              onPressed: _abrirCriarLivro,
            ),
          if (_tabIndex == 2)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Sair',
              onPressed: _logout,
            ),
        ],
      ),
      body: switch (_tabIndex) {
        0 => _telaInicio(),
        1 => _telaFavoritos(),
        _ => _telaPerfil(),
      },
      floatingActionButton: _tabIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _abrirCriarLivro,
              icon: const Icon(Icons.add),
              label: const Text('Novo livro'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) {
          setState(() {
            if (i != 0) {
              _buscaController.clear();
              _busca = '';
            }
            _tabIndex = i;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
