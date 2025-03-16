class History {
  int _id;
  String _type;
  DateTime _date;

  History({
    required int id,
    required String type,
    required DateTime date,
  })  : _id = id,
        _type = type,
        _date = date;

  // Getters
  int get id => _id;
  String get type => _type;
  DateTime get date => _date;

  // Setters
  set type(String value) {
    _type = value;
  }

  set dateCreated(DateTime value) {
    _date = value;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'type': _type,
      'date': _date.toIso8601String(),
    };
  }

  // Create a factory constructor to initialize from JSON
  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'] as int,
      type: json['type'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  @override
  String toString() {
    return 'history{id: $_id, type: $_type, date: $_date}';
  }
}