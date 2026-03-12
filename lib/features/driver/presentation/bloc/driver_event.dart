part of 'driver_bloc.dart';

abstract class DriverEvent extends Equatable {
  const DriverEvent();
  @override
  List<Object?> get props => [];
}

class DriverOnlineChanged extends DriverEvent {
  const DriverOnlineChanged(this.isOnline);
  final bool isOnline;
  @override
  List<Object?> get props => [isOnline];
}

class DriverAvailableDeliveriesRequested extends DriverEvent {
  const DriverAvailableDeliveriesRequested({this.page = 1, this.perPage = 20});
  final int page;
  final int perPage;
  @override
  List<Object?> get props => [page, perPage];
}

class DriverStatsRequested extends DriverEvent {
  const DriverStatsRequested();
}

class DriverAcceptDeliveryRequested extends DriverEvent {
  const DriverAcceptDeliveryRequested(this.deliveryId);
  final String deliveryId;
  @override
  List<Object?> get props => [deliveryId];
}

class DriverDeliveryTrackingRequested extends DriverEvent {
  const DriverDeliveryTrackingRequested(this.deliveryId);
  final String deliveryId;
  @override
  List<Object?> get props => [deliveryId];
}

class DriverDeliveryHistoryRequested extends DriverEvent {
  const DriverDeliveryHistoryRequested({this.page = 1, this.perPage = 20});
  final int page;
  final int perPage;
  @override
  List<Object?> get props => [page, perPage];
}

class DriverConfirmPickupRequested extends DriverEvent {
  const DriverConfirmPickupRequested(this.deliveryId);
  final String deliveryId;
  @override
  List<Object?> get props => [deliveryId];
}

class DriverCompleteDeliveryRequested extends DriverEvent {
  const DriverCompleteDeliveryRequested(this.deliveryId);
  final String deliveryId;
  @override
  List<Object?> get props => [deliveryId];
}

class DriverConfirmReceivedRequested extends DriverEvent {
  const DriverConfirmReceivedRequested(this.deliveryId);
  final String deliveryId;
  @override
  List<Object?> get props => [deliveryId];
}
