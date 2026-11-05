import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'login_viewmodel.dart';
// Compatibility entry point; MaterialApp stays in main.dart.
class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) => const LoginScreen();
}

// ─── Constants ────────────────────────────────────────────────────────────────

class AppColors {
  static const tealDark = Color(0xFF0AADA8);
  static const tealMid = Color(0xFF1DBFB8);
  static const tealLight = Color(0xFF2ED8CE);
  static const tealBg = Color(0xFF8FD8D5);
  static const white = Color(0xFFFFFFFF);
  static const cardBg = Color(0xFFFFFFFF);
  static const inputBg = Color(0xFFF5F7FA);
  static const textDark = Color(0xFF1A1F36);
  static const textMedium = Color(0xFF6B7280);
  static const textLight = Color(0xFF9CA3AF);
  static const tealAccent = Color(0xFF0AADA8);
  static const dividerColor = Color(0xFFE5E7EB);
  static const checkboxBorder = Color(0xFFD1D5DB);
  static const appleDark = Color(0xFF1C1C1E);
  static const googleBorder = Color(0xFFE2E8F0);
  static const shadowColor = Color(0x1A000000);
  static const overlayWhite = Color(0x1AFFFFFF);
  static const overlayWhiteMed = Color(0x26FFFFFF);
}

class AppTextStyles {
  static const headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static const headingAccent = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.tealLight,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static const cardTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
    letterSpacing: -0.5,
  );

  static const bodyRegular = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textMedium,
    letterSpacing: 0.1,
  );

  static const linkStyle = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
    color: AppColors.tealAccent,
    letterSpacing: 0.1,
  );

  static const inputText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
    letterSpacing: 0.1,
  );

  static const hintText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  static const buttonText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    letterSpacing: 0.3,
  );

  static const dividerText = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
    letterSpacing: 0.5,
  );

  static const socialText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    letterSpacing: 0.1,
  );

  static const socialTextLight = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.1,
  );

  static const checkboxLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textMedium,
  );

  static const forgotPassword = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.tealAccent,
  );
}

// ─── Main Screen ──────────────────────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = true;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late final LoginViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = LoginViewModel(context.read<AuthService>());
  }

  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();
    final success = await _vm.signIn(
      _usernameController.text, _passwordController.text, _rememberMe,
    );
    if (!mounted || !success) return;
    _passwordController.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => ScanScreen()), (_) => false,
    );
  }

  @override
  void dispose() {
    _vm.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _vm,
    builder: (context, _) => Scaffold(
      backgroundColor: AppColors.tealDark,
      body: Stack(children: [
        const _GradientBackground(),
        const _BackgroundShapes(),
        SafeArea(child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 24, 24, 28),
                child: _HeroSection(),
              ),
              _LoginCard(
                rememberMe: _rememberMe,
                onRememberMeChanged: (value) => setState(() => _rememberMe = value ?? false),
                usernameController: _usernameController,
                passwordController: _passwordController,
                busy: _vm.busy,
                error: _vm.error,
                onSubmit: _signIn,
              ),
            ]),
          );
        })),
      ]),
    ),
  );
}

// ─── Gradient Background ──────────────────────────────────────────────────────

class _GradientBackground extends StatelessWidget {
  const _GradientBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF07B5AF),
            Color(0xFF0AADA8),
            Color(0xFF13C4BC),
            Color(0xFF7DD8D6),
          ],
          stops: [0.0, 0.3, 0.6, 1.0],
        ),
      ),
    );
  }
}

// ─── Background Shapes ────────────────────────────────────────────────────────

class _BackgroundShapes extends StatelessWidget {
  const _BackgroundShapes();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox.expand(
      child: Stack(
        children: [
          // Large gear bottom-left
          Positioned(
            left: -30,
            bottom: size.height * 0.38,
            child: Opacity(
              opacity: 0.15,
              child: _GearIcon(size: 110, color: AppColors.white),
            ),
          ),
          // Small gear offset
          Positioned(
            left: 60,
            bottom: size.height * 0.44,
            child: Opacity(
              opacity: 0.10,
              child: _GearIcon(size: 60, color: AppColors.white),
            ),
          ),
          // Circle top right
          Positioned(
            right: -40,
            top: -40,
            child: Opacity(
              opacity: 0.12,
              child: Container(
                width: 160,
                height: 160,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          // Small circle mid-right
          Positioned(
            right: 30,
            top: 80,
            child: Opacity(
              opacity: 0.10,
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          // Decorative ring
          Positioned(
            right: 20,
            bottom: size.height * 0.52,
            child: Opacity(
              opacity: 0.12,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 8),
                ),
              ),
            ),
          ),
          // Mockup phone frame hint
          Positioned(
            right: -18,
            top: size.height * 0.04,
            child: Opacity(
              opacity: 0.22,
              child: _PhoneMockupHint(),
            ),
          ),
        ],
      ),
    );
  }
}

class _GearIcon extends StatelessWidget {
  final double size;
  final Color color;
  const _GearIcon({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GearPainter(color: color),
    );
  }
}

class _GearPainter extends CustomPainter {
  final Color color;
  _GearPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width * 0.45;
    final innerRadius = size.width * 0.28;
    final toothCount = 8;
    final toothDepth = size.width * 0.10;

