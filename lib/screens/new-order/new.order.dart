import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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

  final TextEditingController problemController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final List<File> images = [];

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

  bool get isFormValid =>
      selectedBrand != null &&
      selectedYear != null &&
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

  void removeImage(int index) {
    setState(() => images.removeAt(index));
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
          "Neuer Werkstattauftrag",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Fahrzeugdetails",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Marke + Modell
                    Row(
                      children: [
                        Expanded(
                          child: _BrandDropdown(
                            value: selectedBrand,
                            items: carBrands,
                            onChanged: (v) => setState(() => selectedBrand = v),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: _InputField(
                            label: "Modell",
                            hint: "z. B. Golf",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Baujahr + Kilometer (JETZT DROPDOWNS)
                    Row(
                      children: [
                        Expanded(
                          child: _Dropdown(
                            label: "Baujahr",
                            value: selectedYear,
                            items: years,
                            hint: "Auswählen",
                            onChanged: (v) => setState(() => selectedYear = v),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _Dropdown(
                            label: "Kilometer",
                            value: selectedMileage,
                            items: mileages,
                            hint: "z. B. 40.000",
                            onChanged: (v) =>
                                setState(() => selectedMileage = v),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const _InputField(
                      label: "Kennzeichen",
                      hint: "z. B. B-XY 123",
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Problembeschreibung *",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _TextArea(
                      hint: "Beschreiben Sie das Problem im Detail",
                      controller: problemController,
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Fotos hinzufügen",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    _PhotoUploadBox(onPick: pickFromGallery),

                    if (images.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(images.length, (index) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  images[index],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: -6,
                                right: -6,
                                child: GestureDetector(
                                  onTap: () => removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: isFormValid ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
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

// ------------------------------------------------------------
// HELPERS
// ------------------------------------------------------------
class _Dropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;

  const _Dropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: value,
          hint: Text(hint),
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
          decoration: _inputDecoration(),
        ),
      ],
    );
  }
}

class _BrandDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _BrandDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _Dropdown(
      label: "Marke",
      value: value,
      items: items,
      hint: "z. B. VW",
      onChanged: onChanged,
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;

  const _InputField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(decoration: _inputDecoration(hint)),
      ],
    );
  }
}

class _TextArea extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _TextArea({
    required this.hint,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: 4,
      decoration: _inputDecoration(hint),
    );
  }
}

class _PhotoUploadBox extends StatelessWidget {
  final VoidCallback onPick;

  const _PhotoUploadBox({required this.onPick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPick,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.photo_library, color: Colors.blue),
            SizedBox(height: 8),
            Text(
              "Foto aus Galerie auswählen",
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 4),
            Text(
              "PNG, JPG (max. 5MB)",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration([String? hint]) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
  );
}
