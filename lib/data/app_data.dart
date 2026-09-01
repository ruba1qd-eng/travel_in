import 'dart:math';
import 'package:flutter/material.dart';

class City {
  final String id;
  final double lat, lng;
  const City(this.id, this.lat, this.lng);
}

/// جميع محافظات اليمن (عواصم المحافظات) مع الإحداثيات لحساب المسافة
const Map<String, City> kCities = {
  'sanaa': City('sanaa', 15.3694, 44.1910),
  'aden': City('aden', 12.7855, 45.0187),
  'taiz': City('taiz', 13.5789, 44.0219),
  'hodeidah': City('hodeidah', 14.7978, 42.9545),
  'mukalla': City('mukalla', 14.5425, 49.1242),
  'ibb': City('ibb', 13.9662, 44.1847),
  'marib': City('marib', 15.4625, 45.3266),
  'seiyun': City('seiyun', 15.9575, 48.8162),
  'ghaydah': City('ghaydah', 16.1272, 52.1683),
  'hajjah': City('hajjah', 15.6945, 43.6058),
  'sadah': City('sadah', 16.9375, 43.7642),
  'dhamar': City('dhamar', 14.5686, 44.1972),
  'mahwit': City('mahwit', 15.4714, 43.5483),
  'amran': City('amran', 15.6539, 43.9436),
  'bayda': City('bayda', 14.3458, 45.5758),
  'ataq': City('ataq', 14.5328, 46.8347),
  'zinjibar': City('zinjibar', 13.1242, 45.3875),
  'lahij': City('lahij', 13.5367, 44.7339),
  'rima': City('rima', 14.6303, 43.7303),
  'alhazm': City('alhazm', 16.0172, 44.9311),
  'hadibu': City('hadibu', 12.6519, 54.0244),
};

class CarType {
  final String id;
  final double fullPrice;
  final double seatPrice;
  final IconData icon;
  const CarType(this.id, this.fullPrice, this.seatPrice, this.icon);
}

const List<CarType> kCars = [
  CarType('lexus', 300, 90, Icons.directions_car_filled),
  CarType('landcruiser', 280, 75, Icons.directions_car_filled),
  CarType('prado', 250, 65, Icons.directions_car_filled),
  CarType('fortuner', 220, 50, Icons.directions_car_filled),
];

const List<String> kCompanies = ['arhab', 'wisam', 'vip'];

const String kKuraimiAccount = '1234 5678 9012';
const String kKuraimiName = 'Travel In Co.';
const String kWalletNumber = '771 234 567';

double _rad(double d) => d * pi / 180;

double distanceKm(String fromId, String toId) {
  final a = kCities[fromId]!;
  final b = kCities[toId]!;
  const r = 6371.0;
  final dLat = _rad(b.lat - a.lat);
  final dLng = _rad(b.lng - a.lng);
  final s = sin(dLat / 2) * sin(dLat / 2) +
      cos(_rad(a.lat)) * cos(_rad(b.lat)) * sin(dLng / 2) * sin(dLng / 2);
  return 2 * r * asin(sqrt(s));
}

int travelMinutes(double km) => ((km * 1.25) / 65 * 60).round();
