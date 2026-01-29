/// A model representing a user's profile and subscription details.
enum SubscriptionType {
  /// Free subscription type with limited features.
  free,

  /// Premium subscription type with full features.
  premium;

  /// Returns true if the subscription type is premium.
  bool get isPremium => this == SubscriptionType.premium;
}

/// A class representing a user's profile.
final class UserProfile {
  /// Creates a [UserProfile] instance.
  UserProfile({
    required this.id,
    this.subscriptionType = SubscriptionType.free,
    this.maxFreeNotes = 3,
  });

  /// The unique identifier of the user.
  final String id;

  /// The subscription type of the user.
  SubscriptionType subscriptionType;

  /// The maximum number of notes allowed for free users.
  final int maxFreeNotes;

  /// Returns true if the user can create a new note based on their subscription.
  bool get canCreateNote {
    if (subscriptionType.isPremium) return true;
    return false; // Dynamic check will be done in manager based on current count
  }

  /// Creates a copy of this [UserProfile] with the given fields replaced by new values.
  UserProfile copyWith({
    String? id,
    SubscriptionType? subscriptionType,
    int? maxFreeNotes,
  }) {
    return UserProfile(
      id: id ?? this.id,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      maxFreeNotes: maxFreeNotes ?? this.maxFreeNotes,
    );
  }
}
