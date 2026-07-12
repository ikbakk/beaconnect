import 'package:flutter/material.dart';
import '../../../../design/colors/bcg_colors.dart';
import '../../../../design/spacing/bcg_spacing.dart';
import '../../../../design/spacing/bcg_radius.dart';
import '../../../updates/domain/update_story.dart';

/// Home screen update chip - matches design/prototype/beaconnect.css
/// Compact update preview shown on home screen
class HomeUpdateCard extends StatelessWidget {
  const HomeUpdateCard({
    super.key,
    required this.update,
    this.onTap,
  });

  final UpdateStory update;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BcgColors.surfaceVariant,
      borderRadius: BcgRadius.borderMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: BcgRadius.borderMd,
        child: Padding(
          padding: const EdgeInsets.all(BcgSpacing.s3 + 2), // 14px
          child: Row(
            children: [
              // Icon
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: BcgColors.surface,
                  borderRadius: BcgRadius.borderSm,
                ),
                child: Center(
                  child: IconTheme(
                    data: IconThemeData(
                      color: BcgColors.fgMuted,
                      size: 14,
                    ),
                    child: _getIcon(update.type),
                  ),
                ),
              ),

              const SizedBox(width: BcgSpacing.s3),

              // Text
              Expanded(
                child: Text(
                  update.title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: BcgColors.fg,
                    height: 1.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Time
              Text(
                update.timeLabel,
                style: const TextStyle(
                  fontFamily: 'IBM Plex Mono',
                  fontSize: 10,
                  color: BcgColors.fgMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getIcon(String type) {
    switch (type) {
      case 'checkin':
        return const Icon(Icons.check_circle_outline, size: 14);
      case 'arrival':
        return const Icon(Icons.home_outlined, size: 14);
      case 'departure':
        return const Icon(Icons.logout, size: 14);
      case 'live':
        return const Icon(Icons.radar, size: 14);
      case 'reaction':
        return const Icon(Icons.favorite_outline, size: 14);
      default:
        return const Icon(Icons.notifications_outlined, size: 14);
    }
  }
}
