import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/region_bloc.dart';

class ErrorPageView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorPageView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final regionState = context.watch<RegionBloc>().state;
    final isRegionalMode = regionState.selectedRegion != null;

    return Container(
      color: Colors.black,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Pagina non disponibile',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (onRetry != null) ...[
                    FilledButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Riprova'),
                    ),
                    const SizedBox(width: 16),
                  ],
                  FilledButton.icon(
                    onPressed: () {
                      if (isRegionalMode) {
                        context.read<TelevideoBloc>().add(
                          TelevideoEvent.loadRegionalPage(
                            regionState.selectedRegion!,
                            300,
                          ),
                        );
                      } else {
                        context.read<TelevideoBloc>().add(
                          const TelevideoEvent.loadNationalPage(100),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    icon: const Icon(Icons.home),
                    label: Text(isRegionalMode ? 'Torna a 300' : 'Torna a 100'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 