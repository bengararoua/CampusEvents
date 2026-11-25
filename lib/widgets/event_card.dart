import 'package:flutter/material.dart';

import '../models/event.dart';
import 'favorite_button.dart';
import 'info_pill.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  Widget _dateBadge(BuildContext context) {
    final parsed = DateTime.tryParse(event.date);
    if (parsed == null) return const SizedBox.shrink();

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Positioned(
      top: 6,
      left: 6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              event.day,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
            Text(
              event.monthShort,
              style: textTheme.labelSmall?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 84,
                      height: 84,
                      child: Image.asset(
                        event.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: colors.primaryContainer,
                            child: Icon(
                              Icons.image_not_supported,
                              color: colors.onPrimaryContainer,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  _dateBadge(context),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${event.location} • ${event.time}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    InfoPill(
                      text: event.category,
                      background: colors.primary.withValues(alpha: 0.12),
                      foreground: colors.primary,
                    ),
                  ],
                ),
              ),
              if (onFavoriteToggle != null)
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: colors.surfaceContainerHigh,
                  ),
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? colors.error : colors.onSurfaceVariant,
                  ),
                  onPressed: onFavoriteToggle,
                )
              else
                FavoriteButton(event: event),
            ],
          ),
        ),
      ),
    );
  }
}
