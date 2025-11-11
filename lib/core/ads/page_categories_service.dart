/// Servizio per la categorizzazione delle pagine teletext per scopi pubblicitari
/// Ogni canale ha la propria struttura di categorizzazione basata sui range di pagine
class PageCategoriesService {
  static final PageCategoriesService _instance = PageCategoriesService._internal();
  factory PageCategoriesService() => _instance;
  PageCategoriesService._internal();

  /// Ottiene le categorie (keywords) per una pagina di un canale specifico
  List<String> getCategoriesForPage({
    required int pageNumber,
    required String? channelId,
    required bool isRegional,
  }) {
    // Se channelId è null, usa RAI Nazionale come default
    final effectiveChannelId = channelId ?? 'rai_nazionale';
    
    // Se è RAI regionale, usa le categorie regionali
    if (effectiveChannelId.startsWith('rai_') && isRegional) {
      return _getRaiRegionalCategories(pageNumber);
    }
    
    // Altrimenti usa le categorie specifiche del canale
    switch (effectiveChannelId) {
      case 'rai_nazionale':
        return _getRaiNazionaleCategories(pageNumber);
      
      case 'ard_text':
        return _getArdCategories(pageNumber);
      
      case 'zdf_text':
        return _getZdfCategories(pageNumber);
      
      case 'zdfinfo_text':
        return _getZdfinfoCategories(pageNumber);
      
      case 'zdfneo_text':
        return _getZdfneoCategories(pageNumber);
      
      case '3sat_text':
        return _get3satCategories(pageNumber);
      
      case 'swiss_teletext':
        return _getSwissCategories(pageNumber);
      
      case 'orf_teletext':
      case 'orf1_teletext':
      case 'orf2_teletext':
      case 'orf3_teletext':
      case 'orfsportplus_teletext':
        return _getOrfCategories(pageNumber);
      
      case 'tve_teletexto':
        return _getTveCategories(pageNumber);
      
      case 'antena3_teletexto':
        return _getAntena3Categories(pageNumber);
      
      case 'lasexta_teletexto':
        return _getLaSextaCategories(pageNumber);
      
      case 'rtp_teletexto':
        return _getRtpCategories(pageNumber);
      
      case 'nos_teletekst':
        return _getNosCategories(pageNumber);
      
      case 'svt_text':
        return _getSvtCategories(pageNumber);
      
      case 'hrt_teletekst':
        return _getHrtCategories(pageNumber);
      
      case 'bhrt_teletekst':
      case 'rtvfbih_teletekst':
        return _getBosnianCategories(pageNumber);
      
      case 'yle_teksti_tv':
        return _getYleCategories(pageNumber);
      
      case 'ct_teletext':
        return _getCtCategories(pageNumber);
      
      case 'rtvslo_teletext':
        return _getRtvSloCategories(pageNumber);
      
      case 'mtva_teletext':
        return _getMtvaCategories(pageNumber);
      
      case 'ruv_textavarp':
        return _getRuvCategories(pageNumber);
      
      case 'rtl_teletext':
        return _getRtlCategories(pageNumber);
      
      case 'dr_tekst_tv':
        return _getDrCategories(pageNumber);
      
      default:
        return []; // Nessuna categorizzazione per canali non supportati
    }
  }

