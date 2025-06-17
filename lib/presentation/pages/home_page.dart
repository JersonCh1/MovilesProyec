import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easynotes_pro/presentation/providers/notes_provider.dart';
import 'package:easynotes_pro/presentation/widgets/note_card.dart';
import 'package:easynotes_pro/presentation/widgets/search_bar.dart';
import 'package:easynotes_pro/presentation/pages/note_detail_page.dart';
import 'package:easynotes_pro/presentation/pages/security_settings_page.dart';
import 'package:easynotes_pro/data/models/note.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(filteredNotesProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyNotes Pro'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
        actions: [
          // Botón de filtros
          IconButton(
            onPressed: () => _showFilterDialog(context, ref),
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtros',
          ),
          // Botón de configuración de seguridad
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SecuritySettingsPage(),
                ),
              );
            },
            icon: const Icon(Icons.security),
            tooltip: 'Configuración de Seguridad',
          ),
          // Menú de opciones
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Configuración'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info),
                    SizedBox(width: 8),
                    Text('Acerca de'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchBar(
              searchQuery: searchQuery,
              onChanged: (query) {
                ref.read(searchQueryProvider.notifier).state = query;
              },
            ),
          ),

          // Chips de filtros rápidos
          _buildQuickFilters(context, ref),

          // Lista de notas
          Expanded(
            child: notes.isEmpty
                ? const EmptyNotesView()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: NoteCard(
                    note: note,
                    onTap: () => _openNoteDetail(context, note),
                    onFavoriteToggle: () {
                      ref.read(notesProvider.notifier).toggleFavorite(note);
                    },
                    onDelete: () {
                      _showDeleteDialog(context, ref, note);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNoteDetail(context, null),
        tooltip: 'Crear nueva nota',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuickFilters(BuildContext context, WidgetRef ref) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(
            context: context,
            label: 'Todas',
            icon: Icons.notes,
            isSelected: true, // Por ahora siempre seleccionado
            onTap: () {
              // TODO: Implementar filtro "Todas"
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context: context,
            label: 'Favoritas',
            icon: Icons.favorite,
            isSelected: false,
            onTap: () {
              // TODO: Implementar filtro "Favoritas"
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filtro de favoritas próximamente'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context: context,
            label: 'Privadas',
            icon: Icons.lock,
            isSelected: false,
            onTap: () {
              // TODO: Implementar filtro "Privadas"
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filtro de privadas próximamente'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            context: context,
            label: 'Recientes',
            icon: Icons.access_time,
            isSelected: false,
            onTap: () {
              // TODO: Implementar filtro "Recientes"
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filtro de recientes próximamente'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: isSelected
          ? Theme.of(context).colorScheme.primary
          : null,
      selectedColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  void _openNoteDetail(BuildContext context, Note? note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(note: note),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: const Text('¿Estás seguro de que quieres eliminar esta nota?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              ref.read(notesProvider.notifier).deleteNote(note.id!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Nota eliminada'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtros avanzados'),
        content: const Text('Filtros avanzados próximamente'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Configuración general próximamente'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'about':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Acerca de EasyNotes Pro'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('EasyNotes Pro v1.0.0'),
                SizedBox(height: 8),
                Text('Una aplicación avanzada de notas con funcionalidades premium.'),
                SizedBox(height: 8),
                Text('Características:'),
                Text('• Notas con multimedia'),
                Text('• Seguridad biométrica'),
                Text('• Sincronización en la nube'),
                Text('• Recordatorios inteligentes'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
        break;
    }
  }
}

class EmptyNotesView extends StatelessWidget {
  const EmptyNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay notas',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón + para crear tu primera nota',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navegar a crear nota
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoteDetailPage(note: null),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Crear primera nota'),
          ),
        ],
      ),
    );
  }
}