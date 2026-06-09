import 'dart:io';
import 'package:flutter/material.dart';
import '../models/livro.dart';

class CapaLivro extends StatelessWidget {
  final Livro livro;
  final double width;
  final double height;
  final double fontSize;

  const CapaLivro({
    super.key,
    required this.livro,
    this.width = 56,
    this.height = 80,
    this.fontSize = 26,
  });

  @override
  Widget build(BuildContext context) {
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: livro.imagePath != null
            ? Image.file(
                File(livro.imagePath!),
                width: width,
                height: height,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _letra(),
              )
            : _letra(),
      ),
    );
  }

  Widget _letra() {
    return Center(
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
}
