import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easynotes_pro/data/models/note.dart';
import 'package:easynotes_pro/core/database/database_helper.dart';

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredNotesProvider = Provider<List<Note>>((ref) {
  final notes = ref.watch(notesProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  if (searchQuery.isEmpty) {
    return notes;
  }

  return notes.where((note) {
    return note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        note.content.toLowerCase().contains(searchQuery.toLowerCase());
  }).toList();
});

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    final notes = await DatabaseHelper.instance.getAllNotes();
    state = notes;
  }

  Future<void> addNote(Note note) async {
    final id = await DatabaseHelper.instance.insertNote(note);
    final newNote = note.copyWith(id: id);
    state = [newNote, ...state];
  }

  Future<void> updateNote(Note note) async {
    await DatabaseHelper.instance.updateNote(note);
    state = state.map((n) => n.id == note.id ? note : n).toList();
  }

  Future<void> deleteNote(int id) async {
    await DatabaseHelper.instance.deleteNote(id);
    state = state.where((note) => note.id != id).toList();
  }

  Future<void> toggleFavorite(Note note) async {
    final updatedNote = note.copyWith(
      isFavorite: !note.isFavorite,
      updatedAt: DateTime.now(),
    );
    await updateNote(updatedNote);
  }
}