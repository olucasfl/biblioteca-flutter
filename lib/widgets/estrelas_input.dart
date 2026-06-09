import 'package:flutter/material.dart';

class EstrelasInput extends StatelessWidget {
  final double valor;
  final ValueChanged<double> onChanged;
  final double tamanho;

  const EstrelasInput({
    super.key,
    required this.valor,
    required this.onChanged,
    this.tamanho = 42,
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

        return SizedBox(
          width: tamanho,
          height: tamanho,
          child: Stack(
            children: [
              Center(
                child: Icon(icone, color: Colors.amber, size: tamanho),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(i + 0.5),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged((i + 1).toDouble()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
