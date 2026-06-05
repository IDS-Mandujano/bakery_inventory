import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/login_view_model.dart';
import '../../../../features/inventory/presentation/screens/inventory_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Panadería - Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo Electrónico', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nombre de Usuario', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            if (viewModel.errorMessage != null)
              Text(viewModel.errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            viewModel.isLoading
                ? const CircularProgressIndicator()
                : FilledButton(
              onPressed: () async {
                final success = await context.read<LoginViewModel>().register(
                  _emailController.text,
                  _usernameController.text,
                  _passwordController.text,
                );
                if (success && context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const InventoryScreen()),
                  );
                }
              },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}