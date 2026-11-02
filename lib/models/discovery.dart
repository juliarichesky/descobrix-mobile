class Discovery {
  const Discovery({
    required this.id,
    required this.name,
    required this.category,
    required this.rarity,
    required this.description,
    required this.xp,
    required this.illustrationAsset,
    this.additionalInformation = '',
  });

  final String id;
  final String name;
  final String category;
  final String rarity;
  final String description;
  final int xp;
  final String illustrationAsset;
  final String additionalInformation;

  static const supportedCategories = <String>[
    'Medicina Nuclear',
    'Agricultura',
    'Energia',
    'Indústria',
    'Tecnologia',
  ];

  static const supportedRarities = <String>[
    'Comum',
    'Incomum',
    'Raro',
    'Lendário',
  ];

  static const notebook = Discovery(
    id: 'notebook-demo',
    name: 'Notebook',
    category: 'Tecnologia',
    rarity: 'Incomum',
    description: 'Os notebooks utilizam componentes semicondutores que podem ser fabricados com técnicas que envolvem tecnologia nuclear.',
    xp: 120,
    illustrationAsset: 'mock_notebook',
    additionalInformation: 'Semicondutores são materiais fundamentais para processadores e memórias. A fabricação desses componentes envolve processos tecnológicos de alta precisão e controle de materiais.',
  );
}

class DiscoverySession {
  DiscoverySession._();

  static final Set<String> _addedIds = <String>{};

  static bool contains(String id) => _addedIds.contains(id);

  static bool add(String id) => _addedIds.add(id);
}
