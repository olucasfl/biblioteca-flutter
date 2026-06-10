import 'package:flutter/material.dart';
import '../data/dados.dart';
import '../models/livro.dart';

class CriarLivroScreen extends StatefulWidget {
  final String emailUsuario;
  final String nomeUsuario;

  const CriarLivroScreen({
    super.key,
    required this.emailUsuario,
    required this.nomeUsuario,
  });

  @override
  State<CriarLivroScreen> createState() => _CriarLivroScreenState();
}

class _CriarLivroScreenState extends State<CriarLivroScreen> {
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _generoController = TextEditingController();
  String _generoSelecionado = '';
  String _erro = '';

  static const _generos = [
    'Aventura',
    'Biografia',
    'Drama',
    'Distopia',
    'Fábula',
    'Fantasia',
    'Ficção Científica',
    'Mistério',
    'Realismo Mágico',
    'Romance',
    'Sátira',
    'Terror',
  ];

  @override
  void initState() {
    super.initState();
    _tituloController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _descricaoController.dispose();
    _generoController.dispose();
    super.dispose();
  }

  void _salvar() {
    final titulo = _tituloController.text.trim();
    final autor = _autorController.text.trim();
    final descricao = _descricaoController.text.trim();

    if (titulo.isEmpty || autor.isEmpty || _generoSelecionado.isEmpty) {
      setState(() => _erro = 'Preencha título, autor e gênero.');
      return;
    }

    Dados.livros.add(Livro(
      id: Dados.novoId(),
      titulo: titulo,
      autor: autor,
      genero: _generoSelecionado,
      descricao: descricao,
      corCapa: Dados.gerarCorCapa(titulo),
      emailCriador: widget.emailUsuario,
      nomeCriador: widget.nomeUsuario,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Livro adicionado com sucesso!')),
    );

    Navigator.pop(context);
  }

  Widget _previewCapa() {
    final titulo = _tituloController.text.trim();
    final cor = titulo.isNotEmpty ? Dados.gerarCorCapa(titulo) : 0xFFBDBDBD;
    final letra = titulo.isNotEmpty ? titulo[0].toUpperCase() : '?';

    return Container(
      width: 100,
      height: 140,
      decoration: BoxDecoration(
        color: Color(cor),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(3, 3)),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        letra,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 52,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo livro'),
        backgroundColor: cs.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _previewCapa()),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Prévia da capa',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _autorController,
              decoration: const InputDecoration(
                labelText: 'Autor *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) => DropdownMenu<String>(
                controller: _generoController,
                width: constraints.maxWidth,
                label: const Text('Gênero *'),
                leadingIcon: const Icon(Icons.category_outlined),
                enableFilter: false,
                requestFocusOnTap: false,
                dropdownMenuEntries: _generos
                    .map((g) => DropdownMenuEntry(value: g, label: g))
                    .toList(),
                onSelected: (v) =>
                    setState(() => _generoSelecionado = v ?? ''),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição (opcional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            if (_erro.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(_erro, style: TextStyle(color: cs.error)),
            ],
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.check),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child:
                      Text('Adicionar livro', style: TextStyle(fontSize: 16)),
                ),
                onPressed: _salvar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
