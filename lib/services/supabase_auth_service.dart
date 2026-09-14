import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_role.dart';
import '../repositories/auth_repository.dart';

/// Implementación concreta de autenticación utilizando Supabase.
///
/// La clase implementa AuthRepository, por lo que la aplicación
/// puede trabajar con la abstracción sin depender directamente
/// de esta implementación.
class SupabaseAuthService implements AuthRepository {
  final SupabaseClient _client;

  UserRole? _currentRole;

  SupabaseAuthService({
    SupabaseClient? client,
  }) : _client = client ?? Supabase.instance.client;

  @override
  UserRole? get currentRole => _currentRole;

  @override
  Future<UserRole?> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      return null;
    }

    final role = await _getUserRole(user.id);

    _currentRole = role;

    return role;
  }

  Future<UserRole?> _getUserRole(String userId) async {
    final response = await _client
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return _roleFromString(response['role'] as String);
  }

  UserRole? _roleFromString(String value) {
    switch (value) {
      case 'client':
        return UserRole.client;
      case 'restaurant':
        return UserRole.restaurant;
      case 'courier':
        return UserRole.courier;
      case 'central':
        return UserRole.central;
      default:
        return null;
    }
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
    _currentRole = null;
  }
}