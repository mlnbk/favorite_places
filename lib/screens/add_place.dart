import 'dart:io';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/providers/user_places.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      ScaffoldMessenger.of(context).clearMaterialBanners();
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          padding: const EdgeInsets.all(10),
          content: Text(enteredTitle.isEmpty
              ? 'The title can\t be empty!'
              : _selectedLocation == null
                  ? 'Location can\t be empty!'
                  : 'You have to select an image!'),
          leading: const Icon(Icons.error),
          backgroundColor: Colors.red,
          actions: const [
            // FIXME not nice workaround because actions can't be empty
            Visibility(
              visible: false,
              child: Text(''),
            )
          ],
        ),
      );
      Future.delayed(const Duration(seconds: 3), () {
        ScaffoldMessenger.of(context).clearMaterialBanners();
      });
    }

    ref
        .read(userPlacesProvider.notifier)
        .addPlace(enteredTitle, _selectedImage!, _selectedLocation!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                label: Text('Title'),
              ),
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 16),
            ImageInput(
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 16),
            LocationInput(
              onSelectLocation: (location) {
                _selectedLocation = location;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: const Icon(Icons.add),
              label: const Text('Add place'),
            )
          ],
        ),
      ),
    );
  }
}