  // ============================================================================
  // RAI NAZIONALE
  // ============================================================================
  List<String> _getRaiNazionaleCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['news', 'attualita', 'cronaca', 'notizie'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['sport', 'calcio', 'campionato', 'risultati'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['economia', 'finanza', 'mercati', 'borsa'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['utilita', 'servizi', 'informazioni', 'pubblica-utilita'];
    } else if (pageNumber >= 500 && pageNumber < 600) {
      return ['cultura', 'spettacolo', 'entertainment', 'programmi'];
    } else if (pageNumber >= 600 && pageNumber < 700) {
      return ['viabilita', 'trasporti', 'mobilita', 'traffico'];
    } else if (pageNumber >= 700) {
      return ['meteo', 'previsioni', 'tempo', 'clima'];
    }
    return [];
  }

  // ============================================================================
  // RAI REGIONALE
  // ============================================================================
  List<String> _getRaiRegionalCategories(int pageNumber) {
    if (pageNumber >= 300 && pageNumber < 400) {
      return ['cronaca', 'regionale', 'locale', 'territorio'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['sport', 'calcio', 'regionale', 'locale'];
    } else if (pageNumber >= 500 && pageNumber < 600) {
      return ['cultura', 'eventi', 'regionale', 'spettacolo'];
    } else if (pageNumber >= 600 && pageNumber < 700) {
      return ['viabilita', 'traffico', 'regionale', 'locale'];
    } else if (pageNumber >= 700) {
      return ['meteo', 'previsioni', 'regionale', 'locale'];
    }
    return ['regionale', 'locale'];
  }

  // ============================================================================
  // ARD TEXT (Germania)
  // ============================================================================
  List<String> _getArdCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['nachrichten', 'news', 'politik', 'aktuell'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['sport', 'fussball', 'bundesliga', 'ergebnisse'];
    } else if (pageNumber >= 300 && pageNumber < 500) {
      return ['wirtschaft', 'boerse', 'finanzen', 'markt'];
    } else if (pageNumber >= 500 && pageNumber < 600) {
      return ['kultur', 'unterhaltung', 'medien', 'entertainment'];
    } else if (pageNumber >= 600 && pageNumber < 700) {
      return ['verkehr', 'reise', 'service', 'mobilitat'];
    } else if (pageNumber >= 700) {
      return ['wetter', 'vorhersage', 'klima', 'temperatur'];
    }
    return [];
  }

  // ============================================================================
  // ZDF TEXT (Germania - Hauptprogramm)
  // ============================================================================
  List<String> _getZdfCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['nachrichten', 'news', 'politik', 'heute'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['sport', 'fussball', 'bundesliga', 'live'];
    } else if (pageNumber >= 300 && pageNumber < 500) {
      return ['wirtschaft', 'boerse', 'finanzen', 'dax'];
    } else if (pageNumber >= 500 && pageNumber < 600) {
      return ['kultur', 'unterhaltung', 'show', 'film'];
    } else if (pageNumber >= 700) {
      return ['wetter', 'vorhersage', 'europa', 'deutschland'];
    }
    return [];
  }

