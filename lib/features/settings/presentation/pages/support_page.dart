import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cursor_televideo/core/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorOpeningLink)),
        );
      }
    }
  }

  Future<void> _launchEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'samuele@codebysam.it',
      queryParameters: {
        'subject': 'Supporto TeleRetrò Italia - Versione $_appVersion',
      },
    );
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorOpeningEmail)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.support),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.support_agent,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.supportTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.supportSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Sezione Contatto Diretto
          _buildSectionTitle(context, l10n.directContact),
          const SizedBox(height: 16),
          
          // Email Card
          Card(
            child: ListTile(
              leading: const Icon(Icons.email),
              title: Text(l10n.emailLabel),
              subtitle: const Text('samuele@codebysam.it'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _launchEmail,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Website Card
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.websiteLabel),
              subtitle: const Text('www.codebysam.it/teleretro'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _launchUrl('https://www.codebysam.it/teleretro/support.html'),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Tempo di risposta
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.responseTime,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Sezione FAQ
          _buildSectionTitle(context, l10n.faq),
          const SizedBox(height: 16),
          
          _buildFaqItem(
            context,
            l10n.faqGeolocation,
            l10n.faqGeolocationAnswer,
          ),
          
          _buildFaqItem(
            context,
            l10n.faqFavorites,
            l10n.faqFavoritesAnswer,
          ),
          
          _buildFaqItem(
            context,
            l10n.faqTheme,
            l10n.faqThemeAnswer,
          ),
          
          _buildFaqItem(
            context,
            l10n.faqOffline,
            l10n.faqOfflineAnswer,
          ),
          
          _buildFaqItem(
            context,
            l10n.faqReportProblem,
            l10n.faqReportProblemAnswer,
          ),
          
          const SizedBox(height: 32),
          
          // Informazioni segnalazione bug
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.bug_report,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.reportBugTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.reportBugInstructions,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                ...l10n.reportBugItems.split('\n').map((item) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: Text('• $item', style: theme.textTheme.bodySmall),
                )),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Footer
          Center(
            child: Column(
              children: [
                Text(
                  'TeleRetrò Italia',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.developedBy,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Versione $_appVersion',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

