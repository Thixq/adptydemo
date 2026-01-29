import 'dart:async';

import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adptydemo/locator.dart';
import 'package:adptydemo/service_and_managers/adapty_manager.dart';
import 'package:flutter/cupertino.dart';

/// A bottom sheet widget that displays the paywall and allows purchasing products.
class PaywallSheet extends StatefulWidget {
  /// Creates a [PaywallSheet] instance.
  const PaywallSheet({super.key});

  @override
  State<PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends State<PaywallSheet> {
  final AdaptyManager _adaptyManager = locator<AdaptyManager>();
  List<AdaptyPaywallProduct>? _products;
  bool _isLoading = true;
  bool _isPurchasing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    unawaited(_loadProducts());
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Replace 'paywall_main' with your actual placement ID from Adapty Dashboard
      final products = await _adaptyManager.getProduct(
        placementId: 'demo_placement',
      );
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load products. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onPurchase(AdaptyPaywallProduct product) async {
    setState(() {
      _isPurchasing = true;
    });

    try {
      await _adaptyManager.makePurchase(product);
      if (mounted) {
        Navigator.of(context).pop(); // Close paywall on success
      }
    } catch (e) {
      if (mounted) {
        await showCupertinoDialog<void>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Purchase Failed'),
            content: Text(e.toString()),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPurchasing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey3.resolveFrom(context),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Unlock Premium',
                  style: theme.textTheme.navTitleTextStyle.copyWith(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Get unlimited access to all features.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.textStyle.copyWith(
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: CupertinoColors.systemRed),
            ),
            const SizedBox(height: 16),
            CupertinoButton(
              onPressed: _loadProducts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_products == null || _products!.isEmpty) {
      return const Center(
        child: Text('No products available.'),
      );
    }

    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _products!.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final product = _products![index];
            return _ProductItem(
              product: product,
              onTap: () => _onPurchase(product),
            );
          },
        ),
        if (_isPurchasing)
          ColoredBox(
            color: CupertinoColors.systemBackground
                .resolveFrom(context)
                .withOpacity(0.5),
            child: const Center(
              child: CupertinoActivityIndicator(radius: 20),
            ),
          ),
      ],
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({
    required this.product,
    required this.onTap,
  });

  final AdaptyPaywallProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: CupertinoColors.separator.resolveFrom(context),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.localizedTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (product.localizedDescription.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      product.localizedDescription,
                      style: TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.secondaryLabel.resolveFrom(
                          context,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              product.price.localizedString ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: CupertinoColors.activeBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