  // ============================================================================
  // ZDFinfo TEXT (Germania - Documentari)
  // ============================================================================
  List<String> _getZdfinfoCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['nachrichten', 'politik', 'dokumentation', 'info'];
    } else if (pageNumber >= 300 && pageNumber < 700) {
      return ['programm', 'dokumentation', 'reportage', 'wissen'];
    } else if (pageNumber >= 700) {
      return ['wetter', 'service', 'info'];
    }
    return ['dokumentation', 'info', 'wissen'];
  }

  // ============================================================================
  // ZDFneo TEXT (Germania - Entertainment)
  // ============================================================================
  List<String> _getZdfneoCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['nachrichten', 'news', 'aktuell'];
    } else if (pageNumber >= 300 && pageNumber < 700) {
      return ['programm', 'serie', 'film', 'unterhaltung', 'entertainment'];
    } else if (pageNumber >= 700) {
      return ['wetter', 'service'];
    }
    return ['unterhaltung', 'entertainment', 'serie'];
  }

  // ============================================================================
  // 3sat TEXT (Germania/Austria/Svizzera - Cultura)
  // ============================================================================
  List<String> _get3satCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['nachrichten', 'news', 'kultur', 'aktuell'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['sport', 'fussball'];
    } else if (pageNumber >= 400 && pageNumber < 600) {
      return ['wetter', 'vorhersage', 'alpen', 'europa'];
    } else if (pageNumber >= 500 && pageNumber < 700) {
      return ['kultur', 'kunst', 'theater', 'konzert'];
    }
    return ['kultur', 'bildung', 'wissen'];
  }

  // ============================================================================
  // SWISS TELETEXT (Svizzera)
  // ============================================================================
  List<String> _getSwissCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['news', 'nachrichten', 'schweiz', 'aktuell'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['sport', 'fussball', 'eishockey', 'ski'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['wirtschaft', 'boerse', 'finanzen', 'schweiz'];
    } else if (pageNumber >= 400 && pageNumber < 600) {
      return ['wetter', 'vorhersage', 'alpen', 'schweiz'];
    } else if (pageNumber >= 600 && pageNumber < 700) {
      return ['verkehr', 'service', 'schweiz'];
    } else if (pageNumber >= 700) {
      return ['programm', 'tv', 'radio', 'entertainment'];
    }
    return [];
  }

  // ============================================================================
  // ORF TELETEXT (Austria)
  // ============================================================================
  List<String> _getOrfCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['nachrichten', 'news', 'politik', 'oesterreich'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['sport', 'fussball', 'ski', 'eishockey'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['programm', 'tv', 'fernsehen', 'orf'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['kultur', 'unterhaltung', 'show', 'konzert'];
    } else if (pageNumber >= 600 && pageNumber < 700) {
      return ['wetter', 'vorhersage', 'oesterreich', 'alpen'];
    } else if (pageNumber >= 700 && pageNumber < 800) {
      return ['regionen', 'bundeslaender', 'lokal', 'oesterreich'];
    }
    return [];
  }

  // ============================================================================
  // TVE TELETEXTO (Spagna)
  // ============================================================================
  List<String> _getTveCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['noticias', 'actualidad', 'espana', 'nacional'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['deportes', 'futbol', 'liga', 'resultados'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['servicios', 'tiempo', 'trafico', 'utilidad'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['programas', 'television', 'tve', 'entretenimiento'];
    }
    return [];
  }

  // ============================================================================
  // ANTENA 3 TELETEXTO (Spagna)
  // ============================================================================
  List<String> _getAntena3Categories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 150) {
      return ['noticias', 'actualidad', 'espana'];
    } else if (pageNumber >= 130 && pageNumber < 200) {
      return ['deportes', 'futbol', 'resultados'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['marcador', 'futbol', 'directo'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['servicios', 'loterias', 'tiempo', 'bolsa'];
    } else if (pageNumber >= 800) {
      return ['programacion', 'television', 'antena3'];
    }
    return [];
  }

  // ============================================================================
  // LA SEXTA TELETEXTO (Spagna)
  // ============================================================================
  List<String> _getLaSextaCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 150) {
      return ['noticias', 'actualidad', 'espana'];
    } else if (pageNumber >= 130 && pageNumber < 200) {
      return ['deportes', 'futbol', 'resultados'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['marcador', 'futbol', 'directo'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['servicios', 'loterias', 'tiempo', 'bolsa'];
    } else if (pageNumber >= 800) {
      return ['programacion', 'television', 'lasexta'];
    }
    return [];
  }

  // ============================================================================
  // RTP TELETEXTO (Portogallo)
  // ============================================================================
  List<String> _getRtpCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['noticias', 'actualidade', 'portugal', 'nacional'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['desporto', 'futebol', 'liga', 'resultados'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['economia', 'bolsa', 'financas', 'mercados'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['cultura', 'espectaculos', 'entretenimento'];
    } else if (pageNumber >= 500 && pageNumber < 600) {
      return ['meteorologia', 'tempo', 'previsao'];
    } else if (pageNumber >= 600 && pageNumber < 700) {
      return ['servicos', 'utilidade', 'informacao'];
    } else if (pageNumber >= 700) {
      return ['programacao', 'televisao', 'rtp'];
    }
    return [];
  }

  // ============================================================================
  // NOS TELETEKST (Paesi Bassi)
  // ============================================================================
  List<String> _getNosCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['nieuws', 'news', 'actualiteit', 'nederland'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['sport', 'voetbal', 'eredivisie', 'uitslagen'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['economie', 'beurs', 'financien', 'markt'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['weer', 'weerbericht', 'voorspelling'];
    } else if (pageNumber >= 500 && pageNumber < 600) {
      return ['verkeer', 'files', 'reizen', 'mobiliteit'];
    } else if (pageNumber >= 600 && pageNumber < 700) {
      return ['cultuur', 'entertainment', 'media'];
    } else if (pageNumber >= 700) {
      return ['tv-gids', 'programma', 'televisie'];
    }
    return [];
  }

  // ============================================================================
  // SVT TEXT (Svezia)
  // ============================================================================
  List<String> _getSvtCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['nyheter', 'news', 'aktuellt', 'sverige'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['sport', 'fotboll', 'hockey', 'resultat'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['ekonomi', 'bors', 'finans', 'naringsliv'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['vader', 'prognos', 'klimat', 'temperatur'];
    } else if (pageNumber >= 500 && pageNumber < 700) {
      return ['kultur', 'underhallning', 'media'];
    } else if (pageNumber >= 700) {
      return ['program', 'tv', 'svt'];
    }
    return [];
  }

  // ============================================================================
  // HRT TELETEKST (Croazia)
  // ============================================================================
  List<String> _getHrtCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['vijesti', 'news', 'hrvatska', 'aktualno'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['sport', 'nogomet', 'liga', 'rezultati'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['kultura', 'zabava', 'entertainment'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['vrijeme', 'prognoza', 'meteorologija'];
    } else if (pageNumber >= 600 && pageNumber < 700) {
      return ['promet', 'ceste', 'informacije'];
    } else if (pageNumber >= 700) {
      return ['program', 'televizija', 'hrt'];
    }
    return [];
  }

  // ============================================================================
  // BHRT & RTVFBiH TELETEKST (Bosnia)
  // ============================================================================
  List<String> _getBosnianCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['vijesti', 'news', 'bosna', 'aktualno'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['sport', 'nogomet', 'liga', 'rezultati'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['kultura', 'zabava', 'drustvo'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['vrijeme', 'prognoza', 'meteorologija'];
    } else if (pageNumber >= 600) {
      return ['program', 'televizija', 'bhrt'];
    }
    return [];
  }

  // ============================================================================
  // YLE TEKSTI-TV (Finlandia)
  // ============================================================================
  List<String> _getYleCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['uutiset', 'news', 'suomi', 'ajankohtaista'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['urheilu', 'sport', 'jalkapallo', 'jaakiekko'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['talous', 'porssi', 'rahoitus'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['saa', 'ennuste', 'lampotila'];
    } else if (pageNumber >= 500 && pageNumber < 600) {
      return ['kulttuuri', 'viihde', 'media'];
    } else if (pageNumber >= 600) {
      return ['ohjelmat', 'tv', 'yle'];
    }
    return [];
  }

  // ============================================================================
  // ČT TELETEXT (Repubblica Ceca)
  // ============================================================================
  List<String> _getCtCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['zpravy', 'news', 'cesko', 'aktualne'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['sport', 'fotbal', 'hokej', 'vysledky'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['ekonomika', 'burza', 'finance', 'trh'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['pocasi', 'predpoved', 'teplota'];
    } else if (pageNumber >= 500 && pageNumber < 700) {
      return ['kultura', 'zabava', 'entertainment'];
    } else if (pageNumber >= 700) {
      return ['program', 'televize', 'ct'];
    }
    return [];
  }

  // ============================================================================
  // RTV SLO TELETEXT (Slovenia)
  // ============================================================================
  List<String> _getRtvSloCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['novice', 'news', 'slovenija', 'aktualno'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['sport', 'nogomet', 'hokej', 'rezultati'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['gospodarstvo', 'borza', 'finance'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['vreme', 'napoved', 'temperatura'];
    } else if (pageNumber >= 500 && pageNumber < 600) {
      return ['kultura', 'zabava', 'entertainment'];
    } else if (pageNumber >= 600) {
      return ['program', 'televizija', 'rtvslo'];
    }
    return [];
  }

  // ============================================================================
  // MTVA TELETEXT (Ungheria)
  // ============================================================================
  List<String> _getMtvaCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['hirek', 'news', 'magyarorszag', 'aktualis'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['sport', 'labdarugas', 'eredmenyek'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['gazdasag', 'tozsde', 'penzugy'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['idojaras', 'elorejelzes', 'homerseklet'];
    } else if (pageNumber >= 500 && pageNumber < 600) {
      return ['kultura', 'szrakozas', 'entertainment'];
    } else if (pageNumber >= 600) {
      return ['musor', 'televizio', 'mtva'];
    }
    return [];
  }

  // ============================================================================
  // RÚV TEXTAVARP (Islanda)
  // ============================================================================
  List<String> _getRuvCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['frettir', 'news', 'island', 'aktuellt'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['idrottir', 'sport', 'fotbolti', 'urslit'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['efnahagsmal', 'viskipti', 'markadur'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['vedur', 'spá', 'hitastig', 'veðurspá'];
    } else if (pageNumber >= 500 && pageNumber < 600) {
      return ['menning', 'skemmtun', 'entertainment'];
    } else if (pageNumber >= 600) {
      return ['dagskra', 'sjónvarp', 'ruv'];
    }
    return [];
  }

  // ============================================================================
  // RTL TELETEXT (Lussemburgo)
  // ============================================================================
  List<String> _getRtlCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['news', 'actualite', 'luxembourg', 'aktuell'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['sport', 'fussball', 'football', 'resultats'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['economie', 'wirtschaft', 'bourse', 'finance'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['meteo', 'wetter', 'temps', 'previsions'];
    } else if (pageNumber >= 500 && pageNumber < 600) {
      return ['culture', 'kultur', 'entertainment', 'loisirs'];
    } else if (pageNumber >= 600) {
      return ['programme', 'programm', 'television', 'rtl'];
    }
    return [];
  }

  // ============================================================================
  // DR TEKST-TV (Danimarca)
  // ============================================================================
  List<String> _getDrCategories(int pageNumber) {
    if (pageNumber >= 100 && pageNumber < 200) {
      return ['nyheder', 'news', 'danmark', 'aktuelt'];
    } else if (pageNumber >= 200 && pageNumber < 300) {
      return ['sport', 'fodbold', 'haandbold', 'resultater'];
    } else if (pageNumber >= 300 && pageNumber < 400) {
      return ['oekonomi', 'boers', 'finans', 'erhverv'];
    } else if (pageNumber >= 400 && pageNumber < 500) {
      return ['vejr', 'vejrudsigt', 'prognose', 'temperatur'];
    } else if (pageNumber >= 500 && pageNumber < 600) {
      return ['kultur', 'underholdning', 'entertainment'];
    } else if (pageNumber >= 600) {
      return ['program', 'tv', 'dr'];
    }
    return [];
  }
}

