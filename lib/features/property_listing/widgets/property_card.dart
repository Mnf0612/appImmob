import 'package:flutter/material.dart';
import 'package:real_estate_app/models/property.dart';
import 'package:intl/intl.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  
  const PropertyCard({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (property.images.isNotEmpty)
            Image.network(
              property.images.first,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          if (property.featured)
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: const Text(
                'Annonce en vedette',
                style: TextStyle(color: Colors.white),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '${property.bedrooms} chambres • ${property.bathrooms} salles de bain • ${property.surface}m²',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  currencyFormat.format(property.price),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}