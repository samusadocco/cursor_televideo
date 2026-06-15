import 'dart:async';
import 'dart:convert';
import 'package:cursor_televideo/core/teletext/providers/mtva_image_provider.dart';
import 'package:cursor_televideo/core/teletext/providers/intertext_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cursor_televideo/core/settings/app_settings.dart';
import 'package:cursor_televideo/core/ads/ad_service.dart';
import 'package:cursor_televideo/core/animations/page_transitions.dart';
import 'package:cursor_televideo/core/feedback/haptic_feedback_service.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_bloc.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_event.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/televideo_state.dart';
import 'package:cursor_televideo/shared/models/televideo_page.dart';
import 'package:cursor_televideo/shared/models/region.dart';
import 'package:cursor_televideo/features/televideo_viewer/bloc/region_bloc.dart';
import 'package:cursor_televideo/shared/widgets/error_page_view.dart';
import 'package:cursor_televideo/core/analytics/analytics_service.dart';
import 'package:cursor_televideo/core/ocr/lazy_mlkit_ocr_coordinator.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/auto_refresh_overlay.dart';
import 'package:cursor_televideo/core/l10n/app_localizations.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/ard_html_teletext_viewer.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/br_html_teletext_viewer.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/wdr_html_teletext_viewer.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/swr_html_teletext_viewer.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/hr_html_teletext_viewer.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/sr_html_teletext_viewer.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/ndr_html_teletext_viewer.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/zdf_html_teletext_viewer.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/nos_html_teletext_viewer.dart';
import 'package:cursor_televideo/features/televideo_viewer/presentation/widgets/iceland_html_teletext_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TelevideoViewer extends StatefulWidget {
  final TelevideoPage page;
  final Function(int)? onPageNumberSubmitted;
  final bool showControls;
  final bool isNationalMode;

  const TelevideoViewer({
    super.key,
    required this.page,
    required this.onPageNumberSubmitted,
    required this.showControls,
    required this.isNationalMode,
  });

  @override
  State<TelevideoViewer> createState() => _TelevideoViewerState();
}

