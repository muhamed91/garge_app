import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garage_app/widgets/order_form_helpers.dart';
import 'package:image_picker/image_picker.dart';

import '/services/api_service.dart';

class EditOrder extends StatefulWidget {
  final Map<String, dynamic> job;

  const EditOrder({super.key, required this.job});

  @override
  State<EditOrder> createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  // ---------------- STATE ----------------
  String? selectedBrand;
  String? selectedYear;
  String? selectedMileage;

  int? selectedStatus;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController problemController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController plateController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final List<File> images = [];
  final List<Map<String, dynamic>> resources = [];

  bool isLoading = false;

  // ---------------- STATUS MAPPING ----------------
  final Map<String, int> statusMap = {
    "Offen": 0, // Pending
    "In Bearbeitung": 1, // InProgress
    "Fertig": 2, // Finished
    "Problem": 3, // Problem
  };

  String? get selectedStatusLabel {
    if (selectedStatus == null) return null;
    return statusMap.entries.firstWhere((e) => e.value == selectedStatus).key;
  }

  // ---------------- DATA ----------------
  final List<String> carBrands = [
    "Audi",
    "BMW",
    "Mercedes-Benz",
    "Volkswagen",
    "Porsche",
    "Opel",
    "Ford",
    "Toyota",
    "Honda",
    "Hyundai",
    "Kia",
    "Mazda",
    "Nissan",
    "Peugeot",
    "Renault",
    "Fiat",
    "Skoda",
    "Seat",
    "Volvo",
    "Tesla",
  ];

  final List<String> years = [
    for (int y = DateTime.now().year; y >= 1960; y--) y.toString(),
  ];

