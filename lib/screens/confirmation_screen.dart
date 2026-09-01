import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import 'home_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  final Booking booking;
  const ConfirmationScreen({super.key, required this.booking});
  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
  late final Animation<double> _scale =
      CurvedAnimation(parent: _c, curve: Curves.elasticOut);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final b = widget.booking;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l.t('details'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const SizedBox(height: 8),
        ScaleTransition(
          scale: _scale,
          child: Center(
            child: CircleAvatar(
                radius: 44,
                backgroundColor: cs.primary,
                child: const Icon(Icons.check, size: 52, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 14),
        Text(l.t('done'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(l.t('bookingReceived'),
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).hintColor)),
        const SizedBox(height: 14),
        Center(child: _chip('${l.t('bookingId')}: ${b.id}')),
        const SizedBox(height: 8),
        Center(
          child: b.onArrival
              ? _chip(l.t('statusArrival'), color: Colors.green)
              : _chip(l.t('statusPending'), color: Colors.orange),
        ),
        const SizedBox(height: 20),
        _detailsCard(l, b),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false),
          child: Text(l.t('backHome')),
        ),
        const SizedBox(height: 12),
      ]),
    );
  }

  Widget _chip(String text, {Color? color}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: (color ?? Theme.of(context).colorScheme.primary).withOpacity(.15),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color ?? Theme.of(context).colorScheme.primary),
        ),
        child: Text(text,
            style: TextStyle(
                color: color ?? Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13)),
      );

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 2, child: Text(k, style: TextStyle(color: Theme.of(context).hintColor))),
          Expanded(
              flex: 3,
              child: Text(v,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontWeight: FontWeight.w700))),
        ]),
      );

  Widget _detailsCard(AppLocalizations l, Booking b) {
    final type = b.wholeCar
        ? l.t('wholeCar')
        : (b.seats == 1 ? l.t('seatOne') : '${b.seats} ${l.t('seatsMany')}');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.4)),
      ),
      child: Column(children: [
        _row(l.t('routeLabel'), '${l.city(b.fromId)} → ${l.city(b.toId)}'),
        _row(l.t('distance'), '${b.distanceKm.toStringAsFixed(0)} ${l.t('km')}'),
        _row(l.t('duration'), l.duration(b.durationMin)),
        _row(l.t('companyLabel'), l.company(b.companyId)),
        _row(l.t('carLabel'), l.car(b.carId)),
        _row(l.t('typeLabel'), type),
        _row(l.t('priceLabel'), '\$${b.price.toStringAsFixed(0)}'),
        _row(l.t('paymentLabel'), l.payment(b.paymentId)),
        if (!b.onArrival)
          _row(
              l.t('depositInfoLabel'),
              '${b.depositor ?? ''} • ${b.ref ?? ''} • \$${b.paidAmount?.toStringAsFixed(0) ?? ''}'
              '${b.walletType != null ? ' • ${l.walletName(b.walletType!)}' : ''}'),
        _row(l.t('dateLabel'), b.createdAt),
      ]),
    );
  }
}
