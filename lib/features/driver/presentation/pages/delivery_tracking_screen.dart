import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/delivery.dart';
import '../bloc/driver_bloc.dart';

/// Delivery tracking screen with map and actions.
class DeliveryTrackingScreen extends StatefulWidget {
  const DeliveryTrackingScreen({
    super.key,
    required this.deliveryId,
  });
  final String deliveryId;

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  final MapController _mapController = MapController();
  String? _pendingAction; // 'pickup' | 'complete'

  @override
  void initState() {
    super.initState();
    context.read<DriverBloc>().add(DriverDeliveryTrackingRequested(widget.deliveryId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<DriverBloc, DriverState>(
        listenWhen: (a, b) =>
            a.trackingStatus != b.trackingStatus ||
            a.actionStatus != b.actionStatus,
        listener: (context, state) {
          if (state.actionStatus == DriverActionStatus.success) {
            context.read<DriverBloc>().add(DriverDeliveryTrackingRequested(widget.deliveryId));
            if (_pendingAction == 'complete') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Livraison terminée!'),
                  backgroundColor: AppColors.success,
                ),
              );
              _pendingAction = null;
              context.pop();
            }
            _pendingAction = null;
          }
          if (state.actionStatus == DriverActionStatus.failure &&
              state.actionError != null) {
            _pendingAction = null;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.actionError!),
                backgroundColor: AppColors.danger,
              ),
            );
          }
        },
        buildWhen: (a, b) =>
            a.trackingStatus != b.trackingStatus ||
            a.trackedDelivery != b.trackedDelivery ||
            a.actionStatus != b.actionStatus,
        builder: (context, state) {
          switch (state.trackingStatus) {
            case DriverDetailStatus.loading:
              return const LoadingScreen(message: 'Chargement...');
            case DriverDetailStatus.failure:
              return EmptyState.error(
                message: state.trackingError ?? 'Erreur',
                onRetry: () => context
                    .read<DriverBloc>()
                    .add(DriverDeliveryTrackingRequested(widget.deliveryId)),
              );
            case DriverDetailStatus.success:
              final delivery = state.trackedDelivery;
              if (delivery == null) {
                return EmptyState.error(message: 'Livraison non trouvée');
              }
              return _buildContent(context, delivery, state.actionStatus == DriverActionStatus.loading);
            default:
              return const LoadingScreen(message: 'Chargement...');
          }
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Delivery delivery, bool isActionLoading) {
    final pickupLat = delivery.pickupLatitude ?? -3.3731;
    final pickupLng = delivery.pickupLongitude ?? 29.3644;
    final deliveryLat = delivery.deliveryLatitude ?? -3.3812;
    final deliveryLng = delivery.deliveryLongitude ?? 29.3589;
    final status = delivery.status;

    final pickupPoint = LatLng(pickupLat, pickupLng);
    final deliveryPoint = LatLng(deliveryLat, deliveryLng);
    final center = LatLng(
      (pickupLat + deliveryLat) / 2,
      (pickupLng + deliveryLng) / 2,
    );

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: 14,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.gura_now.app',
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: [pickupPoint, deliveryPoint],
                  strokeWidth: 4,
                  color: AppColors.accent,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: pickupPoint,
                  width: 40,
                  height: 40,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.store,
                      color: AppColors.textOnAccent,
                      size: 22,
                    ),
                  ),
                ),
                Marker(
                  point: deliveryPoint,
                  width: 40,
                  height: 40,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: AppColors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          child: AppIconButton(
            icon: Icons.arrow_back,
            onPressed: () => context.pop(),
            backgroundColor: AppColors.surface,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: AppIconButton(
            icon: Icons.my_location,
            onPressed: () {
              _mapController.move(center, 14);
            },
            backgroundColor: AppColors.surface,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _DeliveryBottomSheet(
            delivery: delivery,
            status: status,
            isLoading: isActionLoading,
            onPickup: () {
              context.read<DriverBloc>().add(
                    DriverConfirmPickupRequested(widget.deliveryId),
                  );
            },
            onDelivered: () {
              setState(() => _pendingAction = 'complete');
              context.read<DriverBloc>().add(
                    DriverCompleteDeliveryRequested(widget.deliveryId),
                  );
            },
            onCall: _handleCall,
          ),
        ),
      ],
    );
  }

  void _handleCall(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Appeler $phone'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}

class _DeliveryBottomSheet extends StatelessWidget {
  const _DeliveryBottomSheet({
    required this.delivery,
    required this.status,
    required this.isLoading,
    required this.onPickup,
    required this.onDelivered,
    required this.onCall,
  });
  final Delivery delivery;
  final String status;
  final bool isLoading;
  final VoidCallback onPickup;
  final VoidCallback onDelivered;
  final void Function(String phone) onCall;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black,
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                StatusBadge.fromStatus(status),
                const SizedBox(height: 16),
                if (delivery.driverName != null) ...[
                  Text(
                    'Livreur: ${delivery.driverName}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (delivery.pickupPhone != null || delivery.deliveryPhone != null) ...[
                  _ContactCard(
                    title: 'Contact',
                    name: delivery.driverName ?? 'Livreur',
                    phone: delivery.pickupPhone ?? delivery.deliveryPhone ?? '',
                    onCall: onCall,
                  ),
                  const SizedBox(height: 16),
                ],
                if (status == 'accepted')
                  AppButton(
                    label: 'Confirmer le retrait',
                    onPressed: onPickup,
                    isLoading: isLoading,
                    icon: Icons.check_circle,
                  )
                else if (status == 'picked_up' || status == 'in_transit')
                  AppButton(
                    label: 'Confirmer la livraison',
                    onPressed: onDelivered,
                    isLoading: isLoading,
                    icon: Icons.done_all,
                    backgroundColor: AppColors.success,
                  ),
              ],
            ),
          ),
        ),
      );
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.title,
    required this.name,
    required this.phone,
    required this.onCall,
  });
  final String title;
  final String name;
  final String phone;
  final void Function(String phone) onCall;

  @override
  Widget build(BuildContext context) => AppCard(
        backgroundColor: AppColors.surfaceContainer,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AppIconButton(
              icon: Icons.phone,
              onPressed: () => onCall(phone),
              backgroundColor: AppColors.success.withValues(alpha: 0.15),
              iconColor: AppColors.success,
            ),
          ],
        ),
      );
}
