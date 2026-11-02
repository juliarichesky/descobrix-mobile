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

  static const smokeDetector = Discovery(
    id: 'smoke-detector',
    name: 'Detector de fuma\u00E7a',
    category: 'Tecnologia',
    rarity: 'Comum',
    description: 'Dispositivo que identifica part\u00EDculas de fuma\u00E7a e ajuda a alertar sobre poss\u00EDveis inc\u00EAndios.',
    xp: 60,
    illustrationAsset: 'smoke_detector',
  );

  static const ledLamp = Discovery(
    id: 'led-lamp',
    name: 'L\u00E2mpada LED',
    category: 'Energia',
    rarity: 'Comum',
    description: 'L\u00E2mpadas LED transformam energia el\u00E9trica em luz com baixo consumo de energia.',
    xp: 60,
    illustrationAsset: 'led_lamp',
  );

  static const ctScanner = Discovery(
    id: 'ct-scanner',
    name: 'Tom\u00F3grafo',
    category: 'Sa\u00FAde',
    rarity: 'Raro',
    description: 'Equipamento que utiliza raios X para criar imagens detalhadas do interior do corpo.',
    xp: 160,
    illustrationAsset: 'ct_scanner',
  );

  static const solarPanel = Discovery(
    id: 'solar-panel',
    name: 'Painel solar',
    category: 'Energia',
    rarity: 'Incomum',
    description:
        'Pain\u00E9is solares convertem a luz do Sol em energia el\u00E9trica.',
    xp: 120,
    illustrationAsset: 'solar_panel',
  );

  static const nuclearGenerator = Discovery(
    id: 'nuclear-generator',
    name: 'Gerador nuclear',
    category: 'Energia',
    rarity: 'Lend\u00E1rio',
    description: 'Geradores nucleares produzem energia a partir de rea\u00E7\u00F5es controladas no n\u00FAcleo at\u00F4mico.',
    xp: 240,
    illustrationAsset: 'nuclear_generator',
  );

  static const catalog = <Discovery>[
    notebook,
    smokeDetector,
    ledLamp,
    ctScanner,
    solarPanel,
    nuclearGenerator,
  ];
}

class DiscoverySession {
  DiscoverySession._();

  static final Set<String> _addedIds = <String>{};

  static bool contains(String id) => _addedIds.contains(id);

  static bool add(String id) => _addedIds.add(id);
}
