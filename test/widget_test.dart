import 'package:flutter_test/flutter_test.dart';
import 'package:biblioteca_app/main.dart';

void main() {
  testWidgets('Tela de login é exibida ao iniciar', (WidgetTester tester) async {
    await tester.pumpWidget(const BibliotecaApp());

    expect(find.text('Biblioteca'), findsWidgets);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Criar conta'), findsOneWidget);
  });
}
