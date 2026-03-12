import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/payment_proof.dart';
import '../bloc/payment_bloc.dart';

/// Screen for shop owners to validate payment proofs.
class PaymentValidationScreen extends StatefulWidget {
  const PaymentValidationScreen({super.key});

  @override
  State<PaymentValidationScreen> createState() => _PaymentValidationScreenState();
}

class _PaymentValidationScreenState extends State<PaymentValidationScreen> {
  @override
  void initState() {
    super.initState();
    // Load pending payment proofs
    context.read<PaymentBloc>().add(const PaymentProofsLoadRequested(status: 'pending'));
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
        title: const Text('Validation des Paiements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PaymentBloc>().add(const PaymentProofsLoadRequested(status: 'pending')),
          ),
        ],
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state.actionStatus == PaymentActionStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Action effectuée avec succès'),
                backgroundColor: AppColors.success,
              ),
            );
            // Reload proofs after action
            context.read<PaymentBloc>().add(const PaymentProofsLoadRequested(status: 'pending'));
          } else if (state.actionStatus == PaymentActionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erreur: ${state.actionError ?? 'Erreur inconnue'}'),
                backgroundColor: AppColors.danger,
              ),
            );
          }
        },
        builder: (context, state) {
          switch (state.proofsStatus) {
            case PaymentListStatus.loading:
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              );
            case PaymentListStatus.failure:
              return EmptyState.error(
                message: state.proofsError ?? 'Erreur',
                onRetry: () => context.read<PaymentBloc>().add(const PaymentProofsLoadRequested(status: 'pending')),
              );
            case PaymentListStatus.success:
              final proofs = state.proofs;
              if (proofs.isEmpty) {
                return const EmptyState(
                  icon: Icons.verified,
                  title: 'Aucune preuve en attente',
                  subtitle: 'Les nouvelles preuves de paiement apparaîtront ici',
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PaymentBloc>().add(const PaymentProofsLoadRequested(status: 'pending'));
                },
                color: AppColors.accent,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: proofs.length,
                  itemBuilder: (context, index) {
                    final proof = proofs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _PaymentProofCard(
                        proof: proof,
                        currencyFormat: currencyFormat,
                        onValidate: () => _showValidationDialog(context, proof),
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

  void _showValidationDialog(BuildContext context, PaymentProof proof) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ValidationModal(
        proof: proof,
        onApprove: () {
          Navigator.pop(context);
          context.read<PaymentBloc>().add(PaymentProofValidateRequested(
            proofId: proof.id,
            status: 'approved',
          ));
        },
        onReject: (reason) {
          Navigator.pop(context);
          context.read<PaymentBloc>().add(PaymentProofValidateRequested(
            proofId: proof.id,
            status: 'rejected',
            rejectionReason: reason,
          ));
        },
      ),
    );
  }
}

class _PaymentProofCard extends StatelessWidget {
  const _PaymentProofCard({
    required this.proof,
    required this.currencyFormat,
    required this.onValidate,
  });
  final PaymentProof proof;
  final NumberFormat currencyFormat;
  final VoidCallback onValidate;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.pending_actions,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        proof.orderNumber ?? 'Commande',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        proof.uploaderName ?? 'Client',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge.fromStatus(proof.status),
              ],
            ),
            const SizedBox(height: 16),
            if (proof.imageUrls.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: proof.imageUrls.length,
                  itemBuilder: (context, index) {
                    final imageUrl = proof.imageUrls[index]['url'] as String?;
                    return Padding(
                      padding: EdgeInsets.only(
                          right: index < proof.imageUrls.length - 1 ? 8 : 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                width: 80,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 80,
                                  height: 100,
                                  color: AppColors.surfaceContainer,
                                  child: const Icon(Icons.image,
                                      color: AppColors.textSecondary),
                                ),
                              )
                            : Container(
                                width: 80,
                                height: 100,
                                color: AppColors.surfaceContainer,
                                child: const Icon(Icons.image,
                                    color: AppColors.textSecondary),
                              ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Vérifier',
              onPressed: onValidate,
              icon: Icons.visibility,
            ),
          ],
        ),
      );
}

class _ValidationModal extends StatefulWidget {
  const _ValidationModal({
    required this.proof,
    required this.onApprove,
    required this.onReject,
  });
  final PaymentProof proof;
  final VoidCallback onApprove;
  final void Function(String reason) onReject;

  @override
  State<_ValidationModal> createState() => _ValidationModalState();
}

class _ValidationModalState extends State<_ValidationModal> {
  final _reasonController = TextEditingController();
  bool _isApproving = false;
  bool _isRejecting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    'Vérification du paiement',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                itemCount: widget.proof.imageUrls.length,
                itemBuilder: (context, index) {
                  final imageUrl =
                      widget.proof.imageUrls[index]['url'] as String?;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Container(
                                color: AppColors.surfaceContainer,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 64,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              color: AppColors.surfaceContainer,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 64,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Rejeter',
                        onPressed: _isApproving
                            ? null
                            : () {
                                _showRejectDialog();
                              },
                        isLoading: _isRejecting,
                        isOutlined: true,
                        backgroundColor: AppColors.danger,
                        foregroundColor: AppColors.danger,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        label: 'Approuver',
                        onPressed: _isRejecting
                            ? null
                            : () {
                                setState(() => _isApproving = true);
                                widget.onApprove();
                              },
                        isLoading: _isApproving,
                        backgroundColor: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  void _showRejectDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Raison du rejet'),
        content: TextField(
          controller: _reasonController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Expliquez pourquoi ce paiement est rejeté...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isRejecting = true);
              widget.onReject(_reasonController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}
