import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _profile = false;
  bool _busy = false;
  String? _email, _photo;
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _form = GlobalKey<FormState>();

  Future<void> _google() async {
    setState(() => _busy = true);
    try {
      final acc = await GoogleSignIn().signIn();
      if (acc != null) {
        setState(() {
          _profile = true;
          _email = acc.email;
          _photo = acc.photoUrl;
          _name.text = acc.displayName ?? '';
        });
        return;
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l.t('googleFailed'))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _save() {
    if (!(_form.currentState?.validate() ?? false)) return;
    context.read<AppState>().setUser(AppUser(
          name: _name.text.trim(),
          age: int.parse(_age.text.trim()),
          email: _email,
          photoUrl: _photo,
        ));
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _profile ? _buildProfile(l) : _buildLogin(l),
          ),
        ),
      ),
    );
  }

  Widget _logo() => Column(children: [
        Container(
          width: 92, height: 92,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF0B6E4F), Color(0xFF12A06A)]),
            borderRadius: BorderRadius.circular(26),
          ),
          child: const Icon(Icons.flight_takeoff, color: Colors.white, size: 48),
        ),
        const SizedBox(height: 12),
        const Text('Travel In',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
      ]);

  Widget _buildLogin(AppLocalizations l) =>
      Column(mainAxisSize: MainAxisSize.min, children: [
        _logo(),
        const SizedBox(height: 28),
        Text(l.t('loginTitle'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(l.t('loginSubtitle'),
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).hintColor)),
        const SizedBox(height: 32),
        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _busy ? null : _google,
            icon: _busy
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('G',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF4285F4))),
            label: Text(l.t('signInGoogle')),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => setState(() => _profile = true),
          child: Text(l.t('continueWithout')),
        ),
      ]);

  Widget _buildProfile(AppLocalizations l) => Form(
        key: _form,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _logo(),
              const SizedBox(height: 24),
              Text(l.t('completeProfile'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(l.t('profileHint'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).hintColor)),
              const SizedBox(height: 24),
              TextFormField(
                controller: _name,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: l.t('nameLabel'),
                    hintText: l.t('nameHint'),
                    prefixIcon: const Icon(Icons.person_outline)),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l.t('errName') : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _age,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: l.t('ageLabel'),
                    prefixIcon: const Icon(Icons.cake_outlined)),
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  return (n == null || n < 10 || n > 100) ? l.t('errAge') : null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _save, child: Text(l.t('saveContinue'))),
            ]),
      );
}
