import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _surfaceController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isFeatured = false;
  bool _isLoading = false;
  String? _errorMessage;
  final List<String> _images = [];

  Future<void> _addProperty() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get agent ID
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final agentResponse = await Supabase.instance.client
          .from('agents')
          .select('id')
          .eq('user_id', userId)
          .single();
      
      final agentId = agentResponse['id'] as String;

      // Add property
      await Supabase.instance.client.from('properties').insert({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'surface': double.parse(_surfaceController.text),
        'bedrooms': int.parse(_bedroomsController.text),
        'bathrooms': int.parse(_bathroomsController.text),
        'images': _images,
        'agent_id': agentId,
        'featured': _isFeatured,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Propriété ajoutée avec succès')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _errorMessage = 'Une erreur est survenue');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _addImage() {
    if (_imageUrlController.text.isNotEmpty) {
      setState(() {
        _images.add(_imageUrlController.text);
        _imageUrlController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une propriété')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _surfaceController,
                decoration: const InputDecoration(labelText: 'Surface (m²)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une surface';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _bedroomsController,
                      decoration: const InputDecoration(labelText: 'Chambres'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requis';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Nombre';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _bathroomsController,
                      decoration: const InputDecoration(labelText: 'Salles de bain'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requis';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Nombre';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(labelText: 'URL de l\'image'),
                    ),
                  ),
                  IconButton(
                    onPressed: _addImage,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              if (_images.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _images
                      .map((url) => Chip(
                            label: Text(url.split('/').last),
                            onDeleted: () {
                              setState(() => _images.remove(url));
                            },
                          ))
                      .toList(),
                ),
              ],
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Annonce en vedette'),
                value: _isFeatured,
                onChanged: (value) => setState(() => _isFeatured = value!),
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: _isLoading ? null : _addProperty,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Ajouter la propriété'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}