import '../models/user_role.dart';

/// DIP - Dependency Inversion Principle
///
/// La aplicación no dependerá directamente de Supabase para
/// realizar autenticación.
///
/// En su lugar, las pantallas y servicios dependerán de esta
/// abstracción. Esto permite cambiar la implementación de
/// autenticación sin modificar la interfaz de usuario.
abstract class AuthRepository {
  Future<UserRole?> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  UserRole? get currentRole;
}