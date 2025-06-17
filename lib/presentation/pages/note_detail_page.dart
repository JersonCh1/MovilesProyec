import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easynotes_pro/data/models/note.dart';
import 'package:easynotes_pro/presentation/providers/notes_provider.dart';
//import 'package:easynotes_pro/services/notification_service.dart';

class NoteDetailPage extends ConsumerStatefulWidget {
  final Note? note;

  const NoteDetailPage({super.key, this.note});

  @override
  ConsumerState<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends ConsumerState<NoteDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late bool _isFavorite;
  late bool _isPrivate;
  DateTime? _reminderDate;
  String? _colorHex;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _isFavorite = widget.note?.isFavorite ?? false;
    _isPrivate = widget.note?.isPrivate ?? false;
    _reminderDate = widget.note?.reminderDate;
    _colorHex = widget.note?.colorHex;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Nueva Nota' : 'Editar Nota'),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
          ),
          IconButton(
            icon: Icon(
              _isPrivate ? Icons.lock : Icons.lock_open,
              color: _isPrivate ? Theme.of(context).colorScheme.primary : null,
            ),
            onPressed: () {
              setState(() {
                _isPrivate = !_isPrivate;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de herramientas
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Selector de color
                GestureDetector(
                  onTap: _showColorPicker,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _colorHex != null
                          ? Color(int.parse(_colorHex!.substring(1), radix: 16) + 0xFF000000)
                          : Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _colorHex == null
                        ? const Icon(Icons.palette, size: 16)
                        : null,
                  ),
                ),
                const SizedBox(width: 16),

                // Recordatorio
                IconButton(
                  icon: Icon(
                    _reminderDate != null ? Icons.notifications_active : Icons.notifications_none,
                    color: _reminderDate != null ? Theme.of(context).colorScheme.primary : null,
                  ),
                  onPressed: _showReminderPicker,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Campos de texto
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Título de la nota...',
                      border: InputBorder.none,
                    ),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        hintText: 'Escribe tu nota aquí...',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La nota no puede estar vacía')),
      );
      return;
    }

    final now = DateTime.now();
    final note = Note(
      id: widget.note?.id,
      title: title.isEmpty ? 'Sin título' : title,
      content: content,
      createdAt: widget.note?.createdAt ?? now,
      updatedAt: now,
      isFavorite: _isFavorite,
      isPrivate: _isPrivate,
      reminderDate: _reminderDate,
      colorHex: _colorHex,
    );

    if (widget.note == null) {
      await ref.read(notesProvider.notifier).addNote(note);
    } else {
      await ref.read(notesProvider.notifier).updateNote(note);
    }

    // Programar recordatorio si existe
    //if (_reminderDate != null) {
      //await NotificationService.instance.scheduleNotification(
        //id: note.id ?? 0,
        //title: 'Recordatorio de nota',
        //body: note.title,
        //scheduledDate: _reminderDate!,
      //);
    //}

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar color'),
        content: SizedBox(
          width: 300,
          height: 200,
          child: GridView.count(
            crossAxisCount: 4,
            children: [
              '#FF5722', '#E91E63', '#9C27B0', '#673AB7',
              '#3F51B5', '#2196F3', '#03A9F4', '#00BCD4',
              '#009688', '#4CAF50', '#8BC34A', '#CDDC39',
              '#FFEB3B', '#FFC107', '#FF9800', '#FF5722',
            ].map((color) => GestureDetector(
              onTap: () {
                setState(() {
                  _colorHex = color;
                });
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color(int.parse(color.substring(1), radix: 16) + 0xFF000000),
                  shape: BoxShape.circle,
                ),
              ),
            )).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _colorHex = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Sin color'),
          ),
        ],
      ),
    );
  }

  void _showReminderPicker() {
    showDatePicker(
      context: context,
      initialDate: _reminderDate ?? DateTime.now().add(const Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((date) {
      if (date != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(
            _reminderDate ?? DateTime.now().add(const Duration(hours: 1)),
          ),
        ).then((time) {
          if (time != null) {
            setState(() {
              _reminderDate = DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              );
            });
          }
        });
      }
    });
  }
}