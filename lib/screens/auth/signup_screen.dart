import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../providers/providers.dart';
import '../../widgets/shared_widgets.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  bool _showForm = false;
  bool _showOtp = false;
  bool _showSuccess = false;
  String _email = '';

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) return _SuccessScreen();

    if (_showOtp) {
      return _OtpScreen(
        email: _email,
        onSuccess: () => setState(() => _showSuccess = true),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: _showForm
            ? _SignUpForm(
                onSubmit: (email) {
                  setState(() {
                    _email = email;
                    _showOtp = true;
                  });
                },
                onBack: () => setState(() => _showForm = false),
              )
            : _SignUpOptions(
                onEmailTap: () => setState(() => _showForm = true),
                onGoogleTap: () async {
                  await ref.read(authProvider.notifier).signUp(
                    'Google User', 'google@example.com', 'password123');
                  if (mounted) Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
      ),
    );
  }
}

class _SignUpOptions extends StatelessWidget {
  final VoidCallback onEmailTap;
  final VoidCallback onGoogleTap;

  const _SignUpOptions({required this.onEmailTap, required this.onGoogleTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 48),
          const AppLogo(size: 64, color: AppColors.primary),
          const SizedBox(height: 40),
          Text("Let's Get Started", style: AppTextStyles.headline2),
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
            onTap: onGoogleTap,
          ),
          const SizedBox(height: 12),
          SocialLoginButton(
            label: 'Continue with Apple',
            iconAsset: 'apple',
            isApple: true,
            onTap: () {},
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
          PrimaryButton(label: 'Sign up With Email', onTap: onEmailTap),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: AppTextStyles.body2,
                children: [
                  TextSpan(
                    text: 'Log In',
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

class _SignUpForm extends ConsumerStatefulWidget {
  final Function(String email) onSubmit;
  final VoidCallback onBack;

  const _SignUpForm({required this.onSubmit, required this.onBack});

  @override
  ConsumerState<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<_SignUpForm> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms')),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);
    widget.onSubmit(_emailCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text('Sign Up', style: AppTextStyles.headline2), const SizedBox(height: 32),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(hintText: 'Full name',fillColor: AppColors.white),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Email address',fillColor: AppColors.white),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Text('🇧🇩', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 4),
                    Text('+880', style: AppTextStyles.body1),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(hintText: '0000000000',fillColor: AppColors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordCtrl,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              fillColor: AppColors.white,
              hintText: 'Password',
              suffixIcon: GestureDetector(
                onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                child: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: _agreedToTerms,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'By registering, I confirm that I accept ShowMe\'s ',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      children: [
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(text: ', and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(label: 'Sign up', onTap: _signUp, isLoading: _isLoading),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: widget.onBack,
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
    );
  }
}

class _OtpScreen extends ConsumerStatefulWidget {
  final String email;
  final VoidCallback onSuccess;
  const _OtpScreen({required this.email, required this.onSuccess});

  @override
  ConsumerState<_OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<_OtpScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _isLoading = false);
    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text('Verify OTP', style: AppTextStyles.headline2),
              const SizedBox(height: 8),
              Text(
                'Enter the OTP code sent to ${widget.email.isNotEmpty ? widget.email.substring(0, widget.email.length.clamp(0, 15)) : '...'}...',
                style: AppTextStyles.body2,
              ),
              const SizedBox(height: 40),
              OtpField(controllers: _controllers, focusNodes: _focusNodes),
              const SizedBox(height: 24),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Didn't receive it? Try again ",
                    style: AppTextStyles.body2,
                    children: [
                      TextSpan(
                        text: 'Resend OTP',
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
              PrimaryButton(label: 'Next', onTap: _verify, isLoading: _isLoading),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.success, width: 2),
                ),
                child: const Icon(Icons.check_rounded, color: AppColors.success, size: 40),
              ),
              const SizedBox(height: 24),
              Text('Verification Success!', style: AppTextStyles.headline3),
              const SizedBox(height: 8),
              Text(
                'Your account has been verified',
                style: AppTextStyles.body2,
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                label: 'Go to Home',
                onTap: () async {
                  await ref.read(authProvider.notifier).signUp(
                    'New User', 'user@example.com', 'password123');
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
