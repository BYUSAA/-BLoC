import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_cubit.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}
class _SignInPageState extends State<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _registering = false;
  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Icon(Icons.dashboard_customize_outlined, size: 56),
          const SizedBox(height: 20),
          Text(_registering ? 'Create your account' : 'Welcome back', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text('Sign in to manage your workspace.'),
          const SizedBox(height: 28),
          TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()), validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email address' : null),
          const SizedBox(height: 16),
          TextFormField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()), validator: (v) => v == null || v.length < 6 ? 'Use at least 6 characters' : null),
          const SizedBox(height: 20),
          BlocBuilder<AuthCubit, AuthState>(builder: (context, state) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            FilledButton(onPressed: state.status == AuthStatus.loading ? null : () {
              if (_formKey.currentState!.validate()) context.read<AuthCubit>().submit(_email.text, _password.text, register: _registering);
            }, child: Text(_registering ? 'Create account' : 'Sign in')),
            const SizedBox(height: 10),
            OutlinedButton.icon(onPressed: state.status == AuthStatus.loading ? null : () => context.read<AuthCubit>().googleSignIn(), icon: const Icon(Icons.login), label: const Text('Continue with Google')),
            if (state.error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(state.error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
          ])),
          TextButton(onPressed: () => setState(() => _registering = !_registering), child: Text(_registering ? 'Already registered? Sign in' : 'New here? Create an account')),
          TextButton(onPressed: () {
            if (_email.text.contains('@')) context.read<AuthCubit>().resetPassword(_email.text);
            else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter your email first to reset your password.')));
          }, child: const Text('Forgot password?')),
        ]),
      )),
    ))),
  );
}