class _TelevideoViewerState extends State<TelevideoViewer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _liveShowTimer;
  Timer? _refreshTimer;  // Timer per il refresh periodico
  final AdService _adService = AdService();
  StreamSubscription? _adEventSubscription;
  Offset _dragStart = Offset.zero;
  bool _isDragging = false;
  bool _isVerticalDrag = false;
  int _currentSubPage = 1;
  int _maxSubPages = 1;
  double _dragProgress = 0.0;
  bool _isRefreshing = false;
  bool _showPauseOverlay = false;
  Timer? _overlayTimer;
  DateTime? _timerStartTime;  // Quando è partito il timer corrente
  Duration _remainingTime = Duration.zero;  // Tempo rimanente quando in pausa
  int _lazyOcrGeneration = 0;
  List<ClickableArea>? _lazyClickableAreas;
  String? _cachedImageBaseUrl;
  String? _cachedTimestampedImageUrl;

  /// Aggiunge un timestamp unico all'URL per disabilitare completamente la cache
  /// Funziona per TUTTI i provider con immagini (RAI, MTVA, CT, YLE, SVT, ecc.)
  String _addTimestampToUrl(String url) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final separator = url.contains('?') ? '&' : '?';
    final urlWithTimestamp = '$url${separator}_t=$timestamp';
    print('[TelevideoViewer] 🔄 URL con timestamp (cache disabilitata): $urlWithTimestamp');
    return urlWithTimestamp;
  }

  String _stableTimestampedImageUrl(String baseUrl) {
    if (_cachedImageBaseUrl != baseUrl || _cachedTimestampedImageUrl == null) {
      _cachedImageBaseUrl = baseUrl;
      _cachedTimestampedImageUrl = _addTimestampToUrl(baseUrl);
    }
    return _cachedTimestampedImageUrl!;
  }

  void _resetPageVisualState(TelevideoPage page) {
    _lazyClickableAreas = null;
    _cachedImageBaseUrl = null;
    _cachedTimestampedImageUrl = null;
    _stableTimestampedImageUrl(page.imageUrl);
  }

  List<ClickableArea> _effectiveClickableAreas(TelevideoPage page) {
    return _lazyClickableAreas ?? page.clickableAreas;
  }

  String _pageContentKey(TelevideoPage page, int currentSubPage) {
    return '${page.pageNumber}_${currentSubPage}_${page.imageUrl}';
  }

  @override
  void initState() {
    super.initState();

    // Ascolta gli eventi degli annunci
    _adEventSubscription = _adService.adEventStream.listen((event) {
      switch (event) {
        case AdEvent.shown:
          // Quando l'annuncio viene mostrato, salviamo il tempo rimanente e fermiamo il timer
          if (AppSettings.liveShowEnabled && widget.page.maxSubPages > 1) {
            _remainingTime = _getTimeRemaining();
            _liveShowTimer?.cancel();
            _refreshTimer?.cancel();
          }
          break;
        case AdEvent.dismissed:
          // Quando l'annuncio viene chiuso, riprendiamo dal tempo rimanente
          if (AppSettings.liveShowEnabled && widget.page.maxSubPages > 1) {
            _startLiveShowTimer();
          }
          break;
        default:
          break;
      }
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Inizializza i valori delle sottopagine
    _currentSubPage = widget.page.maxSubPages > 0 ? 1 : 0;
    _maxSubPages = widget.page.maxSubPages;

    // Avvia il timer per il Live Show se abilitato
    _startLiveShowTimer();
    _resetPageVisualState(widget.page);
    _maybeStartLazyOcr();
  }

  void _maybeStartLazyOcr() {
    final page = widget.page;
    if (page.metadata?['lazyOcrPending'] != true) {
      return;
    }

    final engine =
        lazyOcrEngineFromMetadata(page.metadata) ?? LazyOcrEngine.polsat;

    final generation = ++_lazyOcrGeneration;
    final pageNumber = page.pageNumber;
    final subPage = page.subPage;
    final imageUrl = page.imageUrl;
    final existingAreas = page.clickableAreas;

    print(
      '[TelevideoViewer] Scheduling lazy ${engine.name} OCR for '
      '${page.providerId} page $pageNumber/$subPage',
    );

    LazyMlkitOcrCoordinator.instance
        .enrich(
          engine: engine,
          providerId: page.providerId,
          existingAreas: existingAreas,
          imageUrl: imageUrl,
          pageNumber: pageNumber,
          subPage: subPage,
        )
        .then((areas) {
      if (!mounted || generation != _lazyOcrGeneration) {
        return;
      }
      if (widget.page.pageNumber != pageNumber || widget.page.subPage != subPage) {
        return;
      }
      if (widget.page.metadata?['lazyOcrPending'] != true) {
        return;
      }

      setState(() {
        _lazyClickableAreas = areas;
      });
      print(
        '[TelevideoViewer] Lazy OCR ready for page $pageNumber/$subPage: '
        '${areas.length} clickable areas',
      );
    }).catchError((Object error) {
      print('[TelevideoViewer] Lazy OCR failed: $error');
    });
  }

  @override
  void didUpdateWidget(TelevideoViewer oldWidget) {
    super.didUpdateWidget(oldWidget);

    final pageChanged = oldWidget.page.pageNumber != widget.page.pageNumber ||
        oldWidget.page.subPage != widget.page.subPage ||
        oldWidget.page.imageUrl != widget.page.imageUrl;

    if (pageChanged) {
      _resetPageVisualState(widget.page);
      setState(() {
        _maxSubPages = widget.page.maxSubPages;
      });
      if (!_adService.isShowingAd) {
        _startLiveShowTimer();
      }
      _maybeStartLazyOcr();
    }
  }

  void _performRefresh() {
    if (mounted && !_isDragging && !_adService.isShowingAd) {
      context.read<TelevideoBloc>().add(const TelevideoEvent.nextSubPage());
      _timerStartTime = DateTime.now();
    }
  }

  /// Gestisce il tap sulla pagina per play/pause
  /// IMPORTANTE: Controlla sempre se mounted prima di accedere al context
  void _handlePageTap(TelevideoPage page) {
    // Verifica se il widget è ancora montato
    if (!mounted) {
      print('[TelevideoViewer] onTap chiamato ma widget non più mounted, ignoro');
      return;
    }
    
    // Gestisce il tap per play/pause delle sottopagine
    final hasSubPages = page.maxSubPages > 1;
    if (hasSubPages && AppSettings.liveShowEnabled) {
      context.read<TelevideoBloc>().add(const TelevideoEvent.toggleAutoRefreshPause());
      
      // Mostra l'overlay
      setState(() {
        _showPauseOverlay = true;
      });
      
      _overlayTimer?.cancel();
      _overlayTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showPauseOverlay = false;
          });
        }
      });
    }
  }

  void _startPeriodicTimer() {
    _timerStartTime = DateTime.now();
    _refreshTimer = Timer.periodic(
      Duration(seconds: AppSettings.liveShowIntervalSeconds),
      (timer) => _performRefresh()
    );
  }

  Duration _getTimeRemaining() {
    if (_timerStartTime == null) return Duration.zero;
    
    final elapsed = DateTime.now().difference(_timerStartTime!);
    final remaining = Duration(seconds: AppSettings.liveShowIntervalSeconds) - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Costruisce il viewer HTML appropriato in base al provider
  Widget _buildImageWidget(TelevideoPage page, BuildContext context) {
    // Controlla se l'URL è un'immagine base64 (data URI)
    if (page.imageUrl.startsWith('data:image/')) {
      try {
        // Estrai il base64 dalla data URI
        // Formato: data:image/gif;base64,R0lGODlh...
        final base64String = page.imageUrl.split(',')[1];
        final bytes = base64Decode(base64String);
        
        return Image.memory(
          bytes,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) {
            print('[TeletextViewer] Error decoding base64 image: $error');
            return ErrorPageView(
              message: AppLocalizations.of(context)!.pageUnavailable,
              onRetry: () {
                final regionState = context.read<RegionBloc>().state;
                if (regionState.selectedRegion != null) {
                  context.read<TelevideoBloc>().add(
                    TelevideoEvent.loadRegionalPage(
                      regionState.selectedRegion!,
                      page.pageNumber,
                    ),
                  );
                } else {
                  context.read<TelevideoBloc>().add(
                    TelevideoEvent.loadNationalPage(page.pageNumber),
                  );
                }
              },
            );
          },
        );
      } catch (e) {
        print('[TeletextViewer] Error parsing base64 image: $e');
        return ErrorPageView(
          message: AppLocalizations.of(context)!.pageUnavailable,
          onRetry: () {
            final regionState = context.read<RegionBloc>().state;
            if (regionState.selectedRegion != null) {
              context.read<TelevideoBloc>().add(
                TelevideoEvent.loadRegionalPage(
                  regionState.selectedRegion!,
                  page.pageNumber,
                ),
              );
            } else {
              context.read<TelevideoBloc>().add(
                TelevideoEvent.loadNationalPage(page.pageNumber),
              );
            }
          },
        );
      }
    }
    
    // ČT Teletext: WebP dall'API (URL già con ?t=timestamp, come nel browser)
    if (page.providerId == 'ct_teletext') {
      return CachedNetworkImage(
        imageUrl: page.imageUrl,
        httpHeaders: const {
          'Referer': 'https://teletext.ceskatelevize.cz/',
          'Accept': 'image/webp,image/*,*/*',
          'User-Agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
        },
        fit: BoxFit.fill,
        fadeInDuration: const Duration(milliseconds: 100),
        fadeOutDuration: const Duration(milliseconds: 100),
        placeholder: (context, url) => Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
        errorWidget: (context, url, error) {
          print('[TeletextViewer] Error loading CT teletext image: $error url=$url');
          return ErrorPageView(
            message: AppLocalizations.of(context)!.pageUnavailable,
            onRetry: () {
              context.read<TelevideoBloc>().add(
                TelevideoEvent.loadNationalPage(page.pageNumber),
              );
            },
          );
        },
      );
    }

    // Per MTVA usa il provider personalizzato che gestisce certificati self-signed
    if (page.providerId == 'mtva_teletext') {
      final imageUrlWithTimestamp = _stableTimestampedImageUrl(page.imageUrl);
      return Image(
        image: MTVAImageProvider(imageUrlWithTimestamp),
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) {
          print('[TeletextViewer] Error loading MTVA image: $error');
          return ErrorPageView(
            message: AppLocalizations.of(context)!.pageUnavailable,
            onRetry: () {
              context.read<TelevideoBloc>().add(
                TelevideoEvent.loadNationalPage(page.pageNumber),
              );
            },
          );
        },
      );
    }
    
    // Per Intertext usa il provider personalizzato con headers per bypassare 403
    if (page.providerId == 'intertext') {
      final imageUrlWithTimestamp = _stableTimestampedImageUrl(page.imageUrl);
      return Image(
        image: IntertextImageProvider(imageUrlWithTimestamp),
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) {
          print('[TeletextViewer] Error loading Intertext image: $error');
          return ErrorPageView(
            message: AppLocalizations.of(context)!.pageUnavailable,
            onRetry: () {
              context.read<TelevideoBloc>().add(
                TelevideoEvent.loadNationalPage(page.pageNumber),
              );
            },
          );
        },
      );
    }
    
    // URL normale - usa CachedNetworkImage con timestamp per disabilitare cache
    // Funziona per TUTTI i provider (RAI, MTVA, CT, YLE, SVT, HRT, Spanish, ORF, Swiss, DR, ecc.)
    final imageUrlWithTimestamp = _stableTimestampedImageUrl(page.imageUrl);
    return CachedNetworkImage(
      key: ValueKey(imageUrlWithTimestamp),
      imageUrl: imageUrlWithTimestamp,
      httpHeaders: {
        'Cache-Control': 'no-cache',
      },
      fit: BoxFit.fill,
      // Animazioni più veloci per un effetto meno "dissolto"
      fadeInDuration: const Duration(milliseconds: 100),
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholder: (context, url) => Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
      errorWidget: (context, url, error) {
        print('[TeletextViewer] Error loading cached network image: $error');
        return ErrorPageView(
          message: AppLocalizations.of(context)!.pageUnavailable,
          onRetry: () {
            final regionState = context.read<RegionBloc>().state;
            if (regionState.selectedRegion != null) {
              context.read<TelevideoBloc>().add(
                TelevideoEvent.loadRegionalPage(
                  regionState.selectedRegion!,
                  page.pageNumber,
                ),
              );
            } else {
              context.read<TelevideoBloc>().add(
                TelevideoEvent.loadNationalPage(page.pageNumber),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildHtmlViewer(TelevideoPage page, BuildContext context, int currentSubPage) {
    // Determina quale viewer usare in base al provider
    print('[TelevideoViewer] _buildHtmlViewer called with providerId: ${page.providerId}');
    
    final isZDF = page.providerId == 'zdf_text' || 
                  page.providerId == 'zdfinfo_text' || 
                  page.providerId == 'zdfneo_text' || 
                  page.providerId == '3sat_text';
    
    final isNOS = page.providerId == 'nos_teletekst';
    final isIceland = page.providerId == 'ruv_textavarp';
    final isBR = page.providerId == 'br_text';
    final isWDR = page.providerId == 'wdr_text';
    final isSWR = page.providerId == 'swr_bw' || page.providerId == 'swr_rp';
    final isHR = page.providerId == 'hr_text';
    final isSR = page.providerId == 'sr_text';
    final isNDR = page.providerId == 'ndr_text';
    
    print('[TelevideoViewer] Viewer selection - isIceland: $isIceland, isZDF: $isZDF, isNOS: $isNOS, isBR: $isBR, isWDR: $isWDR, isSWR: $isSWR, isHR: $isHR, isSR: $isSR, isNDR: $isNDR');
    
    if (isIceland) {
      print('[TelevideoViewer] Using IcelandHtmlTeletextViewer');
      return IcelandHtmlTeletextViewer(
        key: ValueKey('iceland_${page.pageNumber}_$currentSubPage'),
        page: page,
        onTap: () => _handlePageTap(page),
      );
    } else if (isZDF) {
      return ZDFHtmlTeletextViewer(
        key: ValueKey('zdf_${page.pageNumber}_$currentSubPage'),
        page: page,
        onPageNavigation: (pageNumber) {
          // Naviga alla pagina tramite il Bloc
          if (widget.onPageNumberSubmitted != null) {
            widget.onPageNumberSubmitted!(pageNumber);
          }
        },
        onTap: () => _handlePageTap(page),
      );
    } else if (isNOS) {
      return NOSHtmlTeletextViewer(
        key: ValueKey('nos_${page.pageNumber}_$currentSubPage'),
        page: page,
        onPageNavigation: (pageNumber) {
          // Naviga alla pagina tramite il Bloc
          if (widget.onPageNumberSubmitted != null) {
            widget.onPageNumberSubmitted!(pageNumber);
          }
        },
        onTap: () => _handlePageTap(page),
      );
    } else if (isBR) {
      print('[TelevideoViewer] Using BRHtmlTeletextViewer');
      return BRHtmlTeletextViewer(
        key: ValueKey('br_${page.imageUrl}_$currentSubPage'),
        page: page,
        onPageNavigation: (pageNumber) {
          // Naviga alla pagina tramite il Bloc
          if (widget.onPageNumberSubmitted != null) {
            widget.onPageNumberSubmitted!(pageNumber);
          }
        },
        onTap: () => _handlePageTap(page),
      );
    } else if (isWDR) {
      print('[TelevideoViewer] Using WDRHtmlTeletextViewer');
      return WDRHtmlTeletextViewer(
        key: ValueKey('wdr_${page.imageUrl}_$currentSubPage'),
        page: page,
        onPageNavigation: (pageNumber) {
          // Naviga alla pagina tramite il Bloc
          if (widget.onPageNumberSubmitted != null) {
            widget.onPageNumberSubmitted!(pageNumber);
          }
        },
        onTap: () => _handlePageTap(page),
      );
    } else if (isSWR) {
      print('[TelevideoViewer] Using SWRHtmlTeletextViewer');
      return SWRHtmlTeletextViewer(
        key: ValueKey('swr_${page.imageUrl}_$currentSubPage'),
        page: page,
        onPageNavigation: (pageNumber) {
          // Naviga alla pagina tramite il Bloc
          if (widget.onPageNumberSubmitted != null) {
            widget.onPageNumberSubmitted!(pageNumber);
          }
        },
        onTap: () => _handlePageTap(page),
      );
    } else if (isHR) {
      print('[TelevideoViewer] Using HRHtmlTeletextViewer');
      return HRHtmlTeletextViewer(
        key: ValueKey('hr_${page.imageUrl}_$currentSubPage'),
        page: page,
        onPageNavigation: (pageNumber) {
          // Naviga alla pagina tramite il Bloc
          if (widget.onPageNumberSubmitted != null) {
            widget.onPageNumberSubmitted!(pageNumber);
          }
        },
        onTap: () => _handlePageTap(page),
      );
    } else if (isSR) {
      print('[TelevideoViewer] Using SRHtmlTeletextViewer');
      return SRHtmlTeletextViewer(
        key: ValueKey('sr_${page.pageNumber}_$currentSubPage'),
        page: page,
        onPageTap: (pageNumber) {
          // Naviga alla pagina tramite il Bloc
          if (widget.onPageNumberSubmitted != null) {
            widget.onPageNumberSubmitted!(pageNumber);
          }
        },
      );
    } else if (isNDR) {
      print('[TelevideoViewer] Using NDRHtmlTeletextViewer');
      return NDRHtmlTeletextViewer(
        key: ValueKey('ndr_${page.pageNumber}_$currentSubPage'),
        page: page,
        onTap: () => _handlePageTap(page),
        onPageTap: (pageNumber) {
          // Naviga alla pagina tramite il Bloc
          if (widget.onPageNumberSubmitted != null) {
            widget.onPageNumberSubmitted!(pageNumber);
          }
        },
      );
    } else {
      // ARD o altri provider HTML
      return ARDHtmlTeletextViewer(
        key: ValueKey('ard_${page.imageUrl}_$currentSubPage'),
        page: page,
        onPageNavigation: (pageNumber) {
          // Naviga alla pagina tramite il Bloc
          if (widget.onPageNumberSubmitted != null) {
            widget.onPageNumberSubmitted!(pageNumber);
          }
        },
        onTap: () => _handlePageTap(page),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _liveShowTimer?.cancel();
    _refreshTimer?.cancel();
    _overlayTimer?.cancel();
    _adEventSubscription?.cancel();
    super.dispose();
  }

  void _startLiveShowTimer() {
    // Cancella i timer esistenti
    _liveShowTimer?.cancel();
    _refreshTimer?.cancel();

    // Verifica se il timer è in pausa
    final isPaused = context.read<TelevideoBloc>().state.maybeWhen(
      loaded: (_, __, isAutoRefreshPaused, ___) => isAutoRefreshPaused,
      orElse: () => false,
    );

    // Se è in pausa, non avviare il timer
    if (isPaused) return;

    // Avvia il timer solo se il Live Show è abilitato, ci sono sottopagine e non c'è un annuncio in corso
    if (AppSettings.liveShowEnabled && widget.page.maxSubPages > 1 && !_adService.isShowingAd) {
      if (_remainingTime > Duration.zero) {
        // Se c'è un tempo residuo dalla pausa, usa quello
        _liveShowTimer = Timer(_remainingTime, () {
          if (mounted) {
            _performRefresh();
            _remainingTime = Duration.zero;
            _startPeriodicTimer();
          }
        });
      } else {
        // Altrimenti parti subito con il timer periodico
        _startPeriodicTimer();
      }
    }
  }

  void _onDragStart(DragStartDetails details) {
    _isDragging = true;
    _dragStart = details.globalPosition;
    _dragProgress = 0.0;
    _isVerticalDrag = false;
    setState(() {});
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    final dragDistance = details.globalPosition - _dragStart;
    final screenSize = MediaQuery.of(context).size;
    
    // Determina se il drag è principalmente orizzontale o verticale
    if (!_isVerticalDrag && dragDistance.distance > 10) {
      _isVerticalDrag = dragDistance.dy.abs() > dragDistance.dx.abs();
    }
    
    if (_isVerticalDrag) {
      _dragProgress = (dragDistance.dy / screenSize.height).clamp(-1.0, 1.0);
    } else {
      _dragProgress = (dragDistance.dx / screenSize.width).clamp(-1.0, 1.0);
    }
    
    setState(() {});
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_isDragging) return;
    
    _isDragging = false;
    final velocity = details.primaryVelocity ?? 0;
    final threshold = 0.3; // Soglia per determinare se completare lo swipe
    
    if (_isVerticalDrag) {
      if (_maxSubPages > 1) {
        // Gestione normale delle sottopagine
        if (velocity.abs() > 300 || _dragProgress.abs() > threshold) {
          if (velocity > 0 || _dragProgress > threshold) {
            // Swipe verso il basso - sottopagina precedente
            HapticFeedbackService.success();
            context.read<TelevideoBloc>().add(const TelevideoEvent.previousSubPage());
            AnalyticsService().logSubpageChange(
              widget.page.pageNumber.toString(),
              (_currentSubPage - 1).toString(),
              'manual',
            );
          } else {
            // Swipe verso l'alto - sottopagina successiva
            HapticFeedbackService.success();
            context.read<TelevideoBloc>().add(const TelevideoEvent.nextSubPage());
            AnalyticsService().logSubpageChange(
              widget.page.pageNumber.toString(),
              (_currentSubPage + 1).toString(),
              'manual',
            );
          }
        }
      } else {
        // Gestione pagine senza sottopagine
        if (velocity > 0 && _dragProgress > 0) {  // Solo swipe verso il basso
          final regionState = context.read<RegionBloc>().state;
          
          // Imposta lo stato di refresh
          setState(() {
            _isRefreshing = true;
          });
          
          // Aspetta 0.5 secondi prima di ricaricare la pagina
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {  // Verifica che il widget sia ancora montato
              if (regionState.selectedRegion != null) {
                context.read<TelevideoBloc>().add(
                  TelevideoEvent.loadRegionalPage(
                    regionState.selectedRegion!,
                    widget.page.pageNumber,
                  ),
                );
              } else {
                context.read<TelevideoBloc>().add(
                  TelevideoEvent.loadNationalPage(widget.page.pageNumber),
                );
              }
              // Reset dello stato di refresh
              setState(() {
                _isRefreshing = false;
              });
            }
          });
        }
      }
    } else {
      if (velocity.abs() > 300 || _dragProgress.abs() > threshold) {
        if (velocity > 0 || _dragProgress > threshold) {
          // Swipe verso destra - pagina precedente
          HapticFeedbackService.success();
          context.read<TelevideoBloc>().add(
            TelevideoEvent.previousPage(currentPage: widget.page.pageNumber),
          );
          AnalyticsService().logTelevideoPageView(
            (widget.page.pageNumber - 1).toString(),
            'swipe',
          );
        } else {
          // Swipe verso sinistra - pagina successiva
          HapticFeedbackService.success();
          context.read<TelevideoBloc>().add(
            TelevideoEvent.nextPage(currentPage: widget.page.pageNumber),
          );
          AnalyticsService().logTelevideoPageView(
            (widget.page.pageNumber + 1).toString(),
            'swipe',
          );
        }
      }
    }
    
    _dragProgress = 0.0;
    _isVerticalDrag = false;
    setState(() {});

    // Riavvia il timer dopo il drag
    _startLiveShowTimer();
  }

  void _onTapUp(TapUpDetails details, Size imageSize) {
    if (_isDragging) return;

    final state = context.read<TelevideoBloc>().state;

    // Converti le coordinate del tap in coordinate relative all'immagine
    final localPosition = details.localPosition;
    
    // Determina le dimensioni originali in base al provider
    double originalWidth;
    double originalHeight;
    
    if (widget.page.providerId != null && 
        (widget.page.providerId!.startsWith('rsi_') || 
         widget.page.providerId!.startsWith('rts_') || 
         widget.page.providerId!.startsWith('srf_'))) {
      // Swiss Teletext: 640x460
      originalWidth = 640.0;
      originalHeight = 460.0;
    } else if (widget.page.providerId != null && 
               (widget.page.providerId == 'orf1' || 
                widget.page.providerId == 'orf2' || 
                widget.page.providerId == 'orf3' || 
                widget.page.providerId == 'orf_sport_plus')) {
      // ORF Teletext: 823x494 (dimensioni reali dell'immagine PNG)
      originalWidth = 823.0;
      originalHeight = 494.0;
    } else if (widget.page.providerId != null && 
               (widget.page.providerId == 'tve' || 
                widget.page.providerId == 'antena3' || 
                widget.page.providerId == 'lasexta' ||
                widget.page.providerId == 'rtp')) {
      // Iberian Teletext (ES/PT): 480x336 (dimensioni reali dell'immagine PNG)
      originalWidth = 480.0;
      originalHeight = 336.0;
    } else if (widget.page.providerId != null && 
               (widget.page.providerId == 'svt_text' || 
                widget.page.providerId == 'hrt_teletekst')) {
      // SVT Text (SE) / HRT Teletekst (HR): 520x400 (dimensioni reali dell'immagine GIF)
      originalWidth = 520.0;
      originalHeight = 400.0;
    } else if (widget.page.providerId == 'yle_teksti_tv') {
      // YLE Teksti-TV (FI): 720x432 (dimensioni approssimate basate sulle coordinate della mappa)
      // Le coordinate nelle aree cliccabili vanno fino a circa 701x414
      originalWidth = 720.0;
      originalHeight = 432.0;
    } else if (widget.page.providerId == 'ct_teletext') {
      // ČT Teletext (CZ): 320x276 (dimensioni reali dell'immagine PNG)
      originalWidth = 320.0;
      originalHeight = 276.0;
    } else if (widget.page.providerId == 'rtvslo_teletext') {
      // RTV SLO Teletext (SI): 480x336 (dimensioni reali dell'immagine PNG)
      originalWidth = 480.0;
      originalHeight = 336.0;
    } else if (widget.page.providerId == 'mtva_teletext') {
      // MTVA Teletext (HU): 520x400 (dimensioni reali dell'immagine GIF)
      originalWidth = 520.0;
      originalHeight = 400.0;
    } else if (widget.page.providerId != null && widget.page.providerId!.startsWith('som_')) {
      // SOM Teletextviewer (DE/AT/CH): 600x432 (API /api/page)
      final meta = widget.page.metadata;
      originalWidth = (meta?['width'] as num?)?.toDouble() ?? 600.0;
      originalHeight = (meta?['height'] as num?)?.toDouble() ?? 432.0;
    } else if (widget.page.providerId == 'dr1' || widget.page.providerId == 'dr2') {
      // DR Text TV (DK): 320x375 (dimensioni reali dell'immagine GIF)
      originalWidth = 320.0;
      originalHeight = 375.0;
    } else if (widget.page.providerId == 'bhrt' || widget.page.providerId == 'rtvfbih') {
      // BHRT/RTVFBiH Teletext (BA): 480x336 (dimensioni reali dell'immagine PNG)
      originalWidth = 480.0;
      originalHeight = 336.0;
    } else if (widget.page.providerId == 'intertext') {
      // Intertext (UA): 492x432 (dimensioni reali dell'immagine GIF)
      originalWidth = 492.0;
      originalHeight = 432.0;
    } else if (widget.page.providerId == 'omroepzeeland_teletekst') {
      // Omroep Zeeland (NL): 400x300
      originalWidth = 400.0;
      originalHeight = 300.0;
    } else if (widget.page.providerId == 'polsat_telegazeta' ||
               (widget.page.providerId != null &&
                widget.page.providerId!.startsWith('tvp') &&
                widget.page.providerId!.endsWith('_telegazeta'))) {
      // Polsat / TVP Telegazeta (PL): 480x336
      originalWidth = 480.0;
      originalHeight = 336.0;
    } else if (widget.page.providerId == 'kika_text') {
      // KiKA (DE): 480x336
      originalWidth = 480.0;
      originalHeight = 336.0;
    } else if (widget.page.providerId == 'arte_text' ||
               widget.page.providerId == 'rbb_text' ||
               widget.page.providerId == 'mdr_text' ||
               widget.page.providerId == 'ard_alpha_text' ||
               widget.page.providerId == 'phoenix_text' ||
               widget.page.providerId == 'ntv_text' ||
               widget.page.providerId == 'vox_text' ||
               widget.page.providerId == 'rtl_text') {
      // Zattoo (ARTE, RBB, MDR, ARD Alpha, Phoenix, n-tv, VOX, RTL): 492x500
      // Dimensioni standard per tutti i canali Zattoo
      originalWidth = 492.0;
      originalHeight = 500.0;
    } else {
      // RAI Televideo: 360x400
      originalWidth = 360.0;
      originalHeight = 400.0;
    }
    
    // Con BoxFit.fill, dobbiamo calcolare il rapporto di scala per x e y separatamente
    final scaleX = imageSize.width / originalWidth;
    final scaleY = imageSize.height / originalHeight;
    
    print('[TeletextViewer] Tap at: dx=${localPosition.dx}, dy=${localPosition.dy}');
    print('[TeletextViewer] Image size: ${imageSize.width}x${imageSize.height}');
    print('[TeletextViewer] Original size: ${originalWidth}x$originalHeight');
    print('[TeletextViewer] Scale: X=$scaleX, Y=$scaleY');
    
    // Converti le coordinate del tap in coordinate dell'immagine originale
    final imageX = localPosition.dx / scaleX;
    final imageY = localPosition.dy / scaleY;
    
    print('[TeletextViewer] Image coords: X=$imageX, Y=$imageY');
    
    // Verifica se il tap è su un'area cliccabile
    final clickableAreas = _effectiveClickableAreas(widget.page);
    print('[TeletextViewer] Checking ${clickableAreas.length} clickable areas...');
    
    for (final area in clickableAreas) {
      final bool isInArea = imageX >= area.x &&
          imageX <= (area.x + area.width) &&
          imageY >= area.y &&
          imageY <= (area.y + area.height);
      
      print('[TeletextViewer] Area: x=${area.x}, y=${area.y}, w=${area.width}, h=${area.height}, target=${area.targetPage} → ${isInArea ? "HIT!" : "miss"}');
      
      if (isInArea) {
        print('[TeletextViewer] ✅ Tap on area! Navigating to page ${area.targetPage}');
        // Log dell'evento di navigazione tramite click
        AnalyticsService().logTelevideoPageView(
          area.targetPage.toString(),
          'link_click',
          sourcePageNumber: widget.page.pageNumber.toString(),
        );
        
        if (widget.onPageNumberSubmitted != null) {
          // Ottieni il canale corrente per verificare se è RAI
          final bloc = context.read<TelevideoBloc>();
          String? channelId;
          bloc.state.maybeWhen(
            loaded: (_, __, ___, selectedChannel) {
              channelId = selectedChannel?.id;
            },
            orElse: () {
              channelId = null;
            },
          );
          
          // Verifica se il canale è RAI
          final isRaiChannel = channelId == null || channelId!.startsWith('rai_');
          
          // Carica regionale SOLO se canale RAI E modalità regionale
          if (isRaiChannel && !widget.isNationalMode) {
            // In modalità regionale RAI, manteniamo la regione corrente
            final regionCode = widget.page.region;
            if (regionCode != null) {
              final region = Region.values.firstWhere(
                (r) => r.code == regionCode,
                orElse: () => Region.values.first,
              );
              context.read<TelevideoBloc>().add(
                TelevideoEvent.loadRegionalPage(region, area.targetPage),
              );
            } else {
              // Se non c'è regione, carica nazionale
              widget.onPageNumberSubmitted!(area.targetPage);
            }
          } else {
            // Per canali non-RAI o modalità nazionale, carica sempre nazionale
            widget.onPageNumberSubmitted!(area.targetPage);
          }
        }
        return; // Esce dalla funzione se è stata trovata un'area cliccabile
      }
    }

    // Se arriviamo qui, significa che il tap non è stato su un'area cliccabile
    
    // Verifica se ci sono sottopagine e se l'aggiornamento automatico è abilitato
    final hasSubPages = state.maybeWhen(
      loaded: (page, _, __, ___) => page.maxSubPages > 1,
      orElse: () => false,
    );
    if (!hasSubPages || !AppSettings.liveShowEnabled) return;

    // Invia l'evento di toggle della pausa
    context.read<TelevideoBloc>().add(const TelevideoEvent.toggleAutoRefreshPause());
    
    // Mostra l'overlay e imposta il timer per nasconderlo
    setState(() {
      _showPauseOverlay = true;
    });
    
    _overlayTimer?.cancel();
    _overlayTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showPauseOverlay = false;
        });
      }
    });

    // Gestisci il timer in base allo stato di pausa
    final isPaused = state.maybeWhen(
      loaded: (_, __, isAutoRefreshPaused, ___) => !isAutoRefreshPaused, // Invertiamo perché lo stato non è ancora aggiornato
      orElse: () => false,
    );

    if (isPaused) {
      // Quando mettiamo in pausa, salviamo il tempo rimanente
      _remainingTime = _getTimeRemaining();
      _liveShowTimer?.cancel();
      _refreshTimer?.cancel();
    } else {
      _startLiveShowTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TelevideoBloc, TelevideoState>(
      listener: (context, state) {
        state.maybeWhen(
          loaded: (page, currentSubPage, isAutoRefreshPaused, selectedChannel) {
            setState(() {
              _currentSubPage = currentSubPage;
              _maxSubPages = page.maxSubPages;
              _isRefreshing = false;
            });

            // Gestisci il timer in base allo stato di pausa
            if (isAutoRefreshPaused) {
              // Salva il tempo rimanente prima di cancellare
              _remainingTime = _getTimeRemaining();
              _liveShowTimer?.cancel();
              _refreshTimer?.cancel();
            } else {
              // Riavvia il timer solo se non è in pausa
              _startLiveShowTimer();
            }
          },
          orElse: () {},
        );
      },
      child: Stack(
        children: [
          GestureDetector(
            onVerticalDragStart: _onDragStart,
            onVerticalDragUpdate: _onDragUpdate,
            onVerticalDragEnd: _onDragEnd,
            onHorizontalDragStart: _onDragStart,
            onHorizontalDragUpdate: _onDragUpdate,
            onHorizontalDragEnd: _onDragEnd,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    onTapUp: (details) => _onTapUp(details, constraints.biggest),
                    child: BlocBuilder<TelevideoBloc, TelevideoState>(
                      builder: (context, state) {
                        Widget content = state.when(
                          initial: (selectedChannel) => const Center(child: CircularProgressIndicator()),
                          loading: (pageNumber, selectedChannel) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(
                                  AppLocalizations.of(context)!.loadingPage(pageNumber),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          loaded: (page, currentSubPage, isAutoRefreshPaused, selectedChannel) {
                            final lastEvent = context.read<TelevideoBloc>().lastEvent;
                            var transitionType = PageTransitionType.fade;
                            var forward = true;

                            if (lastEvent != null) {
                              lastEvent.when(
                                loadNationalPage: (_) => transitionType = PageTransitionType.fade,
                                loadRegionalPage: (_, __) => transitionType = PageTransitionType.fade,
                                nextPage: (_) {
                                  // Usa slideHorizontal per canali con IMMAGINI (RAI, MTVA, CT, RTVSLO, YLE, SVT, HRT, Spanish, ORF, Swiss)
                                  // Per canali con HTML/WebView (RTL, Iceland, NOS, ZDF, ARD) usa fade per evitare problemi di rendering
                                  transitionType = page.isHtmlContent 
                                      ? PageTransitionType.fade 
                                      : PageTransitionType.slideHorizontal;
                                  forward = true;
                                },
                                previousPage: (_) {
                                  // Usa slideHorizontal per canali con IMMAGINI (RAI, MTVA, CT, RTVSLO, YLE, SVT, HRT, Spanish, ORF, Swiss)
                                  // Per canali con HTML/WebView (RTL, Iceland, NOS, ZDF, ARD) usa fade per evitare problemi di rendering
                                  transitionType = page.isHtmlContent 
                                      ? PageTransitionType.fade 
                                      : PageTransitionType.slideHorizontal;
                                  forward = false;
                                },
                                nextSubPage: () {
                                  // Usa slideVertical per canali con IMMAGINI
                                  // Per canali con HTML/WebView usa fade
                                  transitionType = page.isHtmlContent 
                                      ? PageTransitionType.fade 
                                      : PageTransitionType.slideVertical;
                                  forward = true;
                                },
                                previousSubPage: () {
                                  // Usa slideVertical per canali con IMMAGINI
                                  // Per canali con HTML/WebView usa fade
                                  transitionType = page.isHtmlContent 
                                      ? PageTransitionType.fade 
                                      : PageTransitionType.slideVertical;
                                  forward = false;
                                },
                                startLoading: () => transitionType = PageTransitionType.fade,
                                toggleAutoRefreshPause: () => transitionType = PageTransitionType.fade,
                                changeChannel: (_) => transitionType = PageTransitionType.fade,
                              );
                            }

                            return AnimatedPageTransition(
                              contentKey: _pageContentKey(page, currentSubPage),
                              type: transitionType,
                              forward: forward,
                              child: page.isHtmlContent
                                  ? _buildHtmlViewer(page, context, currentSubPage)
                                  
                                  : _buildImageWidget(page, context),
                            );
                          },
                          error: (message, selectedChannel) => ErrorPageView(
                            message: message,
                            onRetry: () {
                              final lastEvent = context.read<TelevideoBloc>().lastEvent;
                              
                              lastEvent?.when(
                                loadNationalPage: (pageNumber) {
                                  context.read<TelevideoBloc>().add(
                                    TelevideoEvent.loadNationalPage(pageNumber),
                                  );
                                },
                                loadRegionalPage: (region, pageNumber) {
                                  context.read<TelevideoBloc>().add(
                                    TelevideoEvent.loadRegionalPage(region, pageNumber),
                                  );
                                },
                                nextPage: (currentPage) {
                                  context.read<TelevideoBloc>().add(
                                    TelevideoEvent.nextPage(currentPage: currentPage),
                                  );
                                },
                                previousPage: (currentPage) {
                                  context.read<TelevideoBloc>().add(
                                    TelevideoEvent.previousPage(currentPage: currentPage),
                                  );
                                },
                                nextSubPage: () {
                                  context.read<TelevideoBloc>().add(
                                    const TelevideoEvent.nextSubPage(),
                                  );
                                },
                                previousSubPage: () {
                                  context.read<TelevideoBloc>().add(
                                    const TelevideoEvent.previousSubPage(),
                                  );
                                },
                                startLoading: () {
                                  // Non fare nulla in questo caso
                                },
                                toggleAutoRefreshPause: () {
                                  // Non fare nulla in questo caso
                                },
                                changeChannel: (channel) {
                                  context.read<TelevideoBloc>().add(
                                    TelevideoEvent.changeChannel(channel),
                                  );
                                },
                              );
                            },
                          ),
                        );

                        // Applica la trasformazione durante il drag
                        if (_isDragging) {
                          return Transform.translate(
                            offset: _isVerticalDrag
                                ? Offset(0, _dragProgress * MediaQuery.of(context).size.height)
                                : Offset(_dragProgress * MediaQuery.of(context).size.width, 0),
                            child: content,
                          );
                        }

                        return content;
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          // Indicatore di caricamento
          if (_isRefreshing || context.watch<TelevideoBloc>().state.maybeWhen(
            loading: (_, __) => true,
            orElse: () => false,
          ))
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          // Overlay di pausa/play
          BlocBuilder<TelevideoBloc, TelevideoState>(
            builder: (context, state) {
              final isPaused = state.maybeWhen(
                loaded: (_, __, isAutoRefreshPaused, ___) => isAutoRefreshPaused,
                orElse: () => false,
              );
              return AutoRefreshOverlay(
                isVisible: _showPauseOverlay,
                isPaused: isPaused,
              );
            },
          ),
        ],
      ),
    );
  }
}