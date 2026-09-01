import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_data.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import 'bookings_screen.dart';
import 'login_screen.dart';
import 'payment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _company;
  CarType? _car;
  bool? _whole;
  int _seats = 1;
  String? _from, _to;

  double get _price {
    if (_car == null || _whole == null) return 0;
    return _whole! ? _car!.fullPrice : _car!.seatPrice * _seats;
  }

  double? get _distance =>
      (_from != null && _to != null && _from != _to) ? distanceKm(_from!, _to!) : null;
  int? get _minutes => _distance == null ? null : travelMinutes(_distance!);

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  void _swap() => setState(() {
        final t = _from;
        _from = _to;
        _to = t;
      });

  void _continue() {
    final l = context.l;
    if (_company == null) return _snack(l.t('errCompany'));
    if (_car == null) return _snack(l.t('errCar'));
    if (_whole == null) return _snack(l.t('errType'));
    if (_from == null || _to == null) return _snack(l.t('chooseCity'));
    if (_from == _to) return _snack(l.t('sameCity'));
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PaymentScreen(
        draft: BookingDraft(
          companyId: _company!, carId: _car!.id, wholeCar: _whole!,
          seats: _whole! ? 0 : _seats, fromId: _from!, toId: _to!,
          price: _price, distanceKm: _distance!, durationMin: _minutes!,
        ),
      ),
    ));
  }

  Future<void> _logout() async {
    final l = context.l;
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text(l.t('logout')),
        content: Text(l.t('logoutQ')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d, false), child: Text(l.t('cancel'))),
          TextButton(onPressed: () => Navigator.pop(d, true), child: Text(l.t('yes'))),
        ],
      ),
    );
    if (ok == true && mounted) {
      context.read<AppState>().logout();
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final state = context.watch<AppState>();
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel In'),
        actions: [
          IconButton(
            tooltip: l.t('language'),
            onPressed: () => context.read<AppState>().toggleLanguage(),
            icon: Text(state.locale.languageCode.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          IconButton(
            tooltip: dark ? l.t('lightMode') : l.t('darkMode'),
            onPressed: () => context.read<AppState>().toggleTheme(),
            icon: Icon(dark ? Icons.light_mode : Icons.dark_mode),
          ),
          IconButton(
            tooltip: l.t('myBookings'),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const BookingsScreen())),
            icon: const Icon(Icons.receipt_long),
          ),
          IconButton(
            tooltip: l.t('logout'),
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        children: [
          Text('${l.t('hello')} ${state.user?.name ?? ''} 👋',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          Text(l.t('bookTrip'),
              style: TextStyle(color: Theme.of(context).hintColor, fontSize: 15)),
          const SizedBox(height: 16),
          _section(l.t('chooseCompany')),
          Row(children: [for (final c in kCompanies) Expanded(child: _companyCard(c))]),
          const SizedBox(height: 16),
          _section(l.t('chooseCar')),
          ...kCars.map(_carTile),
          const SizedBox(height: 16),
          _section(l.t('bookingType')),
          Row(children: [
            Expanded(child: _typeCard(true)),
            const SizedBox(width: 10),
            Expanded(child: _typeCard(false)),
          ]),
          if (_whole == false) ...[const SizedBox(height: 12), _seatStepper(l)],
          const SizedBox(height: 16),
          _section(l.t('route')),
          Row(children: [
            Expanded(child: _cityDropdown(isFrom: true)),
            IconButton(onPressed: _swap, icon: const Icon(Icons.swap_horiz)),
            Expanded(child: _cityDropdown(isFrom: false)),
          ]),
          const SizedBox(height: 14),
          _tripInfo(l),
          const SizedBox(height: 8),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(l.t('total'),
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              Text('\$${_price.toStringAsFixed(0)}',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary)),
            ]),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _continue, child: Text(l.t('continuePay'))),
          ]),
        ),
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 4),
        child:
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      );

  BoxDecoration _box() => BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.4)),
      );

  Widget _companyCard(String id) {
    final l = context.l;
    final sel = _company == id;
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => setState(() => _company = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: sel ? cs.primary.withOpacity(.12) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: sel ? cs.primary : Theme.of(context).dividerColor.withOpacity(.4),
              width: sel ? 2 : 1),
        ),
        child: Column(children: [
          Icon(
            id == 'vip' ? Icons.workspace_premium : (id == 'arhab' ? Icons.terrain : Icons.verified),
            color: sel ? cs.primary : cs.onSurfaceVariant, size: 28),
          const SizedBox(height: 6),
          Text(l.company(id),
              style: TextStyle(fontWeight: FontWeight.w700, color: sel ? cs.primary : null)),
        ]),
      ),
    );
  }

  Widget _carTile(CarType car) {
    final l = context.l;
    final sel = _car?.id == car.id;
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => setState(() => _car = car),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: sel ? cs.primary.withOpacity(.08) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: sel ? cs.primary : Theme.of(context).dividerColor.withOpacity(.4),
              width: sel ? 2 : 1),
        ),
        child: Row(children: [
          CircleAvatar(
              radius: 22,
              backgroundColor: cs.primary.withOpacity(.15),
              child: Icon(car.icon, color: cs.primary)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.car(car.id),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 2),
              Text(
                  '${l.t('wholeCar')}: \$${car.fullPrice.toStringAsFixed(0)}  •  ${l.t('perSeat')}: \$${car.seatPrice.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 12.5, color: Theme.of(context).hintColor)),
            ]),
          ),
          Icon(sel ? Icons.check_circle : Icons.radio_button_unchecked,
              color: sel ? cs.primary : Theme.of(context).hintColor),
        ]),
      ),
    );
  }

  Widget _typeCard(bool whole) {
    final l = context.l;
    final sel = _whole == whole;
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => setState(() => _whole = whole),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: sel ? cs.primary.withOpacity(.12) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: sel ? cs.primary : Theme.of(context).dividerColor.withOpacity(.4),
              width: sel ? 2 : 1),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(whole ? Icons.directions_car_filled : Icons.event_seat,
              size: 20, color: sel ? cs.primary : cs.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(l.t(whole ? 'wholeCar' : 'perSeat'),
              style: TextStyle(fontWeight: FontWeight.w700, color: sel ? cs.primary : null)),
        ]),
      ),
    );
  }

  Widget _seatStepper(AppLocalizations l) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: _box(),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(l.t('seatsCount'), style: const TextStyle(fontWeight: FontWeight.w600)),
          Row(children: [
            IconButton(
                onPressed: _seats > 1 ? () => setState(() => _seats--) : null,
                icon: const Icon(Icons.remove_circle_outline)),
            Text(_seats == 1 ? l.t('seatOne') : '$_seats ${l.t('seatsMany')}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            IconButton(
                onPressed: _seats < 7 ? () => setState(() => _seats++) : null,
                icon: const Icon(Icons.add_circle_outline)),
          ]),
        ]),
      );

  Widget _cityDropdown({required bool isFrom}) {
    final l = context.l;
    return DropdownButtonFormField<String>(
      value: isFrom ? _from : _to,
      decoration: InputDecoration(
          labelText: l.t(isFrom ? 'from' : 'to'),
          prefixIcon:
              Icon(isFrom ? Icons.trip_origin : Icons.location_on_outlined)),
      items: [
        for (final id in kCities.keys)
          DropdownMenuItem(
              value: id,
              child: Text(l.city(id), overflow: TextOverflow.ellipsis)),
      ],
      onChanged: (v) => setState(() {
        if (isFrom) { _from = v; } else { _to = v; }
      }),
    );
  }

  Widget _tripInfo(AppLocalizations l) {
    final d = _distance;
    final m = _minutes;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _box(),
      child: Row(children: [
        Expanded(
            child: _infoCol(Icons.straighten, l.t('distance'),
                d == null ? '—' : '≈ ${d.toStringAsFixed(0)} ${l.t('km')}')),
        Container(width: 1, height: 40, color: Theme.of(context).dividerColor),
        Expanded(
            child: _infoCol(Icons.schedule, l.t('duration'),
                m == null ? '—' : '≈ ${l.duration(m)}')),
      ]),
    );
  }

  Widget _infoCol(IconData ic, String label, String value) => Column(children: [
        Icon(ic, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
      ]);
}
