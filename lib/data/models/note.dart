class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final bool isPrivate;
  final int? categoryId;
  final DateTime? reminderDate;
  final String? colorHex;
  final List<String> tags;
  final List<String> attachments;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.isPrivate = false,
    this.categoryId,
    this.reminderDate,
    this.colorHex,
    this.tags = const [],
    this.attachments = const [],
  });

  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    bool? isPrivate,
    int? categoryId,
    DateTime? reminderDate,
    String? colorHex,
    List<String>? tags,
    List<String>? attachments,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isPrivate: isPrivate ?? this.isPrivate,
      categoryId: categoryId ?? this.categoryId,
      reminderDate: reminderDate ?? this.reminderDate,
      colorHex: colorHex ?? this.colorHex,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isFavorite': isFavorite ? 1 : 0,
      'isPrivate': isPrivate ? 1 : 0,
      'categoryId': categoryId,
      'reminderDate': reminderDate?.millisecondsSinceEpoch,
      'colorHex': colorHex,
      'tags': tags.join(','),
      'attachments': attachments.join(','),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      isFavorite: map['isFavorite'] == 1,
      isPrivate: map['isPrivate'] == 1,
      categoryId: map['categoryId'],
      reminderDate: map['reminderDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['reminderDate'])
          : null,
      colorHex: map['colorHex'],
      tags: map['tags'] != null && map['tags'].isNotEmpty
          ? map['tags'].split(',')
          : [],
      attachments: map['attachments'] != null && map['attachments'].isNotEmpty
          ? map['attachments'].split(',')
          : [],
    );
  }
}