import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_theme.dart';
import '../widgets/auth_toggle.dart';
import '../widgets/remember_me.dart';
import '../widgets/showroom_card.dart';
import '../widgets/social_button.dart';

class ShowroomLoginScreen extends StatefulWidget {
  const ShowroomLoginScreen({super.key});

  @override
  State<ShowroomLoginScreen> createState() => _ShowroomLoginScreenState();
}

class _ShowroomLoginScreenState extends State<ShowroomLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  static const _animDuration = Duration(milliseconds: 260);
  static const _verticalPadding = 12.0;

  /// Below this usable height the card would get too small, so the screen
  /// scrolls with a fixed-height card instead.
  static const _minFullScreenHeight = 700.0;

  static const _fieldPadding = EdgeInsets.symmetric(vertical: 15);
  static const _fieldIconConstraints = BoxConstraints(
    minWidth: 60,
    minHeight: 52,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _setMode(bool isSignUp) {
    if (isSignUp == _isSignUp) return;
    _formKey.currentState?.reset();
    setState(() => _isSignUp = isSignUp);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);
    final message = _isSignUp
        ? 'Account created for ${_nameController.text.trim()}'
        : 'Welcome back, ${_emailController.text.trim()}';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String? _validateName(String? value) {
    if ((value?.trim() ?? '').isEmpty) return 'Please enter your name';
    return null;
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
    final padding = MediaQuery.paddingOf(context);
    // Measured without the keyboard so the layout doesn't jump when it opens;
    // the scroll view then lets the focused field scroll into view.
    final screenHeight = MediaQuery.sizeOf(context).height - padding.vertical;
    final fitsScreen = screenHeight >= _minFullScreenHeight;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        if (fitsScreen)
          const Expanded(child: ShowroomCard())
        else
          const SizedBox(height: 250, child: ShowroomCard()),
        const SizedBox(height: 16),
        AuthToggle(
          isSignUp: _isSignUp,
          onChanged: _isLoading ? null : _setMode,
        ),
        const SizedBox(height: 14),
        _buildNameField(),
        _buildEmailField(),
        const SizedBox(height: 12),
        _buildPasswordField(),
        _buildOptionsRow(),
        _buildSubmitButton(),
        const SizedBox(height: 16),
        _buildDivider(),
        const SizedBox(height: 14),
        _buildSocialRow(),
      ],
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24,
            padding.top + _verticalPadding,
            24,
            padding.bottom + _verticalPadding,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: fitsScreen
                    ? SizedBox(
                        height: screenHeight - _verticalPadding * 2,
                        child: content,
                      )
                    : content,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildHeadline()),
        IconButton(
          onPressed: () {},
          tooltip: 'Help',
          style: IconButton.styleFrom(
            backgroundColor: AppColors.field,
            foregroundColor: AppColors.ink,
            fixedSize: const Size(44, 44),
          ),
          icon: const Icon(Icons.headset_mic_outlined, size: 20),
        ),
      ],
    );
  }

  Widget _buildHeadline() {
    return Text.rich(
      const TextSpan(
        children: [
          TextSpan(text: 'Find your\n'),
          TextSpan(
            text: 'dream car',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          TextSpan(text: ' today'),
        ],
      ),
      style: const TextStyle(
        fontSize: 28,
        height: 1.15,
        letterSpacing: -0.7,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }

  /// Slides in above the email field in sign-up mode.
  Widget _buildNameField() {
    return AnimatedSize(
      duration: _animDuration,
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: _isSignUp
          ? Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.name],
                decoration: const InputDecoration(
                  hintText: 'Full name',
                  contentPadding: _fieldPadding,
                  prefixIconConstraints: _fieldIconConstraints,
                  prefixIcon: _FieldIcon(Icons.person_outline_rounded),
                ),
                validator: _validateName,
                onFieldSubmitted: (_) => _emailFocus.requestFocus(),
              ),
            )
          : const SizedBox(width: double.infinity),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocus,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      decoration: const InputDecoration(
        hintText: 'Email address',
        contentPadding: _fieldPadding,
        prefixIconConstraints: _fieldIconConstraints,
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
      autofillHints: [
        _isSignUp ? AutofillHints.newPassword : AutofillHints.password,
      ],
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: _fieldPadding,
        prefixIconConstraints: _fieldIconConstraints,
        prefixIcon: const _FieldIcon(Icons.lock_outline_rounded),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 6),
          child: IconButton(
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            tooltip: _obscurePassword ? 'Show password' : 'Hide password',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.ink,
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

  /// Remember-me and forgot-password only apply to signing in.
  Widget _buildOptionsRow() {
    return AnimatedSize(
      duration: _animDuration,
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: _isSignUp
          ? const SizedBox(width: double.infinity, height: 16)
          : Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 8),
              child: Row(
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
              ),
            ),
    );
  }

  Widget _buildSubmitButton() {
    return FilledButton(
      onPressed: _isLoading ? null : _submit,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        padding: const EdgeInsets.symmetric(horizontal: 6),
      ),
      child: _isLoading
          ? const SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: Colors.white,
              ),
            )
          : Row(
              children: [
                const SizedBox(width: 42),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: _animDuration,
                    child: Text(
                      _isSignUp ? 'Create Account' : 'Sign In',
                      key: ValueKey(_isSignUp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
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
      children: [
        Expanded(
          child: SocialPill(
            label: 'Google',
            icon: const GoogleLogo(size: 22),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SocialPill(
            label: 'Apple',
            icon: const Icon(Icons.apple, size: 24, color: AppColors.ink),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SocialPill(
            label: 'Facebook',
            icon: const FacebookLogo(size: 20),
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}

class _FieldIcon extends StatelessWidget {
  const _FieldIcon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 12, 6),
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
