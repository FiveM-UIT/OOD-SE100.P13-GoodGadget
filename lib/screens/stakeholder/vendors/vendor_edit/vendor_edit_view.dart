import 'package:flutter/material.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';

import '../../../../enums/stakeholders/manufacturer_status.dart';

class VendorEditScreen extends StatefulWidget {
  final Manufacturer manufacturer;

  const VendorEditScreen({super.key, required this.manufacturer});

  @override
  State<VendorEditScreen> createState() => _VendorEditScreenState();
}

class _VendorEditScreenState extends State<VendorEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String manufacturerName;
  late ManufacturerStatus status;

  @override
  void initState() {
    super.initState();
    manufacturerName = widget.manufacturer.manufacturerName;
    status = widget.manufacturer.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Manufacturer'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: manufacturerName,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => manufacturerName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ManufacturerStatus>(
                value: status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: ManufacturerStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.getName()),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      status = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedManufacturer = Manufacturer(
                        manufacturerID: widget.manufacturer.manufacturerID,
                        manufacturerName: manufacturerName,
                        status: status,
                      );
                      Navigator.pop(context, updatedManufacturer);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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