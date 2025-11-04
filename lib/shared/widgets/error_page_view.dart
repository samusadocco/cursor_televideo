import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/region_bloc.dart';
import 'package:cursor_televideo/core/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final bloc = context.read<TelevideoBloc>();
    
    // Ottieni l'ultima pagina visitata con successo
    final lastSuccessfulPage = bloc.lastSuccessfulPage;
    final lastSuccessfulSubPage = bloc.lastSuccessfulSubPage ?? 1;
    final lastSuccessfulRegion = bloc.lastSuccessfulRegion;
    
    // Determina se mostrare il pulsante "Torna a ultima pagina"
    // Lo mostriamo solo se esiste una pagina precedente diversa da quella di default
    final defaultPage = isRegionalMode ? 300 : bloc.minPage;
    final showLastPageButton = lastSuccessfulPage != null && lastSuccessfulPage != defaultPage;

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
                l10n.pageUnavailable,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (onRetry != null)
                    FilledButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.retry),
                    ),
                  if (showLastPageButton)
                    FilledButton.icon(
                      onPressed: () {
                        // Torna all'ultima pagina visitata con successo
                        if (lastSuccessfulRegion != null) {
                          bloc.add(
                            TelevideoEvent.loadRegionalPage(
                              lastSuccessfulRegion,
                              lastSuccessfulPage,
                            ),
                          );
                        } else {
                          bloc.add(
                            TelevideoEvent.loadNationalPage(lastSuccessfulPage),
                          );
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      icon: const Icon(Icons.history),
                      label: Text(l10n.backToPage(lastSuccessfulPage)),
                    ),
                  FilledButton.icon(
                    onPressed: () {
                      if (isRegionalMode) {
                        bloc.add(
                          TelevideoEvent.loadRegionalPage(
                            regionState.selectedRegion!,
                            300,
                          ),
                        );
                      } else {
                        bloc.add(
                          TelevideoEvent.loadNationalPage(defaultPage),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    icon: const Icon(Icons.home),
                    label: Text(l10n.backToPage(defaultPage)),
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