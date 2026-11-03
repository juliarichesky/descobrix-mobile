import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:descobrix/main.dart';

void main() {
  testWidgets('Splash screen renders smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
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
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Criar conta'));
    await tester.pumpAndSettle();

    expect(find.text('Crie sua conta'), findsOneWidget);

    await tester.ensureVisible(find.text('Criar minha conta'));
    await tester.tap(find.text('Criar minha conta'));
    await tester.pumpAndSettle();
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
    await tester.ensureVisible(find.text('Criar minha conta'));
    await tester.tap(find.text('Criar minha conta'));
    await tester.pumpAndSettle();

    expect(find.text('Conta criada com sucesso!'), findsOneWidget);

    await tester.tap(find.byTooltip('Voltar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('login-email-field')),
      'rhayssa@descobrix.com',
    );
    await tester.enterText(
      find.byKey(const Key('login-password-field')),
      'Descobrix@123',
    );
    await tester.ensureVisible(find.text('Entrar'));
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Olá, Rhayssa!'), findsOneWidget);
    expect(find.text('Missão diária'), findsOneWidget);
  });
}
