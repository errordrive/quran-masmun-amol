// Zakat Calculator (v2.1): fully functional, offline. Enter cash, gold,
// silver and business assets plus debts; the nisab is computed from
// live-entered gold/silver prices (defaults are editable estimates).
// Zakat = 2.5% of (zakatable assets - debts) when the net reaches nisab.
// Amounts in ৳. Deep-green header + gold accent (reference look).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

const Color _gold = Color(0xFFC9A227);

// Classical nisab weights.
const double _goldNisabGrams = 87.48; // 7.5 tola
const double _silverNisabGrams = 612.36; // 52.5 tola

String _fmt(double v) {
  final s = v.toStringAsFixed(0);
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}

class ZakatCalculatorScreen extends StatefulWidget {
  const ZakatCalculatorScreen({super.key});
  @override
  State<ZakatCalculatorScreen> createState() => _ZakatCalculatorScreenState();
}

class _ZakatCalculatorScreenState extends State<ZakatCalculatorScreen> {
  final _cashCtrl = TextEditingController();
  final _goldGramsCtrl = TextEditingController();
  final _goldPriceCtrl = TextEditingController(text: '13500');
  final _silverGramsCtrl = TextEditingController();
  final _silverPriceCtrl = TextEditingController(text: '165');
  final _businessCtrl = TextEditingController();
  final _debtsCtrl = TextEditingController();

  double? _zakatDue;
  double _net = 0;
  double _nisab = 0;
  double _goldNisabValue = 0;
  double _silverNisabValue = 0;
  bool _due = false;

  @override
  void dispose() {
    _cashCtrl.dispose();
    _goldGramsCtrl.dispose();
    _goldPriceCtrl.dispose();
    _silverGramsCtrl.dispose();
    _silverPriceCtrl.dispose();
    _businessCtrl.dispose();
    _debtsCtrl.dispose();
    super.dispose();
  }

