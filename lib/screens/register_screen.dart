import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso!')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Voltar',
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 36,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 66,
                        child: CustomPaint(painter: _RegisterAtomPainter()),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Crie sua conta',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineLarge?.copyWith(
                          fontSize: 28,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sua jornada de descobertas começa aqui!',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _RegisterField(
                        fieldKey: const Key('register-name-field'),
                        controller: _nameController,
                        label: 'Nome de usuário',
                        hint: 'Como podemos chamar você?',
                        icon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                        validator: (value) => _required(value, 'nome'),
                      ),
                      const SizedBox(height: 14),
                      _RegisterField(
                        fieldKey: const Key('register-email-field'),
                        controller: _emailController,
                        label: 'E-mail',
                        hint: 'seuemail@exemplo.com',
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _emailValidator,
                      ),
                      const SizedBox(height: 14),
                      _RegisterField(
                        fieldKey: const Key('register-password-field'),
                        controller: _passwordController,
                        label: 'Senha',
                        hint: 'Mínimo de 6 caracteres',
                        icon: Icons.lock_outline_rounded,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        validator: _passwordValidator,
                      ),
                      const SizedBox(height: 14),
                      _RegisterField(
                        fieldKey: const Key('register-confirmation-field'),
                        controller: _confirmationController,
                        label: 'Confirmar senha',
                        hint: 'Digite sua senha novamente',
                        icon: Icons.verified_user_outlined,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirme sua senha';
                          }
                          if (value != _passwordController.text) {
                            return 'As senhas não coincidem';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 26),
                      AppButton(label: 'Criar minha conta', onPressed: _submit),
                      const SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.navy,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textMuted,
                              ),
                              children: [
                                const TextSpan(text: 'Já tem uma conta? '),
                                TextSpan(
                                  text: 'Entrar',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.pink,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String? _required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu $fieldName';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Informe seu e-mail';
    final emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailPattern.hasMatch(value.trim())) return 'Informe um e-mail válido';
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Informe uma senha';
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }
}

class _RegisterField extends StatelessWidget {
  const _RegisterField({
    this.fieldKey,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.onFieldSubmitted,
  });

  final Key? fieldKey;
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final FormFieldValidator<String> validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      style: const TextStyle(
        color: AppColors.navy,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 21),
        filled: true,
        fillColor: AppColors.surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.blue, width: 1.5),
        errorBorder: _border(AppColors.pink, width: 1.2),
        focusedErrorBorder: _border(AppColors.pink, width: 1.5),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _RegisterAtomPainter extends CustomPainter {
  const _RegisterAtomPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.1
      ..strokeCap = StrokeCap.round;

    for (final orbit in [
      (angle: -0.56, color: AppColors.pink),
      (angle: 0.56, color: AppColors.blue),
      (angle: math.pi / 2, color: AppColors.navySoft),
    ]) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(orbit.angle);
      paint.color = orbit.color;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: size.width * 0.78,
          height: size.height * 0.42,
        ),
        paint,
      );
      canvas.restore();
    }

    canvas.drawCircle(center, 4.5, Paint()..color = AppColors.pink);
  }

  @override
  bool shouldRepaint(covariant _RegisterAtomPainter oldDelegate) => false;
}
