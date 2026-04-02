import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../providers/providers.dart';
import '../../widgets/shared_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _showEmailForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: _showEmailForm
            ? _EmailLoginForm(onBack: () => setState(() => _showEmailForm = false))
            : _LoginOptions(onEmailTap: () => setState(() => _showEmailForm = true)),
      ),
    );
  }
}

class _LoginOptions extends StatelessWidget {
  final VoidCallback onEmailTap;
  const _LoginOptions({required this.onEmailTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 48),
          const AppLogo(size: 64, color: AppColors.primary),
          const SizedBox(height: 40),
          Text('Welcome Back!', style: AppTextStyles.headline2),
          const SizedBox(height: 8),
          Text(
            'Hello there, how would you like to continue',
            style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SocialLoginButton(
            label: 'Continue with Google',
            iconAsset: 'google',
            onTap: () async {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          const SizedBox(height: 12),
          SocialLoginButton(
            label: 'Continue with Apple',
            iconAsset: 'apple',
            isApple: true,
            onTap: () async {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.border)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Or', style: AppTextStyles.body2),
              ),
              const Expanded(child: Divider(color: AppColors.border)),
            ],
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Log In With Email',
            onTap: onEmailTap,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/signup'),
            child: RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: AppTextStyles.body2,
                children: [
                  TextSpan(
                    text: 'Sign Up',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _EmailLoginForm extends ConsumerStatefulWidget {
  final VoidCallback onBack;
  const _EmailLoginForm({required this.onBack});

  @override
  ConsumerState<_EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends ConsumerState<_EmailLoginForm> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;
  bool _showNoAccountDialog = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _showNoAccountDialog = false;
    });

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (email.isEmpty) {
      setState(() => _emailError = 'Email is required');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _showNoAccountDialog = true);
      return;
    }
    if (password.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      return;
    }
    if (password.length < 6) {
      setState(() => _passwordError = "The password you've entered is incorrect.");
      return;
    }

    setState(() => _isLoading = true);
    final success = await ref.read(authProvider.notifier).login(email, password);
    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text('Log in With Email', style: AppTextStyles.headline2),
              const SizedBox(height: 8),
              Text(
                'Hello there, log in with your information',
                style: AppTextStyles.body2,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email address',
                  errorText: _emailError,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordCtrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  errorText: _passwordError,
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                    child: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/forgot-password'),
                  child: Text(
                    'Forgot password?',
                    style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Log In',
                onTap: _login,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
              SocialLoginButton(
                label: 'Continue with Google',
                iconAsset: 'google',
                onTap: () => Navigator.of(context).pushReplacementNamed('/home'),
              ),
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed('/signup'),
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: AppTextStyles.body2,
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        if (_showNoAccountDialog)
          _NoAccountDialog(
            onBack: () => setState(() => _showNoAccountDialog = false),
            onCreateAccount: () => Navigator.of(context).pushNamed('/signup'),
          ),
      ],
    );
  }
}

class _NoAccountDialog extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onCreateAccount;

  const _NoAccountDialog({required this.onBack, required this.onCreateAccount});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Sorry, there is no account\nwith this email.',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create an account to continue',
                  style: AppTextStyles.body2,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onBack,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onCreateAccount,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                        ),
                        child: const Text('Create Account'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