  double _num(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '')) ?? 0;

  void _calculate() {
    final cash = _num(_cashCtrl);
    final goldValue = _num(_goldGramsCtrl) * _num(_goldPriceCtrl);
    final silverValue = _num(_silverGramsCtrl) * _num(_silverPriceCtrl);
    final business = _num(_businessCtrl);
    final debts = _num(_debtsCtrl);
    final total = cash + goldValue + silverValue + business;
    final net = total - debts;
    final goldNisab = _goldNisabGrams * _num(_goldPriceCtrl);
    final silverNisab = _silverNisabGrams * _num(_silverPriceCtrl);
    // Threshold: the lower of the two nisab values (usually silver).
    // Both values are shown so the user can decide by their madhab.
    final nisab = goldNisab < silverNisab ? goldNisab : silverNisab;
    final due = net >= nisab && net > 0;
    setState(() {
      _net = net;
      _goldNisabValue = goldNisab;
      _silverNisabValue = silverNisab;
      _nisab = nisab;
      _due = due;
      _zakatDue = due ? net * 0.025 : 0;
    });
    FocusScope.of(context).unfocus();
  }

  void _reset() {
    for (final c in [
      _cashCtrl,
      _goldGramsCtrl,
      _silverGramsCtrl,
      _businessCtrl,
      _debtsCtrl,
    ]) {
      c.clear();
    }
    setState(() {
      _zakatDue = null;
      _net = 0;
      _nisab = 0;
      _due = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bn = AppState.instance.isBangla;
    return AppScaffold(
      appBar: AppBar(title: Text(bn ? 'যাকাত ক্যালকুলেটর' : 'Zakat Calculator')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _HeaderCard(bn: bn),
          const SizedBox(height: 16),
          _MoneyField(
            controller: _cashCtrl,
            label: bn ? 'নগদ টাকা (৳)' : 'Cash in hand / bank (৳)',
            icon: Icons.account_balance_wallet,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MoneyField(
                  controller: _goldGramsCtrl,
                  label: bn ? 'সোনা (গ্রাম)' : 'Gold (grams)',
                  icon: Icons.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MoneyField(
                  controller: _goldPriceCtrl,
                  label: bn ? 'সোনার দাম/গ্রাম (৳)' : 'Gold price / gram (৳)',
                  icon: Icons.attach_money,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MoneyField(
                  controller: _silverGramsCtrl,
                  label: bn ? 'রূপা (গ্রাম)' : 'Silver (grams)',
                  icon: Icons.circle_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MoneyField(
                  controller: _silverPriceCtrl,
                  label: bn ? 'রূপার দাম/গ্রাম (৳)' : 'Silver price / gram (৳)',
                  icon: Icons.attach_money,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _MoneyField(
            controller: _businessCtrl,
            label: bn
                ? 'ব্যবসার সম্পদ / পণ্য (৳)'
                : 'Business assets / stock (৳)',
            icon: Icons.store,
          ),
          const SizedBox(height: 12),
          _MoneyField(
            controller: _debtsCtrl,
            label: bn ? 'ঋণ / দেনা (৳)' : 'Debts / liabilities (৳)',
            icon: Icons.remove_circle_outline,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: bn ? 'হিসাব করুন' : 'Calculate',
                  icon: Icons.calculate,
                  onPressed: _calculate,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TonalButton(
                  label: bn ? 'মুছুন' : 'Clear',
                  icon: Icons.refresh,
                  onPressed: _reset,
                ),
              ),
            ],
          ),
          if (_zakatDue != null) ...[
            const SizedBox(height: 20),
            _ResultCard(
              bn: bn,
              due: _due,
              zakatDue: _zakatDue!,
              net: _net,
              nisab: _nisab,
              goldNisab: _goldNisabValue,
              silverNisab: _silverNisabValue,
            ),
          ],
          const SizedBox(height: 16),
          Text(
            bn
                ? 'ব্যাখ্যা: যাকাত ফরজ হয় যখন যাকাতযোগ্য সম্পদ (নগদ + সোনা + রূপা + ব্যবসার সম্পদ) থেকে ঋণ বাদ দিয়ে অবশিষ্ট পরিমাণ নিসাবের সমান বা বেশি হয় এবং এক চন্দ্রবছর অতিক্রান্ত হয়। নিসাব: ৮৭.৪৮ গ্রাম সোনা অথবা ৬১২.৩৬ গ্রাম রূপার মূল্য। যাকাতের হার ২.৫%। সোনা-রূপার দাম প্রতিদিন বদলায় — উপরের দাম নিজের বাজারদর অনুযায়ী বদলে নিন। এটি সাধারণ নির্দেশনা; জটিল ক্ষেত্রে স্থানীয় আলেমের পরামর্শ নিন।'
                : 'Explanation: Zakat is due when zakatable wealth (cash + gold + silver + business assets) minus debts reaches nisab and a lunar year has passed. Nisab: 87.48 g of gold or 612.36 g of silver. Rate: 2.5%. Gold/silver prices change daily — update the prices above to your local market rate. This is general guidance; consult a local scholar for complex cases.',
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final bool bn;
  const _HeaderCard({required this.bn});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: primaryGreenDark,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.calculate,
                  color: Color(0xFFFFD54F), size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bn ? 'যাকাত ক্যালকুলেটর' : 'Zakat Calculator',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bn
                        ? 'আপনার সম্পদের উপর যাকাত কত, সহজে হিসাব করুন'
                        : 'Work out how much Zakat you owe on your wealth',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoneyField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  const _MoneyField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
      ],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryGreen),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final bool bn;
  final bool due;
  final double zakatDue;
  final double net;
  final double nisab;
  final double goldNisab;
  final double silverNisab;
  const _ResultCard({
    required this.bn,
    required this.due,
    required this.zakatDue,
    required this.net,
    required this.nisab,
    required this.goldNisab,
    required this.silverNisab,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: due ? primaryGreen : primaryGreenDark,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  bn ? 'আপনার যাকাত' : 'Your Zakat',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '৳ ${_fmt(zakatDue)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  due
                      ? (bn
                          ? 'নিসাব পূর্ণ হয়েছে — যাকাত দিতে হবে'
                          : 'Nisab reached — Zakat is due')
                      : (bn
                          ? 'নিসাব পূর্ণ হয়নি — যাকাত ফরজ নয়'
                          : 'Nisab not reached — no Zakat due'),
                  style: TextStyle(
                    color: _gold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _Row(
                    label: bn ? 'মোট সম্পদ (ঋণ বাদে)' : 'Net wealth (after debts)',
                    value: '৳ ${_fmt(net)}'),
                _Row(
                    label: bn ? 'নিসাব (সীমা)' : 'Nisab (threshold)',
                    value: '৳ ${_fmt(nisab)}'),
                _Row(
                    label: bn
                        ? 'সোনার নিসাব (৮৭.৪৮ গ্রাম)'
                        : 'Gold nisab (87.48 g)',
                    value: '৳ ${_fmt(goldNisab)}'),
                _Row(
                    label: bn
                        ? 'রূপার নিসাব (৬১২.৩৬ গ্রাম)'
                        : 'Silver nisab (612.36 g)',
                    value: '৳ ${_fmt(silverNisab)}'),
                _Row(
                    label: bn ? 'যাকাতের হার' : 'Zakat rate',
                    value: '2.5%'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 12),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
