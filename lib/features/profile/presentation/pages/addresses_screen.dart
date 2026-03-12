import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Address entity.
class Address {
  const Address({
    required this.id,
    required this.label,
    required this.fullAddress,
    this.city,
    this.phone,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });
  final String id;
  final String label;
  final String fullAddress;
  final String? city;
  final String? phone;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
}

/// Screen for managing delivery addresses.
class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  // Mock addresses - replace with actual provider
  final List<Address> _addresses = [
    const Address(
      id: '1',
      label: 'Maison',
      fullAddress: 'Avenue de l\'Indépendance, Quartier Buyenzi',
      city: 'Bujumbura',
      phone: '+257 79 123 456',
      isDefault: true,
    ),
    const Address(
      id: '2',
      label: 'Bureau',
      fullAddress: 'Rue du Commerce, Centre-ville',
      city: 'Bujumbura',
      phone: '+257 79 789 012',
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Mes adresses'),
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          elevation: 0,
        ),
        body: _addresses.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune adresse enregistrée',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _showAddressForm(),
                      icon: const Icon(Icons.add),
                      label: const Text('Ajouter une adresse'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  final address = _addresses[index];
                  return _AddressCard(
                    address: address,
                    onEdit: () => _showAddressForm(address: address),
                    onDelete: () => _deleteAddress(address),
                    onSetDefault: () => _setDefaultAddress(address),
                  );
                },
              ),
        floatingActionButton: _addresses.isNotEmpty
            ? FloatingActionButton(
                onPressed: () => _showAddressForm(),
                backgroundColor: AppColors.black,
                child: const Icon(Icons.add),
              )
            : null,
      );

  void _showAddressForm({Address? address}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AddressFormSheet(
        address: address,
        onSave: (newAddress) {
          setState(() {
            if (address != null) {
              final index = _addresses.indexWhere((a) => a.id == address.id);
              if (index != -1) {
                _addresses[index] = newAddress;
              }
            } else {
              _addresses.add(newAddress);
            }
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _deleteAddress(Address address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'adresse'),
        content: Text('Voulez-vous supprimer "${address.label}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _addresses.removeWhere((a) => a.id == address.id);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _setDefaultAddress(Address address) {
    setState(() {
      for (var i = 0; i < _addresses.length; i++) {
        _addresses[i] = Address(
          id: _addresses[i].id,
          label: _addresses[i].label,
          fullAddress: _addresses[i].fullAddress,
          city: _addresses[i].city,
          phone: _addresses[i].phone,
          latitude: _addresses[i].latitude,
          longitude: _addresses[i].longitude,
          isDefault: _addresses[i].id == address.id,
        );
      }
    });
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });
  final Address address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: address.isDefault
              ? const BorderSide(color: AppColors.black, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: address.isDefault
                          ? AppColors.black
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getLabelIcon(address.label),
                          size: 14,
                          color: address.isDefault ? Colors.white : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          address.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                address.isDefault ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (address.isDefault) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Par défaut',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: onEdit,
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Modifier'),
                          ],
                        ),
                      ),
                      if (!address.isDefault)
                        PopupMenuItem(
                          onTap: onSetDefault,
                          child: const Row(
                            children: [
                              Icon(Icons.check_circle),
                              SizedBox(width: 8),
                              Text('Définir par défaut'),
                            ],
                          ),
                        ),
                      PopupMenuItem(
                        onTap: onDelete,
                        child: const Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Supprimer',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, color: Colors.grey[400], size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address.fullAddress,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              if (address.city != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_city,
                        color: Colors.grey[400], size: 18),
                    const SizedBox(width: 8),
                    Text(
                      address.city!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
              if (address.phone != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.grey[400], size: 18),
                    const SizedBox(width: 8),
                    Text(
                      address.phone!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      );

  IconData _getLabelIcon(String label) {
    switch (label.toLowerCase()) {
      case 'maison':
        return Icons.home;
      case 'bureau':
        return Icons.work;
      default:
        return Icons.place;
    }
  }
}

class _AddressFormSheet extends StatefulWidget {
  const _AddressFormSheet({
    this.address,
    required this.onSave,
  });
  final Address? address;
  final Function(Address) onSave;

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.address?.label ?? '');
    _addressController =
        TextEditingController(text: widget.address?.fullAddress ?? '');
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _phoneController = TextEditingController(text: widget.address?.phone ?? '');
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.address != null
                        ? 'Modifier l\'adresse'
                        : 'Nouvelle adresse',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Label
                  TextFormField(
                    controller: _labelController,
                    decoration: InputDecoration(
                      labelText: 'Nom de l\'adresse',
                      hintText: 'Ex: Maison, Bureau',
                      prefixIcon: const Icon(Icons.label_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le nom est requis';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Full Address
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Adresse complète',
                      hintText: 'Rue, quartier, repères',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'L\'adresse est requise';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // City
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'Ville',
                      hintText: 'Ex: Bujumbura',
                      prefixIcon: const Icon(Icons.location_city_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Téléphone de contact',
                      hintText: '+257 XX XXX XXX',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Enregistrer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newAddress = Address(
        id: widget.address?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        label: _labelController.text.trim(),
        fullAddress: _addressController.text.trim(),
        city: _cityController.text.trim().isNotEmpty
            ? _cityController.text.trim()
            : null,
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        latitude: widget.address?.latitude,
        longitude: widget.address?.longitude,
        isDefault: widget.address?.isDefault ?? false,
      );
      widget.onSave(newAddress);
    }
  }
}
