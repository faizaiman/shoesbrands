import 'dart:convert';

class Brand {
  final int? id;
  final String name;
  final String description;
  Brand({
    this.id,
    required this.name,
    required this.description,
  });
  // Convert a Brand into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Brand.fromMap(Map<String, dynamic> map) {
    return Brand(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());
  factory Brand.fromJson(String source) => Brand.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about
  // each brandd when using the print statement.
  @override
  String toString() => 'Brand(id: $id, name: $name, description: $description)';
}
