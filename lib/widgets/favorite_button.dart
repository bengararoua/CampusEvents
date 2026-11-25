import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../providers/event_provider.dart';

class FavoriteButton extends StatelessWidget {
  final Event event;

  const FavoriteButton({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isFavorite = context.select<EventProvider, bool>(
      (provider) => provider.isFavorite(event.id),
    );

    return IconButton(
      tooltip: isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
      style: IconButton.styleFrom(
        backgroundColor: colors.surfaceContainerLowest,
      ),
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? colors.error : colors.onSurfaceVariant,
      ),
      onPressed: () => context.read<EventProvider>().toggleFavorite(event.id),
    );
  }
}
