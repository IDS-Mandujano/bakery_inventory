import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transactional_app/features/login/presentation/providers/login_view_model.dart';
import 'package:transactional_app/features/inventory/presentation/screens/inventory_screen.dart';

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

  void _handleRegister(BuildContext context, LoginViewModel viewModel) async {
    final success = await viewModel.register(
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
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [theme.colorScheme.secondaryContainer, theme.colorScheme.surface],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(theme),
                    const SizedBox(height: 32),
                    _buildForm(),
                    const SizedBox(height: 24),
                    if (viewModel.errorMessage != null) _buildError(theme, viewModel.errorMessage!),
                    const SizedBox(height: 24),
                    _buildRegisterButton(viewModel),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle),
          child: Hero(tag: 'bakery_logo', child: Icon(Icons.bakery_dining, size: 64, color: theme.colorScheme.primary)),
        ),
        const SizedBox(height: 24),
        Text('Únete a nosotros', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Crea tu cuenta de inventario', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Correo Electrónico', prefixIcon: Icon(Icons.email_outlined)),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'Nombre de Usuario', prefixIcon: Icon(Icons.person_outline)),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock_outline)),
        ),
      ],
    );
  }

  Widget _buildError(ThemeData theme, String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(8)),
      child: Text(message, style: TextStyle(color: theme.colorScheme.onErrorContainer)),
    );
  }

  Widget _buildRegisterButton(LoginViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: viewModel.isLoading ? null : () => _handleRegister(context, viewModel),
        child: viewModel.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Registrarse'),
      ),
    );
  }
}