import 'package:flutter/material.dart';
import 'package:real_estate_app/features/property_listing/widgets/property_card.dart';
import 'package:real_estate_app/models/property.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Property>> _propertiesFuture;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _propertiesFuture = _loadProperties();
  }

  Future<List<Property>> _loadProperties() async {
    final response = await _supabase
      .from('properties')
      .select()
      .order('created_at', ascending: false)
      .limit(10);
    
    return (response as List)
      .map((property) => Property.fromJson(property))
      .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelles Annonces'),
      ),
      body: FutureBuilder<List<Property>>(
        future: _propertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          }

          final properties = snapshot.data!;
          
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              return PropertyCard(property: properties[index]);
            },
          );
        },
      ),
    );
  }
}