import 'package:flutter/foundation.dart';

@immutable
class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final double surface;
  final int bedrooms;
  final int bathrooms;
  final List<String> images;
  final DateTime createdAt;
  final String agentId;
  final bool featured;

  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.surface,
    required this.bedrooms,
    required this.bathrooms,
    required this.images,
    required this.createdAt,
    required this.agentId,
    required this.featured,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      surface: (json['surface'] as num).toDouble(),
      bedrooms: json['bedrooms'] as int,
      bathrooms: json['bathrooms'] as int,
      images: List<String>.from(json['images'] as List),
      createdAt: DateTime.parse(json['created_at'] as String),
      agentId: json['agent_id'] as String,
      featured: json['featured'] as bool,
    );
  }
}