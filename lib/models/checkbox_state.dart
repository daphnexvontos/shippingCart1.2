// For 'select all' checkbox

class CheckBoxState{
  final String title;
  bool value;
  final List<bool> toggle;
  final double packageValue;
  final String days;
  final double itemValue;
  final String image;
  final List<bool> shippingMethodBool;
  String trackingNo;
  String dateStored;
  final double storageFee;

  CheckBoxState({
    required this.title,
    this.value = false,
    required this.toggle,
    this.packageValue = 0,
    required this.dateStored,
    required this.days,
    required this.itemValue,
    required this.image,
    required this.shippingMethodBool,
    required this.trackingNo,
    required this.storageFee,
  });
}