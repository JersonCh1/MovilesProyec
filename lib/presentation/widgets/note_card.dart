import 'package:flutter/material.dart';
import 'package:easynotes_pro/data/models/note.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = note.colorHex != null
        ? Color(int.parse(note.colorHex!.substring(1), radix: 16) + 0xFF000000)
        : Theme.of(context).colorScheme.surfaceVariant;

    return Card(
      color: cardColor,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título y acciones
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title.isEmpty ? 'Sin título' : note.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (note.content.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            note.content,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Acciones
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (note.isPrivate)
                        Icon(
                          Icons.lock,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      const SizedBox(width: 4),
                      if (note.reminderDate != null)
                        Icon(
                          Icons.notifications_active,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: onFavoriteToggle,
                        child: Icon(
                          note.isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: note.isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onDelete,
                        child: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Footer con fecha
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(note.updatedAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}