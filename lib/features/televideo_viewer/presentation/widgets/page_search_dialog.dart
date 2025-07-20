import 'package:flutter/material.dart';
import 'package:cursor_televideo/core/descriptions/page_descriptions_service.dart';
import 'package:cursor_televideo/shared/models/region.dart';

class PageSearchDialog extends StatefulWidget {
  final bool isNational;
  final Function(int) onNationalPageSelected;
  final Function(int, Region) onRegionalPageSelected;
  final Region? selectedRegion;

  const PageSearchDialog({
    super.key,
    required this.isNational,
    required this.onNationalPageSelected,
    required this.onRegionalPageSelected,
    required this.selectedRegion,
  });

  @override
  State<PageSearchDialog> createState() => _PageSearchDialogState();
}

class _PageSearchDialogState extends State<PageSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  final PageDescriptionsService _descriptionsService = PageDescriptionsService();
  String _searchQuery = '';
  List<MapEntry<int, String>> _filteredPages = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredPages('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilteredPages(String query) {
    final descriptions = widget.isNational
        ? _descriptionsService.nationalDescriptions
        : _descriptionsService.regionalDescriptions;

    _filteredPages = descriptions.entries
        .where((entry) {
          final pageNumber = entry.key.toString();
          final description = entry.value.toLowerCase();
          final lowercaseQuery = query.toLowerCase();
          return pageNumber.contains(query) ||
              description.contains(lowercaseQuery);
        })
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barra di ricerca
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cerca pagina...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _updateFilteredPages('');
                          },
                        )
                      : null,
                  border: const OutlineInputBorder(),
                ),
                onChanged: _updateFilteredPages,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              // Lista risultati
              Flexible(
                child: _filteredPages.isEmpty
                    ? const Center(
                        child: Text(
                          'Nessuna pagina trovata',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _filteredPages.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final page = _filteredPages[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                page.key.toString(),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            title: Text(page.value),
                            onTap: () {
                              Navigator.of(context).pop();
                              if (widget.isNational) {
                                widget.onNationalPageSelected(page.key);
                              } else if (widget.selectedRegion != null) {
                                widget.onRegionalPageSelected(
                                  page.key,
                                  widget.selectedRegion!,
                                );
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 