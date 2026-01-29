import 'package:adptydemo/locator.dart';
import 'package:adptydemo/model/user_profile.dart';
import 'package:adptydemo/service_and_managers/adapty_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// Manages user profile and subscription status.
class UserProfileManager extends ChangeNotifier {
  /// Creates an instance of [UserProfileManager].
  UserProfileManager() {
    _initialize();
  }

  late UserProfile _currentUser;
  final AdaptyManager _adaptyService = locator<AdaptyManager>();

  /// The current user profile.
  UserProfile get currentUser => _currentUser;

  void _initialize() {
    // In a real app, this ID might come from auth service or storage
    final userId = const Uuid().v4();
    _currentUser = UserProfile(id: userId);

    // Listen to Adapty status changes
    _adaptyService.isPremium.addListener(_onPremiumStatusChanged);

    // Set initial status
    _onPremiumStatusChanged();
  }

  void _onPremiumStatusChanged() {
    final isPremium = _adaptyService.isPremium.value;
    _currentUser = _currentUser.copyWith(
      subscriptionType: isPremium
          ? SubscriptionType.premium
          : SubscriptionType.free,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _adaptyService.isPremium.removeListener(_onPremiumStatusChanged);
    super.dispose();
  }
}
