import 'dart:convert';
import 'package:flutter/widgets.dart';

class Shoe {
  final int? id;
  final String name;
  final int size1;
  final Color color;
  final int brandId;
  Shoe({
    this.id,
    required this.name,
    required this.size1,
    required this.color,
    required this.brandId,
  });
  // Convert a shoe into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'size1': size1,
      'color': color.value,
      'brandId': brandId,
    };
  }

  factory Shoe.fromMap(Map<String, dynamic> map) {
    return Shoe(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      size1: map['size1']?.toInt() ?? 0,
      color: Color(map['color']),
      brandId: map['brandId']?.toInt() ?? 0,
    );
  }
  String toJson() => json.encode(toMap());
  factory Shoe.fromJson(String source) => Shoe.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about each shoe when using the print statement.
  @override
  String toString() {
    return 'Shoe(id: $id, name: $name, size1: $size1, color: $color, brandId: $brandId)';
  }
}
