import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  const AppLocalizations(this.locale);

  static const supportedLocales = [Locale('ar'), Locale('en')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) =>
      AppLocalizations(Localizations.localeOf(context));

  String get code => locale.languageCode;
  bool get isArabic => code == 'ar';

  String t(String key) => _values[code]?[key] ?? _values['en']![key] ?? key;
  String city(String id) => _cities[code]?[id] ?? id;
  String car(String id) => _cars[code]?[id] ?? id;
  String company(String id) => _companies[code]?[id] ?? id;
  String payment(String id) => _payments[code]?[id] ?? id;
  String walletName(String id) =>
      t({'jawali': 'walletJawali', 'one': 'walletOne', 'floosak': 'walletFloosak', 'jaib': 'walletJaib'}[id] ?? id);

  String duration(int minutes) {
    final h = minutes ~/ 60, m = minutes % 60;
    final hh = isArabic ? 'س' : 'h';
    final mm = isArabic ? 'د' : 'm';
    if (h == 0) return '$m $mm';
    if (m == 0) return '$h $hh';
    return '$h $hh $m $mm';
  }

  static const Map<String, Map<String, String>> _values = {
    'ar': {
      'appName': 'Travel In',
      'tagline': 'رحلتك الفاخرة بين محافظات اليمن',
      'skip': 'تخطي',
      'loginTitle': 'مرحباً بك في Travel In',
      'loginSubtitle': 'سجّل الدخول لتحجز رحلتك بسهولة وراحة',
      'signInGoogle': 'المتابعة باستخدام Google',
      'continueWithout': 'المتابعة بدون تسجيل دخول',
      'googleFailed': 'تعذّر تسجيل الدخول عبر Google، يمكنك المتابعة بدون تسجيل.',
      'completeProfile': 'أكمل بياناتك',
      'profileHint': 'نحتاج اسمك وعمرك لإتمام الحجز',
      'nameLabel': 'الاسم الكامل',
      'nameHint': 'مثال: أحمد محمد',
      'ageLabel': 'العمر',
      'saveContinue': 'حفظ والمتابعة',
      'errName': 'الرجاء إدخال الاسم',
      'errAge': 'أدخل عمراً صحيحاً (10 - 100)',
      'hello': 'أهلاً',
      'bookTrip': 'احجز رحلتك الآن',
      'chooseCompany': 'اختر شركة النقل',
      'chooseCar': 'اختر السيارة',
      'bookingType': 'نوع الحجز',
      'wholeCar': 'السيارة كاملة',
      'perSeat': 'بالمقعد',
      'seatsCount': 'عدد المقاعد',
      'seatOne': 'مقعد واحد',
      'seatsMany': 'مقاعد',
      'from': 'من (مدينتك الحالية)',
      'to': 'إلى (وجهتك)',
      'route': 'حدد المسار',
      'chooseCity': 'اختر المدينة',
      'sameCity': 'لا يمكن أن تكون المدينتان متطابقتين',
      'distance': 'المسافة التقريبية',
      'duration': 'الوقت المتوقع للسفر',
      'km': 'كم',
      'total': 'الإجمالي',
      'continuePay': 'متابعة إلى الدفع',
      'errCompany': 'اختر شركة النقل أولاً',
      'errCar': 'اختر السيارة أولاً',
      'errType': 'اختر نوع الحجز أولاً',
      'paymentTitle': 'طريقة الدفع',
      'choosePayment': 'اختر طريقة الدفع المناسبة',
      'arrivalDesc': 'ادفع للسائق نقداً عند وصولك إلى وجهتك',
      'kuraimiDesc': 'إيداع نقدي على حساب بنك الكريمي',
      'walletDesc': 'جوالي، محفظة كاش، فلوسك، جيب',
      'accountNumber': 'رقم الحساب',
      'accountName': 'اسم صاحب الحساب',
      'walletNumber': 'رقم المحفظة',
      'walletType': 'نوع المحفظة',
      'depositorName': 'اسم المودِع',
      'transferRef': 'رقم الإشعار / المرجع',
      'depositAmount': 'مبلغ الإيداع (\$)',
      'errDepositor': 'أدخل اسم المودِع',
      'errRef': 'أدخل رقم الإشعار',
      'errAmount': 'أدخل مبلغاً صحيحاً',
      'depositNote': 'سيتم التحقق من بيانات الإيداع لتأكيد صحة الحجز',
      'confirmBooking': 'تأكيد الحجز',
      'copied': 'تم النسخ',
      'done': 'تم!',
      'bookingReceived': 'تم استلام حجزك بنجاح',
      'statusPending': 'قيد التحقق من الإيداع',
      'statusArrival': 'الدفع عند الوصول',
      'bookingId': 'رقم الحجز',
      'details': 'تفاصيل الحجز',
      'routeLabel': 'المسار',
      'carLabel': 'السيارة',
      'companyLabel': 'الشركة الناقلة',
      'typeLabel': 'نوع الحجز',
      'priceLabel': 'الإجمالي',
      'paymentLabel': 'الدفع',
      'depositInfoLabel': 'بيانات الإيداع',
      'dateLabel': 'التاريخ',
      'backHome': 'العودة إلى الرئيسية',
      'myBookings': 'حجوزاتي',
      'noBookings': 'لا توجد حجوزات بعد',
      'logout': 'تسجيل خروج',
      'logoutQ': 'هل تريد تسجيل الخروج؟',
      'cancel': 'إلغاء',
      'yes': 'نعم',
      'darkMode': 'الوضع الداكن',
      'lightMode': 'الوضع النهاري',
      'language': 'اللغة',
      'walletJawali': 'جوالي',
      'walletOne': 'محفظة كاش',
      'walletFloosak': 'فلوسك',
      'walletJaib': 'جيب',
    },
    'en': {
      'appName': 'Travel In',
      'tagline': 'Your luxury ride across Yemen',
      'skip': 'Skip',
      'loginTitle': 'Welcome to Travel In',
      'loginSubtitle': 'Sign in to book your trip easily',
      'signInGoogle': 'Continue with Google',
      'continueWithout': 'Continue without signing in',
      'googleFailed': 'Google sign-in failed. You can continue without signing in.',
      'completeProfile': 'Complete your profile',
      'profileHint': 'We need your name and age to complete bookings',
      'nameLabel': 'Full name',
      'nameHint': 'e.g. Ahmed Mohammed',
      'ageLabel': 'Age',
      'saveContinue': 'Save & Continue',
      'errName': 'Please enter your name',
      'errAge': 'Enter a valid age (10 - 100)',
      'hello': 'Hello',
      'bookTrip': 'Book your trip now',
      'chooseCompany': 'Choose transport company',
      'chooseCar': 'Choose the car',
      'bookingType': 'Booking type',
      'wholeCar': 'Whole car',
      'perSeat': 'Per seat',
      'seatsCount': 'Number of seats',
      'seatOne': '1 seat',
      'seatsMany': 'seats',
      'from': 'From (your current city)',
      'to': 'To (your destination)',
      'route': 'Select route',
      'chooseCity': 'Select city',
      'sameCity': 'The two cities must be different',
      'distance': 'Estimated distance',
      'duration': 'Estimated travel time',
      'km': 'km',
      'total': 'Total',
      'continuePay': 'Continue to payment',
      'errCompany': 'Choose a transport company first',
      'errCar': 'Choose a car first',
      'errType': 'Choose the booking type first',
      'paymentTitle': 'Payment method',
      'choosePayment': 'Choose a suitable payment method',
      'arrivalDesc': 'Pay the driver in cash when you arrive',
      'kuraimiDesc': 'Cash deposit to our Al-Kuraimi account',
      'walletDesc': 'Jawali, One Cash, Floosak, Jaib',
      'accountNumber': 'Account number',
      'accountName': 'Account holder',
      'walletNumber': 'Wallet number',
      'walletType': 'Wallet type',
      'depositorName': 'Depositor name',
      'transferRef': 'Transfer reference No.',
      'depositAmount': 'Deposit amount (\$)',
      'errDepositor': 'Enter the depositor name',
      'errRef': 'Enter the reference number',
      'errAmount': 'Enter a valid amount',
      'depositNote': 'Your deposit details will be verified to confirm the booking',
      'confirmBooking': 'Confirm booking',
      'copied': 'Copied',
      'done': 'Done!',
      'bookingReceived': 'Your booking has been received successfully',
      'statusPending': 'Deposit under verification',
      'statusArrival': 'Payment on arrival',
      'bookingId': 'Booking ID',
      'details': 'Booking details',
      'routeLabel': 'Route',
      'carLabel': 'Car',
      'companyLabel': 'Company',
      'typeLabel': 'Type',
      'priceLabel': 'Total',
      'paymentLabel': 'Payment',
      'depositInfoLabel': 'Deposit info',
      'dateLabel': 'Date',
      'backHome': 'Back to home',
      'myBookings': 'My bookings',
      'noBookings': 'No bookings yet',
      'logout': 'Log out',
      'logoutQ': 'Do you want to log out?',
      'cancel': 'Cancel',
      'yes': 'Yes',
      'darkMode': 'Dark mode',
      'lightMode': 'Light mode',
      'language': 'Language',
      'walletJawali': 'Jawali',
      'walletOne': 'One Cash',
      'walletFloosak': 'Floosak',
      'walletJaib': 'Jaib',
    },
  };

  static const _cities = {
    'ar': {
      'sanaa': 'صنعاء', 'aden': 'عدن', 'taiz': 'تعز', 'hodeidah': 'الحديدة',
      'mukalla': 'المكلا', 'ibb': 'إب', 'marib': 'مأرب', 'seiyun': 'سيئون',
      'ghaydah': 'الغيظة', 'hajjah': 'حجة', 'sadah': 'صعدة', 'dhamar': 'ذمار',
      'mahwit': 'المحويت', 'amran': 'عمران', 'bayda': 'البيضاء', 'ataq': 'عتق',
      'zinjibar': 'زنجبار', 'lahij': 'الحوطة - لحج', 'rima': 'ريمة',
      'alhazm': 'الحزم - الجوف', 'hadibu': 'حديبو - سقطرى',
    },
    'en': {
      'sanaa': "Sana'a", 'aden': 'Aden', 'taiz': 'Taiz', 'hodeidah': 'Al Hudaydah',
      'mukalla': 'Mukalla', 'ibb': 'Ibb', 'marib': 'Marib', 'seiyun': 'Seiyun',
      'ghaydah': 'Al Ghaydah', 'hajjah': 'Hajjah', 'sadah': "Sa'dah", 'dhamar': 'Dhamar',
      'mahwit': 'Al Mahwit', 'amran': 'Amran', 'bayda': 'Al Bayda', 'ataq': 'Ataq',
      'zinjibar': 'Zinjibar', 'lahij': 'Lahij (Al Houta)', 'rima': 'Al Rima',
      'alhazm': 'Al Hazm (Al Jawf)', 'hadibu': 'Hadibu (Socotra)',
    },
  };

  static const _cars = {
    'ar': {'lexus': 'لكزس', 'landcruiser': 'لاند كروزر', 'prado': 'برادو', 'fortuner': 'فورتشنر'},
    'en': {'lexus': 'Lexus', 'landcruiser': 'Land Cruiser', 'prado': 'Prado', 'fortuner': 'Fortuner'},
  };

  static const _companies = {
    'ar': {'arhab': 'أرحب', 'wisam': 'الوسام', 'vip': 'VIP'},
    'en': {'arhab': 'Arhab', 'wisam': 'Al-Wisam', 'vip': 'VIP'},
  };

  static const _payments = {
    'ar': {'arrival': 'الدفع عند الوصول', 'kuraimi': 'بنك الكريمي', 'wallet': 'محافظ اليمن الرقمية'},
    'en': {'arrival': 'Cash on arrival', 'kuraimi': 'Al-Kuraimi Bank', 'wallet': 'Yemen digital wallets'},
  };
}

extension L10nContext on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
