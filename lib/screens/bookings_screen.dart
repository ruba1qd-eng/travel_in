import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import 'confirmation_screen.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final bookings = context.watch<AppState>().bookings;
    return Scaffold(
      appBar: AppBar(title: Text(l.t('myBookings'))),
      body: bookings.isEmpty
          ? Center(
              child: Text(l.t('noBookings'),
                  style: TextStyle(color: Theme.of(context).hintColor)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final b = bookings[i];
                return ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(.4))),
                  tileColor: Theme.of(context).cardColor,
                  leading: const CircleAvatar(child: Icon(Icons.directions_car_filled)),
                  title: Text('${l.city(b.fromId)} → ${l.city(b.toId)}',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${b.createdAt}  •  \$${b.price.toStringAsFixed(0)}'),
                  trailing: Icon(b.onArrival ? Icons.pending_actions : Icons.hourglass_top,
                      color: b.onArrival ? Colors.green : Colors.orange),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => ConfirmationScreen(booking: b))),
                );
              },
            ),
    );
  }
}
