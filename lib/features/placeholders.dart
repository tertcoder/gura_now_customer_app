import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Profile (Coming Soon)')));
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Settings (Coming Soon)')));
}

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key, required this.productId})
      : super(key: key);
  final String productId;
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('Product $productId')),
      body: const Center(child: Text('Detail Produit')));
}

class DriverDeliveriesScreen extends StatelessWidget {
  const DriverDeliveriesScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Driver Deliveries')));
}
