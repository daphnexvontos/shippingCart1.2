// For shipments

class Shipment{
  final String title;
  final String trackingNumber;
  final String days;
  final String delivery;
  final String estDelivery;
  final String image;
  final String dateStored;
  final value;
  final String bundleType;
  final String notes;
  final double storageFee;

  Shipment({
    required this.title,
    required this.trackingNumber,
    required this.days,
    required this.delivery,
    required this.estDelivery,
    required this.image,
    required this.dateStored,
    required this.value,
    required this.bundleType,
    required this.notes,
    required this.storageFee
  });
}