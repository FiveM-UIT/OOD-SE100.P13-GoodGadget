class Manufacturer {
  final String? manufacturerID;
  final String manufacturerName;

  Manufacturer({
    this.manufacturerID,
    required this.manufacturerName,
  });

  static Manufacturer nullManufacturer = Manufacturer(
    manufacturerName: 'Unknown',
    manufacturerID: '',
  );
}