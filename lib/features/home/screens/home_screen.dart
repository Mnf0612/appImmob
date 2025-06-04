import 'package:flutter/material.dart';
import 'package:real_estate_app/features/property_listing/widgets/property_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelles Annonces'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 10, // À remplacer par la liste réelle des propriétés
        itemBuilder: (context, index) {
          return const PropertyCard();
        },
      ),
    );
  }
}