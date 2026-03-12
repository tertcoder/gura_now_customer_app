part of 'driver_bloc.dart';

enum DriverListStatus { initial, loading, success, failure }
enum DriverDetailStatus { initial, loading, success, failure }
enum DriverActionStatus { initial, loading, success, failure }

class DriverState extends Equatable {
  const DriverState({
    this.isOnline = false,
    this.availableStatus = DriverListStatus.initial,
    this.availableDeliveries = const [],
    this.availableError,
    this.statsStatus = DriverListStatus.initial,
    this.stats,
    this.statsError,
    this.trackingStatus = DriverDetailStatus.initial,
    this.trackedDelivery,
    this.trackingError,
    this.historyStatus = DriverListStatus.initial,
    this.deliveryHistory = const [],
    this.historyError,
    this.actionStatus = DriverActionStatus.initial,
    this.actionError,
  });

  final bool isOnline;
  final DriverListStatus availableStatus;
  final List<Delivery> availableDeliveries;
  final String? availableError;
  final DriverListStatus statsStatus;
  final DriverStats? stats;
  final String? statsError;
  final DriverDetailStatus trackingStatus;
  final Delivery? trackedDelivery;
  final String? trackingError;
  final DriverListStatus historyStatus;
  final List<Delivery> deliveryHistory;
  final String? historyError;
  final DriverActionStatus actionStatus;
  final String? actionError;

  @override
  List<Object?> get props => [
        isOnline,
        availableStatus,
        availableDeliveries,
        availableError,
        statsStatus,
        stats,
        statsError,
        trackingStatus,
        trackedDelivery,
        trackingError,
        historyStatus,
        deliveryHistory,
        historyError,
        actionStatus,
        actionError,
      ];

  DriverState copyWith({
    bool? isOnline,
    DriverListStatus? availableStatus,
    List<Delivery>? availableDeliveries,
    String? availableError,
    DriverListStatus? statsStatus,
    DriverStats? stats,
    String? statsError,
    DriverDetailStatus? trackingStatus,
    Delivery? trackedDelivery,
    String? trackingError,
    DriverListStatus? historyStatus,
    List<Delivery>? deliveryHistory,
    String? historyError,
    DriverActionStatus? actionStatus,
    String? actionError,
  }) {
    return DriverState(
      isOnline: isOnline ?? this.isOnline,
      availableStatus: availableStatus ?? this.availableStatus,
      availableDeliveries: availableDeliveries ?? this.availableDeliveries,
      availableError: availableError,
      statsStatus: statsStatus ?? this.statsStatus,
      stats: stats ?? this.stats,
      statsError: statsError,
      trackingStatus: trackingStatus ?? this.trackingStatus,
      trackedDelivery: trackedDelivery ?? this.trackedDelivery,
      trackingError: trackingError,
      historyStatus: historyStatus ?? this.historyStatus,
      deliveryHistory: deliveryHistory ?? this.deliveryHistory,
      historyError: historyError,
      actionStatus: actionStatus ?? this.actionStatus,
      actionError: actionError,
    );
  }
}
