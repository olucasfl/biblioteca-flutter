import 'package:flutter/material.dart';

class Estrelas extends StatelessWidget {
  final double valor;
  final double tamanho;

  const Estrelas({
    super.key,
    required this.valor,
    this.tamanho = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final IconData icone;
        if (valor >= i + 1) {
          icone = Icons.star;
        } else if (valor >= i + 0.5) {
          icone = Icons.star_half;
        } else {
          icone = Icons.star_border;
        }
        return Icon(icone, color: Colors.amber, size: tamanho);
      }),
    );
  }
}
