import 'package:adptydemo/component/paywall_sheet.dart';
import 'package:adptydemo/locator.dart';
import 'package:adptydemo/service_and_managers/user_profile_manager.dart';
import 'package:flutter/cupertino.dart';

/// A card widget that displays the user's premium status.
class PremiumStatusCard extends StatelessWidget {
  /// Creates a [PremiumStatusCard] instance.
  const PremiumStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    final userProfileManager = locator<UserProfileManager>();

    return AnimatedBuilder(
      animation: userProfileManager,
      builder: (context, _) {
        final isPremium =
            userProfileManager.currentUser.subscriptionType.isPremium;

        final backgroundColor = isPremium
            ? CupertinoColors.activeGreen.resolveFrom(context).withOpacity(0.1)
            : CupertinoColors.systemOrange
                  .resolveFrom(context)
                  .withOpacity(0.1);

        final iconColor = isPremium
            ? CupertinoColors.activeGreen.resolveFrom(context)
            : CupertinoColors.systemOrange.resolveFrom(context);

        final title = isPremium ? 'Premium Active' : 'Free Plan';
        // Add CTA if not premium
        final description = isPremium
            ? 'You have full access to all features.'
            : 'Upgrade to Premium to unlock all features. Tap to view plans.';

        final card = Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: iconColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isPremium
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.star_fill, // Changed icon for free plan
                color: iconColor,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.textStyle.copyWith(
                        fontSize: 12,
                        color: CupertinoColors.label.resolveFrom(context),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isPremium) ...[
                const SizedBox(width: 8),
                Icon(
                  CupertinoIcons.chevron_right,
                  color: iconColor.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ],
          ),
        );

        if (isPremium) return card;

        return GestureDetector(
          onTap: () {
            showCupertinoModalPopup<void>(
              context: context,
              builder: (context) => const PaywallSheet(),
            );
          },
          child: card,
        );
      },
    );
  }
}
