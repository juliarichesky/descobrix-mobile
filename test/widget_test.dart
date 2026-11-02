// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:descobrix/main.dart';

void main() {
  testWidgets('Splash screen renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Descobrix'), findsOneWidget);
    expect(
      find.text('Explore. Descubra.\nColecione. Desafie.'),
      findsOneWidget,
    );
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Criar conta'), findsOneWidget);
  });

  testWidgets('Register validates and confirms account creation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Criar conta'));
    await tester.pumpAndSettle();

    expect(find.text('Crie sua conta'), findsOneWidget);

    await tester.tap(find.text('Criar minha conta'));
    await tester.pump();
    expect(find.text('Informe seu nome'), findsOneWidget);
    expect(find.text('Informe seu e-mail'), findsOneWidget);
    expect(find.text('Informe uma senha'), findsOneWidget);
    expect(find.text('Confirme sua senha'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('register-name-field')),
      'Rhayssa',
    );
    await tester.enterText(
      find.byKey(const Key('register-email-field')),
      'rhayssa@descobrix.com',
    );
    await tester.enterText(
      find.byKey(const Key('register-password-field')),
      'segredo123',
    );
    await tester.enterText(
      find.byKey(const Key('register-confirmation-field')),
      'segredo123',
    );
    await tester.tap(find.text('Criar minha conta'));
    await tester.pump();

    expect(find.text('Conta criada com sucesso!'), findsOneWidget);
  });
}
