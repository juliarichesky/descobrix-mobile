# Descobrix

Aplicativo educacional desenvolvido em Flutter e Dart para o Challenge FIAP/CTMSP 2026, em parceria com o Centro Tecnológico da Marinha em São Paulo (CTMSP/Marinha).

O Descobrix apresenta, de forma interativa, aplicações da tecnologia nuclear no cotidiano. A Sprint 1 concentra-se na construção do protótipo mobile, na navegação entre telas, em formulários, persistência local e interações demonstrativas.

## Objetivo

Criar uma experiência educativa em formato de exploração e coleção, permitindo que o usuário descubra objetos, consulte informações científicas contextualizadas, acompanhe seu progresso e interaja com recursos demonstrativos de duelos e ranking.

## Integrantes

| Integrante | RM |
| --- | --- |
| Julia Valerio Guimarães da Silva | 568275 |

## Tecnologias utilizadas

- Flutter
- Dart
- Material Design e widgets nativos do Flutter
- `shared_preferences` para persistência local demonstrativa
- `camera` para acesso à câmera durante a exploração
- Testes com `flutter_test`

## Funcionalidades da Sprint 1

- Splash/Login e cadastro local.
- Validação de nome, e-mail, senha e confirmação de senha.
- Login demonstrativo sem backend.
- Home/Dashboard com progresso do jogador.
- Scanner com solicitação de permissão da câmera.
- Resultado de descoberta simulado usando o Notebook como exemplo.
- Coleção local de objetos descobertos.
- Persistência dos objetos e do XP no dispositivo.
- Detalhes educativos do Notebook.
- Tela demonstrativa de Meu Submarino.
- Duelos, amigos, duelos em andamento e duelo educativo demonstrativo.
- Ranking demonstrativo entre amigos e classificação global fictícia.
- Perfil do usuário, diálogos informativos e logout.

## Como instalar e executar

Requisitos:

- Flutter instalado e configurado.
- Android Studio ou outro ambiente com emulador Android.
- Um emulador Android ou aparelho físico com depuração habilitada.

Na raiz do projeto, execute:

```bash
flutter pub get
flutter run
```

Para verificar o código e executar os testes:

```bash
flutter analyze
flutter test
```

## Demonstração local

O login desta Sprint é exclusivamente local e demonstrativo. Depois de criar uma conta pelo aplicativo, utilize o e-mail cadastrado e a senha fixa abaixo:

```text
Senha demonstrativa: Descobrix@123
```

Essa senha não representa autenticação real, não deve ser usada por usuários reais e precisa ser substituída por um mecanismo seguro antes de qualquer distribuição pública. A senha do usuário não é salva em `SharedPreferences`; o armazenamento local mantém apenas dados públicos do perfil, como nome e e-mail.

O reconhecimento de objetos também é simulado nesta Sprint. Após uma captura, o aplicativo apresenta o Notebook como exemplo educativo, sem afirmar que houve reconhecimento real ou medição de radioatividade.

## Vídeo de apresentação

Link do vídeo no YouTube: **pendente de inserção**.

## Observações sobre o escopo

Os recursos de autenticação online, backend, multiplayer real, ranking online, reconhecimento por IA e banco de dados remoto não fazem parte da implementação demonstrativa da Sprint 1.

As funcionalidades locais e demonstrativas devem ser apresentadas como protótipo acadêmico, não como serviços online ou mecanismos de autenticação de produção.