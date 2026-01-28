import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adptydemo/service/adapty_service.dart';
import 'package:flutter/cupertino.dart';

class PremiumStatusCard extends StatelessWidget {
  const PremiumStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    // We can safely pass a new Adapty instance here because the service is a singleton
    // and will return the existing instance.
    final adaptyService = AdaptyService(adapty: Adapty());

    return ValueListenableBuilder<bool>(
      valueListenable: adaptyService.isPremium,
      builder: (context, isPremium, child) {
        final backgroundColor = isPremium
            ? CupertinoColors.activeGreen.resolveFrom(context).withOpacity(0.1)
            : CupertinoColors.systemOrange
                  .resolveFrom(context)
                  .withOpacity(0.1);

        final iconColor = isPremium
            ? CupertinoColors.activeGreen.resolveFrom(context)
            : CupertinoColors.systemOrange.resolveFrom(context);

        final title = isPremium ? 'Premium Active' : 'Free Plan';
        final description = isPremium
            ? 'You have full access to all features.'
            : 'Upgrade to Premium to unlock all features.';

        return Container(
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
                    : CupertinoIcons.info_circle_fill,
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
            ],
          ),
        );
      },
    );
  }
}
