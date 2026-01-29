import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'package:hivecaching/features/domain/model/address.dart';
//flutter pub run build_runner build --delete-conflicting-outputs

part 'users.g.dart';

@HiveType(typeId: 0)
class Users extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final Address address;

  const Users({required this.id, required this.name, required this.address});
  @override
  List<Object?> get props => [id, name, address];

  Users copyWith({int? id, String? name, Address? address}) {
    return Users(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'address': address.toMap(),
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'] as int,
      name: map['name'] as String,
      address: Address.fromMap(map['address'] as Map<String, dynamic>),
    );
  }
}
