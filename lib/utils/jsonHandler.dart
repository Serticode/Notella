class JsonNote {
  int id, priority;
  String title, description, date;

  JsonNote(this.id, this.title, this.date, this.priority, this.description);

  Map toJson() => {
        'ID': id,
        'Title': title,
        'Date': date,
        'Priority': priority,
        'Description': description,
      };

  factory JsonNote.fromJson(dynamic json) {
    return JsonNote(
      json['ID'] as int,
      json['Title'] as String,
      json['Date'] as String,
      json['Priority'] as int,
      json['Description'] as String,
    );
  }

  @override
  String toString() {
    return '{${this.id}, ${this.title}, ${this.date}, ${this.priority} ${this.description} }';
  }
}
