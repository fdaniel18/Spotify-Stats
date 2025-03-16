class TrackModel {
  final String id;
  final String spotify_id;
  final String name;
  final String author;
  final String image300;
  final String image64;
  final double valence;
  final double energy;
  String date;

  TrackModel({
    required this.id,
    required this.spotify_id,
    required this.name,
    required this.author,
    required this.image300,
    required this.image64,
    required this.valence,
    required this.energy,
    String? date,
  }) : date = date ?? '';

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
      id: json['id'].toString(),
      spotify_id: json['spotify_id'],
      name: json['name'],
      author: json['author'],
      image300: json['image300'],
      image64: json['image64'],
      valence: json['valence'].toDouble(),
      energy: json['energy'].toDouble(),
      date: json['date']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spotify_id': spotify_id,
      'name': name,
      'author': author,
      'image300': image300,
      'image64': image64,
      'valence': valence,
      'energy': energy,
      'date': date,
    };
  }
}