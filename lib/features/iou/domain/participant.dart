/// Participant entity.
///
/// Author: Lim Kai Zhe
/// Created: 25 Aug 2025
/// Represents a person involved in an IOU entry.
///
/// Each participant has a unique [id] and a [name]. The [id] is generated
/// using a UUID and is immutable across the lifetime of the object.
/// This ensures participants can be uniquely identified regardless of
/// name changes.
///
/// Equality (`==`) and [hashCode] are based on [id] only.
library;

import 'package:uuid/uuid.dart';

class Participant {
  /// Unique identifier for this participant (UUID v4).
  final String id;

  /// Human-readable name of the participant.
  final String name;

  /// Private constructor. Use [Participant.create] to instantiate safely.
  const Participant._({required this.id, required this.name});

  /// Factory constructor that validates the [name] and generates a unique [id].
  ///
  /// - Throws [ArgumentError] if [name] is empty or whitespace.
  factory Participant.create(String name) {
    if (name.trim().isEmpty) {
      throw ArgumentError("Participant name cannot be empty");
    }
    return Participant._(id: const Uuid().v4(), name: name);
  }

  /// Returns a new [Participant] with optional updated [name].
  ///
  /// The [id] remains unchanged to preserve participant identity.
  Participant copyWith({String? name}) {
    return Participant._(id: id, name: name ?? this.name);
  }

  /// Equality is defined only by [id], not by [name].
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Participant && other.id == id);

  /// Hash code is derived from [id] for consistency with [==].
  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Participant(id: $id, name: $name)';
}
