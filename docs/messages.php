<?php
/**
 * API messaggi remoti per Teletext Europe
 * Parametri: lang, country, version, channel
 * Esempio: messages.php?lang=it&country=IT&version=2.1.1&channel=rai_nazionale
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');

$lang = strtolower($_GET['lang'] ?? 'en');
$country = strtoupper($_GET['country'] ?? 'IT');
$version = $_GET['version'] ?? '0.0.0';
$channel = $_GET['channel'] ?? '';

$messages = [
    [
        'id' => 'welcome_2025',
        'content' => [
            'it' => 'Benvenuto! Novità in arrivo per Teletext Europe.',
            'en' => 'Welcome! New features coming to Teletext Europe.',
            'de' => 'Willkommen! Neue Funktionen kommen zu Teletext Europe.',
        ],
        'fallbackContent' => 'Welcome! New features coming.',
        'countries' => ['IT', 'DE', 'AT', 'CH'],
        'channels' => ['rai_nazionale', 'ard_text'],
        'maxVersion' => '2.2.0',
        'minVersion' => '2.0.0',
        'priority' => 1,
        'type' => 'snackbar',
    ],
    [
        'id' => 'update_reminder',
        'content' => [
            'it' => 'È disponibile una nuova versione! Aggiorna per le ultime novità.',
            'en' => 'A new version is available! Update for the latest features.',
        ],
        'fallbackContent' => 'A new version is available! Update for the latest features.',
        'maxVersion' => '2.2.2',
        'priority' => 2,
        'type' => 'snackbar',
        'isUpdateNotification' => true,
        'actionUrl' => 'https://apps.apple.com/app/teletext-europe/6748967698',
        'actionLabel' => 'Update',
    ],
];

function versionCompare($v1, $v2) {
    $v1 = explode('.', preg_replace('/\+.*/', '', $v1));
    $v2 = explode('.', preg_replace('/\+.*/', '', $v2));
    for ($i = 0; $i < 3; $i++) {
        $a = (int)($v1[$i] ?? 0);
        $b = (int)($v2[$i] ?? 0);
        if ($a > $b) return 1;
        if ($a < $b) return -1;
    }
    return 0;
}

$filtered = [];
foreach ($messages as $m) {
    if (!empty($m['languages']) && !in_array($lang, array_map('strtolower', $m['languages']))) continue;
    if (!empty($m['countries']) && !in_array($country, array_map('strtoupper', $m['countries']))) continue;
    if (!empty($m['channels']) && !in_array($channel, $m['channels'])) continue;
    if (!empty($m['maxVersion']) && versionCompare($version, $m['maxVersion']) >= 0) continue;
    if (!empty($m['minVersion']) && versionCompare($version, $m['minVersion']) < 0) continue;

    $text = $m['content'][$lang] ?? $m['content']['en'] ?? $m['fallbackContent'] ?? '';
    if (empty($text)) continue;

    $filtered[] = $m;
}

usort($filtered, fn($a, $b) => ($b['priority'] ?? 0) - ($a['priority'] ?? 0));

echo json_encode(['messages' => $filtered]);
