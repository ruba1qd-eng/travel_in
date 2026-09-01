import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/app_data.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import 'confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final BookingDraft draft;
  const PaymentScreen({super.key, required this.draft});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _pay;
  String _wallet = 'jawali';
  final _depositor = TextEditingController();
  final _ref = TextEditingController();
  final _amount = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amount.text = widget.draft.price.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _depositor.dispose();
    _ref.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  void _copy(String s) {
    Clipboard.setData(ClipboardData(text: s));
    _snack(context.l.t('copied'));
  }

  String _fmt(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}  ${two(d.hour)}:${two(d.minute)}';
  }

  void _confirm() {
    final l = context.l;
    if (_pay == null) return _snack(l.t('choosePayment'));
    double? amt;
    if (_pay != 'arrival') {
      if (_depositor.text.trim().isEmpty) return _snack(l.t('errDepositor'));
      amt = double.tryParse(_amount.text.trim());
      if (amt == null || amt <= 0) return _snack(l.t('errAmount'));
      if (_ref.text.trim().isEmpty) return _snack(l.t('errRef'));
    }
    final d = widget.draft;
    final booking = Booking(
      id: 'TI-${10000 + Random().nextInt(90000)}',
      companyId: d.companyId, carId: d.carId, wholeCar: d.wholeCar, seats: d.seats,
      fromId: d.fromId, toId: d.toId, price: d.price, paymentId: _pay!,
      walletType: _pay == 'wallet' ? _wallet : null,
      depositor: _pay == 'arrival' ? null : _depositor.text.trim(),
      ref: _pay == 'arrival' ? null : _ref.text.trim(),
      paidAmount: amt,
      createdAt: _fmt(DateTime.now()),
      distanceKm: d.distanceKm, durationMin: d.durationMin,
    );
    context.read<AppState>().addBooking(booking);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ConfirmationScreen(booking: booking)));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final d = widget.draft;
    final type = d.wholeCar
        ? l.t('wholeCar')
        : (d.seats == 1 ? l.t('seatOne') : '${d.seats} ${l.t('seatsMany')}');

    return Scaffold(
      appBar: AppBar(title: Text(l.t('paymentTitle'))),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: ElevatedButton(onPressed: _confirm, child: Text(l.t('confirmBooking'))),
        ),
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: _box(),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${l.city(d.fromId)} → ${l.city(d.toId)}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                    '${l.company(d.companyId)} • $type • ${d.distanceKm.toStringAsFixed(0)} ${l.t('km')} • ${l.duration(d.durationMin)}',
                    style: TextStyle(fontSize: 12.5, color: Theme.of(context).hintColor)),
              ]),
            ),
            const SizedBox(width: 10),
            Text('\$${d.price.toStringAsFixed(0)}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary)),
          ]),
        ),
        const SizedBox(height: 18),
        _section(l.t('choosePayment')),
        for (final id in ['arrival', 'kuraimi', 'wallet']) _payCard(id),
        if (_pay == 'kuraimi') ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: _box(),
            child: Column(children: [
              _infoRow(l.t('accountNumber'), kKuraimiAccount, copy: true),
              const Divider(),
              _infoRow(l.t('accountName'), kKuraimiName),
            ]),
          ),
          const SizedBox(height: 12),
          _fields(l),
        ],
        if (_pay == 'wallet') ...[
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _wallet,
            decoration: InputDecoration(
                labelText: l.t('walletType'),
                prefixIcon: const Icon(Icons.wallet)),
            items: const [
              DropdownMenuItem(value: 'jawali', child: Text('Jawali / جوالي')),
              DropdownMenuItem(value: 'one', child: Text('One Cash / محفظة كاش')),
              DropdownMenuItem(value: 'floosak', child: Text('Floosak / فلوسك')),
              DropdownMenuItem(value: 'jaib', child: Text('Jaib / جيب')),
            ],
            onChanged: (v) => setState(() => _wallet = v ?? 'jawali'),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: _box(),
            child: _infoRow(l.t('walletNumber'), kWalletNumber, copy: true),
          ),
          const SizedBox(height: 12),
          _fields(l),
        ],
        if (_pay == 'arrival') ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: _box(),
            child: Row(children: [
              Icon(Icons.payments, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                    '${l.t('arrivalDesc')} — \$${d.price.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
        ],
        if (_pay != null && _pay != 'arrival') ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.amber.withOpacity(.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber)),
            child: Row(children: [
              Icon(Icons.info_outline, color: Colors.amber.shade800),
              const SizedBox(width: 8),
              Expanded(child: Text(l.t('depositNote'))),
            ]),
          ),
        ],
        const SizedBox(height: 20),
      ]),
    );
  }

  Widget _fields(AppLocalizations l) => Column(children: [
        TextField(
          controller: _depositor,
          decoration: InputDecoration(
              labelText: l.t('depositorName'),
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _amount,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: l.t('depositAmount'),
              prefixIcon: const Icon(Icons.attach_money)),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _ref,
          decoration: InputDecoration(
              labelText: l.t('transferRef'),
              prefixIcon: const Icon(Icons.receipt)),
        ),
      ]);

  Widget _infoRow(String label, String value, {bool copy = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Expanded(child: Text(label, style: TextStyle(color: Theme.of(context).hintColor))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
          if (copy)
            IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () => _copy(value),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints()),
        ]),
      );

  Widget _payCard(String id) {
    final l = context.l;
    final sel = _pay == id;
    final cs = Theme.of(context).colorScheme;
    final icon = {
      'arrival': Icons.payments,
      'kuraimi': Icons.account_balance,
      'wallet': Icons.account_balance_wallet,
    }[id]!;
    return GestureDetector(
      onTap: () => setState(() => _pay = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: sel ? cs.primary.withOpacity(.08) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: sel ? cs.primary : Theme.of(context).dividerColor.withOpacity(.4),
              width: sel ? 2 : 1),
        ),
        child: Row(children: [
          Icon(icon, color: sel ? cs.primary : cs.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.payment(id), style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(l.t('${id}Desc'),
                  style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
            ]),
          ),
          Icon(sel ? Icons.check_circle : Icons.radio_button_unchecked,
              color: sel ? cs.primary : Theme.of(context).hintColor),
        ]),
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child:
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      );

  BoxDecoration _box() => BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(.4)),
      );
}
