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
    name: 'Detector de fumaÃ§a',
    category: 'Tecnologia',
    rarity: 'Comum',
    description: 'Dispositivo que identifica partÃ­culas de fumaÃ§a e ajuda a alertar sobre possÃ­veis incÃªndios.',
    xp: 60,
    illustrationAsset: 'smoke_detector',
  );

  static const ledLamp = Discovery(
    id: 'led-lamp',
    name: 'LÃ¢mpada LED',
    category: 'Energia',
    rarity: 'Comum',
    description: 'LÃ¢mpadas LED transformam energia elÃ©trica em luz com baixo consumo de energia.',
    xp: 60,
    illustrationAsset: 'led_lamp',
  );

  static const ctScanner = Discovery(
    id: 'ct-scanner',
    name: 'TomÃ³grafo',
    category: 'SaÃºde',
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
        'PainÃ©is solares convertem a luz do Sol em energia elÃ©trica.',
    xp: 120,
    illustrationAsset: 'solar_panel',
  );

  static const nuclearGenerator = Discovery(
    id: 'nuclear-generator',
    name: 'Gerador nuclear',
    category: 'Energia',
    rarity: 'LendÃ¡rio',
    description: 'Geradores nucleares produzem energia a partir de reaÃ§Ãµes controladas no nÃºcleo atÃ´mico.',
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
