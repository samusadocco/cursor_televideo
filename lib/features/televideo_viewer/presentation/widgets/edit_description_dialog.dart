import 'package:flutter/material.dart';
import 'package:cursor_televideo/core/descriptions/page_descriptions_service.dart';
import 'package:cursor_televideo/core/storage/favorites_service.dart';
import 'package:cursor_televideo/shared/models/region.dart';

class EditDescriptionDialog extends StatefulWidget {
  final int pageNumber;
  final String? regionCode;
  final String? initialDescription;
  final String regionName;

  const EditDescriptionDialog({
    super.key,
    required this.pageNumber,
    required this.regionCode,
    required this.initialDescription,
    required this.regionName,
  });

  @override
  State<EditDescriptionDialog> createState() => _EditDescriptionDialogState();
}

class _EditDescriptionDialogState extends State<EditDescriptionDialog> {
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifica descrizione'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pagina ${widget.pageNumber} - ${widget.regionName}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrizione',
                border: OutlineInputBorder(),
                hintText: 'Inserisci una descrizione personalizzata',
              ),
              autofocus: true,
              maxLength: 50,
            ),
            const SizedBox(height: 8),
            const Text(
              'Suggerimento: tieni premuto il pulsante "RIPRISTINA" per tornare alla descrizione predefinita.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onLongPress: () {
            final defaultDescription = PageDescriptionsService().getDescription(
              widget.pageNumber,
              isRegional: widget.regionCode != null,
            );
            setState(() {
              _descriptionController.text = defaultDescription;
            });
          },
          child: TextButton(
            onPressed: () {},
            child: const Text('RIPRISTINA'),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('ANNULLA'),
        ),
        TextButton(
          onPressed: () {
            final newDescription = _descriptionController.text.trim();
            if (newDescription.isNotEmpty) {
              FavoritesService().updateDescription(
                widget.pageNumber,
                widget.regionCode,
                newDescription,
              );
              Navigator.of(context).pop(true);
            }
          },
          child: const Text('SALVA'),
        ),
      ],
    );
  }
} 