    final path = Path();
    for (int i = 0; i < toothCount; i++) {
      final angle1 = (2 * math.pi * i / toothCount) - math.pi / toothCount * 0.6;
      final angle2 = (2 * math.pi * i / toothCount) + math.pi / toothCount * 0.6;
      final angle3 = angle2 + math.pi / toothCount * 0.2;
      final angle4 = (2 * math.pi * (i + 1) / toothCount) - math.pi / toothCount * 0.8;

      if (i == 0) {
        path.moveTo(
          center.dx + (outerRadius + toothDepth) * math.cos(angle1),
          center.dy + (outerRadius + toothDepth) * math.sin(angle1),
        );
      }
      path.lineTo(
        center.dx + (outerRadius + toothDepth) * math.cos(angle2),
        center.dy + (outerRadius + toothDepth) * math.sin(angle2),
      );
      path.lineTo(
        center.dx + outerRadius * math.cos(angle3),
        center.dy + outerRadius * math.sin(angle3),
      );
      path.lineTo(
        center.dx + outerRadius * math.cos(angle4),
        center.dy + outerRadius * math.sin(angle4),
      );
      path.lineTo(
        center.dx + (outerRadius + toothDepth) * math.cos(angle4 + math.pi / toothCount * 0.2),
        center.dy + (outerRadius + toothDepth) * math.sin(angle4 + math.pi / toothCount * 0.2),
      );
    }
    path.close();
    canvas.drawPath(path, paint);

    // Center hole
    canvas.drawCircle(center, innerRadius, Paint()..color = AppColors.tealDark.withOpacity(0.3));
  }

  @override
  bool shouldRepaint(_GearPainter old) => false;
}

class _PhoneMockupHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 55,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 16),
          Icon(Icons.task_alt_rounded, color: Colors.white.withOpacity(0.5), size: 28),
        ],
      ),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App logo / brand mark
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.overlayWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.overlayWhiteMed, width: 1),
          ),
          child: const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.white,
            size: 22,
          ),
        ),
        const SizedBox(height: 22),
        // Heading with teal accent
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Welcome to\n',
                style: AppTextStyles.headingLarge,
              ),
              TextSpan(
                text: 'Garam ',
                style: AppTextStyles.headingAccent,
              ),
              TextSpan(
                text: 'Mug.',
                style: AppTextStyles.headingLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Login Card ───────────────────────────────────────────────────────────────

class _LoginCard extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool busy;
  final String? error;
  final VoidCallback onSubmit;
  const _LoginCard({required this.rememberMe, required this.onRememberMeChanged,
    required this.usernameController, required this.passwordController,
    required this.busy, required this.error, required this.onSubmit});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(24, 30, 24, 32),
    decoration: const BoxDecoration(color: AppColors.cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
    child: AutofillGroup(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Welcome back', style: AppTextStyles.cardTitle),
        const SizedBox(height: 6),
        const Text('Sign in with your ERP account to use Garam Mug.',
            style: AppTextStyles.bodyRegular),
        const SizedBox(height: 26),
        _InputField(controller: usernameController, hint: 'Email or username',
            icon: Icons.person_outline_rounded,
            keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 14),
        _InputField(controller: passwordController, hint: 'Password',
            icon: Icons.lock_outline_rounded, isPassword: true),
        const SizedBox(height: 8),
        CheckboxListTile(
          value: rememberMe,
          onChanged: busy ? null : onRememberMeChanged,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text('Keep me signed in', style: AppTextStyles.checkboxLabel),
        ),
        if (error != null) ...[
          Text(error!, style: const TextStyle(color: Color(0xFFB91C1C))),
          const SizedBox(height: 12),
        ],
        SizedBox(width: double.infinity, height: 54,
            child: FilledButton(
              onPressed: busy ? null : onSubmit,
              style: FilledButton.styleFrom(backgroundColor: AppColors.tealDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: busy
                  ? const SizedBox(width: 22, height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Sign in'),
            )),
      ],
    )),
  );
}

// ─── Input Field ──────────────────────────────────────────────────────────────

class _InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final bool isPassword;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0F2F5), width: 1),
      ),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _obscureText : false,
        style: AppTextStyles.inputText,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: AppTextStyles.hintText,

          // LEFT ICON
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Icon(
              widget.icon,
              color: AppColors.textLight,
              size: 20,
            ),
          ),

          // RIGHT ICON (SHOW/HIDE PASSWORD)
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              size: 20,
              color: AppColors.textLight,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,

          prefixIconConstraints: const BoxConstraints(minWidth: 52),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          isDense: true,
        ),
      ),
    );
  }
}



