import 'package:flutter/material.dart';
import '../../models/user_role.dart';
import '../../repositories/auth_repository.dart';
import '../../services/supabase_auth_service.dart';
import '../client/client_dashboard.dart';
import '../restaurant/restaurant_dashboard.dart';
import '../courier/courier_dashboard.dart';
import '../central/central_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // DIP:
  // La pantalla trabaja con la abstracción AuthRepository
  // y no directamente con Supabase.
  final AuthRepository _authRepository = SupabaseAuthService();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Ingresa tu correo y contraseña.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final role = await _authRepository.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (role == null) {
        setState(() {
          _errorMessage = 'No se pudo obtener el rol del usuario.';
        });
        return;
      }

      _goToDashboard(role);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goToDashboard(UserRole role) {
    final Widget dashboard;

    switch (role) {
      case UserRole.client:
        dashboard = const ClientDashboard();
        break;

      case UserRole.restaurant:
        dashboard = const RestaurantDashboard();
        break;

      case UserRole.courier:
        dashboard = const CourierDashboard();
        break;

      case UserRole.central:
        dashboard = const CentralDashboard();
        break;
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => dashboard));
  }     

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'QueueGo',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Inicia sesión para continuar',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 50,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Iniciar sesión'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
