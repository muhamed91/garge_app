import 'package:flutter/material.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------
              // HEADER
              // --------------------------------------------------
              Row(
                children: [
                  const Text(
                    "Berichte",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // --------------------------------------------------
              // PERIOD SWITCH
              // --------------------------------------------------
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    _PeriodChip(label: "Tag"),
                    _PeriodChip(label: "Woche", active: true),
                    _PeriodChip(label: "Monat"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --------------------------------------------------
              // STATS CARDS
              // --------------------------------------------------
              Row(
                children: const [
                  Expanded(
                    child: _StatCard(
                      title: "Abgeschlossen",
                      value: "12",
                      subtitle: "+2 vs. letzte Woche",
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: "Gesamtumsatz",
                      value: "€12.450",
                      subtitle: "+15%",
                      icon: Icons.account_balance_wallet,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: const [
                  Expanded(
                    child: _StatCard(
                      title: "Teile",
                      value: "€4.200",
                      progress: 0.34,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: "Arbeit",
                      value: "€8.250",
                      progress: 0.66,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --------------------------------------------------
              // TRENDS
              // --------------------------------------------------
              const Text(
                "Auftragstrends",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Expanded(
                          child: Text(
                            "Reparaturen pro Tag",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        _TrendBadge(value: "5%"),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Total: 42",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _DayLabel("MO"),
                        _DayLabel("DI"),
                        _DayLabel("MI", active: true),
                        _DayLabel("DO"),
                        _DayLabel("FR"),
                        _DayLabel("SA"),
                        _DayLabel("SO"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --------------------------------------------------
              // REVENUE DISTRIBUTION
              // --------------------------------------------------
              const Text(
                "Umsatzverteilung",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              _Card(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      height: 160,
                      alignment: Alignment.center,
                      child: const Text(
                        "Diagramm\n(Platzhalter)",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const Divider(),
                    _LegendRow(
                      color: Colors.blue,
                      label: "Arbeitszeit",
                      value: "€8.250 (66%)",
                    ),
                    const SizedBox(height: 8),
                    _LegendRow(
                      color: Colors.orange,
                      label: "Teile",
                      value: "€4.200 (34%)",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --------------------------------------------------
              // SPECIFIC REPORTS
              // --------------------------------------------------
              const Text(
                "Spezifische Berichte",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              const _ReportItem(
                icon: Icons.person,
                title: "Umsatz nach Kunde",
                subtitle: "Top 10 Kunden anzeigen",
              ),
              const _ReportItem(
                icon: Icons.directions_car,
                title: "Umsatz nach Fahrzeugtyp",
                subtitle: "Marken & Modelle Analyse",
              ),
              const _ReportItem(
                icon: Icons.build,
                title: "Teileverbrauch",
                subtitle: "Inventar und Kosten",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// HELPER WIDGETS
// --------------------------------------------------

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool active;

  const _PeriodChip({required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? Colors.blue : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final double? progress;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Icon(icon, color: color),
              if (icon != null) const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: TextStyle(color: Colors.green.shade700),
            ),
          ],
          if (progress != null) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              color: color,
              backgroundColor: color.withOpacity(0.2),
            ),
          ],
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _TrendBadge extends StatelessWidget {
  final String value;

  const _TrendBadge({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "↑ $value",
        style: TextStyle(
          color: Colors.green.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String label;
  final bool active;

  const _DayLabel(this.label, {this.active = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: active ? Colors.blue : Colors.grey,
        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _ReportItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ReportItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
