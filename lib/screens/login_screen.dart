import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_theme.dart';
import '../widgets/car_illustration.dart';
import '../widgets/remember_me.dart';
import '../widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Welcome back, ${_emailController.text.trim()}')),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Please enter your password';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_buildHero(), _buildSheet()],
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.paddingOf(context).top + 12,
        20,
        34,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.charcoal, AppColors.charcoalDeep],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _GlassIconButton(
                icon: Icons.arrow_back_rounded,
                tooltip: 'Back',
                onPressed: () => Navigator.maybePop(context),
              ),
              const Expanded(
                child: Text(
                  'Sign In',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              _GlassIconButton(
                icon: Icons.headset_mic_outlined,
                tooltip: 'Help',
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Find your\ndream car today',
              style: TextStyle(
                fontSize: 26,
                height: 1.2,
                letterSpacing: -0.4,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(child: CarIllustration()),
        ],
      ),
    );
  }

  Widget _buildSheet() {
    return Transform.translate(
      offset: const Offset(0, -24),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.sheet),
          ),
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          28,
          24,
          MediaQuery.paddingOf(context).bottom + 8,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeading(),
                  const SizedBox(height: 23),
                  _buildEmailField(),
                  const SizedBox(height: 14),
                  _buildPasswordField(),
                  const SizedBox(height: 4),
                  _buildOptionsRow(),
                  const SizedBox(height: 18),
                  _buildSignInButton(),
                  const SizedBox(height: 24),
                  _buildDivider(),
                  const SizedBox(height: 18),
                  _buildSocialRow(),
                  const SizedBox(height: 14),
                  _buildSignUpPrompt(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeading() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            Icon(Icons.star_rounded, size: 20, color: AppColors.star),
            SizedBox(width: 3),
            Text(
              '(4.8)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 6),
        Text(
          'Sign in to see saved cars, test drives and offers picked for you.',
          style: TextStyle(
            fontSize: 13.5,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      decoration: const InputDecoration(
        hintText: 'Email address',
        prefixIcon: _FieldIcon(Icons.mail_outline_rounded),
      ),
      validator: _validateEmail,
      onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocus,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: const _FieldIcon(Icons.lock_outline_rounded),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 6),
          child: IconButton.filled(
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            tooltip: _obscurePassword ? 'Show password' : 'Hide password',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.ink,
              foregroundColor: Colors.white,
              fixedSize: const Size(44, 44),
            ),
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 19,
            ),
          ),
        ),
      ),
      validator: _validatePassword,
      onFieldSubmitted: (_) => _submit(),
    );
  }

  Widget _buildOptionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: RememberMe(
            value: _rememberMe,
            onChanged: (value) => setState(() => _rememberMe = value),
          ),
        ),
        Flexible(
          child: TextButton(
            onPressed: _isLoading ? null : () {},
            child: const Text(
              'Forgot Password?',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return FilledButton(
      onPressed: _isLoading ? null : _submit,
      child: _isLoading
          ? const SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: Colors.white,
              ),
            )
          : const Text('Sign In'),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'or continue with',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialRow() {
    final onPressed = _isLoading ? null : () {};
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SocialButton(
          label: 'Google',
          icon: const GoogleLogo(),
          onPressed: onPressed,
        ),
        SocialButton(
          label: 'Apple',
          icon: const Icon(Icons.apple, size: 28, color: Colors.white),
          onPressed: onPressed,
        ),
        SocialButton(
          label: 'Facebook',
          icon: const FacebookLogo(),
          onPressed: onPressed,
        ),
      ],
    );
  }

  Widget _buildSignUpPrompt() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        TextButton(
          onPressed: _isLoading ? null : () {},
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        foregroundColor: Colors.white,
        fixedSize: const Size(46, 46),
      ),
      icon: Icon(icon, size: 21),
    );
  }
}

class _FieldIcon extends StatelessWidget {
  const _FieldIcon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
      child: Container(
        width: 40,
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: AppColors.ink),
      ),
    );
  }
}
