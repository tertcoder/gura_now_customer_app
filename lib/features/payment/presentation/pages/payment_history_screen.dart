import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/payment_history_model.dart';
import '../bloc/payment_bloc.dart';

/// Screen for viewing payment history.
class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentBloc>().add(const PaymentHistoryLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'fr_BI',
      symbol: '',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Historique des Paiements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PaymentBloc>().add(const PaymentHistoryLoadRequested()),
          ),
        ],
      ),
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          switch (state.historyStatus) {
            case PaymentListStatus.loading:
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              );
            case PaymentListStatus.failure:
              return EmptyState.error(
                message: state.historyError ?? 'Erreur',
                onRetry: () => context.read<PaymentBloc>().add(const PaymentHistoryLoadRequested()),
              );
            case PaymentListStatus.success:
              final payments = state.history
                  .map((e) => PaymentHistoryItemModel.fromJson(e as Map<String, dynamic>))
                  .toList();
              if (payments.isEmpty) {
                return const EmptyState(
                  icon: Icons.receipt_long,
                  title: 'Aucun paiement',
                  subtitle: 'Votre historique de paiements apparaîtra ici',
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PaymentBloc>().add(const PaymentHistoryLoadRequested());
                },
                color: AppColors.accent,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final payment = payments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _PaymentHistoryCard(
                        payment: payment,
                        currencyFormat: currencyFormat,
                      ),
                    );
                  },
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _PaymentHistoryCard extends StatelessWidget {
  const _PaymentHistoryCard({
    required this.payment,
    required this.currencyFormat,
  });
  final PaymentHistoryItemModel payment;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getTypeColor(payment.type).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getTypeIcon(payment.type),
                color: _getTypeColor(payment.type),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getTypeLabel(payment.type),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      StatusBadge.fromStatus(payment.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    payment.orderNumber ?? '',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(payment.createdAt),
                    style: const TextStyle(
                      color: AppColors.textDisabled,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${payment.isRefund ? '-' : '+'}${currencyFormat.format(payment.amount)} ${payment.currency}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: payment.isRefund ? AppColors.danger : AppColors.success,
              ),
            ),
          ],
        ),
      );

  Color _getTypeColor(String type) {
    switch (type) {
      case 'order_payment':
      case 'payment':
        return AppColors.success;
      case 'refund':
        return AppColors.danger;
      case 'commission':
        return AppColors.accentPurple;
      default:
        return AppColors.info;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'order_payment':
      case 'payment':
        return Icons.shopping_bag;
      case 'refund':
        return Icons.replay;
      case 'commission':
        return Icons.percent;
      default:
        return Icons.payment;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'order_payment':
      case 'payment':
        return 'Paiement de commande';
      case 'refund':
        return 'Remboursement';
      case 'commission':
        return 'Commission';
      default:
        return 'Paiement';
    }
  }

  String _formatDate(DateTime date) =>
      DateFormat('dd MMM yyyy, HH:mm', 'fr_FR').format(date);
}
