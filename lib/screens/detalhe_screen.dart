import 'package:flutter/material.dart';
import '../data/dados.dart';
import '../models/avaliacao.dart';
import '../models/livro.dart';
import '../widgets/capa_livro.dart';
import '../widgets/estrelas.dart';
import '../widgets/estrelas_input.dart';

class DetalheScreen extends StatefulWidget {
  final Livro livro;
  final String emailUsuario;
  final String nomeUsuario;

  const DetalheScreen({
    super.key,
    required this.livro,
    required this.emailUsuario,
    required this.nomeUsuario,
  });

  @override
  State<DetalheScreen> createState() => _DetalheScreenState();
}

class _DetalheScreenState extends State<DetalheScreen> {
  double _nota = 0;
  final _comentarioController = TextEditingController();
  bool _mostrarFormulario = false;

  @override
  void initState() {
    super.initState();
    final existente =
        Dados.avaliacaoDoUsuario(widget.emailUsuario, widget.livro.id);
    if (existente != null) {
      _nota = existente.nota;
      _comentarioController.text = existente.comentario;
    }
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  bool get _favorito => Dados.isFavorito(widget.emailUsuario, widget.livro.id);
  bool get _jaAvaliou =>
      Dados.avaliacaoDoUsuario(widget.emailUsuario, widget.livro.id) != null;

  void _toggleFavorito() {
    Dados.toggleFavorito(widget.emailUsuario, widget.livro.id);
    setState(() {});
  }

  void _salvarAvaliacao() {
    if (_nota == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione pelo menos meia estrela.')),
      );
      return;
    }

    Dados.salvarAvaliacao(Avaliacao(
      livroId: widget.livro.id,
      emailUsuario: widget.emailUsuario,
      nomeUsuario: widget.nomeUsuario,
      nota: _nota,
      comentario: _comentarioController.text.trim(),
      data: DateTime.now(),
    ));

    setState(() => _mostrarFormulario = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Avaliação salva!')),
    );
  }

  void _confirmarExclusaoAvaliacao() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir avaliação'),
        content: const Text('Deseja excluir sua avaliação? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Dados.deletarAvaliacao(widget.emailUsuario, widget.livro.id);
              Navigator.pop(context);
              setState(() {
                _nota = 0;
                _comentarioController.clear();
                _mostrarFormulario = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Avaliação excluída.')),
              );
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  String _formatarData(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

  Widget _formularioAvaliacao() {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.surfaceContainerHighest,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _jaAvaliou ? 'Editar avaliação' : 'Escrever avaliação',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text('Nota'),
            const SizedBox(height: 8),
            EstrelasInput(
              valor: _nota,
              onChanged: (v) => setState(() => _nota = v),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _comentarioController,
              decoration: const InputDecoration(
                labelText: 'Comentário (opcional)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => setState(() => _mostrarFormulario = false),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Salvar'),
                  onPressed: _salvarAvaliacao,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardAvaliacao(Avaliacao a, {bool minha = false}) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: minha ? cs.primaryContainer : null,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: cs.primary,
                  child: Text(
                    a.nomeUsuario[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            a.nomeUsuario,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (minha) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: cs.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Você',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        _formatarData(a.data),
                        style: const TextStyle(
                            fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Estrelas(valor: a.nota, tamanho: 15),
              ],
            ),
            if (a.comentario.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(a.comentario, style: const TextStyle(height: 1.4)),
            ],
            if (minha && !_mostrarFormulario) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: const Text('Excluir'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: _confirmarExclusaoAvaliacao,
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Editar'),
                    onPressed: () => setState(() => _mostrarFormulario = true),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final livro = widget.livro;
    final cs = Theme.of(context).colorScheme;
    final media = Dados.mediaNotas(livro.id);
    final total = Dados.totalAvaliacoes(livro.id);
    final minhaAvaliacao =
        Dados.avaliacaoDoUsuario(widget.emailUsuario, livro.id);
    final outrasAvaliacoes = Dados.avaliacoesDeLivro(livro.id)
        .where((a) => a.emailUsuario != widget.emailUsuario)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.primaryContainer,
        title: const Text('Detalhes'),
        actions: [
          IconButton(
            icon: Icon(
              _favorito ? Icons.favorite : Icons.favorite_border,
              color: _favorito ? Colors.red : null,
            ),
            tooltip: _favorito
                ? 'Remover dos favoritos'
                : 'Adicionar aos favoritos',
            onPressed: _toggleFavorito,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CapaLivro(
                livro: livro,
                width: 110,
                height: 155,
                fontSize: 56,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              livro.titulo,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              livro.autor,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: cs.primary),
            ),
            const SizedBox(height: 10),
            Chip(
              label: Text(livro.genero),
              backgroundColor: cs.secondaryContainer,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Estrelas(valor: media, tamanho: 22),
                const SizedBox(width: 8),
                Text(
                  total > 0
                      ? '${media.toStringAsFixed(1)} · $total '
                          '${total == 1 ? 'avaliação' : 'avaliações'}'
                      : 'Sem avaliações',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            if (livro.descricao.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Descrição',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(livro.descricao, style: const TextStyle(height: 1.6)),
            ],
            const SizedBox(height: 10),
            Text(
              'Adicionado por ${livro.nomeCriador}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Avaliações',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (minhaAvaliacao != null)
              _cardAvaliacao(minhaAvaliacao, minha: true),
            if (_mostrarFormulario) _formularioAvaliacao(),
            if (!_jaAvaliou && !_mostrarFormulario) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.star_outline),
                  label: const Text('Escrever avaliação'),
                  onPressed: () => setState(() => _mostrarFormulario = true),
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (outrasAvaliacoes.isEmpty &&
                minhaAvaliacao == null &&
                !_mostrarFormulario)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'Seja o primeiro a avaliar este livro!',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ),
              ),
            ...outrasAvaliacoes.map((a) => _cardAvaliacao(a)),
          ],
        ),
      ),
    );
  }
}
