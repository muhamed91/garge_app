import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  const TaskDetailScreen({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    final vehicle = job["vehicleInfo"];

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
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
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
                          text: "Hohe Priorität",
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        _StatusDot(color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "In Bearbeitung",
                          style: TextStyle(
                            color: Colors.blue,
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
                        _Meta(label: "Fälligkeitsdatum", value: "25. Dez. 2023"),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
                    _InfoRow(
                        label: "FIN", value: "WVWZZZAUZMP123456"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --------------------------------------------------
              // RESOURCE MANAGEMENT
              // --------------------------------------------------
              _Card(
                background: Colors.blue.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ressourcenverwaltung",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    const _Input(label: "Ersatzteil (Teilenummer)"),
                    const SizedBox(height: 12),
                    const _Input(label: "Hersteller"),
                    const SizedBox(height: 12),
                    const _Input(label: "Verwendete Werkzeuge"),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text("Ressource hinzufügen"),
                    ),
                  ],
                ),
              ),

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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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

              const SizedBox(height: 16),

              // --------------------------------------------------
              // CHECKLIST
              // --------------------------------------------------
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Checkliste für Endkontrolle",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 12),
                    _CheckItem("Bremsflüssigkeit geprüft"),
                    _CheckItem("Radmuttern mit Drehmoment angezogen"),
                    _CheckItem("Probefahrt durchgeführt"),
                    _CheckItem("Fahrzeug gereinigt"),
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
            onPressed: null,
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
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: TextStyle(color: color, fontWeight: FontWeight.w600)),
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

class _Input extends StatelessWidget {
  final String label;
  const _Input({required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "z. B. $label",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
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

class _CheckItem extends StatelessWidget {
  final String text;
  const _CheckItem(this.text);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: false,
      onChanged: (_) {},
      title: Text(text),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
