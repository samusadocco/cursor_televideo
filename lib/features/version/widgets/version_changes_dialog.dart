import 'package:flutter/material.dart';
import '../../../core/version_manager.dart';

class VersionChangesDialog extends StatelessWidget {
  final List<VersionInfo> versions;

  const VersionChangesDialog({super.key, required this.versions});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Novità'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: versions.map((version) => _buildVersionSection(version)).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget _buildVersionSection(VersionInfo version) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
          child: Text(
            'Versione ${version.version}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...version.changes.map((change) => Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 14)),
              Expanded(
                child: Text(
                  change,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        )).toList(),
        const Divider(),
      ],
    );
  }
}

