// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
//flutter pub run build_runner build --delete-conflicting-outputs

part 'address.g.dart';

@HiveType(typeId: 1)
class Address extends Equatable {
  @HiveField(0)
  final String street;
  @HiveField(1)
  final String city;

  const Address({required this.street, required this.city});

  @override
  // TODO: implement props
  List<Object?> get props => [street, city];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'street': street, 'city': city};
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'] as String,
      city: map['city'] as String,
    );
  }

  Address copyWith({String? street, String? city}) {
    return Address(street: street ?? this.street, city: city ?? this.city);
  }
}
