import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isRequired;
  final bool showError;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  const InputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isRequired = false,
    this.showError = false,
    this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = controller.text.trim().isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRequired ? '$label *' : label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          decoration: inputDecoration(
            hint,
            hasError: showError && isRequired && isEmpty,
          ),
        ),
      ],
    );
  }
}

class DropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;
  final bool isRequired;
  final bool showError;

  const DropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.isRequired = false,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = value == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRequired ? '$label *' : label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: value,
          hint: Text(hint, overflow: TextOverflow.ellipsis),
          items: items
              .map(
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(i, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: inputDecoration(
            null,
            hasError: showError && isRequired && isEmpty,
          ),
        ),
      ],
    );
  }
}

class BrandDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool isRequired;
  final bool showError;

  const BrandDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownField(
      label: 'Marke',
      value: value,
      items: items,
      hint: 'z. B. VW',
      onChanged: onChanged,
      isRequired: isRequired,
      showError: showError,
    );
  }
}

class TextArea extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isRequired;
  final bool showError;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  const TextArea({
    super.key,
    required this.hint,
    required this.controller,
    this.isRequired = false,
    this.showError = false,
    this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = controller.text.trim().isEmpty;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType ?? TextInputType.multiline,
      maxLines: 4,
      decoration: inputDecoration(
        hint,
        hasError: showError && isRequired && isEmpty,
      ),
    );
  }
}

class PhotoUploadBox extends StatelessWidget {
  final VoidCallback onPick;

  const PhotoUploadBox({super.key, required this.onPick});

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
              'Foto aus Galerie auswählen',
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 4),
            Text(
              'PNG, JPG (max. 5MB)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration inputDecoration(String? hint, {bool hasError = false}) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    errorText: hasError ? 'Pflichtfeld' : null,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: hasError ? Colors.red : Colors.grey.shade400,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red),
    ),
  );
}
