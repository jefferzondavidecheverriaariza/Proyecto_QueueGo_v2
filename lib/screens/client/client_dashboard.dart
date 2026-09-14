import 'package:flutter/material.dart';

import '../restaurant/restaurants_screen.dart';

class ClientDashboard extends StatelessWidget {
  const ClientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QueueGo - Cliente'),
        actions: [
          IconButton(
            onPressed: () {
              // Próximamente mostraremos las notificaciones.
            },
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notificaciones',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, Cliente',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 8),

            const Text('¿Qué quieres pedir hoy?'),

            const SizedBox(height: 24),

            // Grid responsive.
            //
            // En pantallas grandes mostramos 3 columnas.
            // En pantallas pequeñas mostramos 1 columna.
            //
            // Más adelante podemos ajustar los breakpoints
            // para diferenciar móvil, tablet y escritorio.
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final int columns;

                  if (constraints.maxWidth >= 1000) {
                    columns = 3;
                  } else if (constraints.maxWidth >= 600) {
                    columns = 2;
                  } else {
                    columns = 1;
                  }

                  return GridView.count(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _DashboardCard(
                        icon: Icons.restaurant,
                        title: 'Restaurantes',
                        description: 'Explora restaurantes disponibles',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RestaurantsScreen(),
                            ),
                          );
                        },
                      ),

                      _DashboardCard(
                        icon: Icons.receipt_long,
                        title: 'Mis pedidos',
                        description: 'Consulta tus pedidos',
                        onTap: () {
                          // Próximo paso:
                          // abrir la pantalla de pedidos.
                        },
                      ),

                      _DashboardCard(
                        icon: Icons.location_on,
                        title: 'Seguimiento',
                        description: 'Mira dónde está tu pedido',
                        onTap: () {
                          // Próximo paso:
                          // abrir el seguimiento del pedido
                          // mediante geolocalización.
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta reutilizable del dashboard.
///
/// SRP:
/// Este widget se encarga únicamente de representar
/// visualmente una opción del dashboard.
///
/// No conoce Supabase ni lógica de negocio.
///
/// Esto permite reutilizar la misma tarjeta para
/// diferentes funcionalidades.
class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 42),

              const SizedBox(height: 12),

              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(description, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
