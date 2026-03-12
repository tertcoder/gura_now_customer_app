import 'package:flutter/material.dart';

/// Placeholder for driver app (customer app does not implement driver screens).
class DriverDeliveriesScreen extends StatelessWidget {
  const DriverDeliveriesScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Driver Deliveries')));
}

/// Placeholder for admin/shop owner (customer app does not implement owner dashboard).
class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Tableau de bord propriétaire')));
}
