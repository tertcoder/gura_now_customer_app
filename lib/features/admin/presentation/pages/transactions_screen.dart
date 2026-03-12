import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/admin_bloc.dart';

/// Admin screen for viewing all transactions.
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedType = 'all';
  DateTimeRange? _dateRange;

  final List<Map<String, String>> _typeFilters = [
    {'value': 'all', 'label': 'Tous'},
    {'value': 'order_payment', 'label': 'Paiements'},
    {'value': 'commission', 'label': 'Commissions'},
    {'value': 'refund', 'label': 'Remboursements'},
    {'value': 'payout', 'label': 'Versements'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const AdminTransactionsRequested());
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
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _selectDateRange,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AdminBloc>().add(AdminTransactionsRequested(type: _selectedType == 'all' ? null : _selectedType)),
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<AdminBloc, AdminState>(
            buildWhen: (prev, next) => prev.transactionsStatus != next.transactionsStatus || prev.transactions != next.transactions,
            builder: (context, state) {
              if (state.transactionsStatus == AdminListStatus.success) {
                final transactions = state.transactions
                    .map((e) => e as Map<String, dynamic>)
                    .toList();
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: _SummaryCards(
                    transactions: transactions,
                    currencyFormat: currencyFormat,
                  ),
                );
              }
              return Container(
                padding: const EdgeInsets.all(16),
                child: const _SummaryCardsSkeleton(),
              );
            },
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _typeFilters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _typeFilters[index];
                final isSelected = _selectedType == filter['value'];
                return FilterChip(
                  label: Text(filter['label']!),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = filter['value']!;
                    });
                    context.read<AdminBloc>().add(AdminTransactionsRequested(type: _selectedType == 'all' ? null : _selectedType));
                  },
                  backgroundColor: AppColors.surfaceContainer,
                  selectedColor: AppColors.accent.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color:
                        isSelected ? AppColors.accent : AppColors.textSecondary,
                  ),
                  side: BorderSide.none,
                );
              },
            ),
          ),
          if (_dateRange != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text(
                    '${DateFormat('dd/MM').format(_dateRange!.start)} - ${DateFormat('dd/MM').format(_dateRange!.end)}',
                  ),
                  onDeleted: () {
                    setState(() => _dateRange = null);
                  },
                  backgroundColor: AppColors.surfaceContainer,
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  deleteIconColor: AppColors.textSecondary,
                ),
              ),
            ),
          Expanded(
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                switch (state.transactionsStatus) {
                  case AdminListStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    );
                  case AdminListStatus.failure:
                    return EmptyState.error(
                      message: state.transactionsError ?? 'Erreur',
                      onRetry: () => context.read<AdminBloc>().add(const AdminTransactionsRequested()),
                    );
                  case AdminListStatus.success:
                    final transactions = state.transactions
                        .map((e) => e as Map<String, dynamic>)
                        .toList();
                    final filtered = _filterTransactions(transactions);

                    if (filtered.isEmpty) {
                      return const EmptyState(
                        icon: Icons.receipt_long,
                        title: 'Aucune transaction',
                        subtitle: 'Les transactions apparaîtront ici',
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async =>
                          context.read<AdminBloc>().add(AdminTransactionsRequested(type: _selectedType == 'all' ? null : _selectedType)),
                      color: AppColors.accent,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final transaction = filtered[index];
                          return _TransactionTile(
                            transaction: transaction,
                            currencyFormat: currencyFormat,
                          );
                        },
                      ),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _filterTransactions(
          List<Map<String, dynamic>> transactions) =>
      transactions.where((t) {
        if (_selectedType != 'all' && t['type'] != _selectedType) {
          return false;
        }
        if (_dateRange != null) {
          try {
            final date = DateTime.parse(t['created_at'] as String);
            if (date.isBefore(_dateRange!.start) ||
                date.isAfter(_dateRange!.end.add(const Duration(days: 1)))) {
              return false;
            }
          } catch (_) {}
        }
        return true;
      }).toList();

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            surface: AppColors.surface,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({
    required this.transactions,
    required this.currencyFormat,
  });
  final List<Map<String, dynamic>> transactions;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    double totalPayments = 0;
    double totalCommissions = 0;
    double totalRefunds = 0;

    for (final t in transactions) {
      final amount = (t['amount'] as num?)?.toDouble() ?? 0;
      switch (t['type']) {
        case 'order_payment':
          totalPayments += amount;
          break;
        case 'commission':
          totalCommissions += amount;
          break;
        case 'refund':
          totalRefunds += amount;
          break;
      }
    }

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Paiements',
            value: currencyFormat.format(totalPayments),
            icon: Icons.payments,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            label: 'Commissions',
            value: currencyFormat.format(totalCommissions),
            icon: Icons.percent,
            color: AppColors.accentPurple,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            label: 'Remboursements',
            value: currencyFormat.format(totalRefunds),
            icon: Icons.replay,
            color: AppColors.danger,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => AppCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
}

class _SummaryCardsSkeleton extends StatelessWidget {
  const _SummaryCardsSkeleton();

  @override
  Widget build(BuildContext context) => const Row(
        children: [
          Expanded(child: ShimmerLoading(height: 80)),
          SizedBox(width: 8),
          Expanded(child: ShimmerLoading(height: 80)),
          SizedBox(width: 8),
          Expanded(child: ShimmerLoading(height: 80)),
        ],
      );
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.transaction,
    required this.currencyFormat,
  });
  final Map<String, dynamic> transaction;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    final type = transaction['type'] as String? ?? 'payment';
    final amount = (transaction['amount'] as num?)?.toDouble() ?? 0;
    final isNegative = type == 'refund' || type == 'payout';

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getTypeColor(type).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getTypeIcon(type),
              color: _getTypeColor(type),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getTypeLabel(type),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction['reference'] as String? ??
                      transaction['order_number'] as String? ??
                      '',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isNegative ? '-' : '+'}${currencyFormat.format(amount)} BIF',
                style: TextStyle(
                  color: isNegative ? AppColors.danger : AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatDate(transaction['created_at'] as String?),
                style: const TextStyle(
                  color: AppColors.textDisabled,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'order_payment':
        return AppColors.success;
      case 'commission':
        return AppColors.accentPurple;
      case 'refund':
        return AppColors.danger;
      case 'payout':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'order_payment':
        return Icons.payments;
      case 'commission':
        return Icons.percent;
      case 'refund':
        return Icons.replay;
      case 'payout':
        return Icons.account_balance;
      default:
        return Icons.receipt;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'order_payment':
        return 'Paiement de commande';
      case 'commission':
        return 'Commission plateforme';
      case 'refund':
        return 'Remboursement';
      case 'payout':
        return 'Versement boutique';
      default:
        return 'Transaction';
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM HH:mm').format(date);
    } catch (_) {
      return '';
    }
  }
}
