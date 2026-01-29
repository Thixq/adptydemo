// ignore_for_file: avoid_catches_without_on_clauses, document_ignores

import 'dart:async';
import 'package:adapty_flutter/adapty_flutter.dart';

import 'package:flutter/foundation.dart';

/// A service class to manage Adapty SDK interactions.
final class AdaptyManager {
  /// Creates an instance of [AdaptyManager].
  AdaptyManager({required Adapty adapty}) : _adapty = adapty;

  final Adapty _adapty;

  /// A notifier that indicates whether the user has premium access.
  final ValueNotifier<bool> isPremium = ValueNotifier(false);

  StreamSubscription<AdaptyProfile>? _profileSubscription;

  /// Initializes the Adapty SDK with the given [apiKey].
  Future<void> initialize({required String apiKey}) async {
    try {
      await _adapty.activate(
        configuration: AdaptyConfiguration(apiKey: apiKey),
      );
    } on AdaptyError catch (e) {
      if (e.code == 3005) {
        debugPrint('AdaptyManager: Adapty already activated.');
      } else {
        debugPrint(
          'AdaptyManager: Activation error: ${e.message} (${e.code})',
        );
        return;
      }
    } catch (e) {
      debugPrint('AdaptyManager: Unexpected activation error: $e');
      return;
    }

    try {
      if (kDebugMode) {
        await _adapty.setLogLevel(AdaptyLogLevel.verbose);
      } else {
        await _adapty.setLogLevel(AdaptyLogLevel.error);
      }

      await _setupProfileListener();

      await _checkInitialSubscriptionStatus();
      debugPrint('AdaptyManager: Successfully initialized.');
    } catch (e) {
      debugPrint('AdaptyManager: Setup error: $e');
    }
  }

  /// Sets up a listener for profile updates.
  Future<void> _setupProfileListener() async {
    await _profileSubscription?.cancel();
    _profileSubscription = _adapty.didUpdateProfileStream.listen((profile) {
      debugPrint('AdaptyManager: Profile update received.');
      _updatePremiumStatus(profile);
    });
  }

  /// Checks the initial subscription status and updates the premium status.
  Future<void> _checkInitialSubscriptionStatus() async {
    try {
      final profile = await _adapty.getProfile();
      _updatePremiumStatus(profile);
    } on AdaptyError catch (e) {
      debugPrint('AdaptyManager: Profile fetch error: ${e.message}');
    }
  }

  /// Updates the premium status based on the given [profile].
  void _updatePremiumStatus(AdaptyProfile profile) {
    final premiumAccess = profile.accessLevels['premium'];

    final isActive = premiumAccess?.isActive ?? false;

    if (isPremium.value != isActive) {
      isPremium.value = isActive;
      debugPrint('AdaptyManager: Premium status updated: $isActive');
    }
  }

  /// Fetches the product information for the given [placementId].
  Future<List<AdaptyPaywallProduct>?> getProduct({
    required String placementId,
  }) async {
    try {
      final paywall = await _adapty.getPaywall(placementId: placementId);
      final products = await _adapty.getPaywallProducts(paywall: paywall);
      return products;
    } on AdaptyError catch (e) {
      debugPrint('AdaptyManager: Get product error: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('AdaptyManager: Unexpected get product error: $e');
      return null;
    }
  }

  /// Initiates a purchase for the given [product].
  Future<void> makePurchase(AdaptyPaywallProduct product) async {
    try {
      final result = await _adapty.makePurchase(product: product);

      switch (result) {
        case final AdaptyPurchaseResultSuccess success:
          _updatePremiumStatus(success.profile);
        case AdaptyPurchaseResultUserCancelled():
          debugPrint('AdaptyManager: User cancelled purchase.');
        case AdaptyPurchaseResultPending():
          debugPrint('AdaptyManager: Purchase pending.');
      }
    } on AdaptyError catch (e) {
      debugPrint('AdaptyManager: Purchase error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('AdaptyManager: Unexpected purchase error: $e');
      rethrow;
    }
  }

  /// Disposes resources used by the AdaptyManager.
  Future<void> dispose() async {
    await _profileSubscription?.cancel();
    isPremium.dispose();
  }
}
