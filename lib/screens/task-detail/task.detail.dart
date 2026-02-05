import 'package:flutter/material.dart';
import 'package:garage_app/services/api_service.dart';

String statusText(int status) {
  switch (status) {
    case 0:
      return "Offen";
    case 1:
      return "In Bearbeitung";
    case 2:
      return "Fertig";
    default:
      return "Problem";
  }
}

Color statusColor(int status) {
  switch (status) {
    case 0:
      return Colors.grey;
    case 1:
      return Colors.orange.shade800;
    case 2:
      return Colors.green;
    default:
      return Colors.red;
  }
}

/// 🔹 Background-Farbe für Status-Badge
Color statusBgColor(int status) {
  switch (status) {
    case 1:
      return Colors.orange.shade100;
    case 2:
      return Colors.green.shade100;
    case 0:
      return Colors.grey.shade200;
    default:
      return Colors.red.shade100;
  }
}

class TaskDetailScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  const TaskDetailScreen({super.key, required this.job});

  Future<void> setStatusFinished(BuildContext context) async {
    final api = ApiService();
    await api.updateWorkOrderStatus(job["id"], 2);

    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = job["vehicleInfo"];

    // 🔹 HIER ERGÄNZT (war vorher nicht vorhanden)
    final List<dynamic> resources = job["resources"] as List<dynamic>? ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      // --------------------------------------------------
      // APP BAR
      // --------------------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Werkstattauftragsdetails",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      // --------------------------------------------------
      // BODY
      // --------------------------------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // --------------------------------------------------
              // HEADER CARD
              // --------------------------------------------------
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            job["description"],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _Badge(
                          text: statusText(job["status"]),
                          color: statusColor(job["status"]),
                          backgroundColor: statusBgColor(job["status"]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _StatusDot(color: statusColor(job["status"])),
                        const SizedBox(width: 8),
                        Text(
                          statusText(job["status"]),
                          style: TextStyle(
                            color: statusColor(job["status"]),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _Meta(label: "Erstellt", value: "23. Dez. 2023"),
                        _Meta(
                          label: "Fälligkeitsdatum",
                          value: "25. Dez. 2023",
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --------------------------------------------------
              // VEHICLE DETAILS
              // --------------------------------------------------
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Fahrzeugdetails",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.directions_car),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${vehicle["brand"]} ${vehicle["model"]}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              vehicle["licensePlate"],
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    _InfoRow(label: "Kilometerstand", value: "85.430 km"),
                    _InfoRow(label: "Erstzulassung", value: "03/2021"),
                    _InfoRow(label: "FIN", value: "WVWZZZAUZMP123456"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --------------------------------------------------
              // RESOURCES
              // --------------------------------------------------
              if (resources.isNotEmpty) ...[
                const SizedBox(height: 16),
                _Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ressourcen",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...resources.map(
                        (r) => _ResourceRow(
                          name: r["name"] ?? "Unbekannt",
                          quantity: r["quantity"] ?? 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // --------------------------------------------------
              // PHOTOS
              // --------------------------------------------------
              _Card(
                background: Colors.green.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Fotos vom Fortschritt",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _PhotoPlaceholder(),
                        const SizedBox(width: 8),
                        _PhotoPlaceholder(),
                        const SizedBox(width: 8),
                        _AddPhoto(),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),

      // --------------------------------------------------
      // BOTTOM BUTTON
      // --------------------------------------------------
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: job["status"] == 2
                ? null
                : () => setStatusFinished(context),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text("Auftrag abschließen"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              disabledBackgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// HELPERS
// --------------------------------------------------

class _Card extends StatelessWidget {
  final Widget child;
  final Color? background;

  const _Card({required this.child, this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _Meta extends StatelessWidget {
  final String label;
  final String value;

  const _Meta({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final Color backgroundColor;

  const _Badge({
    required this.text,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final Color color;
  const _StatusDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _AddPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.add_a_photo, color: Colors.green),
    );
  }
}

class _ResourceRow extends StatelessWidget {
  final String name;
  final int quantity;

  const _ResourceRow({required this.name, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.build, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            "× $quantity",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
