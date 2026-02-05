import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/services/api_service.dart';
import '/widgets/order_form_helpers.dart';

class NewOrder extends StatefulWidget {
  const NewOrder({super.key});

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  // ---------------- STATE ----------------
  String? selectedBrand;
  String? selectedYear;
  String? selectedMileage;
  bool orderCreated = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final problemController = TextEditingController();
  final modelController = TextEditingController();
  final plateController = TextEditingController();

  final resourceNameController = TextEditingController();
  final resourceQtyController = TextEditingController(text: "1");
  final resourcePriceController = TextEditingController();

  final List<Map<String, dynamic>> resources = [];
  final ImagePicker _picker = ImagePicker();
  final List<File> images = [];

  bool isLoading = false;
  bool submitted = false; // ⭐ steuert Pflichtfeld-Anzeige

  // ---------------- DATA ----------------
  static const List<String> carBrands = [
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

  bool get isFormValid =>
      firstNameController.text.trim().isNotEmpty &&
      lastNameController.text.trim().isNotEmpty &&
      selectedBrand != null &&
      selectedYear != null &&
      modelController.text.trim().isNotEmpty &&
      plateController.text.trim().isNotEmpty &&
      problemController.text.trim().isNotEmpty;

  // ---------------- LIFECYCLE ----------------
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    problemController.dispose();
    modelController.dispose();
    plateController.dispose();

    resourceNameController.dispose();
    resourceQtyController.dispose();

    super.dispose();
  }

  // ---------------- IMAGE PICKER ----------------
  Future<void> pickFromGallery() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file != null) {
      setState(() => images.add(File(file.path)));
    }
  }

  void addResource() {
    if (resourceNameController.text.trim().isEmpty) return;

    setState(() {
      resources.add({
        "name": resourceNameController.text.trim(),
        "quantity": int.tryParse(resourceQtyController.text) ?? 1,
        "price":
            double.tryParse(
              resourcePriceController.text.replaceAll(',', '.'),
            ) ??
            0.0,
      });

      resourceNameController.clear();
      resourceQtyController.text = "1";
      resourcePriceController.clear();
    });
  }

  // ---------------- API ----------------
  Future<void> createWorkOrder() async {
    setState(() => isLoading = true);

    final clientName =
        '${firstNameController.text.trim()} ${lastNameController.text.trim()}';

    final payload = {
      "clientName": clientName,
      "description": problemController.text.trim(),
      "creationDate": DateTime.now().toIso8601String(),
      "status": 0,
      "vehicleInfo": {
        "brand": selectedBrand,
        "model": modelController.text.trim(),
        "licensePlate": plateController.text.trim(),
        "year": int.parse(selectedYear!),
        "mileage": selectedMileage != null
            ? int.parse(selectedMileage!.replaceAll('.', ''))
            : 0,
      },
      "resources": resources,
    };

    try {
      await ApiService().createWorkOrder(payload);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Der Auftrag wurde erfolgreich erstellt"),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fehler beim Erstellen des Auftrags: $e")),
      );
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
          onPressed: () => Navigator.pop(context, orderCreated),
        ),
        title: const Text(
          "Neuer Werkstattauftrag",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
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
                      isRequired: true,
                      showError: submitted,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      label: "Nachname",
                      hint: "z. B. Mustermann",
                      controller: lastNameController,
                      isRequired: true,
                      showError: submitted,
                      onChanged: (_) => setState(() {}),
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
                      isRequired: true,
                      showError: submitted,
                      onChanged: (_) => setState(() {}),
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
                      isRequired: true,
                      showError: submitted,
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
                isRequired: true,
                showError: submitted,
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 24),

              const Text(
                "Problembeschreibung *",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextArea(
                hint: "Beschreiben Sie das Problem im Detail",
                controller: problemController,
                isRequired: true,
                showError: submitted,
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 24),

              const Text(
                "Ressourcen",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 16),
              // --------------------------------------------------
              // RESOURCE INPUT
              // --------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      label: "Ressource",
                      hint: "z. B. Ölfilter",
                      controller: resourceNameController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 70,
                    child: InputField(
                      label: "Menge",
                      hint: "1",
                      controller: resourceQtyController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 90,
                    child: InputField(
                      label: "Preis €",
                      hint: "29.90",
                      controller: resourcePriceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: addResource,
                  icon: const Icon(Icons.add),
                  label: const Text("Ressource hinzufügen"),
                ),
              ),
              const SizedBox(height: 16),

              // --------------------------------------------------
              // RESOURCE LIST
              // --------------------------------------------------
              if (resources.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: resources.asMap().entries.map((entry) {
                      final index = entry.key;
                      final r = entry.value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                r["name"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text("× ${r["quantity"]}"),
                            const SizedBox(width: 12),
                            Text("${r["price"].toStringAsFixed(2)} €"),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () {
                                setState(() => resources.removeAt(index));
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

              PhotoUploadBox(onPick: pickFromGallery),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: isFormValid && !isLoading
                      ? createWorkOrder
                      : () => setState(() => submitted = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "Auftrag erstellen",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
