import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paynback_manufacturer_app/controller/repositories/get_product_for_offers_repo.dart';
import 'package:paynback_manufacturer_app/view/bloc/add_offer_products/add_offer_products_bloc.dart';
import 'package:paynback_manufacturer_app/view/screen/select_offer_product_screen.dart';

class AddProductOfferScreen extends StatefulWidget {
  const AddProductOfferScreen({super.key});

  @override
  State<AddProductOfferScreen> createState() => _AddProductOfferScreenState();
}

class _AddProductOfferScreenState extends State<AddProductOfferScreen> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _offerController = TextEditingController();
  final TextEditingController _discriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  void _submitOffer() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AddOfferProductsBloc(GetProductForOffersRepo()),
            child: SelectOfferProductScreen(
              description: _discriptionController.text.toString(),
              endDate: _endDateController.text.toString(),
              offerValue: _offerController.text.toString(),
              startDate: _startDateController.text.toString(),
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _offerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product Offer'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildDateField(
              label: "Start Date",
              controller: _startDateController,
              onTap: () => _pickDate(_startDateController),
            ),
            const SizedBox(height: 16),
            _buildDateField(
              label: "End Date",
              controller: _endDateController,
              onTap: () => _pickDate(_endDateController),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _offerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Offer Percentage",
                prefixIcon: const Icon(Icons.percent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Enter offer (e.g. 10)",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter offer percentage";
                }
                final num? offer = num.tryParse(value);
                if (offer == null || offer <= 0 || offer > 100) {
                  return "Enter a valid percentage (1–100)";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _discriptionController,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: "Discription",
                prefixIcon: const Icon(Icons.note),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "About the offer",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter Discription";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _submitOffer,
              icon: const Icon(Icons.check),
              label: const Text(
                "Add Products",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: "Select $label",
      ),
      validator: (value) => value == null || value.isEmpty ? "Select $label" : null,
      onTap: onTap,
    );
  }
}