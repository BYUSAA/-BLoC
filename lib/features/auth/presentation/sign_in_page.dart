import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/validators.dart';
import 'auth_cubit.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _registering = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthCubit>().submit(
          _emailController.text,
          _passwordController.text,
          register: _registering,
        );
  }

  void _resetPassword() {
    if (Validators.email(_emailController.text) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid email address first.')),
      );
      return;
    }

    context.read<AuthCubit>().resetPassword(_emailController.text);
  }

  void _toggleMode() {
    setState(() => _registering = !_registering);
    context.read<AuthCubit>().clearFeedback();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return _buildForm(context, state);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, AuthState state) {
    final isBusy = state.isBusy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.dashboard_customize_outlined, size: 56),
        const SizedBox(height: 20),
        Text(
          _registering ? 'Create your account' : 'Welcome back',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          _registering
              ? 'Create an account to get started.'
              : 'Sign in to manage your workspace.',
        ),
        const SizedBox(height: 28),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          autocorrect: false,
          enabled: !isBusy,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          validator: Validators.email,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          autofillHints: _registering
              ? const [AutofillHints.newPassword]
              : const [AutofillHints.password],
          onFieldSubmitted: (_) => _submit(),
          enabled: !isBusy,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              tooltip: _obscurePassword ? 'Show password' : 'Hide password',
              onPressed: isBusy
                  ? null
                  : () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
          validator: Validators.password,
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: isBusy ? null : _submit,
          child: isBusy
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_registering ? 'Create account' : 'Sign in'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed:
              isBusy ? null : () => context.read<AuthCubit>().googleSignIn(),
          icon: const Icon(Icons.login),
          label: const Text('Continue with Google'),
        ),
        if (state.error != null) ...[
          const SizedBox(height: 12),
          _MessagePanel(message: state.error!, isError: true),
        ],
        if (state.notice != null) ...[
          const SizedBox(height: 12),
          _MessagePanel(message: state.notice!),
        ],
        TextButton(
          onPressed: isBusy ? null : _toggleMode,
          child: Text(
            _registering
                ? 'Already registered? Sign in'
                : 'New here? Create an account',
          ),
        ),
        TextButton(
          onPressed: isBusy ? null : _resetPassword,
          child: const Text('Forgot password?'),
        ),
      ],
    );
  }
}

class _MessagePanel extends StatelessWidget {
  const _MessagePanel({
    required this.message,
    this.isError = false,
  });

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final background =
        isError ? colors.errorContainer : colors.secondaryContainer;
    final foreground =
        isError ? colors.onErrorContainer : colors.onSecondaryContainer;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message, style: TextStyle(color: foreground)),
    );
  }
}
