<div align="center">
  
# Descobrix
  
### Explore o cotidiano. Descubra a ciência. Evolua seu conhecimento.

**Um universo de descobertas na palma da sua mão!** 🔬

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![Status](https://img.shields.io/badge/Status-Sprint%201-9CCFE8?style=for-the-badge)

**Challenge FIAP 2026 | CTMSP - Centro Tecnológico da Marinha em São Paulo**

### [Acesso ao repositório](https://github.com/juliarichesky/descobrix-mobile)

</div>

---

## 💙 Sobre o projeto

O **Descobrix** é um aplicativo mobile educativo que transforma objetos do cotidiano em oportunidades de aprendizado.

Por meio de uma experiência inspirada em jogos de exploração e coleção, o usuário descobre informações científicas, acompanha sua evolução e participa de desafios educativos.

O projeto busca aproximar a população do conhecimento sobre a tecnologia nuclear e suas aplicações em diferentes áreas, como saúde, indústria, energia e pesquisa.

Desenvolvido para o **Challenge FIAP/CTMSP 2026**, o aplicativo tem como proposta tornar a ciência mais acessível, interativa e interessante para diferentes públicos.

> **Sprint 1:** desenvolvimento de um protótipo funcional em Flutter e Dart, com foco em interface, navegação, formulários, gerenciamento de estado e interações demonstrativas.

---

## 🎯 Nosso objetivo

Demonstrar que a ciência está mais próxima do nosso cotidiano do que imaginamos.

Com o Descobrix, queremos:

- 🔎 Incentivar a curiosidade e a exploração.
- 🧠 Apresentar conhecimentos científicos de forma simples.
- 🎮 Transformar o aprendizado em uma experiência divertida.
- 🏆 Estimular a participação por meio de desafios e conquistas.
- 🚢 Valorizar a evolução do jogador com um sistema de recompensas.

---

## 📱 Funcionalidades

O protótipo da Sprint 1 apresenta as seguintes funcionalidades:

| Funcionalidade | Descrição |
|---|---|
| 🔐 Cadastro e Login | Cadastro com validações e acesso demonstrativo local. |
| 🏠 Home | Painel com informações do jogador, nível e progresso. |
| 📷 Scanner | Acesso à câmera do dispositivo para exploração demonstrativa. |
| 🔬 Descobertas | Exibição de informações educativas sobre objetos do cotidiano. |
| 📚 Minha Coleção | Registro dos objetos descobertos, com armazenamento local. |
| ⭐ XP e Níveis | Sistema de experiência e evolução do jogador. |
| 📖 Detalhes dos Objetos | Conteúdos educativos e curiosidades científicas. |
| ⚔️ Duelos | Perguntas educativas em partidas demonstrativas. |
| 👥 Amigos e Convites | Interface de desafios entre amigos com dados simulados. |
| 🏆 Ranking | Classificação demonstrativa de jogadores. |
| 🚢 Meu Submarino | Sistema visual de peças e recompensas demonstrativas. |
| 👤 Perfil | Informações do usuário, progresso e opção de logout. |

### 🔍 Exploração e descobertas

O jogador utiliza a câmera do dispositivo para explorar objetos.

Nesta Sprint, o reconhecimento é **simulado**, utilizando o Notebook como exemplo de descoberta educativa.

Após a descoberta, o usuário pode consultar informações científicas e adicionar o objeto à coleção.

### ⭐ Evolução do jogador

O Descobrix conta com um sistema local de progresso:

- Experiência (XP) por novas descobertas.
- Evolução de níveis.
- Registro dos objetos descobertos.
- Persistência dos dados no dispositivo.
- Visualização do progresso na Home e no Perfil.

### ⚔️ Desafios educativos

Os duelos apresentam perguntas relacionadas aos conteúdos científicos do aplicativo.

Nesta versão, os adversários, convites e rankings são demonstrativos, sem comunicação online entre usuários.

---

## 🛠️ Tecnologias utilizadas

| Tecnologia | Utilização |
|---|---|
| **Flutter** | Desenvolvimento da interface mobile. |
| **Dart** | Linguagem de programação. |
| **Material Design** | Componentes visuais e interações. |
| **shared_preferences** | Armazenamento local de informações demonstrativas. |
| **camera** | Acesso à câmera do dispositivo. |
| **flutter_test** | Testes automatizados do aplicativo. |
| **Android Emulator** | Execução e demonstração do protótipo. |

---

## 🚀 Como executar o projeto

### Pré-requisitos

Antes de começar, tenha instalado:

- Flutter SDK configurado.
- Dart SDK (incluído no Flutter).
- Android Studio ou ambiente compatível.
- Emulador Android ou dispositivo físico com depuração USB habilitada.

### 1. Obtenha o projeto

Clone o repositório pelo GitHub ou faça o download dos arquivos.

### 2. Instale as dependências

Na pasta raiz do projeto, execute:

```bash
flutter pub get
```

### 3. Execute o aplicativo

Com o emulador Android iniciado:

```bash
flutter run
```

Para visualizar os dispositivos disponíveis:

```bash
flutter devices
```

### 4. Execute as verificações

Análise estática:

```bash
flutter analyze
```

Testes automatizados:

```bash
flutter test
```

**Observação:** a análise estática pode apresentar avisos informativos e de APIs depreciadas que não impedem a execução do protótipo.

---

## 🔑 Acesso demonstrativo

A Sprint 1 utiliza autenticação local simulada, sem integração com um servidor.

Para acessar:

1. Abra o aplicativo.
2. Selecione a opção de cadastro.
3. Preencha nome, e-mail e os campos solicitados.
4. Após o cadastro, utilize o e-mail informado.
5. Entre com a senha demonstrativa:

**Senha de demonstração:** `Descobrix@123`

> ⚠️ A autenticação é exclusiva do protótipo acadêmico. A senha fixa não representa um mecanismo seguro de autenticação e deverá ser substituída antes de qualquer distribuição pública. A senha informada no cadastro não é persistida localmente.

---

## 🧪 Testes e validação

Durante o desenvolvimento, foram considerados cenários como:

- Cadastro com campos inválidos.
- Navegação entre telas.
- Permissões da câmera.
- Persistência local da coleção.
- Atualização do XP e dos níveis.
- Logout e retorno à tela inicial.
- Interações com duelos, ranking e submarino.

O projeto utiliza `flutter_test` para verificações automatizadas e emulador Android para demonstração das funcionalidades.

---

## 🎬 Vídeo de apresentação

Confira a demonstração do Descobrix, apresentando as principais telas, navegação e funcionalidades da Sprint 1.

### ▶️ [Assistir à apresentação no YouTube](https://youtu.be/ggHNNN1JjUU)

O vídeo apresenta o aplicativo em execução no ambiente Android.

---

## 👩‍💻 Equipe de desenvolvimento

| Integrante | RM |
|---|---|
| Julia Valerio Guimarães da Silva | 568275 |
| Ruan Lima da Silva | 566719 |
| Rhayssa Graziano Bernardes e Rocha Ferreira | 567549 |

---

## 🔮 Próximas etapas

O Descobrix continuará evoluindo nas próximas Sprints.

Entre as funcionalidades planejadas estão:

- Reconhecimento de objetos com inteligência artificial.
- Integração com banco de dados.
- Autenticação real de usuários.
- Duelos online entre amigos.
- Sistema de convites e partidas.
- Ranking com pontuações reais.
- Sincronização de coleções e progresso.
- Evolução do sistema de recompensas do submarino.
- Ampliação do catálogo de descobertas.

Esses recursos fazem parte do planejamento futuro e **não estão implementados integralmente na Sprint 1**.

---

<div align="center">

### Descobrix

**Cada descoberta é uma nova forma de enxergar o mundo.**

*Desenvolvido com 💙 para o Challenge FIAP/CTMSP 2026.*

</div>
