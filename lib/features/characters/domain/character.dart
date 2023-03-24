import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Character {
  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.image,
    required this.created,
  });

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] as String? ?? '0',
      name: map['name'] as String? ?? '',
      status: map['status'] as String? ?? '',
      species: map['species'] as String? ?? '',
      type: map['type'] as String? ?? '',
      gender: map['gender'] as String? ?? '',
      image: map['image'] as String? ?? '',
      created: map['created'] as String? ?? '',
    );
  }

  factory Character.fromJson(String source) =>
      Character.fromMap(jsonDecode(source) as Map<String, dynamic>);

  final String id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String image;
  final String created;

  Character copyWith({
    String? id,
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
    String? image,
    String? created,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'image': image,
      'created': created,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return '''Character(id: $id, name: $name, status: $status, species: $species, type: $type, gender: $gender, image: $image, created: $created)''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character &&
        other.id == id &&
        other.name == name &&
        other.status == status &&
        other.species == species &&
        other.type == type &&
        other.gender == gender &&
        other.image == image &&
        other.created == created;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        status.hashCode ^
        species.hashCode ^
        type.hashCode ^
        gender.hashCode ^
        image.hashCode ^
        created.hashCode;
  }
}
