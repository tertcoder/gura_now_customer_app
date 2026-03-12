import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/delivery.dart';
import '../../domain/repositories/delivery_repository.dart';

part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  DriverBloc(this._repository) : super(const DriverState()) {
    on<DriverOnlineChanged>(_onOnlineChanged);
    on<DriverAvailableDeliveriesRequested>(_onAvailableDeliveriesRequested);
    on<DriverStatsRequested>(_onStatsRequested);
    on<DriverAcceptDeliveryRequested>(_onAcceptDeliveryRequested);
    on<DriverDeliveryTrackingRequested>(_onDeliveryTrackingRequested);
    on<DriverDeliveryHistoryRequested>(_onDeliveryHistoryRequested);
    on<DriverConfirmPickupRequested>(_onConfirmPickupRequested);
    on<DriverCompleteDeliveryRequested>(_onCompleteDeliveryRequested);
    on<DriverConfirmReceivedRequested>(_onConfirmReceivedRequested);
  }

  final DeliveryRepository _repository;

  void _onOnlineChanged(DriverOnlineChanged event, Emitter<DriverState> emit) {
    emit(state.copyWith(isOnline: event.isOnline));
  }

  Future<void> _onAvailableDeliveriesRequested(
    DriverAvailableDeliveriesRequested event,
    Emitter<DriverState> emit,
  ) async {
    if (!state.isOnline) {
      emit(state.copyWith(availableDeliveries: [], availableStatus: DriverListStatus.success));
      return;
    }
    emit(state.copyWith(availableStatus: DriverListStatus.loading, availableError: null));
    final result = await _repository.getAvailableDeliveries(page: event.page, perPage: event.perPage);
    result.fold(
      (f) => emit(state.copyWith(availableStatus: DriverListStatus.failure, availableError: f.message)),
      (list) => emit(state.copyWith(availableStatus: DriverListStatus.success, availableDeliveries: list)),
    );
  }

  Future<void> _onStatsRequested(DriverStatsRequested event, Emitter<DriverState> emit) async {
    emit(state.copyWith(statsStatus: DriverListStatus.loading, statsError: null));
    final result = await _repository.getDriverStats();
    result.fold(
      (f) => emit(state.copyWith(statsStatus: DriverListStatus.failure, statsError: f.message)),
      (stats) => emit(state.copyWith(statsStatus: DriverListStatus.success, stats: stats)),
    );
  }

  Future<void> _onAcceptDeliveryRequested(
    DriverAcceptDeliveryRequested event,
    Emitter<DriverState> emit,
  ) async {
    emit(state.copyWith(actionStatus: DriverActionStatus.loading, actionError: null));
    final result = await _repository.acceptDelivery(event.deliveryId);
    result.fold(
      (f) => emit(state.copyWith(actionStatus: DriverActionStatus.failure, actionError: f.message)),
      (_) => emit(state.copyWith(actionStatus: DriverActionStatus.success)),
    );
  }

  Future<void> _onDeliveryTrackingRequested(
    DriverDeliveryTrackingRequested event,
    Emitter<DriverState> emit,
  ) async {
    emit(state.copyWith(trackingStatus: DriverDetailStatus.loading, trackingError: null));
    final result = await _repository.getDeliveryTracking(event.deliveryId);
    result.fold(
      (f) => emit(state.copyWith(trackingStatus: DriverDetailStatus.failure, trackingError: f.message)),
      (d) => emit(state.copyWith(trackingStatus: DriverDetailStatus.success, trackedDelivery: d)),
    );
  }

  Future<void> _onDeliveryHistoryRequested(
    DriverDeliveryHistoryRequested event,
    Emitter<DriverState> emit,
  ) async {
    emit(state.copyWith(historyStatus: DriverListStatus.loading, historyError: null));
    final result = await _repository.getDeliveryHistory(page: event.page, perPage: event.perPage);
    result.fold(
      (f) => emit(state.copyWith(historyStatus: DriverListStatus.failure, historyError: f.message)),
      (list) => emit(state.copyWith(historyStatus: DriverListStatus.success, deliveryHistory: list)),
    );
  }

  Future<void> _onConfirmPickupRequested(
    DriverConfirmPickupRequested event,
    Emitter<DriverState> emit,
  ) async {
    emit(state.copyWith(actionStatus: DriverActionStatus.loading, actionError: null));
    final result = await _repository.confirmPickup(event.deliveryId);
    result.fold(
      (f) => emit(state.copyWith(actionStatus: DriverActionStatus.failure, actionError: f.message)),
      (_) => emit(state.copyWith(actionStatus: DriverActionStatus.success)),
    );
  }

  Future<void> _onCompleteDeliveryRequested(
    DriverCompleteDeliveryRequested event,
    Emitter<DriverState> emit,
  ) async {
    emit(state.copyWith(actionStatus: DriverActionStatus.loading, actionError: null));
    final result = await _repository.completeDelivery(event.deliveryId);
    result.fold(
      (f) => emit(state.copyWith(actionStatus: DriverActionStatus.failure, actionError: f.message)),
      (_) => emit(state.copyWith(actionStatus: DriverActionStatus.success)),
    );
  }

  Future<void> _onConfirmReceivedRequested(
    DriverConfirmReceivedRequested event,
    Emitter<DriverState> emit,
  ) async {
    emit(state.copyWith(actionStatus: DriverActionStatus.loading, actionError: null));
    final result = await _repository.confirmReceived(event.deliveryId);
    result.fold(
      (f) => emit(state.copyWith(actionStatus: DriverActionStatus.failure, actionError: f.message)),
      (_) => emit(state.copyWith(actionStatus: DriverActionStatus.success)),
    );
  }
}
