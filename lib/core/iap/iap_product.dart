/// Prodotto IAP esposto all'UI (indipendente da in_app_purchase).
class IAPProduct {
  final String id;
  final String title;
  final String description;
  final String price;
  final String currencyCode;

  const IAPProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyCode,
  });
}
