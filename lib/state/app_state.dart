import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  final String name;
  final int age;
  final String? email, photoUrl;
  AppUser({required this.name, required this.age, this.email, this.photoUrl});

  Map<String, dynamic> toJson() =>
      {'name': name, 'age': age, 'email': email, 'photoUrl': photoUrl};

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
        name: (j['name'] ?? '') as String,
        age: (j['age'] as num?)?.toInt() ?? 0,
        email: j['email'] as String?,
        photoUrl: j['photoUrl'] as String?,
      );
}

class Booking {
  final String id, companyId, carId, fromId, toId, paymentId, createdAt;
  final bool wholeCar;
  final int seats;
  final double price, distanceKm;
  final int durationMin;
  final String? walletType, depositor, ref;
  final double? paidAmount;

  Booking({
    required this.id, required this.companyId, required this.carId,
    required this.wholeCar, required this.seats, required this.fromId,
    required this.toId, required this.price, required this.paymentId,
    this.walletType, this.depositor, this.ref, this.paidAmount,
    required this.createdAt, required this.distanceKm, required this.durationMin,
  });

  bool get onArrival => paymentId == 'arrival';

  Map<String, dynamic> toJson() => {
        'id': id, 'companyId': companyId, 'carId': carId, 'wholeCar': wholeCar,
        'seats': seats, 'fromId': fromId, 'toId': toId, 'price': price,
        'paymentId': paymentId, 'walletType': walletType, 'depositor': depositor,
        'ref': ref, 'paidAmount': paidAmount, 'createdAt': createdAt,
        'distanceKm': distanceKm, 'durationMin': durationMin,
      };

  factory Booking.fromJson(Map<String, dynamic> j) => Booking(
        id: j['id'], companyId: j['companyId'], carId: j['carId'],
        wholeCar: j['wholeCar'], seats: (j['seats'] as num).toInt(),
        fromId: j['fromId'], toId: j['toId'],
        price: (j['price'] as num).toDouble(), paymentId: j['paymentId'],
        walletType: j['walletType'], depositor: j['depositor'], ref: j['ref'],
        paidAmount: (j['paidAmount'] as num?)?.toDouble(),
        createdAt: j['createdAt'],
        distanceKm: (j['distanceKm'] as num).toDouble(),
        durationMin: (j['durationMin'] as num).toInt(),
      );
}

class BookingDraft {
  final String companyId, carId, fromId, toId;
  final bool wholeCar;
  final int seats;
  final double price, distanceKm;
  final int durationMin;
  const BookingDraft({
    required this.companyId, required this.carId, required this.wholeCar,
    required this.seats, required this.fromId, required this.toId,
    required this.price, required this.distanceKm, required this.durationMin,
  });
}

class AppState extends ChangeNotifier {
  final SharedPreferences prefs;
  AppState(this.prefs);

  Locale _locale = const Locale('ar');
  ThemeMode _themeMode = ThemeMode.system;
  AppUser? user;
  List<Booking> bookings = [];

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  void load() {
    final l = prefs.getString('locale');
    if (l == 'en') _locale = const Locale('en');
    final t = prefs.getString('theme');
    if (t == 'light') _themeMode = ThemeMode.light;
    if (t == 'dark') _themeMode = ThemeMode.dark;
    final u = prefs.getString('user');
    if (u != null) {
      try { user = AppUser.fromJson(jsonDecode(u)); } catch (_) {}
    }
    final b = prefs.getString('bookings');
    if (b != null) {
      try {
        bookings = (jsonDecode(b) as List).map((e) => Booking.fromJson(e)).toList();
      } catch (_) {}
    }
  }

  void setLocale(Locale locale) {
    _locale = locale;
    prefs.setString('locale', locale.languageCode);
    notifyListeners();
  }

  void toggleLanguage() => setLocale(
      _locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar'));

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    prefs.setString('theme',
        mode == ThemeMode.dark ? 'dark' : mode == ThemeMode.light ? 'light' : 'system');
    notifyListeners();
  }

  void toggleTheme() =>
      setThemeMode(_themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

  void setUser(AppUser u) {
    user = u;
    prefs.setString('user', jsonEncode(u.toJson()));
    notifyListeners();
  }

  void logout() {
    user = null;
    prefs.remove('user');
    notifyListeners();
  }

  void addBooking(Booking b) {
    bookings.insert(0, b);
    prefs.setString('bookings', jsonEncode(bookings.map((e) => e.toJson()).toList()));
    notifyListeners();
  }
}
