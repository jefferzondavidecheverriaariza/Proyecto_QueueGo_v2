import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/delivery_request.dart';
import '../repositories/central_repository.dart';

/// Servicio encargado de las operaciones de Central.
///
/// SRP:
/// Gestiona las operaciones relacionadas con Central.
///
/// DIP:
/// Implementa CentralRepository.
class SupabaseCentralService implements CentralRepository {
  final SupabaseClient _client;

  SupabaseCentralService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  @override
  Future<List<DeliveryRequest>> getPendingDeliveries() async {
    final response = await _client
        .from('delivery_requests')
        .select()
        .eq('status', 'pending')
        .order('created_at', ascending: true);

    return (response as List)
        .map((item) => DeliveryRequest.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getCouriers() async {
    final response = await _client
        .from('profiles')
        .select('id, full_name, email')
        .eq('role', 'courier')
        .eq('is_active', true)
        .order('full_name');

    return (response as List)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  @override
  Future<void> assignDelivery({
    required String deliveryId,
    required double price,
    required String courierId,
  }) async {
    await _client
        .from('delivery_requests')
        .update({
          'price': price,
          'courier_id': courierId,
          'status': 'assigned',
          'assigned_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', deliveryId);
  }
}
