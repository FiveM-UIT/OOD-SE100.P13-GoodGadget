import 'package:gizmoglobe_client/objects/address_related/district.dart';
import 'package:gizmoglobe_client/objects/address_related/province.dart';
import 'package:gizmoglobe_client/objects/address_related/ward.dart';

class Address {
  final String? addressID;
  final String receiverName;
  final String receiverPhone;
  final Province? province;
  final District? district;
  final Ward? ward;
  final String? street;
  final bool isDefault;

  Address({
    this.addressID,
    required this.receiverName,
    required this.receiverPhone,
    this.province,
    this.district,
    this.ward,
    this.street,
    required this.isDefault,
  });

  @override
  String toString() {
    return '$receiverName - $receiverPhone'
          '${street != null ? ', $street' : ''}'
          '${ward != null ? ', $ward' : ''}'
          '${district != null ? ', $district' : ''}'
          '${province != null ? ', $province' : ''}';
  }
}