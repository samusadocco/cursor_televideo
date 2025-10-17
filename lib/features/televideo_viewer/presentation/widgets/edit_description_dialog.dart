import 'package:flutter/material.dart';
import 'package:cursor_televideo/core/descriptions/page_descriptions_service.dart';
import 'package:cursor_televideo/core/storage/favorites_service.dart';
import 'package:cursor_televideo/core/l10n/app_localizations.dart';

class EditDescriptionDialog extends StatefulWidget {
  final int pageNumber;
  final String? regionCode;
  final String? channelId;
  final String? initialDescription;
  final String regionName;

  const EditDescriptionDialog({
    super.key,
    required this.pageNumber,
    required this.regionCode,
    this.channelId,
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
      title: Text(AppLocalizations.of(context)?.editDescription ?? 'Edit description'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.pageAndRegion(widget.pageNumber, widget.regionName) ?? 'Page ${widget.pageNumber} - ${widget.regionName}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)?.description ?? 'Description',
                border: const OutlineInputBorder(),
                hintText: AppLocalizations.of(context)?.enterCustomDescription ?? 'Enter a custom description',
              ),
              autofocus: true,
              maxLength: 50,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)?.restoreHint ?? 'Tip: long press the "RESTORE" button to return to the default description.',
              style: const TextStyle(
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
            child: Text(AppLocalizations.of(context)?.restore ?? 'RESTORE'),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context)?.cancel ?? 'CANCEL'),
        ),
        TextButton(
          onPressed: () {
            final newDescription = _descriptionController.text.trim();
            if (newDescription.isNotEmpty) {
              FavoritesService().updateDescription(
                widget.pageNumber,
                widget.regionCode,
                widget.channelId,
                newDescription,
              );
              Navigator.of(context).pop(true);
            }
          },
          child: Text(AppLocalizations.of(context)?.save ?? 'SAVE'),
        ),
      ],
    );
  }
} 