  final List<String> mileages = [
    for (int m = 20000; m <= 260000; m += 20000)
      m.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => '.',
      ),
  ];

  // ---------------- INIT ----------------
  @override
  void initState() {
    super.initState();

    final vehicle = widget.job["vehicleInfo"];
    final nameParts = widget.job["clientName"].split(" ");

    firstNameController.text = nameParts.first;
    lastNameController.text = nameParts.length > 1
        ? nameParts.sublist(1).join(" ")
        : "";

    problemController.text = widget.job["description"];
    modelController.text = vehicle["model"];
    plateController.text = vehicle["licensePlate"];

    selectedBrand = vehicle["brand"];
    selectedYear = vehicle["year"].toString();
    selectedMileage = vehicle["mileage"].toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );

    selectedStatus = widget.job["status"];

    final existingResources = widget.job["resources"];
    if (existingResources is List) {
      resources.addAll(
        existingResources.map<Map<String, dynamic>>(
          (r) => {
            "name": r["name"],
            "type": r["type"],
            "quantity": r["quantity"],
            "cost": r["cost"],
          },
        ),
      );
    }
  }

  // ✅ FORM VALIDATION (wie bei dir)
  bool get isFormValid =>
      firstNameController.text.trim().isNotEmpty &&
      lastNameController.text.trim().isNotEmpty &&
      selectedStatus != null &&
      selectedBrand != null &&
      selectedYear != null &&
      modelController.text.trim().isNotEmpty &&
      plateController.text.trim().isNotEmpty &&
      problemController.text.trim().isNotEmpty;

  // ---------------- IMAGE PICKER ----------------
  Future<void> pickFromGallery() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file != null) {
      setState(() => images.add(File(file.path)));
    }
  }

  // ---------------- RESOURCE DIALOG ----------------
  Future<void> _addResource() async {
    final nameController = TextEditingController();
    final quantityController = TextEditingController(text: "1");
    final costController = TextEditingController(text: "0");
    String type = "Part";

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: const Text("Ressource hinzufügen"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputField(
                    label: "Name",
                    hint: "z. B. Bremsbeläge",
                    controller: nameController,
                  ),
                  const SizedBox(height: 12),
                  DropdownField(
                    label: "Typ",
                    value: type,
                    items: const ["Part", "Material"],
                    hint: "Typ auswählen",
                    onChanged: (v) {
                      setStateDialog(() {
                        type = v ?? "Part";
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  InputField(
                    label: "Menge",
                    hint: "z. B. 2",
                    controller: quantityController,
                  ),
                  const SizedBox(height: 12),
                  InputField(
                    label: "Preis (€)",
                    hint: "z. B. 120",
                    controller: costController,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Abbrechen"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Hinzufügen"),
              ),
            ],
          ),
        );
      },
    );

    if (confirmed == true && nameController.text.trim().isNotEmpty) {
      setState(() {
        resources.add({
          "name": nameController.text.trim(),
          "type": type,
          "quantity": int.tryParse(quantityController.text) ?? 1,
          "cost": double.tryParse(costController.text) ?? 0.0,
        });
      });
    }
  }

  // ---------------- API ----------------
  Future<void> updateWorkOrder() async {
    setState(() => isLoading = true);

    final api = ApiService();

    final String clientName =
        '${firstNameController.text.trim()} ${lastNameController.text.trim()}';

    final payload = {
      "clientName": clientName,
      "description": problemController.text.trim(),
      "status": selectedStatus,
      "vehicleInfo": {
        "brand": selectedBrand,
        "model": modelController.text.trim(),
        "licensePlate": plateController.text.trim(),
        "year": int.parse(selectedYear!),
        "mileage": int.parse(selectedMileage!.replaceAll('.', '')),
      },
      "resources": resources,
    };

    try {
      await api.updateWorkOrder(widget.job["id"], payload);

      if (!mounted) return;

      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Auftrag erfolgreich aktualisiert"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Fehler beim Aktualisieren: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Werkstattauftrag bearbeiten",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      // ✅ BUTTON IMMER SICHTBAR
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: isFormValid && !isLoading ? updateWorkOrder : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                disabledBackgroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Auftrag aktualisieren",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          child: Column(
            children: [
              const Text(
                "Auftragsstatus",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              DropdownField(
                label: "Status",
                value: selectedStatusLabel,
                items: statusMap.keys.toList(),
                hint: "Status auswählen",
                onChanged: (label) {
                  setState(() {
                    selectedStatus = statusMap[label];
                  });
                },
              ),

              const SizedBox(height: 32),

              const Text(
                "Kundendaten",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: InputField(
                      label: "Vorname",
                      hint: "z. B. Max",
                      controller: firstNameController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      label: "Nachname",
                      hint: "z. B. Mustermann",
                      controller: lastNameController,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const Text(
                "Fahrzeugdetails",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: BrandDropdown(
                      value: selectedBrand,
                      items: carBrands,
                      onChanged: (v) => setState(() => selectedBrand = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      label: "Modell",
                      hint: "z. B. Golf",
                      controller: modelController,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownField(
                      label: "Baujahr",
                      value: selectedYear,
                      items: years,
                      hint: "Auswählen",
                      onChanged: (v) => setState(() => selectedYear = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownField(
                      label: "Kilometer",
                      value: selectedMileage,
                      items: mileages,
                      hint: "z. B. 40.000",
                      onChanged: (v) => setState(() => selectedMileage = v),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              InputField(
                label: "Kennzeichen",
                hint: "z. B. B-XY 123",
                controller: plateController,
              ),

              const SizedBox(height: 24),

              const Text(
                "Problembeschreibung *",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextArea(
                hint: "Beschreiben Sie das Problem im Detail",
                controller: problemController,
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 24),

              // ---------------- RESSOURCEN ----------------
              const Text(
                "Ressourcen",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              ...resources.asMap().entries.map((entry) {
                final index = entry.key;
                final resource = entry.value;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(resource["name"].toString()),
                    subtitle: Text(
                      "${resource["type"]} • ${resource["quantity"]} × ${resource["cost"]} €",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          setState(() => resources.removeAt(index)),
                    ),
                  ),
                );
              }).toList(),

              TextButton.icon(
                onPressed: _addResource,
                icon: const Icon(Icons.add),
                label: const Text("Ressource hinzufügen"),
              ),

              // ---------------- ENDE ----------------
              const SizedBox(height: 24),

              PhotoUploadBox(onPick: pickFromGallery),
            ],
          ),
        ),
      ),
    );
  }
}
