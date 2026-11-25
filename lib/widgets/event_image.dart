import 'package:flutter/material.dart';

class EventImage extends StatelessWidget {
  final String url;

  const EventImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.asset(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: colors.primaryContainer,
              child: Icon(Icons.event, size: 48, color: colors.primary),
            );
          },
        ),
      ),
    );
  }
}
