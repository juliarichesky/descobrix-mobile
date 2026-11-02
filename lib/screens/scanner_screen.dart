import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

import '../theme/app_colors.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  static const _settingsChannel = MethodChannel('descobrix/settings');

  CameraController? _controller;
  bool _cameraReady = false;
  bool _initializing = true;
  bool _permissionDenied = false;
  bool _permissionPermanentlyDenied = false;
  bool _flashEnabled = false;
  String? _cameraMessage;
  bool _cameraAttempted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (_cameraAttempted || _permissionDenied || _permissionPermanentlyDenied) {
      return;
    }
    _cameraAttempted = true;

    if (mounted) {
      setState(() {
        _initializing = true;
        _cameraMessage = null;
      });
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _setCameraUnavailable(
          'Nenhuma câmera foi encontrada neste dispositivo.',
        );
        return;
      }

      final camera = cameras.firstWhere(
        (description) => description.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );
      _controller = controller;
      await controller.initialize();

      if (!mounted) return;
      setState(() {
        _cameraReady = true;
        _initializing = false;
      });
    } on CameraException catch (error) {
      await _controller?.dispose();
      _controller = null;
      if (!mounted) return;

      final code = error.code.toLowerCase();
      final permanentlyDenied = code.contains('withoutprompt');
      setState(() {
        _cameraReady = false;
        _initializing = false;
        _permissionDenied = code.contains('accessdenied') && !permanentlyDenied;
        _permissionPermanentlyDenied = permanentlyDenied;
        _cameraMessage = permanentlyDenied
            ? 'O acesso à câmera está bloqueado nas configurações.'
            : _permissionDenied
            ? 'A permissão da câmera foi negada.'
            : 'A câmera não está disponível neste momento.';
      });
    } catch (_) {
      _setCameraUnavailable('Não foi possível iniciar a câmera.');
    }
  }

  void _setCameraUnavailable(String message) {
    if (!mounted) return;
    setState(() {
      _cameraReady = false;
      _initializing = false;
      _cameraMessage = message;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller?.dispose();
      _controller = null;
      _cameraAttempted = false;
      if (mounted) setState(() => _cameraReady = false);
    } else if (state == AppLifecycleState.resumed &&
        !_cameraAttempted &&
        !_permissionDenied &&
        !_permissionPermanentlyDenied) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (!_cameraReady ||
        controller == null ||
        controller.value.isTakingPicture) {
      _showMessage(_cameraMessage ?? 'A câmera ainda não está pronta.');
      return;
    }

    try {
      await controller.takePicture();
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Imagem capturada'),
          content: const Text(
            'O reconhecimento educativo será simulado nesta etapa.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendi'),
            ),
          ],
        ),
      );
    } on CameraException {
      _showMessage('Não foi possível capturar a imagem.');
    }
  }

  Future<void> _toggleFlash() async {
    final controller = _controller;
    if (!_cameraReady || controller == null) {
      _showMessage('O flash não está disponível sem uma câmera ativa.');
      return;
    }

    try {
      final enabled = !_flashEnabled;
      await controller.setFlashMode(enabled ? FlashMode.torch : FlashMode.off);
      if (mounted) setState(() => _flashEnabled = enabled);
    } on CameraException {
      _showMessage('Este dispositivo não oferece suporte ao flash.');
    }
  }

  Future<void> _openSettings() async {
    try {
      await _settingsChannel.invokeMethod<void>('openAppSettings');
    } catch (_) {
      _showMessage('Abra as configurações do app e permita o acesso à câmera.');
    }
  }

  void _showHelp() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Como usar o scanner'),
        content: const Text(
          'Aponte a câmera para um objeto educativo e mantenha-o dentro da moldura.\n\n'
          'Nesta etapa, a identificação será apenas simulada e nenhuma imagem será enviada a servidores.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _CameraView(
            controller: _controller,
            cameraReady: _cameraReady,
            initializing: _initializing,
            message: _cameraMessage,
            permanentlyDenied: _permissionPermanentlyDenied,
            permissionDenied: _permissionDenied,
            onOpenSettings: _openSettings,
          ),
          SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: 18,
                  left: 16,
                  child: _CircleControl(
                    icon: Icons.arrow_back_rounded,
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Voltar',
                  ),
                ),
                Positioned(
                  top: 18,
                  right: 16,
                  child: _CircleControl(
                    icon: _flashEnabled
                        ? Icons.flash_on_rounded
                        : Icons.flash_auto_rounded,
                    onPressed: _toggleFlash,
                    tooltip: 'Flash',
                  ),
                ),
                const Positioned(
                  top: 68,
                  left: 56,
                  right: 56,
                  child: _InstructionCard(),
                ),
                Center(
                  child: SizedBox(
                    width: 270,
                    height: 330,
                    child: CustomPaint(painter: _ScannerFramePainter()),
                  ),
                ),
                Positioned(
                  left: 28,
                  bottom: 30,
                  child: _CircleControl(
                    icon: Icons.photo_library_outlined,
                    onPressed: () => _showMessage('Galeria em desenvolvimento'),
                    tooltip: 'Galeria',
                    size: 42,
                  ),
                ),
                Positioned(
                  right: 28,
                  bottom: 30,
                  child: _CircleControl(
                    icon: Icons.help_outline_rounded,
                    onPressed: _showHelp,
                    tooltip: 'Ajuda',
                    size: 42,
                  ),
                ),
                Positioned(
                  bottom: 14,
                  left: 0,
                  right: 0,
                  child: Center(child: _CaptureButton(onPressed: _capture)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraView extends StatelessWidget {
  const _CameraView({
    required this.controller,
    required this.cameraReady,
    required this.initializing,
    required this.message,
    required this.permanentlyDenied,
    required this.permissionDenied,
    required this.onOpenSettings,
  });

  final CameraController? controller;
  final bool cameraReady;
  final bool initializing;
  final String? message;
  final bool permanentlyDenied;
  final bool permissionDenied;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    if (cameraReady && controller != null) {
      final previewSize = controller!.value.previewSize;
      return ColoredBox(
        color: Colors.black,
        child: Center(
          child: previewSize == null
              ? CameraPreview(controller!)
              : FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: previewSize.height,
                    height: previewSize.width,
                    child: CameraPreview(controller!),
                  ),
                ),
        ),
      );
    }

    return ColoredBox(
      color: const Color(0xFF151922),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 42),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                permissionDenied || permanentlyDenied
                    ? Icons.no_photography_outlined
                    : Icons.camera_alt_outlined,
                color: AppColors.surface,
                size: 52,
              ),
              const SizedBox(height: 18),
              Text(
                initializing
                    ? 'Preparando a câmera...'
                    : message ?? 'Câmera indisponível',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.surface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (permanentlyDenied) ...[
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: onOpenSettings,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.surface),
                  ),
                  child: const Text('Abrir configurações'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InstructionCard extends StatelessWidget {
  const _InstructionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xB52F3034),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x66FFFFFF)),
      ),
      child: const Text(
        'Aponte a câmera\npara um objeto',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.surface,
          fontSize: 13,
          height: 1.25,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _CircleControl extends StatelessWidget {
  const _CircleControl({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.size = 42,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Material(
        color: const Color(0x7A55565A),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, color: AppColors.surface, size: size * 0.53),
          ),
        ),
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  const _CaptureButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 58,
        height: 58,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(color: const Color(0xCC11151D), width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x44000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.navy, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _ScannerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    const length = 35.0;
    const radius = 18.0;
    final path = Path()
      ..moveTo(0, length)
      ..lineTo(0, radius)
      ..quadraticBezierTo(0, 0, radius, 0)
      ..lineTo(length, 0)
      ..moveTo(size.width - length, 0)
      ..lineTo(size.width - radius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, radius)
      ..lineTo(size.width, length)
      ..moveTo(size.width, size.height - length)
      ..lineTo(size.width, size.height - radius)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - radius,
        size.height,
      )
      ..lineTo(size.width - length, size.height)
      ..moveTo(length, size.height)
      ..lineTo(radius, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - radius)
      ..lineTo(0, size.height - length);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ScannerFramePainter oldDelegate) => false;
}
